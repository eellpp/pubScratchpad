
### What is the application structure in scala
My own suggestion is that you model your efforts on Maven's standard directory layout.
./lib
./src
./src/main
./src/main/resources
./src/main/scala
./src/test
./src/test/resources
./src/test/scala

### What is the equivalent of java application.properties
Use application.conf

This is based on typesafe config
- https://github.com/lightbend/config
