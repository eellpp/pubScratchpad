Security Areas
1) Ciphers : Substitution and transposition 
2) One Way Hash Functions (MD5, SHA cryptogrpahic hash function, HMAC)
3) PK cryptogrpahy (RSA)
4) Digital Signatures with Encryption
5) Cryptogrpahic protection of Databases
6) Key Exchange Algorithms (eg DH algo  and Kerberoes Authentication )
7) AES File system Encryption
8) SSl, TLS, MTLS
9) PGP and  DKIM 
10) XSS and CSRF

In **"Applied Cryptography"**, Bruce Schneier discusses how cryptography provides four fundamental security services:

1. **Confidentiality**: Ensures that only authorized parties can read the information. Encryption transforms the data into unreadable formats unless decrypted by someone with the right key.
   
2. **Authentication**: Verifies the identity of the parties involved in the communication, ensuring that the sender is who they claim to be.

3. **Integrity**: Ensures that data is not altered during transmission. Techniques like hashing ensure that any modification to the message is detectable.

4. **Non-repudiation**: Prevents the sender from denying the authenticity of a message or transaction, typically achieved through digital signatures.



| **Security Service**  | **Relevant Algorithms**                       | **Real-Life Package or App**                                           |
|-----------------------|------------------------------------------------|------------------------------------------------------------------------|
| **Confidentiality**    | AES, RSA, DES                                 | OpenSSL (SSL/TLS encryption), BitLocker (Disk Encryption)              |
| **Authentication**     | HMAC, RSA (digital signatures)                | OAuth (API authentication), JWT (JSON Web Tokens)                      |
| **Integrity**          | SHA-256, MD5, HMAC                            | Git (commit hashing), Blockchain (transaction integrity)               |
| **Non-repudiation**    | RSA, DSA (Digital Signatures)                 | DocuSign (e-signatures), PGP (email encryption with signature)         |

Each of these algorithms and tools addresses one or more of the core cryptographic goals: confidentiality, authentication, integrity, and non-repudiation.

