# Exception Handling strategy

## 1) Goals & Principles

* **Consistency:** One error shape across all endpoints.
* **No leakage:** Never expose stack traces, SQL/API details, PII, or configs.
* **Actionability:** Clear user-facing message + developer-facing diagnostics (via logs/trace).
* **Deterministic mapping:** Same failure → same HTTP status and error code.
* **Observability-first:** Every error path is traceable, searchable, and alerts correctly.

## 2) Error Model (Problem Details)

Adopt **Problem Details for HTTP APIs (RFC 9457)** as the canonical error envelope. Standard fields:

* `type` (URI for error category), `title` (short human label),
* `status` (HTTP), `detail` (safe, user-facing explanation), `instance` (request path).
  Extend with:
* `code` (compact, stable application error code, e.g., `USR_001`),
* `correlationId` / `traceId`,
* `violations` (for validation issues),
* `retryable` (boolean), `hint` (next-step guidance),
* optional `source` (field/path that failed).

## 3) Exception Taxonomy

Define a small, stable set of **domain exceptions** that map 1:1 to error categories:

* **Client/Request**

  * `ValidationException` (body/query/header/path errors)
  * `ConstraintViolation` (bean validation)
  * `NotFoundException` (entity/resource)
  * `ConflictException` (version/concurrency, duplicate)
  * `UnauthorizedException` / `ForbiddenException`
  * `RateLimitExceededException`
* **Domain/Business**

  * `BusinessRuleException` (legal state violations)
* **Integration**

  * `DownstreamTimeoutException`
  * `Downstream4xxException` / `Downstream5xxException`
  * `CircuitOpenException`
* **Infrastructure**

  * `DataAccessException` (normalized category), `StorageUnavailableException`
* **Server**

  * `InternalErrorException` (unexpected)
    Each exception carries: **error code**, **safe message**, **retryable?**, and optional **metadata** (non-PII).

## 4) HTTP Mapping (deterministic)

* 400: validation/format errors, unsupported media, bad params.
* 401/403: authn/authz failures.
* 404: missing resource.
* 409: optimistic locking conflict, duplicates.
* 415/406: media type negotiation issues.
* 422: semantically valid JSON but domain rule failure (optional policy).
* 429: rate limited.
* 499 (custom app layer only, not HTTP): client cancelled (log/metrics only).
* 502/503/504: downstream or platform unavailability/timeouts.
* 500: unhandled exceptions.

## 5) Handling Architecture

* **Global Handler Layer:** A single cross-cutting handler (e.g., `ControllerAdvice` conceptually) translates exceptions → Problem Details envelope.
* **Layered Throwing:**

  * **Controller**: Never builds error bodies; just throws domain/request exceptions.
  * **Service**: Throws domain/business exceptions; never HTTP-aware.
  * **Client/Repository**: Normalizes vendor/library exceptions to integration/data exceptions.
* **Message Hygiene:**

  * `detail` is safe and user-targeted.
  * Dangerous info goes only to logs (with traceId).

## 6) Validation Strategy

* **Request-level:** Bean Validation for DTOs; collect all violations → `violations[]` with `{field, message, code}`.
* **Domain-level:** Business rule checks throw `BusinessRuleException` with precise `code` (e.g., `ORDER_MIN_AMOUNT`).
* **Idempotent Writes:** Use idempotency keys; on replay collisions respond with 409 or return prior result.

## 7) Observability & Forensics

* **Correlation/Trace IDs:** Inject into every response (success + error).
* **Structured Logging:** Log one concise error event with fields: `traceId`, `errorCode`, `httpStatus`, `category`, `retryable`, `tenant`, `principal`, `endpoint`, latency.
* **Metrics:**

  * Counters by `errorCode` and `httpStatus`.
  * Timers for downstream calls; **error rate SLOs** per route.
* **Alerts:** Thresholds on 5xx rate, timeouts, circuit breaks, and specific `errorCode`s.

## 8) Downstream/Integration Failures

* **Time-boxing:** Enforce strict client timeouts (connect/read).
* **Circuit Breakers & Bulkheads:** Convert open circuits to well-known `CircuitOpenException` (→ 503).
* **Retry Semantics:** Only for idempotent operations; classify **retryable vs. non-retryable** and surface that flag in error body.
* **Graceful Degradations:** Fallback data or feature flags where appropriate.

## 9) Security Considerations

