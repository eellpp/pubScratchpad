
### Kerberos 
http://www.roguelynn.com/words/explain-like-im-5-kerberos/
https://kb.iu.edu/d/acjj
https://www2.cisl.ucar.edu/resources/storage-and-file-systems/hpss/kerberos-basics
https://web.mit.edu/kerberos/krb5-devel/doc/admin/install_kdc.html

https://www.slideshare.net/MichaelStack4/practical-kerberos-with-apache-hbase-69971097
https://steveloughran.gitbooks.io/kerberos_and_hadoop/content/index.html

Kerberos is composed of three parts: a client, a server, and a trusted third party known as the Kerberos Key Distribution Center (KDC). The KDC provides authentication and ticket granting services.

`KDC` - Kerberos ticket controller. The one who stores all the username and passwords. It has two parts
- KDC Authenticating Server
- KDC Ticket Granting Server
`Service` - A service which `user` wants to access

A high livel overview of what happens when user wants to authenticate to service, he 
- contacts the `KDC AUTHENTICATING SERVER` for a TGT ticket which can be used in future to authenticate against multiple `services`. TGT is the ticket granting ticket. During the process of getting a ticket, the user sends messages encrypted with his passwords. Since `KDC AUTHENTICATOR` knows users password, it authenticates the `user` for TGT

Example of TGT ticket
```bash
shell% klist
Ticket cache: /tmp/krb5cc_ttypa
Default principal: jennifer@ATHENA.MIT.EDU

Valid starting     Expires            Service principal
06/07/04 19:49:21  06/08/04 05:49:19  krbtgt/ATHENA.MIT.EDU@ATHENA.MIT.EDU
```
- To authenticate with service, the 'user' sends this TGT ticket along with the service name to `KDC Ticket Granting Server`. `KDC` now checks whether the service exists etc and if all ok, sends a ticket for the `service`, which is encrypted with the `service` password. At this stage, the `KDC` has ensured that the `user` is who they they are and are eligible to use the service.
- `User` can't decryt this ticket, (since it is encypted with the `service` password). It then sends to ticket to the `service`. The `service` can decrypt this and allows the `user`.

Note:
- The services never stored user passwords etc !
- Nobody sends passwords (encrypted or otherwise) while communicating !
- The service never contacts the KDC to verify user credentials !

Really cool !


Single Sign-on Using Kerberos in Java
https://docs.oracle.com/javase/8/docs/technotes/guides/security/jgss/single-signon.html

#### Video reference
- (Fundamentals of Kerberos ) https://www.youtube.com/watch?v=XLBAhz735mg&t=1698s
- https://www.youtube.com/watch?v=kp5d8Yv3-0c
- https://www.youtube.com/watch?v=hG-PotkV-5U

### Keytab:
https://kb.iu.edu/d/aumh

A keytab used with kinit can be thought of as storing a password in a file. So when you kinit using a keytab, it uses the key in the keytab to decrypt the blob you get from KDC.

The kerberos KDC does not store your password, but a secret key. When you kinit what is going on under the covers is that you are asking the KDC for a ticket to ask for more kerberos tickets, it encrypts that ticket with your secret key.

If you know your secret key, you can unencrypt the blob and use that to access other services.

#### Creating Keytab on Windows/Linux
http://www.itadmintools.com/2011/07/creating-kerberos-keytab-files.html

```bash
## Windows
ktpass ﻿/princ username@MYDOMAIN.COM /pass password /ptype KRB5_NT_PRINCIPAL /out username.keytab

# Ubuntu
ktutil
addent -password -p username@MYDOMAIN.COM -k 1 -e RC4-HMAC
- enter password for username -
wkt username.keytab
q
```

### Configuring Windows
http://doc.mapr.com/display/MapR/Configuring+Kerberos+Authentication+for+Windows

