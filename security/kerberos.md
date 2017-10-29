
### Kerberos 
http://www.roguelynn.com/words/explain-like-im-5-kerberos/
https://kb.iu.edu/d/acjj
https://www2.cisl.ucar.edu/resources/storage-and-file-systems/hpss/kerberos-basics
https://web.mit.edu/kerberos/krb5-devel/doc/admin/install_kdc.html


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

#### Video reference
https://www.youtube.com/watch?v=kp5d8Yv3-0c

### Keytab:
https://kb.iu.edu/d/aumh

A keytab used with kinit can be thought of as storing a password in a file. So when you kinit using a keytab, it uses the key in the keytab to decrypt the blob you get from KDC.

The kerberos KDC does not store your password, but a secret key. When you kinit what is going on under the covers is that you are asking the KDC for a ticket to ask for more kerberos tickets, it encrypts that ticket with your secret key.

If you know your secret key, you can unencrypt the blob and use that to access other services.

### Configuring Windows
http://doc.mapr.com/display/MapR/Configuring+Kerberos+Authentication+for+Windows

