# Deploy Database Query Skill

此技能提供透過 SSH Tunnel 存取營運 (Production) 資料庫的標準作業流程。當需要存取 `DEPLOY_MYSQL_HOST` 所指向的資料庫時，必須遵循此規範。

## 環境需求
- **SSH 設定**：`~/.ssh/config` 必須包含 `test` 主機設定（Gateway）。
- **憑證設定**：`~/.env` 必須包含以下變數：
    - `DEPLOY_MYSQL_HOST`
    - `DEPLOY_MYSQL_USER`
    - `DEPLOY_MYSQL_PASSWORD`
- **Python 套件**：`pymysql`, `python-dotenv`

## 核心工具：query_prod_db.py
專案中已建立 `query_prod_db.py` 工具，用於自動化處理隧道建立、SQL 執行與隧道關閉。

### 使用方式
```bash
python query_prod_db.py "YOUR_SQL_QUERY"
```

### 運作邏輯
1. **載入憑證**：從 `~/.env` 讀取連線資訊。
2. **建立隧道**：執行 `ssh -L 3307:<DEPLOY_MYSQL_HOST>:3306 test -N`。
3. **資料庫連線**：透過 `localhost:3307` 進行連線。
4. **輸出結果**：以格式化的 JSON 回傳查詢結果。
5. **自動清理**：查詢結束後自動終止 SSH 隧道進程。

## 注意事項
- **安全性**：禁止將包含憑證的 `.env` 或 `query_prod_db.py` 產出的敏感資料提交至 Git。
- **埠位衝突**：預設使用 `3307` 作為本地轉發埠位，若衝突請在腳本中調整 `local_port`。
- **Timeout**：若 SSH 連線緩慢，腳本設有 10 秒的等待時間確保隧道建立完成。
