---
name: vertex-ai-training
description: 提供在 Google Cloud Vertex AI 上執行無伺服器訓練 (Serverless/Custom Training) 的指南與實作範例。當使用者需要進行大規模模型訓練、設定 CustomJob 或使用預建/自訂容器時，應參考此技能。
---

# Vertex AI Serverless Training (Custom Training)

Vertex AI 提供無伺服器 (Serverless) 的訓練環境，讓開發者只需專注於訓練程式碼，而不需管理底層 VM 基礎架構。

## 核心概念

- **CustomJob**: Vertex AI 中最基礎的訓練工作執行單元。
- **WorkerPoolSpec**: 用於定義訓練叢集的硬體規格。
    - `worker_pool_specs[0]` 為主要訓練節點。
    - 若進行分散式訓練，可定義多個 Worker Pool。
- **容器化策略**:
    - **預建容器 (Pre-built Containers)**: 內建 TensorFlow, PyTorch, XGBoost 等框架，適合標準工作流。
    - **自訂容器 (Custom Containers)**: 允許完全控制環境、安裝非 Python 套件或特定驅動程式。

## 準備工作

1. **Cloud Storage (GCS)**: 作為數據輸入與模型輸出 (Artifacts) 的存儲中心。
2. **Artifact Registry**: 若使用自訂容器，映像檔須推送到此。
3. **IAM 權限**: 執行帳號需具備 `aiplatform.user` 與 `storage.admin` 等角色。

## 實作指南

### 1. 使用 Python SDK (推薦方式)

適合整合進自動化 Pipeline 或筆記本環境。

```python
from google.cloud import aiplatform

# 初始化
aiplatform.init(
    project="YOUR_PROJECT_ID",
    location="us-central1",
    staging_bucket="gs://YOUR_BUCKET_NAME"
)

# 定義工作規格
job = aiplatform.CustomJob(
    display_name="vertex-training-job",
    worker_pool_specs=[{
        "machine_spec": {
            "machine_type": "n1-standard-4",
            "accelerator_type": "NVIDIA_TESLA_T4",
            "accelerator_count": 1,
        },
        "replica_count": 1,
        "container_spec": {
            "image_uri": "us-docker.pkg.dev/vertex-ai/training/tf-gpu.2-14.py310:latest",
            "command": ["python3", "task.py"],
            "args": ["--epochs", "50"],
        },
    }]
)

# 執行
job.run(sync=True)
```

### 2. 使用 gcloud CLI (快速腳本)

適合在 CI/CD 或本地終端機快速提交工作。

```bash
gcloud ai custom-jobs create \
    --region=us-central1 \
    --display-name="my-custom-job" \
    --worker-pool-spec=machine-type=n1-standard-4,replica-count=1,container-image-uri="us-docker.pkg.dev/vertex-ai/training/tf-gpu.2-14.py310:latest" \
    --args="--epochs=50"
```

### 3. 自動打包 (Autopackaging)

當程式碼位於本地且不想手動構建 Docker 時：

```bash
gcloud ai custom-jobs create \
    --region=us-central1 \
    --local-package-path="." \
    --python-module="trainer.task" \
    --worker-pool-spec=machine-type=n1-standard-4,replica-count=1,executor-image-uri="us-docker.pkg.dev/vertex-ai/training/tf-cpu.2-12.py310:latest"
```

## 最佳實踐

- **環境變數**: 訓練容器內可透過 `AIP_MODEL_DIR` 獲取輸出路徑。
- **日誌監控**: 透過 Cloud Logging 實時查看訓練日誌。
- **成本控制**: 善用 GPU 切分或選擇合適的機器類型。
