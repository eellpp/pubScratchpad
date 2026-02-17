In production Java systems, people almost always **don’t implement TLS “by hand.”** They rely on one of a few **standard HTTP client stacks** (Spring / Apache / OkHttp / JDK client) and focus on **how certificates & trust are provisioned** (keystores, truststores, rotation, alias selection, and debugging).

Below are the most common approaches you’ll see—especially for **mTLS**.

---

## 1) Spring ecosystem (most common in enterprise)

### A. **Spring `WebClient`** (recommended for new work)

* Used in reactive apps, but also fine in non-reactive if you need high concurrency.
* Typically backed by **Reactor Netty** (default) or **Jetty**.
* Good for: high throughput, streaming, async/non-blocking.

### B. **Spring `RestClient`** (modern synchronous replacement)

* Synchronous/blocking style, but modern API.
* Introduced as the newer option alongside WebClient; commonly chosen when you don’t want reactive complexity.
* Spring has been moving away from `RestTemplate` for new development. The Spring reference docs note `RestTemplate` is in maintenance mode. ([Home][1])
* Spring’s own blog outlines an intent to deprecate and eventually remove `RestTemplate` across future Spring Framework major versions. ([Home][2])

### C. **Spring `RestTemplate`** (legacy, still everywhere)

* Huge existing footprint in production.
* Still works, but “maintenance mode” and no longer the recommended choice for new projects. ([Home][1])

**Production pattern in Spring:**

* Use **WebClient or RestClient** for new code; keep RestTemplate in older services until you have time to migrate.

---

## 2) Apache HttpClient (very common, especially in platform SDKs)

### **Apache HttpClient 5.x**

* A very common “serious” production choice when teams want explicit control:

  * connection pooling
  * timeouts
  * TLS versions/ciphers
  * proxy support
  * custom `SSLContext` and key/trust material
* Apache’s docs emphasize modern TLS defaults and allow explicitly constraining TLS versions. ([hc.apache.org][3])
* Also widely embedded indirectly (some SDKs/frameworks use it under the hood), and AWS SDK v2 supports an Apache 5.x based client. ([AWS Documentation][4])

**Why teams pick it:** stable, mature, lots of knobs, predictable behavior under load.

---

## 3) OkHttp (common in Android + some backend teams)

### **OkHttp**

* Very popular on Android; also used on servers.
* Nice TLS control surface, good defaults, great ergonomics.
* For mTLS you typically build an `SSLContext` + supply key manager/trust manager to the OkHttp client.
* OkHttp docs cover TLS configuration concepts. ([square.github.io][5])

**Where it shines:** mobile, simple client apps, high-quality networking stack.

---

## 4) JDK built-in clients (common in “no extra deps” environments)

### A. **Java 11+ `java.net.http.HttpClient`**

* Used more in modern JVM codebases that want fewer dependencies.
* Works well, but some orgs still prefer Apache/OkHttp for richer features and familiar ops patterns.

### B. `HttpsURLConnection`

* Older, still present, usually not the first choice in modern production code.

---

## 5) “Production SSL” is mostly about *ops & configuration*, not the library

Regardless of Spring/Apache/OkHttp/JDK, production teams standardize on:

### A. **Keystore/truststore management**

* PKCS12 is common for keystores.
* Separate **truststore** (server CA trust) vs **keystore** (client identity for mTLS).
* In containers/Kubernetes: mount as secrets + reload strategy.

### B. **mTLS gotchas handled explicitly**

* Ensure client **certificate chain** includes intermediates.
* Ensure Java picks the correct **alias** (your earlier issue).
* Consistent trust store across environments (dev/prod CA mismatch is a classic).

### C. **Debugging playbooks**

* Always have a documented way to enable:

  * `-Djavax.net.debug=ssl,handshake,certpath`
* And a way to compare with:

  * `openssl s_client ...`
  * `curl -vk ...`

---

## Quick recommendation matrix (what most teams do)

* **Spring Boot app calling REST APIs (sync):** Spring **RestClient** (new), RestTemplate (legacy) ([Home][2])
* **Spring Boot reactive / high concurrency:** **WebClient**
* **Non-Spring / need max TLS+pooling control:** **Apache HttpClient 5**
* **Android / mobile-first:** **OkHttp**
* **“minimal deps” backend:** **JDK HttpClient**


[1]: https://docs.spring.io/spring-framework/reference/6.0/integration/rest-clients.html?utm_source=chatgpt.com "REST Clients :: Spring Framework"
[2]: https://spring.io/blog/2025/09/30/the-state-of-http-clients-in-spring?utm_source=chatgpt.com "The state of HTTP clients in Spring"
[3]: https://hc.apache.org/httpcomponents-client-5.6.x/migration-guide/migration-to-classic.html?utm_source=chatgpt.com "Migration to Apache HttpClient 5.x classic APIs"
[4]: https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/http-configuration-apache5.html?utm_source=chatgpt.com "Configure the Apache 5.x based HTTP client"
[5]: https://square.github.io/okhttp/features/https/?utm_source=chatgpt.com "HTTPS - OkHttp"
