## 1. What this error actually means (plain English)

> **“Server does not recognise the issuer of the client certificate”**
> means:

👉 The client presented a certificate, but
👉 the **server does not trust the CA (issuer)** that signed the client’s certificate.

So the TLS handshake fails during **client authentication**.

This is **not** about the server’s own certificate.
This is about the **client certificate trust chain**.

---

## 2. Where in the TLS handshake this fails

In mTLS, the flow is:

1. Client → Server: “Hello”
2. Server → Client: “Here is my cert. Also, I require a client cert.”
3. Client → Server: “Here is my client certificate + proof I own the key”
4. **Server tries to validate the client cert**
5. ❌ Fails → handshake aborts

The failure happens at step 4.

---

## 3. Core causes (most common to rare)

### ✅ Cause #1 – Server does not trust the client CA

The server only trusts client certificates issued by **specific Certificate Authorities (CAs)**.

Example:

* Client cert issued by: `MyCompany Internal CA`
* Server trust store contains: `DigiCert`, `Let's Encrypt`, `GlobalSign`
* Result: ❌ Server rejects client cert

**Fix:**
Add the client CA (or its root/intermediate) to the server’s trust store.

---

### ✅ Cause #2 – Missing intermediate CA in client chain

Even if the server trusts the root CA, the client must send the **full certificate chain**.

Bad client sends:

```
[Client cert only]
```

Correct client sends:

```
[Client cert]
[Intermediate CA]
```

Server can’t build the chain → issuer appears “unknown”.

**Fix:**
Configure the client to send the **full chain**.

---

### ✅ Cause #3 – Server configured to trust wrong CA

Example:

Server is configured to trust:

```
Corp-CA-Prod
```

But client cert is issued by:

```
Corp-CA-Dev
```

Same org, different CA → handshake fails.

**Fix:**
Align environments (Prod vs Dev CA trust).

---

### ✅ Cause #4 – Expired or revoked CA cert in server trust store

Even if the CA is present, if:

* The CA cert is expired
* The CA is revoked
* The trust store is outdated

Then validation fails.

**Fix:**
Update server trust store with valid CA certificates.

---

### ✅ Cause #5 – Certificate purpose / EKU mismatch

Client certificate must allow:

```
Extended Key Usage: Client Authentication
```

If it only has:

```
Extended Key Usage: Server Authentication
```

Some TLS stacks reject it as “untrusted issuer” or generic auth failure.

**Fix:**
Issue client certs with correct EKU.

---

### ✅ Cause #6 – Server expects specific client cert DN / OU / policy

Some servers enforce policy:

* Only accept certs with:

  * Specific OU
  * Specific policy OID
  * Specific Subject pattern

Cert chain may be valid, but policy rejects it.

**Fix:**
Update server policy or issue certs matching expected attributes.

---

## 4. How this shows up in real systems

### Typical error messages

**Nginx / OpenSSL**

```
SSL alert number 48
unknown ca
```

**Java server**

```
javax.net.ssl.SSLHandshakeException:
PKIX path building failed:
unable to find valid certification path
```

**Curl client**

```
SSL certificate problem: unable to get local issuer certificate
```

**Envoy / Istio**

```
tls: unknown certificate authority
```

---

## 5. How to debug step-by-step (practical)

### Step 1 – Inspect client cert chain

```bash
openssl x509 -in client.crt -noout -issuer -subject
```

Check:

* Issuer name
* CA hierarchy

---

### Step 2 – Check what CA the server trusts

On Linux servers:

```bash
ls /etc/ssl/certs/
```

Or application config (e.g., Java truststore):

```bash
keytool -list -keystore truststore.jks
```

---

### Step 3 – Test with OpenSSL

```bash
openssl s_client -connect server:443 \
  -cert client.crt \
  -key client.key \
  -CAfile server_trusted_ca.pem
```

If this fails, you’ve isolated the problem.

---

### Step 4 – Verify full chain is sent

```bash
openssl s_client -connect server:443 -cert client_fullchain.pem -key client.key
```

Make sure the file contains:

```
-----BEGIN CERTIFICATE-----
(client)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
(intermediate)
-----END CERTIFICATE-----
```

---

## 6. Visual mental model

```
Server Trust Store:
  ✔ RootCA-A
  ✔ Intermediate-A1

Client Certificate:
  Client cert
    ↓ signed by
  Intermediate-B1
    ↓ signed by
  RootCA-B

Result: ❌ No overlap → handshake fails
```

The server must trust **RootCA-B** (or Intermediate-B1).

---

## 7. Security reason this is enforced

If servers accepted **any** client cert:

* Anyone could spin up their own CA
* Issue themselves a client cert
* Authenticate as a “trusted client”

So the server must explicitly whitelist **which CAs are allowed to authenticate clients**.

This is the foundation of:

* API authentication via mTLS
* Service-to-service authentication (Istio, Linkerd, SPIFFE)
* B2B secure integrations

---

## 8. Quick checklist (copy-paste friendly)

If you see “server does not recognise issuer of client certificate”:

* [ ] Is the correct **client CA** installed on the server?
* [ ] Is the **full client certificate chain** sent?
* [ ] Is the client cert issued by the **expected environment CA**?
* [ ] Is the CA cert **not expired/revoked**?
* [ ] Does the client cert include **EKU: Client Authentication**?
* [ ] Is server policy filtering by subject / OU / policy OID?

---

## 9. One-line summary

> This handshake error happens because the server does not trust the Certificate Authority that issued the client’s certificate, so it refuses to authenticate the client during mTLS.
