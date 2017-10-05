
## Formats for certificate file

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
