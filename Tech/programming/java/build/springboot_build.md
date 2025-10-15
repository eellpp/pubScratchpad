The Repo has pom.xml and assembly.xml

## Compilation
The maven-compiler-plugin is configured to compile the code configured java version

## Packaging 
The maven-jar-plugin is used to package the compiled code into jar file. THis contains only the compiled code and no dependencies. 

## Spring boot integration 
Springboot-maven-plugin is used to create a executable jar (fat jar) that has the compiled jar and all the dependencies and spring run time 

## file removal during packaging 

The truezip-maven-plugin is used to remove specific files or directories from the packaged jar. 

## Assembly
The maven-assembly-plugin is used to create a distributable archive (.tar or .zip) file. Other than the jar it may include other files/dir like scripts etc 

## Clean
The maven-clean-plugin is used to remove the specific jar files from the root path. This is run before the compilation phase (to remove any redundant files) or after assembly 

THe project uses spring-boot-starter-parent  to manage dependency.

This setups the version of various dependencies of jars that spring depends on. Thus avoiding bioler plate in pom.xml

# Maven's nearest neighbour rule and dependency mediation 
- If two dependencies with different versions are at same level, then the dependency declared first would be applicable
- If you explicitly declare a dependency and specify its version in pom.xml then maven will use this version overriding the version of transitive dependencies
