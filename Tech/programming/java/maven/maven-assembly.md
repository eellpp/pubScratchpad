`assembly.xml` is a **Maven Assembly Plugin descriptor file**.

It tells Maven:

> “When building this project, create an extra packaged output, and include these files, folders, JARs, dependencies, scripts, configs, etc., in this structure.”

The official Maven Assembly Plugin describes this as a way to define an arbitrary assembly of files and directories from a project. ([Apache Maven][1])

## Simple meaning

Normal Maven build usually creates something like:

```text
target/my-app-1.0.jar
```

But sometimes you want a full distributable package like:

```text
my-app.zip
 ├── bin/
 │   └── start.sh
 ├── lib/
 │   ├── my-app.jar
 │   ├── dependency1.jar
 │   └── dependency2.jar
 ├── config/
 │   └── application.properties
 └── README.md
```

That is what `assembly.xml` helps define.

## Common uses

`assembly.xml` is commonly used to create:

```text
.zip
.tar.gz
.jar-with-dependencies
distribution folders
release packages
deployment bundles
```

For example, for a Java command-line app, you may want to package:

```text
your application jar
all dependency jars
startup shell scripts
config files
SQL scripts
README files
```

## Example `assembly.xml`

A simple one may look like this:

```xml
<assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.1.0 https://maven.apache.org/xsd/assembly-2.1.0.xsd">

    <id>dist</id>

    <formats>
        <format>zip</format>
    </formats>

    <includeBaseDirectory>true</includeBaseDirectory>

    <fileSets>
        <fileSet>
            <directory>src/main/scripts</directory>
            <outputDirectory>bin</outputDirectory>
            <fileMode>0755</fileMode>
        </fileSet>

        <fileSet>
            <directory>src/main/config</directory>
            <outputDirectory>config</outputDirectory>
        </fileSet>
    </fileSets>

    <dependencySets>
        <dependencySet>
            <outputDirectory>lib</outputDirectory>
            <scope>runtime</scope>
        </dependencySet>
    </dependencySets>

</assembly>
```

This says:

```text
Create a ZIP file.
Put scripts into bin/.
Put config files into config/.
Put runtime dependencies into lib/.
```

## How it connects to `pom.xml`

In `pom.xml`, you usually configure the Maven Assembly Plugin like this:

```xml
<build>
    <plugins>
        <plugin>
            <artifactId>maven-assembly-plugin</artifactId>
            <version>3.7.1</version>
            <configuration>
                <descriptors>
                    <descriptor>src/main/assembly/assembly.xml</descriptor>
                </descriptors>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <phase>package</phase>
                    <goals>
                        <goal>single</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

Then when you run:

```bash
mvn clean package
```

Maven creates the normal JAR plus the assembled ZIP/TAR/etc. The `assembly:single` goal is used to assemble an application bundle or distribution from an assembly descriptor. ([Apache Maven][2])

## Important sections inside `assembly.xml`

### 1. `<id>`

```xml
<id>dist</id>
```

This becomes part of the generated file name.

Example:

```text
my-app-1.0-dist.zip
```

### 2. `<formats>`

```xml
<formats>
    <format>zip</format>
</formats>
```

Controls output type.

Common values:

```text
zip
tar
tar.gz
dir
jar
```

### 3. `<fileSets>`

Used to copy project files/folders into the package.

Example:

```xml
<fileSet>
    <directory>src/main/config</directory>
    <outputDirectory>config</outputDirectory>
</fileSet>
```

Meaning:

```text
Take files from src/main/config
Put them inside config/ in the final ZIP
```

### 4. `<dependencySets>`

Used to include Maven dependencies.

Example:

```xml
<dependencySet>
    <outputDirectory>lib</outputDirectory>
    <scope>runtime</scope>
</dependencySet>
```

Meaning:

```text
Take runtime dependencies
Put them into lib/
```

### 5. `<files>`

Used to copy specific individual files.

Example:

```xml
<file>
    <source>README.md</source>
    <outputDirectory>/</outputDirectory>
</file>
```

## Difference from normal JAR packaging

Normal Maven JAR:

```text
Contains your compiled classes/resources.
Usually does not include all dependency JARs inside it.
```

Assembly package:

```text
Can contain your JAR, dependencies, scripts, configs, docs, folders, and anything else you define.
```

So `assembly.xml` is more like a **release package recipe**.

## Built-in descriptors

You do not always need a custom `assembly.xml`. Maven Assembly Plugin also has predefined descriptors like:

```text
bin
jar-with-dependencies
src
project
```

For example:

```xml
<descriptorRefs>
    <descriptorRef>jar-with-dependencies</descriptorRef>
</descriptorRefs>
```

This creates a fat JAR containing dependencies. Maven documents these built-in descriptors officially. ([Apache Maven][3])

## Practical mental model

Think of `assembly.xml` as saying:

```text
Final package name/type:
    zip / tar.gz / jar

Include:
    application jar
    dependency jars
    scripts
    config files
    docs

Arrange them as:
    bin/
    lib/
    config/
    docs/
```

So in a Java project, `assembly.xml` is mainly used when you want to distribute or deploy the application in a clean, ready-to-run structure.

[1]: https://maven.apache.org/plugins/maven-assembly-plugin/?utm_source=chatgpt.com "Introduction – Apache Maven Assembly Plugin"
[2]: https://maven.apache.org/plugins/maven-assembly-plugin/plugin-info.html?utm_source=chatgpt.com "Plugin Documentation – Apache Maven Assembly Plugin"
[3]: https://maven.apache.org/plugins/maven-assembly-plugin/descriptor-refs.html?utm_source=chatgpt.com "Predefined Assembly Descriptors - Apache Maven"
