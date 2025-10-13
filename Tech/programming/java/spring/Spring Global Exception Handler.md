
# What it is

A **global exception handler** centralizes how your app turns Java exceptions into stable HTTP error responses. In Spring Boot you do this with:

- `@RestControllerAdvice` (or `@ControllerAdvice` for MVC/views)
    
- `@ExceptionHandler(...)` methods
    
- Optionally extending `ResponseEntityExceptionHandler` to reuse Spring’s defaults (validation, binding, etc.)
    
- In Boot 3+, use **`ProblemDetail`** (RFC 7807) for a consistent JSON error shape.
    

---

# A clean, modern template (Boot 3+)

```java
@RestControllerAdvice
public class GlobalApiExceptionHandler extends ResponseEntityExceptionHandler {

  // Domain/business exception with an error code
  @ExceptionHandler(UserNotFoundException.class)
  ResponseEntity<ProblemDetail> handleUserNotFound(UserNotFoundException ex, HttpServletRequest req) {
    ProblemDetail pd = ProblemDetail.forStatus(HttpStatus.NOT_FOUND);
    pd.setTitle("User not found");
    pd.setDetail(ex.getMessage());                   // "User 42 not found"
    pd.setProperty("code", "USR_404");
    pd.setProperty("instance", req.getRequestURI());
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(pd);
  }

  // Validation errors from @Valid on request bodies
  @Override
  protected ResponseEntity<Object> handleMethodArgumentNotValid(
      MethodArgumentNotValidException ex, HttpHeaders headers,
      HttpStatusCode status, WebRequest request) {

    ProblemDetail pd = ProblemDetail.forStatus(HttpStatus.UNPROCESSABLE_ENTITY);
    pd.setTitle("Validation failed");
    var fieldErrors = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> Map.of("field", fe.getField(), "message", fe.getDefaultMessage()))
        .toList();
    pd.setProperty("errors", fieldErrors);
    pd.setProperty("code", "VAL_422");
    return ResponseEntity.unprocessableEntity().body(pd);
  }

  // Query/path param validation (e.g., @Validated on controller)
  @ExceptionHandler(ConstraintViolationException.class)
  ResponseEntity<ProblemDetail> handleConstraintViolation(ConstraintViolationException ex) {
    ProblemDetail pd = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
    pd.setTitle("Invalid request");
    pd.setProperty("errors", ex.getConstraintViolations().stream()
        .map(v -> Map.of("param", v.getPropertyPath().toString(), "message", v.getMessage()))
        .toList());
    pd.setProperty("code", "VAL_400");
    return ResponseEntity.badRequest().body(pd);
  }

  // Fallback (don’t leak internals)
  @ExceptionHandler(Exception.class)
  ResponseEntity<ProblemDetail> handleUnknown(Exception ex, HttpServletRequest req) {
    // log with correlation id, stack trace; return generic message to caller
    ProblemDetail pd = ProblemDetail.forStatus(HttpStatus.INTERNAL_SERVER_ERROR);
    pd.setTitle("Internal error");
    pd.setDetail("An unexpected error occurred. Please try again later.");
    pd.setProperty("code", "GEN_500");
    pd.setProperty("instance", req.getRequestURI());
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(pd);
  }
}
```

**Notes**

- ProblemDetail is the spring class that is available for spring 3
- `ProblemDetail` fields you’ll typically set: `title`, `detail`, `status`. Add custom properties like `code`, `errors[]`, `instance`, `correlationId`.
    
- Put a **narrow handler per domain exception**, plus a **catch-all**.
    

---

# How you raise errors from controllers/services

- For _client mistakes_ (resource missing, invalid state), throw a **typed exception** and let the advice map it:
    
    ```java
    if (user == null) throw new UserNotFoundException("User %s not found".formatted(id));
    ```
    
- For quick one-offs in controllers, `throw new ResponseStatusException(HttpStatus.NOT_FOUND, "...")`.
    
- For validation: annotate DTOs with `@Valid` + Bean Validation (`@NotBlank`, `@Email`, …).
    

---

# Response shape (example JSON)

```json
{
  "type": "about:blank",
  "title": "Validation failed",
  "status": 422,
  "detail": "One or more fields are invalid.",
  "code": "VAL_422",
  "errors": [
    { "field": "email", "message": "must be a well-formed email address" },
    { "field": "age",   "message": "must be greater than or equal to 18" }
  ],
  "instance": "/api/users"
}
```

---

# Industrial best practices

**1) Use Problem Details (RFC 7807)**

- Stable shape across all errors; clients can parse reliably.
    
- Include a **short machine code** (`code`) and a human message (`detail`).
    
- Optionally provide a `type` URL for docs, e.g., `https://errors.yourco.com/user/not-found`.
    

**2) Don’t leak internals**

- Never return stack traces, SQL errors, class names, or secrets.
    
- Generic messages for 5xx; detailed messages only for your own logs.
    

**3) Logging discipline**

- **Log once at the edge** (the global handler) with stack trace and a **correlation ID** in MDC:
    
    - Propagate `X-Request-ID` header; generate if absent.
        
    - Log level guidelines:
        
        - 4xx you expected → `INFO` (or `WARN` if interesting).
            
        - 5xx → `ERROR`.
            
- Avoid “log spam” at multiple layers.
    

**4) Validation first**

- Prefer Bean Validation to fail fast before business logic.
    
- Return **422** for body validation, **400** for param/format issues.
    

**5) Exception taxonomy**

- Create a small set of **domain exceptions** (e.g., `ResourceNotFound`, `Conflict`, `Forbidden`, `RateLimited`, `BusinessRuleViolation`).
    
- Map them to appropriate HTTP statuses (404, 409, 403, 429, 422…).
    

**6) Idempotency & retries**

