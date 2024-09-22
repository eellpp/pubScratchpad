## Security Areas
1) Ciphers : Substitution and transposition 
2) One Way Hash Functions (MD5, SHA cryptogrpahic hash function, HMAC)
3) PK cryptogrpahy (RSA)
4) Digital Signatures with Encryption
5) Cryptogrpahic protection of Databases
6) Key Exchange Algorithms (eg DH algo  and Kerberoes Authentication )
7) AES File system Encryption
8) SSL, TLS, MTLS
9) SSH
10) PGP and  DKIM 
11) XSS and CSRF

## Books
- **"Applied Cryptography"**, Bruce Schneier
- **"Java Cryptography_ Tools and Techniques"**

## Notes

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

### types of ciphers
In **Chapter 1** of *Applied Cryptography*, Bruce Schneier introduces various types of ciphers, including:

1. **Substitution Ciphers**: Replace each symbol with another (e.g., Caesar cipher).
2. **Transposition Ciphers**: Rearrange the symbols in a message (e.g., Rail Fence cipher).
3. **Block Ciphers**: Encrypt fixed-size blocks of data (e.g., DES, AES).
4. **Stream Ciphers**: Encrypt data bit by bit (e.g., RC4).

These ciphers are foundational to cryptographic practices used in modern encryption techniques.

### Digital Signature
A digital signature uses the sender’s private key to sign a message. Since only the sender possesses this private key, the signature uniquely ties them to the message. When a recipient verifies the signature with the sender’s public key, it proves the authenticity and integrity of the message

### Protocol to enforce non repudiation 
In the **protocol between Alice, Trent, and Bob** (Chapter 2 of *Applied Cryptography*), the process ensures **non-repudiation**:

Trent is a trusted arbitrator 

1. **Alice signs a message** and creates a header with identifying info. She concatenates them, signs again, and sends it to Trent.
2. **Trent verifies** Alice’s signature and adds a timestamp to the message and header. He signs it and sends it to both Alice and Bob.
3. **Bob verifies** both Trent’s and Alice’s signatures.
4. **Alice verifies** the message. If it’s not hers, she must raise an objection quickly.

This guarantees that Alice can't deny sending the message.

### Key Distribution methods
The public key needs to be shared publicly . But it has to be secured so that we know that people don't put their public key and claim it for messages sent to others. 

There are several **key distribution methods** :

1. **Public Key Infrastructure (PKI)**: Involves digital certificates issued by a trusted Certificate Authority (CA) to distribute public keys securely.
   
2. **Key Distribution Centers (KDC)**: A central trusted authority, as in **Kerberos**, which distributes symmetric keys to authenticated users.

3. **Diffie-Hellman Key Exchange**: A method that allows two parties to generate a shared symmetric key over an insecure channel without the need for prior key exchange.

4. **Pre-shared Keys (PSK)**: Keys are exchanged manually or via a secure offline method beforehand.

Each method depends on the level of security and use case (e.g., symmetric vs. asymmetric encryption).
