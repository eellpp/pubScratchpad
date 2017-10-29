
### Goal: 
- To set up a Cloudera VM setup on Hadoop and connect to it from a remote client with using Kerberos
- hive connection with beeline. 
- java hive driver kerberos setup
- python: jpype hive connect
- RJAVA hive connect with kerberos
- Spark connection with kerberos

### Access Keberized service from Java program
To access Hive in a Java program, a Kerberos login is needed. For a keytab login, call the Hadoop UserGroupInformation API in your Java program. For kinit login, run kinit with the client principal before you run the Java program.

## cloudera Quick Start VM kerberos
http://blog.cloudera.com/blog/2015/03/how-to-quickly-configure-kerberos-for-your-apache-hadoop-cluster/

Accessing VM from host: 
https://2buntu.com/articles/1513/accessing-your-virtualbox-guest-from-your-host-os/

## Cloudera Manager Kerberos
https://www.youtube.com/watch?v=4TwU0LwDJAg

## Commands
Video: Kerberize hadoop and hive
https://www.youtube.com/watch?v=xzcLiN-X4Q4
