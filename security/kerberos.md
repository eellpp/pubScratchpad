
### Kerberos basics
https://www2.cisl.ucar.edu/resources/storage-and-file-systems/hpss/kerberos-basics

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

