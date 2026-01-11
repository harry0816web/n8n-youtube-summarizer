FROM n8nio/runners:2.0.0

USER root

RUN set -eux; \
    ARCH="$(uname -m)"; \
    APK_FILENAME=$(wget -qO- "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" \
      | grep -o 'apk-tools-static-[0-9.]*-r[0-9].apk' \
      | head -n 1); \
    wget -q "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/${APK_FILENAME}"; \
    tar -xzf ${APK_FILENAME}; \
    ./sbin/apk.static add --no-cache apk-tools; \
    rm -f ${APK_FILENAME} ./sbin/apk.static

RUN apk add --no-cache \
    build-base \
    libsndfile \
    python3-dev

RUN cd /opt/runners/task-runner-python && \
    uv pip install --python .venv \
    google-genai \
    youtube-transcript-api \
    pytz \
    requests \
    yt-dlp

COPY n8n-task-runners.json /etc/n8n-task-runners.json

USER runner
