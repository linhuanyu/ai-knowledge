---
name: backend-java-programming
description: 所有要開發與 review Java 後端程式時都要參考的開發標準與模式。
---

# Backend Development Guidelines (Java & Spring Boot)

本文件定義了後端開發的編碼標準與模式，專注於 Java、Spring Boot 以及特定的實用模式。

## 1. Entity Model Rules (`model.entity`)
- **Jakarta Persistence**: 使用 `@Entity` 與 `jakarta.persistence` 註解進行 ORM 映射。
- **Lombok**: 使用 `@Data`, `@NoArgsConstructor`, 與 `@AllArgsConstructor`。
- **Primary Keys**: 使用 `@Id` 與 `@GeneratedValue(strategy = GenerationType.IDENTITY)`。
- **Documentation**: 在欄位後方加上行尾註釋 (`//`) 來描述其用途與可能的數值。

## 2. Enum Rules (`model.enumType`)
- **Internal Value**: Enum 應具備一個 `final` 欄位（如 `value` 或 `code`）來儲存資料庫數值。
- **Lombok**: 使用 `@AllArgsConstructor` 與 `@Getter`。
- **Naming**: Enum 常量應使用 `PascalCase`。
- **Structure**:
  ```java
  @AllArgsConstructor
  @Getter
  public enum Status {
      Enable(1),
      Disable(0);
      final int value;
  }
  ```

## 3. DTO Rules (`model.dto`)
- **Lombok**: 使用 `@Data`, `@NoArgsConstructor`, 與 `@AllArgsConstructor`。
- **Purpose**: 使用 DTO 進行層與層之間的資料傳輸（Controller 到 Service、外部 API）。
- **Naming**: 務必以 `Dto` 為後綴（例如 `UserDto`）。
- **Comments**: 為欄位加上註釋以解釋業務意義。

## 4. System Utility Class Rules (`model.utility`)
- **Domain-Specific Logic**: 用於複雜計算或非實體的資料結構。
- **Lombok**: 視需求使用 `@Data` 或 `@AllArgsConstructor`。

## 5. Mapper Rules (`mapper`)
- **MapStruct**: 使用 MapStruct 處理 Entity 與 DTO 之間的物件映射。
- **Spring Integration**: 在介面加上 `@Mapper(componentModel = "spring")` 註解。
- **Target Mapper Rule**: 「目標是什麼就是什麼的 Mapper」。
    - Entity 的 Mapper 放在 `mapper.entity`，例如 `UserMapper`。
    - DTO 的 Mapper 放在 `mapper.pub` 或其他對應路徑，例如 `UserInfoDtoMapper`。
- **Explicit Field Mapping**: 「明確寫出每個 field 的 mapping」。
    - 所有 Mapper 的方法都應明確使用 `@Mapping` 定義目標物件的所有欄位（Target Fields）。
    - 即使來源與目標欄位名稱相同，也必須明確寫出，以增加程式碼透明度並避免自動對應可能帶來的隱性問題。
- **Naming**: 以 `Mapper` 為後綴（例如 `UserMapper`）。

## 6. Controller Rules (`controller`)
- **Annotations**: 使用 `@RestController` 與 `@RequestMapping`。
- **Injection**: 使用 Lombok 的 `@RequiredArgsConstructor` 進行建構子注入。
- **Exceptions**: 拋出自定義異常，如 `BadRequestException` 或 `DataNotFoundException`。
- **Authentication**: 透過 `CurrentUserService` 存取當前使用者資訊。

## 7. Service Rules (`service`)
- **Annotations**: 使用 `@Service`。
- **Injection**: 使用 `@RequiredArgsConstructor`。
- **Business Logic**: 所有業務邏輯必須位於 Service 層。
- **Logging**: 使用 `@Slf4j`。
- **Transactions**: 針對包含多個資料庫操作的方法使用 `@Transactional`。

## 8. DAO/Repository Rules (`repository`)
- **Spring Data JPA**: 繼承 `JpaRepository<Entity, IdType>`。
- **Naming**: 以 `Dao` 為後綴（例如 `UserDao`）。
- **Query Methods**: 使用基於屬性的查詢推導（例如 `findByStatus`）。

## 9. General Coding Rules
- **Explicit Typing**: 避免使用 `var` 關鍵字。務必使用明確的類型宣告以提升可讀性與清晰度。
- **Multi-line Strings**: 針對所有多行純文字字串使用 Text Blocks (`"""`)，以保持格式整潔。
- **String Formatting**: 在字串中插入變數時，使用 `.formatted(...)` 方法，而非字串拼接或 `String.format()`。

## 10. RedisService Rules
- **API Reference**: 使用 `RedisService` 時，務必參考專案知識庫（例如 `.ai/knowledge/redis-service-api.md`）以獲得正確的方法簽章與異常處理資訊。

## 11. Build and Test Rules
- **Build Tool**: 使用 Gradle (`gradlew`) 進行所有構建與測試任務。
- **Testing**: 使用 `./gradlew test` 或 `./gradlew test --tests <TestClassName>` 執行測試。**切勿**使用 Maven (`mvn`)。
