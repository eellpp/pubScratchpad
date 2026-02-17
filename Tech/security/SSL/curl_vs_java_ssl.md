This happens a lot: **curl “works” but Java fails** in mTLS. It’s usually not that curl is “more lenient” in a risky way—rather **they validate different things by default, use different trust stores, and handle chains differently**.

Here are the main reasons, in the order that most often explains your exact symptom.

---

## 1) Different trust stores (biggest cause)

### curl / OpenSSL

* Uses **OS CA bundle** (e.g., `/etc/ssl/certs`, macOS Keychain, etc.) unless you override with `--cacert` / `--capath`.
* If the server (or proxy) CA is in the OS trust, curl will trust it.

### Java

* Uses **its own truststore** (often the JRE’s `cacerts`) unless you explicitly set:

  * `-Djavax.net.ssl.trustStore=...`
  * or configure your HTTP client / container trust managers.
* So curl can trust something that Java simply **doesn’t have**.

**Typical outcome:**
curl succeeds, Java says “PKIX path building failed / unable to find valid certification path”.

---

## 2) Client certificate chain sent: curl often sends full chain more easily; Java often sends only leaf

In mTLS, the **client must send**:

* client leaf certificate
* and usually **intermediate CA(s)**

### curl

If you pass a PEM that includes leaf + intermediates, curl will happily send the chain:

```bash
--cert client-fullchain.pem --key client.key
```

### Java

If you put only the leaf cert in a keystore (or mis-import), Java may send only the leaf, and the server rejects it:

* server error becomes “unknown ca / issuer not recognized” (server can’t build chain)

**Key point:**
Even if Java trusts the server fine, the **server may reject Java’s client cert** because Java didn’t send the intermediate(s).

---

## 3) Java is stricter about hostname / SAN and algorithm constraints

Even in mTLS, Java may still fail because it is stricter about the **server certificate**:

* Requires **SAN** (Subject Alternative Name) for hostname verification (CN-only can fail in modern Java clients depending on stack).
* Rejects weaker/legacy algorithms more aggressively:

  * old RSA key sizes
  * SHA1 signatures
  * weak curves
* Enforces “disabledAlgorithms” from `java.security`.

curl/OpenSSL may allow some of these depending on build/options, while Java refuses.

---

## 4) EKU / KeyUsage enforcement differences (client cert suitability)

Java stacks often enforce that the **client cert is meant for client auth**:

* Extended Key Usage should include: `Client Authentication`
* KeyUsage should allow: `Digital Signature` (commonly)

curl/OpenSSL may still proceed in some scenarios where Java will reject or not select that cert.

Also: **Java’s cert selection** logic can be picky:

* if multiple certs exist in the keystore, it may pick the “wrong” alias unless you specify.

---

## 5) TLS version and cipher suite mismatch (Java sometimes fails where curl negotiates fine)

* curl/OpenSSL may negotiate TLS 1.2/1.3 flexibly
* Java client might be locked down by:

  * JVM defaults
  * corporate policy
  * application config (enabledProtocols / enabledCipherSuites)

If server requires something Java doesn’t offer (or vice versa), handshake fails.

---

## 6) Revocation / OCSP / CRL behavior differs

Sometimes Java is configured (explicitly or via enterprise policy) to do stricter revocation checking:

* OCSP/CRL failures can cause handshake fail in Java
* curl often does not enforce revocation by default (unless configured)

This is less common than truststore/chain issues, but it shows up in corporate environments.

---

# What to do: fast diagnosis steps

## A) Turn on Java SSL debug (most useful)

Run with:

```bash
-Djavax.net.debug=ssl,handshake,certpath
```

Look for:

* `PKIX path building failed` → truststore problem (server cert chain / CA missing)
* `no suitable certificate found` → client cert selection/alias/EKU issue
* `unable to find valid certification path` → again truststore/chain
* `Received fatal alert: bad_certificate` or `unknown_ca` → server rejected client cert (often missing intermediate)

## B) Compare what curl is *actually* trusting

Run:

```bash
curl -vk https://server:443 --cert client.pem --key client.key
```

In verbose output look for:

* which TLS version/cipher
* server certificate chain shown
* any “issuer” details

## C) Verify your client cert file includes intermediates (if server needs them)

Check:

```bash
openssl crl2pkcs7 -nocrl -certfile client.pem | openssl pkcs7 -print_certs -noout
```

Or simplest: open the PEM and see if it contains multiple `BEGIN CERTIFICATE` blocks.

## D) Ensure Java keystore contains **full chain**

In Java, the private key entry should include:

* leaf cert
* intermediate(s)

`keytool -list -v -keystore client.p12`
Check the “Certificate chain length”.

---

# The most common root cause for your exact symptom

> **curl works but Java fails in mTLS**
> Most often it’s one of these two:

1. **Java truststore doesn’t include the CA that curl/OS trusts** (server side validation fails in Java), or
2. **Java is not sending the intermediate(s) for the client cert**, so the **server rejects Java’s client cert**.

