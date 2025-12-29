### JMXTrans
It is a connector between speaking to a JVM via JMX on one end and whatever logging / monitoring / graphing package that you can dream up on the other end. The core engine is very solid and there are writers for Graphite, StatsD, Ganglia, cacti/rrdtool, OpenTSDB, text files, and stdout.

jmxtrans is a tool which allows you to connect to any number of Java Virtual Machines (JVMs) and query them for their attributes without writing a single line of Java code. The attributes are exported from the JVM via Java Management Extensions (JMX). Most Java applications have made their statistics available via this protocol and it is possible to add this to any codebase without a lot of effort. If you use the SpringFramework for your code, it can be as easy as just adding a couple of annotations to a Java class file.

https://github.com/jmxtrans/jmxtrans/wiki

### The creator of jmxTrans

>  My target audience is the netops/devops role. It is configured with a relatively simple JSON based structure so it doesn't require an engineering degree to configure and use it.

> The thought is that you use jmxtrans to continuously monitor services which expose statistics via jmx. You use jmxtrans to 'transform' data from jmx to whatever output format you want. Generally, devops people want to integrate their JVMs with some sort of monitoring solution like Graphite/Ganglia so I provided output writers for those tools.

> jmxtrans is also very smart about how it does queries against jmx servers and there is a bit of optimization in there for that. There is also a lot of work to allow you to do things like parallelize requests to many servers to enable to you scale jmxtrans to continuously query hundreds of servers with a single jmxtrans instance.
