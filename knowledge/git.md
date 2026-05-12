# Git 知識點

## 標籤推送 (Tag Push) 與 CI/CD 觸發

### 多標籤指向同一提交的觸發問題
當多個 Git Tag 指向「同一個提交 (SHA)」且同時推送時（例如使用 `git push origin --tags` 或一次推送多個 tag），GitHub 的 Webhook 可能只會發送一個 `push` 事件。Cloud Build 在收到此事件時，可能只會匹配並啟動一個 Trigger，導致其他同樣符合該提交但標籤名稱不同的 Trigger 被略過。

**建議做法：**
為了確保所有相關的 Cloud Build Trigger 都能被正確喚醒，應分開推送標籤，並在推送之間加入間隔（例如 3-5 秒）。

**範例腳本：**
```bash
git tag v1.1-back
git tag v1.1-front
git push origin v1.1-back && sleep 3 && git push origin v1.1-front
```
