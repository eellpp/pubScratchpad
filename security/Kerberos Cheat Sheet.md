
Source : Pivotal

https://discuss.pivotal.io/hc/en-us/articles/203053938-Kerberos-Cheat-Sheet

## Environment

Pivotal HD Kerberos: All versions

## Purpose

This article lists common commands regarding Kerberos administration, as my memo. The platform is CentOS6.

## Description

1. Package Installation

`yum install krb5-libs krb5-workstation krb5-server `

2. Configuration File (Default location for Pivotal HD)

KDC configuration on KDC host

/var/kerberos/krb5kdc/kdc.conf
Kerberos configuration on all hosts

/etc/krb5.conf
kadmind ACL on KDC host

/var/kerberos/krb5kdc/kadm5.acl
3. kdb5_util

kdb5_util allows an administrator to perform maintenance procedures on the KDC Database. Backup KDC Database

Backup KDC Database

[root@admin]# kdb5_util dump -verbose /backup/kdc.dump
HTTP/hdm.xxx.com@VIADEA.COM
HTTP/hdw1.xxx.com@VIADEA.COM
HTTP/hdw2.xxx.com@VIADEA.COM
Then you can use "string" to check the content of the dump file

strings /backup/kdc.dump
Restore KDC Database

kdb5_util load /backup/kdc.dump
Add a new master key

Adds a new master key to the master key principal, but does not mark it as active.

[root@admin]# kdb5_util add_mkey
Creating new master key for master key principal 'K/M@VIADEA.COM'
You will be prompted for a new database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key:
Re-enter KDC database master key to verify:
List all master keys

List all master keys, from most recent to earliest, in the master key principal.

[root@admin]# kdb5_util list_mkeys
Master keys for Principal: K/M@VIADEA.COM
KNVO: 2, Enctype: aes256-cts-hmac-sha1-96, No activate time set
KNVO: 1, Enctype: aes256-cts-hmac-sha1-96, Active on: Wed Dec 31 16:00:00 PST 1969 *
Activate a new master key

Once a master key becomes active, it will be used to encrypt newly created principal keys.

kdb5_util use_mkey mkeyVNO [time]
Example:

[root@admin]# kdb5_util use_mkey 2
[root@admin]# kdb5_util list_mkeys
Master keys for Principal: K/M@VIADEA.COM
KNVO: 2, Enctype: aes256-cts-hmac-sha1-96, Active on: Tue Jun 10 15:39:01 PDT 2014 *
KNVO: 1, Enctype: aes256-cts-hmac-sha1-96, Active on: Wed Dec 31 16:00:00 PST 1969
Update all principal keys to be encrypted in the new master key

Update all principal records (Or only those matching the princ-pattern glob pattern) to re-encrypt the key data using the active database master key, if they are encrypted using a different version, and give a count at the end of the number of principals updated.

Do a dry run 
[root@admin]# kdb5_util update_princ_encryption -v -n
Principals whose keys WOULD BE re-encrypted to master key vno 2:
would update: HTTP/hdm.xxx.com@VIADEA.COM
(......)
would update: yarn/hdw3.xxx.com@VIADEA.COM
22 principals processed: 22 would be updated, 0 already current
Run it
[root@admin]# kdb5_util update_princ_encryption -v
Re-encrypt all keys not using master key vno 2?
(type 'yes' to confirm)? yes
Principals whose keys are being re-encrypted to master key vno 2 if necessary:
updating: HTTP/hdm.xxx.com@VIADEA.COM
skipping: HTTP/hdm.xxx.com@VIADEA.COM
updating: HTTP/hdw1.xxx.com@VIADEA.COM
(......)
23 principals processed: 22 updated, 1 already current
Create the stash file for new master key to replace the existing one

[root@admin]# kdb5_util stash /var/kerberos/krb5kdc/.k5.VIADEA.COM
Using existing stashed keys to update stash file.
Delete old master keys

Delete master keys from the master key principal that are not used to protect any principals.

Do a dry run 
[root@admin]# kdb5_util purge_mkeys -v -n
Would purge the follwing master key(s) from K/M@VIADEA.COM:
KVNO: 1
1 key(s) would be purged.
Run it
[root@admin]# kdb5_util purge_mkeys -v
Will purge all unused master keys stored in the 'K/M@VIADEA.COM' principal, are you sure?
(type 'yes' to confirm)? yes
OK, purging unused master keys from 'K/M@VIADEA.COM'...
Purging the follwing master key(s) from K/M@VIADEA.COM:
KVNO: 1
1 key(s) purged.
Creating a new Database

kdb5_util create -s
Destroying a database

kdb5_util destroy
4. Principal Administration

List Principals

kadmin.local: list_principals yarn*
yarn/hdm.xxx.com@VIADEA.COM
yarn/hdw1.xxx.com@VIADEA.COM
yarn/hdw2.xxx.com@VIADEA.COM
yarn/hdw3.xxx.com@VIADEA.COM
Viewing a Principal's Attributes

