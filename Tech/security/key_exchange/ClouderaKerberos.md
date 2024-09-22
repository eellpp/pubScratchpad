
### Goal: 
- To set up a Cloudera VM setup on Hadoop and connect to it from a remote client with using Kerberos
- hive connection with beeline. 
- java hive driver kerberos setup
- python: jpype hive connect
- RJAVA hive connect with kerberos
- Spark connection with kerberos

### Access Keberized service from Java program
To access Hive in a Java program, a Kerberos login is needed. For a keytab login, call the Hadoop UserGroupInformation API in your Java program. For kinit login, run kinit with the client principal before you run the Java program.

#### With Keytab
```java
import org.apache.hadoop.security.UserGroupInformation;
org.apache.hadoop.conf.Configuration conf = new     
org.apache.hadoop.conf.Configuration();
conf.set("hadoop.security.authentication", "Kerberos");
UserGroupInformation.setConfiguration(conf);
UserGroupInformation.loginUserFromKeytab("example_user@DOMAIN", "/path/to/example_user.keytab");
String url =  "jdbc:hive2://hive2_host:10000/default;principal=hive/hive2_host@YOUR-REALM.COM"
Connection con = DriverManager.getConnection(url);
```

#### Without Keytab

Have to do kinit on the shell before launching the java app

```java
public class RecordController {
  private static String driverName = "org.apache.hive.jdbc.HiveDriver";

  public static void main(String[] args) throws SQLException, ClassNotFoundException, IOException {
    Class.forName(driverName);
    System.setProperty("javax.security.auth.useSubjectCredsOnly","false");
    System.setProperty("java.security.krb5.conf","krb5.conf");

    Connection con = DriverManager
                         .getConnection("jdbc:hive2://host:port/arstel;" +
                                          "principal=hive/host@DOMAIN;" +
                                          "auth=kerberos;" +
                                          "kerberosAuthType=fromSubject");
```
#### ENV and JVM parameters
```bash
export HADOOP_OPTS="-Dsun.security.krb5.debug=true"
export HADOOP_CLIENT_OPTS="-Dsun.security.jgss.debug=true;-Djavax.security.auth.useSubjectCredsOnly=false;-Djava.security.krb5.conf=/etc/krb5.conf"

```


### Server debug logs
You will be able to locate the kerberos debug message from HiveServer2’s process directory on the server host, which is located under /var/run/cloudera-scm-agent/process/XXX-hive-HIVESERVER2/logs/stdout.log, where XXX is the largest number under the directory for HiveServer2

### Removing the 128-bit key restriction in Java (default is 128)
https://stackoverflow.com/questions/11538746/check-for-jce-unlimited-strength-jurisdiction-policy-files
https://www.javamex.com/tutorials/cryptography/unrestricted_policy_files.shtml

Caused by: org.ietf.jgss.GSSException: No valid credentials provided (Mechanism level: Failed to find any Kerberos tgt)

## cloudera Quick Start VM kerberos
http://blog.cloudera.com/blog/2015/03/how-to-quickly-configure-kerberos-for-your-apache-hadoop-cluster/

Kerberos Admin ID : cloudera-scm/admin@CLOUDERA
```bash
[cloudera@quickstart ~]$ kadmin -p cloudera-scm/admin@CLOUDERA
Authenticating as principal cloudera-scm/admin@CLOUDERA with password.
Password for cloudera-scm/admin@CLOUDERA: 
kadmin:  list_principals
HTTP/quickstart.cloudera@CLOUDERA
K/M@CLOUDERA
cloudera-scm/admin@CLOUDERA
cloudera@CLOUDERA
hbase/quickstart.cloudera@CLOUDERA
hdfs/quickstart.cloudera@CLOUDERA
hdfs@CLOUDERA
hive/quickstart.cloudera@CLOUDERA
hue/quickstart.cloudera@CLOUDERA
impala/quickstart.cloudera@CLOUDERA
kadmin/admin@CLOUDERA
kadmin/changepw@CLOUDERA
kadmin/quickstart.cloudera@CLOUDERA
krbtgt/CLOUDERA@CLOUDERA
mapred/quickstart.cloudera@CLOUDERA
oozie/quickstart.cloudera@CLOUDERA
solr/quickstart.cloudera@CLOUDERA
spark/quickstart.cloudera@CLOUDERA
sqoop2/quickstart.cloudera@CLOUDERA
yarn/quickstart.cloudera@CLOUDERA
zookeeper/quickstart.cloudera@CLOUDERA
```

Cloudera Manager passes configuration and those keytabs through the agent at startup of the CDH processes configured to run on that cluster server. The keytabs are pushed from a database to a runtime location at startup of services.
 The path to keytab is /var/run/cloudera-scm-agent/process/  but this is ephemeral, next restart will have another location. 


./bin/beeline -u "jdbc:hive2://quickstart.cloudera:10000/default;principal=hive/_HOST@CLOUDERA;auth=kerberos"

### Kerberos user principals
Kerberos user principals have 2 parts. Eg: myuser@COMPANY.COM

### Kerberos service principals

`nfs/server.example.com@EXAMPLE.COM`

Let's analyze this principal name. The first component represents the service being used, in this case 'nfs' is used to represent a NFS server. Other well know service types are 'HTTP', 'DNS', 'host', 'cifs', etc... The second component is a DNS name. This is the server's own name. The realm specifies that this service is bound to the EXAMPLE.COM realm.

In the beeline connect string you should always use the hive service principal for the HiveServer2 instance to which you are connecting. Another option is to use _HOST instead of the specific hostname, which will be expanded to the correct host.

For example:
```bash
kinit myuser@COMPANY.COM
beeline> !connect jdbc:hive2://somehost.company.com:10000/default;principal=hive/_HOST@COMPANY.COM
```

### Java Hive JDBC with Kerberos
kinit cloudera@CLOUDERA

gss-jaas.conf
```bash
com.sun.security.jgss.initiate {
     com.sun.security.auth.module.Krb5LoginModule required
     useKeyTab=false
     useTicketCache=true
     principal="cloudera@CLOUDERA"
     debug=true;
  };
```
The connection url is jdbc:hive2://quickstart.cloudera:10000/default;principal=hive/quickstart.cloudera@CLOUDERA

run the jar
```bash
java -cp $HADOOP_CLASSPATH:out/artifacts/hiveJDBCWithKerberos_jar/hiveJDBCWithKerberos.jar hiveTest.HiveJDBC
```



Accessing VM from host: 
https://2buntu.com/articles/1513/accessing-your-virtualbox-guest-from-your-host-os/

## Cloudera Manager Kerberos
https://www.youtube.com/watch?v=4TwU0LwDJAg

## Commands
Video: Kerberize hadoop and hive
https://www.youtube.com/watch?v=xzcLiN-X4Q4

