---
name: backend-db-query
description: 後端程式處理資料庫存取 (DB Access) 或調用 DAO 時需要注意的知識。
---

# DB Query Optimization Skill

## Context
- Java Spring Boot environment using JPA/Hibernate.
- Standard Java 8+ Stream API.

## When to use this skill
- 當你正在撰寫或修改 Java 程式碼，且在迴圈 (Loop) 或 Stream 中執行資料庫查詢時。
- 當你正在實作 Mapper 或 Service 方法，需要將實體清單轉換為包含關聯資料的 DTO 時。
- 當你偵測到對同一個 DAO/Repository 方法的多次調用可以合併為單次批量查詢時。

## How to use it
為了防止 N+1 查詢造成的效能下降，你 **必須** 遵循以下步驟：

1. **收集查詢鍵 (ID Collection)**：
    - 在開始任何迴圈或 Stream 映射之前，先遍歷主清單，將所有需要的 ID 或 Key 收集到 `Set` 或 `List` 中。
2. **執行批量查詢 (Batch Fetching)**：
    - 確認對應的 DAO 具備 `In` 查詢方法（例如 `findByHerbIdIn(Collection<Long> herbIds)`）。若無，請先在 DAO 介面中建立。
    - 在迴圈外調用此方法一次，獲取所有相關記錄。
3. **建立 Map 索引 (Indexing)**：
    - 使用 Java Stream API 將結果整理成標準 `Map`：
        - **1對1 關係**：`results.stream().collect(Collectors.toMap(KeyExtractor, Function.identity()))`
        - **1對多 關係**：`results.stream().collect(Collectors.groupingBy(KeyExtractor))`
4. **O(1) Map 存取**：
    - 在主迴圈或 Stream 映射內部，從步驟 3 建立的 Map 中獲取關聯資料。**絕對禁止** 在迴圈內調用 DAO。

### 範例對比

#### ❌ 低效寫法 (N+1)
```java
return herbs.stream().map(herb -> {
    // 迴圈內調用 DAO - 效能陷阱！
    List<HerbReferenceRelation> relations = herbReferenceRelationDao.findByHerbId(herb.getId());
    return toDto(herb, relations);
}).toList();
```

#### ✅ 優化寫法 (Batch Fetching + Standard Map)
```java
// 1. 收集 ID
Set<Long> herbIds = herbs.stream().map(Herb::getId).collect(Collectors.toSet());

// 2. 批量查詢
List<HerbReferenceRelation> allRelations = herbReferenceRelationDao.findByHerbIdIn(herbIds);

// 3. 建立索引 (使用 Standard Java Map)
Map<Long, List<HerbReferenceRelation>> relationMap = allRelations.stream()
    .collect(Collectors.groupingBy(HerbReferenceRelation::getHerbId));

// 4. 快速存取 (使用 getOrDefault 處理空值)
return herbs.stream().map(herb -> {
    List<HerbReferenceRelation> myRelations = relationMap.getOrDefault(herb.getId(), List.of());
    return toDto(herb, myRelations);
}).toList();
```
