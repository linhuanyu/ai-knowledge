# Cloud Build Triggers 知識點

## 觸發條件配置
- **標記觸發 (Tag-based)**: 使用 `--tag-pattern` 旗標設定正則表達式，例如 `.*-(full|segment)$` 可匹配特定後綴的標記。
- **CEL 篩選器**: 可使用 Common Expression Language (CEL) 進行更精細的事件篩選（如 `build.tags.exists(t, t == 'prod')`）。

## gcloud 指令技巧
- **更新觸發條件**: 使用 `gcloud builds triggers update {TYPE}`，其中 TYPE 為 `github`, `manual`, `pubsub` 等。
- **啟用/停用觸發條件**: 
  - 若 `gcloud` 指令不支援直接的 `--no-disabled` 旗標，可透過 `--trigger-config` 匯入 JSON 配置。
  - **流程**:
    1. 匯出配置: `gcloud builds triggers describe {NAME} --format=json > config.json`
    2. 修改 `disabled` 欄位並移除唯讀欄位 (`id`, `name`, `createTime`, `resourceName`)。
    3. 重新匯入: `gcloud builds triggers update {TYPE} {NAME} --trigger-config=config.json`
- **清理 Github 分支觸發**: 在切換到 Tag 觸發時，系統會自動處理或可透過 API 清除舊的分支正則表達式。

## 最佳實踐
- **IaC**: 建議使用 Terraform 管理大規模觸發條件。
- **動態環境變數**: 在 `cloudbuild.yaml` 中結合 `substitutions` 與 Bash 邏輯（如 `TAG_NAME` 解析）來動態調整建構參數（如 `PREDICT_MODE`）。
