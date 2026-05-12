# Angular (Vite) Nginx Proxy Configuration

在 Angular 17+ (使用 Application Builder/Vite) 的環境下，若要透過 Nginx 代理存取 ng serve 的開發伺服器，需處理 Vite 的依賴預編譯 (Pre-bundling) 與虛擬路徑問題。

## Nginx 配置重點

### 1. 攔截 Vite 虛擬路徑
Vite 會從根目錄請求 /@fs/, /@vite/, node_modules 等資源。Nginx 必須捕獲這些請求並導向 Angular 埠口。

### 2. 子路徑代理 (Sub-path Proxy)
若代理路徑為 /testfront/，建議不要在 Nginx 使用 rewrite 移除路徑，而是讓 Angular 處理子路徑。

## Angular 配置 (angular.json)

建議建立專屬的 testfront 配置以避免影響本機開發：
1. 在 build.configurations 增加 testfront，設定 baseHref 為 /testfront/。
2. 在 serve.configurations 增加 testfront，指向 build:testfront。

## 啟動指令

ng serve [project] -c testfront --host 0.0.0.0 --disable-host-check --serve-path /testfront/