- For endpoints that clients may retry, combine with **idempotency keys** and return the **same** error (including `code`) on replays.
    

**7) Observability**

- Emit metrics: counts by `status`, `code`, controller; top N messages.
    
- Trace errors using OpenTelemetry; add attributes like `error.code`.
    

**8) Versioning & i18n**

- Keep `code` stable across versions; you can translate `detail` by locale if needed.
    
- Provide a doc page per `type` with troubleshooting steps.
    

**9) Security exceptions**

- Map authN/authZ uniformly:
    
    - `AuthenticationException` → 401 with `WWW-Authenticate` header if relevant.
        
    - `AccessDeniedException` → 403.
        
- Don’t reveal which part of credentials failed.
    

**10) Async/Reactive gotchas**

- `@RestControllerAdvice` works with **WebFlux** too. For raw WebFlux pipelines, you can also use a `@Component``WebExceptionHandler`.
    
- For `@Async` methods, configure an `AsyncUncaughtExceptionHandler` to capture background errors.
    

**11) Keep handlers thin**

- Only translate exception → response. Put business decisions (e.g., compensations) in services.
    


**Bottom line:**  
Centralize errors with `@RestControllerAdvice`, return **Problem Details** with stable `code`s, log once with correlation IDs, validate early, and never leak internals. This gives you predictable client contracts _and_ clean operations.

## On Error send response on ProblemDetail standard format

You _can_ return a single “envelope” shape for everything, but the industry trend (and Spring 6/Boot 3 defaults) is: **use HTTP status codes + RFC 7807 Problem Details for errors**, and your normal JSON for successes. It’s simpler for clients, better-supported by tools, and still lets you add custom fields.


# Why prefer Problem Details for errors

- **Standardized**: Many clients, gateways, and tools recognize `application/problem+json`.
    
- **HTTP-friendly**: Uses real 4xx/5xx statuses instead of overloading a `{ "status": "failed" }` field.
    
- **Extensible**: You can add your own fields (`code`, `correlationId`, etc.) without losing compatibility.
    
- **Less boilerplate**: Spring already builds and serializes `ProblemDetail`.

Yes—standard practice is:

1. **Use the HTTP status first.**
    
    - **2xx ⇒ success body** (your normal JSON schema).
        
    - **4xx/5xx ⇒ error body** (usually `application/problem+json` with RFC 7807).
        
2. **Confirm via `Content-Type`.**
    
    - Success: `application/json` (or your variant).
        
    - Error: `application/problem+json` (Problem Details).
        
3. **Then parse accordingly** (deserialize into the right model).
    

This is how common clients behave/are used:

### JavaScript

**fetch**

```js
const res = await fetch(url, { headers: { Accept: "application/json, application/problem+json" }});
if (res.ok) {
  const data = await res.json();       // success schema
  return data;
} else {
  const ct = res.headers.get("content-type") || "";
  const err = ct.includes("application/problem+json") ? await res.json() : { detail: await res.text() };
  throw err;                            // Problem Details or plain text
}
```

**axios**

- Axios **throws** for non-2xx. You catch and inspect `error.response`:
    

```js
try {
  const { data } = await axios.get(url, { headers: { Accept: "application/json, application/problem+json" }});
  return data;
} catch (e) {
  const res = e.response;
  if (res && res.headers["content-type"]?.includes("application/problem+json")) {
    throw res.data;                     // RFC 7807 JSON
  }
  throw new Error(res ? await res.data : e.message);
}
```

### Java (Spring)

**WebClient**

```java
WebClient client = WebClient.builder()
  .defaultHeader(HttpHeaders.ACCEPT, "application/json, application/problem+json")
  .build();

Mono<MyDto> call = client.get().uri("/api/thing")
  .retrieve()
  .onStatus(HttpStatusCode::isError, r ->
      r.headers().contentType().map(ct -> ct.isCompatibleWith(MediaType.APPLICATION_PROBLEM_JSON)).orElse(false)
        ? r.bodyToMono(ProblemDetail.class).flatMap(pd -> Mono.error(new MyApiException(pd)))
        : r.bodyToMono(String.class).flatMap(body -> Mono.error(new MyApiException(body))))
  .bodyToMono(MyDto.class);
```

**RestTemplate**

- Non-2xx throws `HttpStatusCodeException`; you can read the body and try to map to `ProblemDetail`.
    

### Python (requests)

```python
import requests
headers = {"Accept": "application/json, application/problem+json"}
r = requests.get(url, headers=headers)
ct = r.headers.get("Content-Type", "")
if 200 <= r.status_code < 300:
    data = r.json()
else:
    err = r.json() if "application/problem+json" in ct else {"detail": r.text}
    raise Exception(err)
```

### OpenAPI/Swagger codegen

- Generated clients typically:
    
    - Deserialize **2xx** into success models.
        
    - For **4xx/5xx**, throw an `ApiException` carrying status, headers, and body; you can map the body to Problem Details if `Content-Type` matches.
        

### Gateways & middlewares

- API gateways (Kong, NGINX, Spring Cloud Gateway) and proxies rely on **status codes** for routing/retries. Returning 200 with an “error envelope” breaks that. Use proper 4xx/5xx.
    

---

## Recommended contract & headers

- **Success:** `200/201/204` with `Content-Type: application/json`.
    
- **Errors:** proper `4xx/5xx` with `Content-Type: application/problem+json`.
    
- Clients send `Accept: application/json, application/problem+json`.
    
- Include stable fields like `code`, `correlationId` in Problem Details via `setProperty`.
    

## TL;DR

Clients should **branch on HTTP status**, then **confirm `Content-Type`**, then **deserialize into the right schema** (success model vs Problem Details). That’s the de-facto standard and plays nicely with tooling, retries, caching, and observability.