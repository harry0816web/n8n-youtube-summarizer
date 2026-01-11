FROM n8nio/runners:2.0.0

USER root

# --- 步驟 1: 動態安裝 apk (解決 404 問題) ---
# 這段腳本會自動去 Alpine 官網找「最新版」的 apk-tools-static，
# 而不是寫死版本號，這樣就不會因為過期而 404。
RUN set -eux; \
    ARCH="$(uname -m)"; \
    # 1. 抓取官網列表，找出最新的 apk-tools-static 檔名
    APK_FILENAME=$(wget -qO- "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" \
      | grep -o 'apk-tools-static-[0-9.]*-r[0-9].apk' \
      | head -n 1); \
    # 2. 下載該檔案
    wget -q "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/${APK_FILENAME}"; \
    # 3. 解壓縮並安裝
    tar -xzf ${APK_FILENAME}; \
    ./sbin/apk.static add --no-cache apk-tools; \
    # 4. 清理暫存檔
    rm -f ${APK_FILENAME} ./sbin/apk.static

# --- 步驟 2: 安裝系統依賴 ---
# 現在 apk 回來了，可以正常安裝 ffmpeg 等工具
RUN apk add --no-cache \
    ffmpeg \
    build-base \
    libsndfile \
    python3-dev

# --- 步驟 3: 安裝 Python 庫 ---
# 修正了之前的語法錯誤：
# 1. --python .venv (中間加了空格)
RUN cd /opt/runners/task-runner-python && \
    uv pip install --python .venv \
    google-genai \
    youtube-transcript-api \
    pytz \
    requests \
    yt-dlp

# 複製設定檔
COPY n8n-task-runners.json /etc/n8n-task-runners.json

USER runner
