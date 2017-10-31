## SASL, SSL, KERBEROS and JAAS
Frameworks/API:
 - `SASL` is a framework, which allows authentication with multiple protocols like GSSAPI, Kerberos, NTLM, et
 - `JAAS` (Java Authentication and Authorization Service ) is a pluggable authentication framework for java. Kerberos authentication can be done with JAAS
 - `GSSAPI` is a generic programming interface for doing authentication, encryption, etc regardless of what protocol is used underneath. Eg: Kerberos
 
 Protocols:
 - `SSL/TLS` is a communication protocol
 - `Kerberos`, which is an authentication protocol 
 
#### When to use Java GSS-API vs. JSSE
 https://docs.oracle.com/javase/7/docs/technotes/guides/security/jgss/tutorials/JGSSvsJSSE.html
 
SASL is not a protocol but a framework. It's also true that SSL and SASL are kind of providing similar features. Both of them provide authentication, data signing and encryption.

SSL is done at the transport layer and it is normally transparent to the underneath protocol. For example, you can use SSL on LDAP or HTTP. However, in some cases, modification to existing protocols is necessary in order to switch to secured mode. For example, POP3 and IMAP is extended to have a command STARTTLS to initiate the use of SSL. From that angle, this is kind of similar to what SASL doing.

On the other side, many protocols are also extended to provide SASL capability. Here is the list of protocols. Again, POP3 and IMAP are two of them and they are using different commands to initiate the authentication.

So, when should we use SSL and when should we use SASL?

An obvious difference between SSL and SASL is that SASL allows you to select different mechanisms to authenticate the client while SSL is kind of binded to do authentication based on certificate. In SASL, you can choose to use GSSAPI, Kerberos, NTLM, etc.

Because of this difference, there are some situations, it's just more intuitive to use SASL but not SSL. For example, your client application is using Kerberos to authenticate the end user. Your server needs to authenticates the client. Since your client application already have a Kerberos credentials (in Kerberos terminology, a ticket), it makes sense to use the Kerberos credentials to authenticate with the server. Of course, you can always setup SSL to do the same thing. However, that means on top of the existing Kerberos infrastructure, you need to setup Certificate Authority infrasture and somehow correlate the client certificate with the Kerberos credentials. It's doable but a lot of work.

Also, sometimes, you need to use some features that available only in the SASL mechanism but not the SSL. For example, Kerberos allows you to forward the ticket from the client to the server so that the server can use the ticket to query some resources on behalf of the client. One common example is that you have a application server and a database. The client application authenticates with the application server and the application server needs to query the database on behave the the client using client's credentials. SSL cannot provide this feature to you but Kerberos supports this. So, in that case, you have to choose to use SASL.

In some cases, you do want to use SSL but not SASL. For example, extending the protocol is not an option or you want to encrypt every single packet exchanged using underneath protocol.

### How does GSSAPI relate to Kerberos and SASL

Both GSSAPI and Kerberos are supported mechansim in SASL. GSSAPI is a generic programming interface. The idea is to let application writer use one single common API to do authentication, encryption, etc regardless of what protocol is used underneath. GSSAPI implements Kerberos. So, you can use GSSAPI to do Kerberos authentication.

In the Java 2 Standard Edition, GSS-API contains support for Kerberos as a mandatory security mechanism. This means that if your desktop has Kerberos support, you can write Java GSS-API based applications that never prompt the user for a password.


### How does JAAS relate to SASL

JAAS can be used for two purposes for authentication and authorization 
JAAS authentication is performed in a pluggable fashion. This permits Java applications to remain independent from underlying authentication technologies. New or updated technologies can be plugged in without requiring modifications to the application itself. An implementation for a particular authentication technology to be used is determined at runtime. The implementation is specified in a login configuration file. The authentication technology used for this tutorial is Kerberos. 

JAAS is similar to GSSAPI. It provides a single programming interface regardless of what authentication method is using. While GSSAPI is focusing on authentication and secured message exchange, JAAS is focusing on authentication and authorization. 
#### Kerberos with JAAS tutorial
https://docs.oracle.com/javase/7/docs/technotes/guides/security/jgss/tutorials/AcnOnly.html


### SPNEGO 
SPNEGO is a standard specification defined in The Simple and Protected GSS-API Negotiation Mechanism (IETF RFC 2478).
Kerberos is a network authentication protocol for client/server applications, and SPNEGO provides a mechanism for extending Kerberos to Web applications through the standard HTTP protocol
