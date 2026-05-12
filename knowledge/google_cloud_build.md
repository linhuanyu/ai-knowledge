# Google Cloud Build 知識點

本文件紀錄 Google Cloud Build (GCB) 的核心規範與常見問題解決方案。

## 1. 變數替換 (Substitutions) 規範

在 `cloudbuild.yaml` 或 Trigger 中使用自定義變數時，必須遵循以下規則：

- **命名規則**：自定義變數名稱**必須以底線 (`_`) 開頭**（例如：`_MODE`, `_VERSION`）。不帶底線的變數被視為內建變數（如 `$PROJECT_ID`）。
- **引用方式**：使用 `$_變數名` 或 `${\_變數名}`。建議使用 `${}` 以避免歧義。
- **預設值**：可在 `cloudbuild.yaml` 頂層定義 `substitutions` 區塊提供預設值。

## 2. Shell 變數轉義 (Escaping)

當在 `cloudbuild.yaml` 的 `bash` 腳本中使用 **Shell 自定義變數**時，必須使用 **雙錢字號 (`27012`)** 進行轉義。

- **原因**：GCB 會在執行前嘗試解析所有 `$VAR`。若 `VAR` 不是內建或自定義 Substitution，建構將失敗。
- **正確寫法**：
  ```yaml
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        MY_VAR="hello"
        echo $$MY_VAR  # 正確：GCB 會將其視為 Shell 變數
  ```

## 3. 觸發條件 (Triggers) 管理

### 更新觸發條件變數
- **覆蓋所有變數**：
  ```bash
  gcloud builds triggers update [NAME_OR_ID] --region=[REGION] --substitutions=_KEY=VALUE
  ```
- **僅更新/新增特定變數**：
  ```bash
  gcloud builds triggers update [NAME_OR_ID] --region=[REGION] --update-substitutions=_KEY=VALUE
  `