kadmin.local: getprinc yarn/hdm.xxx.com
Principal: yarn/hdm.xxx.com@VIADEA.COM
Expiration date: [never]
Last password change: Sat Jun 07 14:49:36 PDT 2014
Password expiration date: [none]
Maximum ticket life: 1 day 00:00:00
Maximum renewable life: 7 days 00:00:00
Last modified: Tue Jun 10 15:49:49 PDT 2014 (K/M@VIADEA.COM)
Last successful authentication: [never]
Last failed authentication: [never]
Failed password attempts: 0
Number of keys: 6
Key: vno 1, aes256-cts-hmac-sha1-96, no salt
Key: vno 1, aes128-cts-hmac-sha1-96, no salt
Key: vno 1, des3-cbc-sha1, no salt
Key: vno 1, arcfour-hmac, no salt
Key: vno 1, des-hmac-sha1, no salt
Key: vno 1, des-cbc-md5, no salt
MKey: vno 2
Attributes:
Policy: [none]
Creating a New Principal

kadmin.local: addprinc mysuperman/admin@VIADEA.COM
WARNING: no policy specified for mysuperman/admin@VIADEA.COM; defaulting to no policy
Enter password for principal "mysuperman/admin@VIADEA.COM":
Re-enter password for principal "mysuperman/admin@VIADEA.COM":
Principal "mysuperman/admin@VIADEA.COM" created.
Changing the Password for a Principal

kadmin.local: cpw tim@VIADEA.COM
Enter password for principal "tim@VIADEA.COM":
Re-enter password for principal "tim@VIADEA.COM":
Password for "tim@VIADEA.COM" changed.
or use kpasswd

[root@admin ~]# kpasswd duncan2
Password for duncan2@VIADEA.COM:
Enter new password:
Enter it again:
Delete a Principal

kadmin.local: delete_principal testuser
Are you sure you want to delete the principal "testuser@VIADEA.COM"? (yes/no): yes
Principal "testuser@VIADEA.COM" deleted.
Make sure that you have removed this principal from all ACLs before reusing.
Rename a Principal

kadmin.local: rename_principal duncan duncan2
Are you sure you want to rename the principal "duncan@VIADEA.COM" to "duncan2@VIADEA.COM"? (yes/no): yes
Principal "duncan@VIADEA.COM" renamed to "duncan2@VIADEA.COM".
Make sure that you have removed the old principal from all ACLs before reusing.
Modify a Principal to use Policy

kadmin.local:  modify_principal -policy testpolicy duncan2
Principal "duncan2@VIADEA.COM" modified.
Unlock a Principal

kadmin.local: modify_principal -unlock duncan2
Principal "duncan2@VIADEA.COM" modified. 
5. Policy Administration

Create a Policy

kadmin.local: add_policy -minlength 1 -minlength 5 -maxlife "999 days" -maxfailure 3 testpolicy
List Policies

kadmin.local: list_policies
testpolicy
Modifying a Policy

kadmin.local: modify_policy -minlength 3 testpolicy
Viewing a Kerberos Policy's Attributes

kadmin.local:  get_policy testpolicy
Policy: testpolicy
Maximum password life: 86313600
Minimum password life: 0
Minimum password length: 3
Minimum number of password character classes: 1
Number of old keys kept: 1
Reference count: 0
Maximum password failures before lockout: 3
Password failure count reset interval: 0 days 00:00:00
Password lockout duration: 0 days 00:00:00
Deleting a Policy

kadmin.local: delete_policy testpolicy
6. Keytab Administration

Add Principals to a Keytab

kadmin.local: ktadd -norandkey -k /tmp/tmp.keytab duncan2@VIADEA.COM
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type aes256-cts-hmac-sha1-96 added to keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type aes128-cts-hmac-sha1-96 added to keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type des3-cbc-sha1 added to keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type arcfour-hmac added to keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type des-hmac-sha1 added to keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1, encryption type des-cbc-md5 added to keytab WRFILE:/tmp/tmp.keytab.
Display Keylist (Principals) in a Keytab File

[root@admin ~]# klist -kt /tmp/tmp.keytab
Keytab name: FILE:/tmp/tmp.keytab
KVNO Timestamp         Principal
---- ----------------- --------------------------------------------------------
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
   1 06/10/14 22:08:00 duncan2@VIADEA.COM
Remove Keylist (Principal) from a Keytab File

kadmin.local:  ktremove -k /tmp/tmp.keytab duncan2@VIADEA.COM
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Entry for principal duncan2@VIADEA.COM with kvno 1 removed from keytab WRFILE:/tmp/tmp.keytab.
Authentication using Keytab

kinit -kt /etc/security/phd/keytab/hdfs.service.keytab hdfs/hdm.xxx.com@VIADEA.COM
7. Credential Cache Administration

List Principals in Credential Cache

[root@admin ~]# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: tim@VIADEA.COM

Valid starting     Expires            Service principal
06/10/14 22:24:22  06/11/14 22:24:22  krbtgt/VIADEA.COM@VIADEA.COM
 renew until 06/17/14 22:24:22
Destroy Credential Cache

Note: This will only destroy credential cache for this user.

[testuser@admin ~]$ ls -altr /tmp/krb5*
-rw-------. 1 root     root     741 Jun 10 22:24 /tmp/krb5cc_0
-rw-------. 1 testuser testuser 758 Jun 10 22:36 /tmp/krb5cc_501
[root@admin ~]# kdestroy
[root@admin ~]# ls -altr /tmp/krb*
-rw-------. 1 testuser testuser 758 Jun 10 22:36 /tmp/krb5cc_501
[root@admin ~]# klist
klist: No credentials cache found (ticket cache FILE:/tmp/krb5cc_0)
8. Kerberos Services

KDC Service

/etc/init.d/krb5kdc start
kadmin Service

/etc/init.d/kadmin start
