
### Kerberos basics
https://www2.cisl.ucar.edu/resources/storage-and-file-systems/hpss/kerberos-basics

`KDC` - Kerberos ticket controller. The one who stores all the username and passwords
`Service` - A service which `user` wants to access

A high livel overview of what happens when user wants to authenticate to service, he 
- contacts the `KDC` for ticket to use the `service`. During the process of getting a ticket, the user sends messages encrypted with his passwords. Since `KDC` knows users password, it authenticates the `user`
- `KDC` sends a ticket for the `service`, which is encrypted with the `service` password. At this stage, the `KDC` has ensured that the `user` is who they they are and are eligible to use the service.
- `User` can't decryt this ticket, (since it is encypted with the services key). It then sends to ticket to the `service`. The `service` can decrypt this and allows the `user`.

#### Video reference
https://www.youtube.com/watch?v=kp5d8Yv3-0c


### kerberos
https://kb.iu.edu/d/acjj
http://www.roguelynn.com/words/explain-like-im-5-kerberos/

### Keytab:
https://kb.iu.edu/d/aumh


A keytab used with kinit can be thought of as storing a password in a file. So when you kinit using a keytab, it uses the key in the keytab to decrypt the blob you get from KDC.

The kerberos KDC does not store your password, but a secret key. When you kinit what is going on under the covers is that you are asking the KDC for a ticket to ask for more kerberos tickets, it encrypts that ticket with your secret key.

If you know your secret key, you can unencrypt the blob and use that to access other services.

### Configuring Windows
http://doc.mapr.com/display/MapR/Configuring+Kerberos+Authentication+for+Windows