* **PII Scrubbing:** Never echo secrets, tokens, internal IDs, SQL, stack traces.
* **Auth Errors:** Use neutral wording (don’t reveal which credential failed).
* **Multi-tenant:** Include tenant in logs/metrics; never in error `detail` unless safe.
* **Rate Limiting:** Return 429 with reset hint (e.g., `hint: "Retry after 2s"`).

## 10) Async & Streaming Paths

* **@Async / Events / Messaging:**

  * Use a parallel **error envelope** for DLQs and audit topics (`code`, `message`, `payloadRef`, `traceId`).
  * Implement dead-letter policies, retry schedules (exponential with jitter), and poison-message detection.
* **SSE/WebSocket/Streaming:** Send structured terminal error frames consistent with Problem Details fields.

## 11) Versioning & Backward Compatibility

* **Stable `code` values:** Treat them as an external contract (document them).
* **Additive Evolution:** You can add fields to the error body; avoid removing or renaming.
* **Problem `type` URIs:** Publish a catalog (human-readable docs) for each error code/category.

## 12) Documentation & DX

* **Error Catalog:** Table of `code` → meaning, typical causes, HTTP status, `retryable`, remediation steps.
* **OpenAPI:** Define global error schema and per-operation responses with examples.
* **Runbooks:** For on-call: “If code X spikes, check Y dashboards, Z downstream.”

## 13) Testing Strategy

* **Contract Tests:** Verify request → exception → exact HTTP status + body shape.
* **Boundary Tests:** Validation (missing/extra fields), media types, large payloads.
* **Chaos/Resilience:** Downstream timeouts, 429s, 5xx storms, circuit-open states.
* **Idempotency & Concurrency:** Conflicts (409), duplicate submissions.
* **Red-Team:** Ensure no stack traces or sensitive info ever appear in responses.

## 14) Governance & Implementation Checklist

* Single global handler pattern agreed and enforced.
* Mandatory mapping table (exception → `status`, `code`, `type`).
* Library/DB/HTTP client exception normalization policy.
* Default “last-resort” handler → 500 with generic message.
* PII scrubber in logs; sampling for 4xx vs 5xx.
* Playbooks for rollout and regression gates (lint rules, PR checks).



----

# **key Spring (and Spring Boot) classes & annotations** you’ll use to build a clean, production-grade **exception handling** design, plus when and why to use each.

## Core, framework-level

**`@ControllerAdvice` / `@RestControllerAdvice`**

* *What:* Cross-cutting exception (and binding) handler for all controllers.
* *When:* Centralize mapping of exceptions → HTTP responses.
* *Tips:* Use `@RestControllerAdvice` for JSON APIs; combine with `@Order` to control precedence (e.g., a “framework” advice first, a “domain” advice second).

**`@ExceptionHandler`**

* *What:* Method-level mapping from one or more exception types to a response.
* *When:* In your `@RestControllerAdvice` (preferred) or a single controller for local handling.
* *Tips:* Keep handlers single-purpose by exception category (validation, business, integration).

**`ResponseEntityExceptionHandler` (Spring MVC)**

* *What:* Base class that already handles many MVC exceptions (405, 415, etc.).
* *When:* Extend to override/standardize Spring’s defaults (e.g., `HttpMessageNotReadableException`).
* *Tips:* Good place to normalize framework errors into your API’s error envelope.

**`HandlerExceptionResolver` & `DefaultHandlerExceptionResolver`**

* *What:* SPI that translates exceptions raised during handler execution into responses.
* *When:* Rare; use for cross-cutting behavior that predates controller layer (low-level filters) or for libraries.
* *Tips:* Prefer `@ControllerAdvice` unless you need very early interception.

**`ProblemDetail` (Spring 6 / Boot 3)**

* *What:* Built-in representation of RFC 9457 Problem Details.
* *When:* Standardize your error shape consistently across the app.
* *Tips:* Add app-specific fields (e.g., `code`, `correlationId`, `violations`) via `ProblemDetail#setProperty`.

**`@ResponseStatus` & `ResponseStatusException`**

* *What:* Declarative status mapping.
* *When:* For simple, stable mappings (e.g., `NotFoundException → 404`).
* *Tips:* Use sparingly—domain exceptions plus centralized handlers are usually clearer. `ResponseStatusException` is handy for early, explicit aborts.

**`ErrorController`, `BasicErrorController`, `ErrorAttributes` (Spring Boot)**

