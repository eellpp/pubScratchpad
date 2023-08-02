SSL Authentication (TLS Authentication):   
SSL (Secure Sockets Layer) is a cryptographic protocol used to secure communication between a client and a server over the internet. Its successor is TLS (Transport Layer Security), which is commonly referred to as TLS/SSL. SSL/TLS authentication is commonly used in HTTPS connections to authenticate the server and, in some cases, the client.

1) Server Authentication: When a client connects to a server using SSL/TLS, the server presents a digital certificate containing its public key. The client validates this certificate using a trust chain to ensure the server's authenticity. If the validation is successful, the client knows it is communicating with the intended server and establishes a secure connection.

2) Client Authentication: SSL/TLS can also support client authentication, where the client presents its digital certificate to the server. The server verifies the client's certificate to ensure the client's identity before establishing the connection.

SSL/TLS authentication relies on X.509 certificates for identity verification. Certificates are issued and signed by Certificate Authorities (CAs), and clients trust the CAs to validate the authenticity of the certificates.

## SSL over browser - overview
To operate correctly, SSL relies on a properly configured digital certificate, which the server passes to the browser when it tries to access a secure web page. Amongst other things, the certificate contains the “name” of the server for which the certificate has been issued, an encoded signature unique to the domain, the domain’s public key, and the validity period of the certificate itself. If the certificate has been digitally signed by a Certificate Authority (CA), it also contains the CA’s name and signature. In addition to establishing a relationship of trust, the certificate allows the server and browser to negotiate the encryption algorithm and encryption key used for the browsing session.

Here is a very simplified explanation:

* Your web browser downloads the web server's certificate, which contains the public key of the web server. This certificate is signed with the private key of a trusted certificate authority.
* Your web browser comes installed with the public keys of all of the major certificate authorities. It uses this public key to verify that the web server's certificate was indeed signed by the trusted certificate authority.
* The certificate contains the domain name and/or ip address of the web server. Your web browser confirms with the certificate authority that the address listed in the certificate is the one to which it has an open connection.
* Your web browser generates a shared symmetric key which will be used to encrypt the HTTP traffic on this connection; this is much more efficient than using public/private key encryption for everything. Your browser encrypts the symmetric key with the public key of the web server then sends it back, thus ensuring that only the web server can decrypt it, since only the web server has its private key.



### Java JKS based encryption
JKS-based encryption involves storing cryptographic material, such as private keys and certificates, in a Java KeyStore file.

With the key pair securely stored in the JKS, the Java application can use it for various cryptographic operations, such as encrypting data using the public key or decrypting data using the private key. In SSL/TLS communication, the server can present its certificate (containing the public key) to clients for encrypted communication.


### Self-Signed Certificates:

A self-signed certificate is a certificate where the entity generating the certificate is also the one signing it. Essentially, the entity acts as its own Certificate Authority. Self-signed certificates are easy to create, as demonstrated in the previous example, but they lack any external validation. They are not signed by a trusted third-party CA, so they do not provide the same level of trust and security as CA-issued certificates.


### Certificates Issued by a CA:
Certificates issued by a trusted Certificate Authority go through a rigorous validation process to ensure the authenticity and identity of the certificate owner. The CA acts as a trusted third party that verifies the identity of the entity requesting the certificate and signs it with the CA's own private key. Web browsers and other applications trust certificates issued by well-known CAs, making them widely recognized and accepted.


### creating a self signed JKS keystore
>>> keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -validity 365 -keystore mykeystore.jks

During the process, you'll be prompted to enter information like your name, organization, city, etc. This information will be used to create the self-signed certificate.

Remember to keep the JKS file and its password secure, as it holds sensitive cryptographic material. Also, be cautious when using self-signed certificates in production environments, as they are typically used for testing and development purposes, not for securing real-world applications. In production, it is recommended to use certificates issued by a trusted Certificate Authority (CA).


### How SSL/TLS does encryption
 

The public key of the Server is just used in the beginning (handshaking protocol) to establish a secure key, for Secure key encryption (Symmetric encryption).
All the communication is over Secret key or Symmetric Key encryption, where the client (browser) and the Server use the same secret key to encrypt and decrypt data.
TLS (Transport Layer Security) protocol uses a combination of Asymmetric encryption (Public key) and Symmetric Encryption (Secure Key). The main communication with your bank is using symmetric encryption, for which the session keys (secure key) is established safely during TLS handshaking, using asymmetric encryption.



### How browsers protect from fake certificates  
https://stackoverflow.com/questions/7733881/how-to-recognize-fake-ssl-certificates  

