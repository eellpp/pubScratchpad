
## Formats for certificate file
Different formates for SSL certificates and their components:

- PEM Governed by RFCs, it's used preferentially by open-source software. It can have a variety of extensions (.pem, .key, .cer, .cert, more)
- PKCS7 An open standard used by Java and supported by Windows. Does not contain private key material.
- PKCS12 A private standard that provides enhanced security versus the plain-text PEM format. This can contain private key material. It's used preferentially by Windows systems, and can be freely converted to PEM format through use of openssl.
- DER The parent format of PEM. It's useful to think of it as a binary version of the base64-encoded PEM file. Not routinely used by much outside of Windows.

## jks file
JKS stands for Java KeyStore. It is a repository of certificates (signed public keys) and [private] keys. You can export a certificate stored in a JKS file into a certificate file. You can use the "keytool" utility found in Java distributions to maintain your JKS trust and key repositories. 

.CER - Certificate file i.e. public ckey. 
You can convert from CER to JKS   as you are only converting the public key. 

## Steps for creation of certificate

#### Create a self signed certificate
// input the information about the organization etc. This would create the keystore jks file
keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass password -validity 360 -keysize 2048

#### create the cer file
keytool -export -alias selfsigned -keystore keystore.jks -rfc -file my_certificate.cer

#### provide info in properties file
// Now in the build.properties add the following lines,
key.store=<path to keystore>//keystore.jks
// same as the alias used to generate
key.alias=selfsigned
