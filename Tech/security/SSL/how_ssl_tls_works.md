The **TLS handshake** involves several detailed steps to establish a secure communication channel between a client and a server:

### 1. **Client Hello**:
   - The client initiates the handshake by sending a "Client Hello" message to the server.
   - This message includes the **client’s supported TLS version**, **cipher suites** (encryption algorithms), **compression methods**, and a **randomly generated number** (random value).
   
### 2. **Server Hello**:
   - The server responds with a "Server Hello" message.
   - The server chooses the highest TLS version and cipher suite supported by both parties.
   - The server sends its **SSL/TLS certificate**, **a server-generated random value**, and, optionally, a request for the client’s certificate (if client-side authentication is required).

### 3. **Server Certificate and Authentication**:
   - The client verifies the server’s **certificate** to authenticate the server’s identity.
   - This involves checking the certificate’s **validity**, ensuring it’s issued by a trusted **Certificate Authority (CA)**, and that it hasn’t expired or been revoked.
   - If **client authentication** is requested, the client will send its own certificate.

### 4. **Premaster Secret**:
   - After verifying the server’s identity, the client generates a **premaster secret** (a large random number).
   - The client **encrypts** this premaster secret using the server’s public key (from the server’s certificate) and sends it to the server.
   - Since only the server has the private key, only it can decrypt the premaster secret.

### 5. **Session Key Generation**:
   - Both the client and server use the premaster secret along with their previously exchanged random values to generate **session keys**.
   - These session keys are symmetric and are used to encrypt the communication during the session.

### 6. **Finished Messages**:
   - The client and server send each other an encrypted "Finished" message to confirm that the key exchange and the handshake were successful.
   - These messages are encrypted using the session keys.
   - If both parties can decrypt the messages successfully, the handshake is complete, and they can securely exchange data.

### 7. **Secure Communication**:
   - Once the handshake is complete, the client and server use the symmetric session keys to encrypt and decrypt the communication for the duration of the session.

In summary, the **TLS handshake** ensures that both the client and server can establish an encrypted communication channel after verifying each other’s identity and securely exchanging cryptographic keys. This process allows for secure, encrypted communication over the internet.

For more details, you can refer to the [Cloudflare article on TLS handshakes](https://www.cloudflare.com/learning/ssl/what-happens-in-a-tls-handshake/).
