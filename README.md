# 🚀 n8n YouTube Summarizer Quick Start

這套環境預先配置了 **n8n** 主程式與一個 **客製化 Python Runner**。它能讓您在 n8n 的 Code 節點中直接執行 `yt-dlp` 抓取 YouTube 字幕，並結合 AI 進行摘要。

### 📋 前置需求 (Prerequisites)

在開始之前，請確保您的電腦已安裝：

* **Docker** (Desktop 或 Engine)
* **Docker Compose**

---

### 1️⃣ 第一步：複製專案 (Clone Repository)

打開您的終端機 (Terminal)，執行以下指令下載專案並進入資料夾：

```bash
git clone https://github.com/harry0816web/n8n-youtube-summarizer.git
cd n8n-youtube-summarizer

```

### 2️⃣ 第二步：準備資料夾與權限 (Setup Folders)

n8n 需要一個資料夾來儲存工作流與設定。為了避免權限錯誤，請先手動建立資料夾：

```bash
mkdir n8n_data

# 如果您是 Linux 或 Mac 用戶，請執行此行確保 n8n 有權限讀寫
sudo chown -R 1000:1000 n8n_data

```

### 3️⃣ 第三步：設定安全性 Token (Security Setup)

為了讓 n8n 主程式能與 Python Runner 安全通訊，請編輯 `docker-compose.yml`：

1. 找到兩處 `N8N_RUNNERS_AUTH_TOKEN`。
2. 將 `change-this-to-a-secure-token` 改為您自定義的複雜字串（**兩個地方必須完全相同**）。

### 4️⃣ 第四步：建置並啟動服務 (Launch)

執行以下指令，Docker 會根據 `Dockerfile` 自動安裝 Python 環境並啟動容器：

```bash
docker-compose up -d --build

```

* `--build`: 確保 Docker 會重新讀取您的 `Dockerfile` 並安裝 `yt-dlp` 等套件。
* `-d`: 在背景執行。

---

### 5️⃣ 第五步：進入 n8n 並匯入工作流 (Import Workflow)

1. 打開瀏覽器，前往：`http://localhost:5678`
2. 完成初次登入設定。
3. **測試 Python 環境**：
* 新增一個 **Code 節點**，語言選擇 **Python**。
* 輸入以下程式碼測試：
```python
import yt_dlp
return {"status": "success", "version": yt_dlp.version.__version__}

```


* 點擊 **Execute Node**，若看到版本號，代表您的 Python Runner 已完美運作！



---

### 🛠️ 故障排除 (Troubleshooting)

* **看日誌 (Logs)**：如果服務沒動靜，可以用此指令查看錯誤訊息：
```bash
docker-compose logs -f task-runners

```


* **重新安裝套件**：如果您修改了 `Dockerfile` 裡的 pip 套件，請務必再次執行 `docker-compose up -d --build`。

### 📂 檔案架構說明

* **`Dockerfile`**: 安裝 Python 3 與 `yt-dlp` 的核心環境。
* **`docker-compose.yml`**: 定義 n8n 主機與 Runner 之間的分工。
* **`n8n-task-runners.json`**: 引導 n8n 找到正確的 Python 執行路徑。
