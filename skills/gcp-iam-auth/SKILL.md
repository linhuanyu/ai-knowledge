---
name: gcp-iam-auth
description: Patterns and implementation guide for authenticating with GCP Cloud Run or other IAM-restricted services using ID Tokens. Use this skill when implementing or refactoring backend services that need to call GCP APIs or internal Cloud Run services requiring IAM invoker permissions.
---

# GCP IAM Authentication (ID Token)

This skill provides the standard implementation pattern for Java/Spring Boot applications to authenticate with IAM-restricted GCP services (like Cloud Run) using ID Tokens.

## Core Pattern: IAMAuthService

The recommended approach is to create a dedicated `IAMAuthService` that handles token acquisition with a fallback mechanism for local development.

### Implementation Guide

#### 1. Configuration (ConfigService)
Ensure your configuration service can handle an optional service account key path. This allows local development without setting global environment variables.

```java
@Value("${lingshu.gcp.key:}")
private String gcpKey;
```

#### 2. Service Implementation (IAMAuthService)
The service should prioritize the configured key file, then fallback to Application Default Credentials (ADC).

```java
@Service
@RequiredArgsConstructor
public class IAMAuthService {
  private final ConfigService configService;

  public String getIdToken(String audience) throws LSInternalErrorException {
    try {
      GoogleCredentials credentials;
      // 1. Try explicit key file if configured and exists
      if (StringUtils.isNotBlank(configService.getGcpKey()) && new File(configService.getGcpKey()).exists()) {
        try (FileInputStream fis = new FileInputStream(configService.getGcpKey())) {
          credentials = GoogleCredentials.fromStream(fis);
        }
      } else {
        // 2. Fallback to Application Default Credentials (ADC)
        credentials = GoogleCredentials.getApplicationDefault();
      }

      if (credentials instanceof IdTokenProvider idTokenProvider) {
        // Audience should be the URL of the target service
        return idTokenProvider.idTokenWithAudience(audience, null).getTokenValue();
      }
      throw new LSInternalErrorException(new RuntimeException("Credentials do not support ID Tokens."));
    } catch (IOException e) {
      throw new LSInternalErrorException(new RuntimeException("Failed to get IAM ID Token: " + e.getMessage(), e));
    }
  }
}
```

#### 3. Usage in Connection Services
Inject `IAMAuthService` and use it to add the `Authorization` header.

```java
private Map<String, String> getAuthHeaders() throws LSInternalErrorException {
    String audience = configService.getTargetServiceUrl();
    String token = iamAuthService.getIdToken(audience);
    return Map.of("Authorization", "Bearer " + token);
}
```

## Testing Patterns

Use Mockito to verify both the explicit key and ADC fallback paths.

```java
@ExtendWith(MockitoExtension.class)
class IAMAuthServiceTest {
    @Mock private ConfigService configService;
    @InjectMocks private IAMAuthService iamAuthService;

    @Test
    void testGetIdToken_FallbackToADC() throws IOException, LSInternalErrorException {
        when(configService.getGcpKey()).thenReturn("");
        
        try (MockedStatic<GoogleCredentials> mockedGoogleCredentials = mockStatic(GoogleCredentials.class)) {
            mockedGoogleCredentials.when(GoogleCredentials::getApplicationDefault).thenReturn(mockCredentials);
            // ... verify token acquisition
        }
    }
}
```

## When to use this skill
- When calling a Cloud Run service that has "Allow unauthenticated" turned OFF.
- When you need to programmaticly obtain an OIDC ID Token for GCP.
- When setting up local development environments to use a specific service account JSON key.
