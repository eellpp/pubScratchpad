## Connecting to a server securely
First you need to obtain the public certificate from the server you're trying to connect to. That can be done in a variety of ways, such as 
- contacting the server admin and asking for it, 
- using openssl to download it, or, 
- since this appears to be an HTTP server, connecting to it with any browser, viewing the page's security info, and saving a copy of the certificate. (Google should be able to tell you exactly what to do for your specific browser.)

Now that you have the certificate saved in a file, you need to add it to your JVM's trust store. At $JAVA_HOME/jre/lib/security/ for JREs or $JAVA_HOME/lib/security for JDKs, there's a file named cacerts, which comes with Java and contains the public certificates of the well-known Certifying Authorities. To import the new cert, run keytool as a user who has permission to write to cacerts:

`keytool -import -file <the cert file> -alias <some meaningful name> -keystore <path to cacerts file>`
It will most likely ask you for a password. The default password as shipped with java is changeit. 

or you can write to your own jks file
`keytool -import  -file bob.crt -alias bob -keystore keystore.jks`




## Formats for certificate file
Different formates for SSL certificates and their components:

- PEM Governed by RFCs, it's used preferentially by open-source software. It can have a variety of extensions **(.pem, .key, .cer, .cert, more)**
- PKCS7 An open standard used by Java and supported by Windows. Does not contain private key material.
- PKCS12 A private standard that provides enhanced security versus the plain-text PEM format. This can contain private key material. It's used preferentially by Windows systems, and can be freely converted to PEM format through use of openssl.
- DER The parent format of PEM. It's useful to think of it as a binary version of the base64-encoded PEM file. Not routinely used by much outside of Windows.


## keystore vs trustore in java
Essentially, the keystore in `javax.net.ssl.keyStore` is meant to contain your private keys and certificates, whereas the `javax.net.ssl.trustStore` is meant to contain the CA certificates you're willing to trust when a remote party presents its certificate. In some cases, they can be one and the same store, although it's often better practice to use distinct stores (especially when they're file-based).

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

#### provide info in properties file

// Now in the build.properties add the following lines,

`key.store=<path to keystore>//keystore.jks`

// same as the alias used to generate

`key.alias=selfsigned`