* *What:* Boot’s default error endpoint (`/error`) and pluggable attributes.
* *When:* Customize the fallback error response for unmapped routes or filter-level failures.
* *Tips:* Replace/augment `ErrorAttributes` to ensure even “last-resort” errors match your envelope.

## Validation & binding

**Bean Validation annotations (`jakarta.validation.*`: `@NotNull`, `@Size`, …)**

* *What:* Declarative request/DTO validation.
* *When:* Validate request bodies, path variables, query params.
* *Tips:* Keep messages user-safe; map violations into a `violations[]` section.

**`@Validated` (Spring)**

* *What:* Triggers Bean Validation at method level and for `@ConfigurationProperties`.
* *When:* Validate controller method parameters, service boundaries, startup config.
* *Tips:* Consider groups for create/update semantics; collect `ConstraintViolationException` centrally.

**Key MVC exceptions to map**

* `MethodArgumentNotValidException` / `BindException` (Bean Validation & data binding)
* `ConstraintViolationException` (method-level/parameter validation)
* `MissingServletRequestParameterException` / `MethodArgumentTypeMismatchException` (bad params)
* `HttpMessageNotReadableException` (malformed JSON)
* `HttpRequestMethodNotSupportedException` (405),
  `HttpMediaTypeNotSupportedException` (415),
  `HttpMediaTypeNotAcceptableException` (406)

## Security

**Spring Security exceptions**

* `AuthenticationException` → map to **401** (via `AuthenticationEntryPoint`)
* `AccessDeniedException` → map to **403** (via `AccessDeniedHandler`)
* *Tips:* Keep responses neutral (don’t leak which credential failed). Ensure your global advice doesn’t fight Security’s own handlers; configure both to produce the same envelope.

# Integration & data access

**`DataAccessException` hierarchy (Spring Data/JDBC)**

* *What:* Consistent, vendor-agnostic data error taxonomy.
* *When:* Normalize SQL/driver errors (duplicate key → 409, connectivity → 503).
* *Tips:* Map subclasses deterministically (e.g., `DuplicateKeyException`, `CannotAcquireLockException`).

**Web client errors**

* `WebClientResponseException` (WebFlux) / `HttpStatusCodeException` (RestTemplate)
* *When:* Standardize downstream 4xx/5xx, timeouts, and circuit-open states to your integration error category.

# Reactive (WebFlux) counterparts (if applicable)

**`@RestControllerAdvice` (reactive)** still applies.
**`WebExceptionHandler`**

* *What:* Reactive, low-level error hook.
* *When:* Framework-level handling or when you need to operate before controller resolution.

## Cross-cutting utilities

**`@Order`**

* *What:* Control precedence of multiple advices/resolvers.
* *When:* Separate “framework” vs “domain” advice cleanly.

**SLF4J `MDC` (Mapped Diagnostic Context)**

* *What:* Correlate logs with `traceId`/`correlationId`.
* *When:* Populate in a filter/interceptor; include in every error response and log.

**`@Retryable` / Spring Retry (optional)**

* *What:* Declarative retries for transient faults.
* *When:* Idempotent calls to flaky downstreams; surface `retryable=true` in error bodies.
* *Tips:* Pair with timeouts and circuit breakers; never wrap non-idempotent writes blindly.

## Practical mapping guidance (no code—what to configure)

* **Global advice** (`@RestControllerAdvice`): one place to translate **(a)** validation/binding exceptions, **(b)** domain/business exceptions, **(c)** integration/data exceptions, and **(d)** last-resort `Throwable` into **ProblemDetail** with a **stable `code`**, HTTP `status`, a safe `detail`, and diagnostic properties (e.g., `traceId`, `retryable`, `violations`).
* **Extend** `ResponseEntityExceptionHandler` to normalize MVC/framework errors into your format.
* **Security**: configure `AuthenticationEntryPoint` and `AccessDeniedHandler` to output the *same envelope* as the advice.
* **Boot error path**: customize `ErrorAttributes` so `/error` matches your envelope.
* **Validation**: annotate DTOs with Bean Validation, add `@Validated` at controllers/services, and aggregate field errors into `violations[]`.
* **Data/HTTP clients**: catch and rethrow into **your** integration exception types (or map library exceptions centrally) so handlers stay deterministic.
* **Observability**: enrich every error with `traceId` (MDC), log structured events once per failure, and export metrics by `errorCode` + `status`.


