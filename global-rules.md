# Global Personal Memory

# 規則與工具位置定義
- **全域規則**：`~/.ai/global-rules.md`
- **全域 Skills**：`~/.ai/skills/`
- **全域 Subagent 規則**：`~/.ai/agents/`
- **專案規則**：`{專案目錄}/.ai/global-rules.md`
- **專案 Skills**：`{專案目錄}/.ai/skills/`

# 知識管理優先
- **知識點存放位置**：
  - 專案知識點：`.ai/knowledge/`
  - 共同知識點：`~/.ai/knowledge/`
- **索引機制**：每個目錄應包含 `index.md` 說明檔案內容簡介。若不存在，應遍覽知識點後建立。
- **閱讀流程**：參考知識點前必須先閱讀 `index.md` 以選擇適合的檔案。
- **執行時機**：在任何開發、分析或重構任務開始前，應主動檢查知識點並在結束後更新記錄。

# 任務管理與延續 (Task Management)
- **專案任務管理位置**：
  - 專案任務管理放在 `.ai/tasks/{task name}/` 中。
  - **環境檢查**：專案的 `.gitignore` 必須排除 `.ai/tasks/`，但應包含 `.ai/` 的其他部分（如知識點 `.ai/knowledge/`）。
- **多步驟計畫**：對於預期超過 1 個步驟的任務，必須建立 Markdown 格式的計畫清單 `plan.md`。
- **進度追蹤**：每執行一個步驟後，應在計畫檔案或 `current-note.md` 中標記進度。
- **動態調整**：若執行過程中遇到問題，應先紀錄在 `current-note.md`，並且修正 `plan.md`。
- **工作恢復**：若要繼續工作，先閱讀專案下的 `plan.md` 與 `current-note.md` 理解狀況，並向使用者彙報進度後再開始工作。
- **任務清理**：當任務完全執行結束且驗證無誤後，應清理相關計畫檔案。