Validity of a server certificate is established by:

- Host name verification
- Verifying the signatures of the entire certificate chain
- Performing additional checks on meta data for each certificate
- Checking the revocation status of each of the certificates involved
- Checking whether the self-signed root certificate of the chain is among the certificates that one trusts by default

The model is that there are a few (well, unfortunately not so few anymore) trusted root certificate authorities ("root CAs") that either you could choose on your own or (more likely) that come preconfigued with your software (e.g. browser) that are blindly trusted. These trusted authorities form the anchors of the entire trust model of "PKI" (Public Key Infrastructure). The basic idea is that the trusted entities may issue certificates to other authorities and grant them permission to again issue certificates (these authorities are called intermediate certificate authorities). The intermediate CAs may again recursively apply this procedure up to a certain point, the number of intermediate CAs between an actual end entity certificate and a root CA certificate is generally limited.

At one point, an intermediate CA will issue certificates to an "end entity" ("mail.google.com" in our example). Now the process of issuing a certificate actually means that the party requesting a certificate will create a public/private key pair first, and use them to authenticate a certificate request that is sent to the certificate authority. The issuing authority creates a certificate for the subordinate entity (either intermediate CA or end entity) by "signing" that certificate using its own private key using an asymmetric algorithm such as RSA and by additionally including the public key of the requesting party within the newly generated certificate. The root CA possesses a so called self-signed certificate, i.e. the root CA is the only authority that may sign their own certificate and include their own public key. The private key remains hidden at all times, of course.

The recursive nature of the certificate issuing process implies that for each end entity certificate there is a unique way of establishing a "chain" of certificates that leads up to a root certificate authority. Now when you are presented with an end entity certificate while trying to connect to a TLS-secured site, the following procedure will be applied recursively until you end up with a root CA certificate:

### Self certification brief
Scenario: You are on the server doing an maven updated and it throws up certification erros for maven repo url 

In this case, the easiest way is to 
- On your client desktop, use the chrome browser to download the maven repo security certificate. As of now it is within the security tab under inspect element
- Copy this .cer file on the server and generate a .jks file. 
`keytool -import  -file maven-repo.crt -alias msven -keystore keystore.jks`
- Pass these as jvm options when doing the maven connection
`-Djavax.net.ssl.trustStore=keystore.jks -Djavax.net.ssl.trustStorePassword=x`

Detailed overview in following sections.


#### Root and Intermediate CA
There are two types of certificate authorities (CAs): root CAs and intermediate CAs. In order for an SSL certificate to be trusted, that certificate must have been issued by a CA that is included in the trusted store of the device that is connecting.

Here’s a practical example. Let’s suppose that you purchase a certificate from the Awesome Authority for the domain example.awesome.

- Awesome Authority is not a root certificate authority. In other words, its certificate is not directly embedded in your web browser and therefore it can’t be explicitly trusted.
- Awesome Authority utilizes a certificate issued by Intermediate Awesome CA Alpha.
- Intermediate Awesome CA Alpha utilizes a certificate issued by Intermediate Awesome CA Beta.
- Intermediate Awesome CA Beta utilizes a certificate issued by Intermediate Awesome CA Gamma.
- Intermediate Awesome CA Gamma utilizes a certificate issued by The King of Awesomeness.
- The King of Awesomeness is a Root CA. Its certificate is directly embedded in your web browser, therefore it can be explicitly trusted.

In our example, the SSL certificate chain is represented by 6 certificates:
- End-user Certificate - Issued to: example.com; Issued By: Awesome Authority
- Intermediate Certificate 1 - Issued to: Awesome Authority; Issued By: Intermediate Awesome CA Alpha
- Intermediate Certificate 2 - Issued to: Intermediate Awesome CA Alpha; Issued By: Intermediate Awesome CA Beta
- Intermediate Certificate 3 - Issued to: Intermediate Awesome CA Beta; Issued By: Intermediate Awesome CA Gamma
- Intermediate Certificate 4 - Issued to: Intermediate Awesome CA Gamma; Issued By: The King of Awesomeness
- Root certificate - Issued by and to: The King of Awesomeness

Certificate 1 is your end-user certificate, the one you purchase from the CA. The certificates from 2 to 5 are called intermediate certificates. Certificate 6, the one at the top of the chain (or at the end, depending on how you read the chain), is called root certificate.

When you install your end-user certificate for example.awesome, you must bundle all the intermediate certificates and install them along with your end-user certificate. If the SSL certificate chain is invalid or broken, your certificate will not be trusted by some devices.


## Formats for certificate file
Different formates for SSL certificates and their components:

- PEM Governed by RFCs, it's used preferentially by open-source software. It can have a variety of extensions **(.pem, .key, .cer, .cert, more)**
- PKCS7 An open standard used by Java and supported by Windows. Does not contain private key material.
- PKCS12 A private standard that provides enhanced security versus the plain-text PEM format. This can contain private key material. It's used preferentially by Windows systems, and can be freely converted to PEM format through use of openssl.
- DER The parent format of PEM. It's useful to think of it as a binary version of the base64-encoded PEM file. Not routinely used by much outside of Windows.


## Connecting to a server securely for Development
First you need to obtain the public certificate from the server you're trying to connect to. That can be done in a variety of ways, such as 
- contacting the server admin and asking for it, 
- using openssl to download it, or, 

`echo -n | openssl s_client -connect HOST:PORTNUMBER \
    | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/$SERVERNAME.cert`
    
- since this appears to be an HTTP server, connecting to it with any browser, viewing the page's security info, and saving a copy of the certificate. (Google should be able to tell you exactly what to do for your specific browser.)
(In chrome click on the inspect and then find the security tab, from there follow instructions to download the certificate for the website)

Now that you have the certificate saved in a file, you need to add it to your JVM's trust store. At $JAVA_HOME/jre/lib/security/ for JREs or $JAVA_HOME/lib/security for JDKs, there's a file named cacerts, which comes with Java and contains the public certificates of the well-known Certifying Authorities. To import the new cert, run keytool as a user who has permission to write to cacerts:

`keytool -import -file <the cert file> -alias <some meaningful name> -keystore <path to cacerts file>`
It will most likely ask you for a password. The default password as shipped with java is changeit. 

or you can write to your own jks file ( if youare verifying the certificate yourslef, for eg while doing Java development)
`keytool -import  -file maven-repo.crt -alias msven -keystore keystore.jks`



## keystore vs trustore in java
Essentially, the keystore in `javax.net.ssl.keyStore` is meant to contain your private keys and certificates, whereas the `javax.net.ssl.trustStore` is meant to contain the CA certificates you're willing to trust when a remote party presents its certificate. In some cases, they can be one and the same store, although it's often better practice to use distinct stores (especially when they're file-based).

- Trustore contains the CA certificates you are willing to trust. It also contains the clients public key
- Keystore contains the clients public and private key pair and certificates

To export the client's certificate (public key) to a file, so you can copy it to the server, use

`keytool -export -alias MYKEY -file publicclientkey.cer -store keystore.jks`

To import the client's public key into the server's truststore, use

`keytool -import -file publicclientkey.cer -store trustore.jks`

#### Key Manager and Trust Manager working
The `javax.net.ssl.keyStore` and `javax.net.ssl.trustStore` parameters are the default parameters used to build KeyManagers and TrustManagers (respectively), then used to build an SSLContext which essentially contains the SSL/TLS settings to use when making an SSL/TLS connection via an SSLSocketFactory or an SSLEngine. These system properties are just where the default values come from, which is then used by `SSLContext.getDefault()`, itself used by `SSLSocketFactory.getDefault()` for example. (All of this can be customized via the API in a number of places, if you don't want to use the default values and that specific SSLContexts for a given purpose.)

#### Setup the application to use the file
`-Djavax.net.ssl.keyStore=keystore.jks -Djavax.net.ssl.keyStorePassword=x`

`-Djavax.net.ssl.trustStore=keystore.jks -Djavax.net.ssl.trustStorePassword=x`




## jks file
JKS stands for Java KeyStore. It is a repository of certificates (signed public keys) and (private) keys. You can export a certificate stored in a JKS file into a certificate file. You can use the "keytool" utility found in Java distributions to maintain your JKS trust and key repositories. 

.CER - Certificate file i.e. public ckey. 
**You can convert from CER to JKS   as you are only converting the public key**

## Steps for creation of certificate

#### Create a self signed certificate
// input the information about the organization etc. This would create the keystore jks file

keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass password -validity 360 -keysize 2048

#### create the cer file
keytool -export -alias selfsigned -keystore keystore.jks -rfc -file my_certificate.cer

## Verifiying certificate and adding to keystore
The certificate presented is verfied by public CA (certificate authorities). But you can manually verify and add it at server
- from the browser get the cer file
- print the cer fingerprints 
`keytool -printcert -file Example.cer`
- call up the person and ask to verify the fingerprints that you obtained from server

## provide info in properties file

// Now in the build.properties add the following lines,

`key.store=<path to keystore>//keystore.jks`

// same as the alias used to generate

`key.alias=selfsigned`