---
# **production-oriented mapping table** for a Spring **MVC** REST API with **Spring Security enabled** and **JDBC/DataAccess** stack. 
 It standardizes exceptions → HTTP responses using a Problem-Details style envelope (RFC 9457). No code—just the contract.

## Canonical error shape (Problem Details)

* **Required fields:** `type` (URI), `title`, `status`, `detail`, `instance`
* **App extensions:** `code` (stable app code), `traceId` (from MDC), `retryable` (bool), `violations[]` (for validation), optional `hint`

> **Type URIs:** Use `/problems/<category>/<slug>` (served by your docs site).
> **Codes:** UPPER_SNAKE, stable (log/monitor/alert on these).

---

## Master mapping (MVC + Security + JDBC)

| Category                        | Typical Trigger (Spring/JDK)                                                     | HTTP | `type`                                     | `code`                     |     `retryable`    | Log level |
| ------------------------------- | -------------------------------------------------------------------------------- | ---: | ------------------------------------------ | -------------------------- | :----------------: | --------- |
| **Malformed JSON / body**       | `HttpMessageNotReadableException`                                                |  400 | `/problems/request/body-unreadable`        | `REQ_BODY_UNREADABLE`      |         no         | WARN      |
| **Missing/invalid params**      | `MissingServletRequestParameterException`, `MethodArgumentTypeMismatchException` |  400 | `/problems/request/param-invalid`          | `REQ_PARAM_INVALID`        |         no         | WARN      |
| **Validation errors (DTO)**     | `MethodArgumentNotValidException`, `BindException`                               |  400 | `/problems/request/validation`             | `REQ_VALIDATION_FAILED`    |         no         | WARN      |
| **Validation errors (method)**  | `ConstraintViolationException`                                                   |  400 | `/problems/request/constraint-violation`   | `REQ_CONSTRAINT_VIOLATION` |         no         | WARN      |
| **Unsupported method**          | `HttpRequestMethodNotSupportedException`                                         |  405 | `/problems/request/method-not-allowed`     | `REQ_METHOD_NOT_ALLOWED`   |         no         | INFO      |
| **Content type not supported**  | `HttpMediaTypeNotSupportedException`                                             |  415 | `/problems/request/unsupported-media-type` | `REQ_UNSUPPORTED_MEDIA`    |         no         | INFO      |
| **Not acceptable**              | `HttpMediaTypeNotAcceptableException`                                            |  406 | `/problems/request/not-acceptable`         | `REQ_NOT_ACCEPTABLE`       |         no         | INFO      |
| **Auth required**               | `AuthenticationException` → via `AuthenticationEntryPoint`                       |  401 | `/problems/security/unauthenticated`       | `SEC_UNAUTHENTICATED`      |        yes*        | WARN      |
| **Forbidden**                   | `AccessDeniedException` → via `AccessDeniedHandler`                              |  403 | `/problems/security/forbidden`             | `SEC_FORBIDDEN`            |         no         | WARN      |
| **Resource not found**          | your `NotFoundException`                                                         |  404 | `/problems/resource/not-found`             | `RES_NOT_FOUND`            |         no         | INFO      |
| **Conflict / duplicate**        | `DuplicateKeyException`, optimistic-lock error, your `ConflictException`         |  409 | `/problems/resource/conflict`              | `RES_CONFLICT`             |         no         | WARN      |
| **Unprocessable (domain rule)** | your `BusinessRuleException`                                                     |  422 | `/problems/domain/rule-violation`          | `DOMAIN_RULE_VIOLATION`    |         no         | WARN      |
| **Rate limited**                | gateway/limiter signal, `RateLimitExceededException`                             |  429 | `/problems/platform/rate-limited`          | `PLATFORM_RATE_LIMITED`    | yes (after window) | INFO      |
| **Downstream 4xx**              | `HttpStatusCodeException` (4xx), map to your `Downstream4xxException`            |  502 | `/problems/integration/bad-gateway`        | `INTG_DOWNSTREAM_4XX`      |         no         | WARN      |
| **Downstream 5xx**              | `HttpStatusCodeException` (5xx), `WebClientResponseException`                    |  502 | `/problems/integration/bad-gateway`        | `INTG_DOWNSTREAM_5XX`      |         yes        | ERROR     |
| **Downstream timeout**          | `ResourceAccessException`/timeout, `SocketTimeoutException`                      |  504 | `/problems/integration/timeout`            | `INTG_TIMEOUT`             |         yes        | ERROR     |
| **Circuit open**                | breaker open state                                                               |  503 | `/problems/integration/circuit-open`       | `INTG_CIRCUIT_OPEN`        |         yes        | WARN      |
| **Database duplicate**          | `DuplicateKeyException` (also in Conflict row)                                   |  409 | `/problems/data/duplicate-key`             | `DATA_DUPLICATE_KEY`       |         no         | WARN      |
| **DB unavailable**              | `CannotGetJdbcConnectionException`, `DataAccessResourceFailureException`         |  503 | `/problems/data/unavailable`               | `DATA_UNAVAILABLE`         |         yes        | ERROR     |
| **DB timeout/lock**             | `QueryTimeoutException`, `CannotAcquireLockException`                            |  503 | `/problems/data/timeout-or-lock`           | `DATA_TIMEOUT_OR_LOCK`     |         yes        | WARN      |
| **Integrity violation**         | `DataIntegrityViolationException`                                                |  422 | `/problems/data/integrity-violation`       | `DATA_INTEGRITY_VIOLATION` |         no         | WARN      |
| **Last-resort**                 | any uncaught `Throwable`                                                         |  500 | `/problems/server/unexpected`              | `SRV_UNEXPECTED_ERROR`     |         yes        | ERROR     |

* *Retryable for 401 depends on auth flow; generally no, but token refresh flows might retry.*

---

### JDBC/DataAccess nuances (Spring JDBC)

* Use Spring’s **`DataAccessException` hierarchy** to keep vendor-agnostic mapping:

  * **Duplicate** → `DuplicateKeyException` → **409**
  * **Integrity** → `DataIntegrityViolationException` → **422**
  * **Conn/Resource** → `CannotGetJdbcConnectionException`, `DataAccessResourceFailureException` → **503**
  * **Timeout/Lock** → `QueryTimeoutException`, `CannotAcquireLockException` → **503**
* Keep **DB messages out** of `detail`. If needed, attach safe hints (e.g., “constraint violated”) and log vendor codes/SQL states privately with `traceId`.

### Security path (Spring Security)

* Configure **`AuthenticationEntryPoint` (401)** and **`AccessDeniedHandler` (403)** to emit the **same envelope** as your MVC advice (Problem Details + `code` + `traceId`).
* Avoid revealing which credential failed; the `detail` should be neutral.

---

## Envelope population rules

* **`title`**: short, stable label (human-readable).
* **`detail`**: safe, user-facing message (no stack trace, SQL, secrets).
* **`instance`**: request path.
* **`traceId`**: from SLF4J **MDC** (populate in a servlet filter).
* **`violations[]`** (for validation): `{field, message, code?}`—aggregate all errors, don’t fail-fast.
* **`retryable`**:

  * `true` for transient platform/integration/database timeouts/outages (5xx/502/503/504).
  * `false` for client errors (4xx), domain rule violations, conflicts (unless your idempotency policy dictates returning prior success).
* **Headers** (when applicable):

  * `Retry-After` for **429/503**;
  * `WWW-Authenticate` for **401**;
  * correlation header like `X-Trace-Id` on all responses.

---

# Logging, metrics, and SLOs (operability)

* **Log once** per failure (at the handler), structured: `timestamp, traceId, httpStatus, code, category, retryable, endpoint, principal/tenant, cause.class`.
* **Metrics:** counters by `{code,status}`; timers for downstream clients; alert on spikes in `SRV_UNEXPECTED_ERROR`, `DATA_UNAVAILABLE`, `INTG_TIMEOUT`.
* **Sampling:** consider sampling WARN logs for noisy 4xx classes; never sample 5xx.

---

## Testing checklist (contract, not code)

* **Contract tests** per row in the table: throw representative exception ⇒ assert exact `status`, `type`, `code`, `retryable`, and presence of `traceId`.
* **Validation aggregation:** ensure multiple field errors produce a complete `violations[]`.
* **Security path:** unauthenticated (401) vs forbidden (403) produce identical envelopes (different codes).
* **DataAccess adapters:** simulate duplicate key, connection down, lock timeouts.
* **Downstream clients:** simulate 4xx/5xx/timeout/circuit-open and verify mappings.
* **Red-team:** assert no stack traces or vendor SQL/URL details leak into `detail`.




