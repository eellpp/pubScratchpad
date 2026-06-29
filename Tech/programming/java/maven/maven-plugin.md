Below is the practical Maven plugin map I would keep in mind as a Java developer.

Maven itself has **lifecycles** like:

```text
clean → validate → compile → test → package → verify → install → deploy
```

A **plugin** provides goals that run in these lifecycle phases. For example, during `compile`, Maven uses the compiler plugin; during `test`, it uses Surefire; during `package`, it may use the JAR plugin, WAR plugin, Assembly plugin, Shade plugin, or Spring Boot plugin depending on the project. Maven’s default plugin bindings depend on the packaging type, such as `jar`, `war`, or `pom`. ([Apache Maven][1])

---

# 1. `maven-compiler-plugin`

## What it does

Compiles your Java source code.

It handles:

```text
src/main/java  → target/classes
src/test/java  → target/test-classes
```

## Essential configuration

For Java 17:

```xml
<properties>
    <maven.compiler.release>17</maven.compiler.release>
</properties>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.14.1</version>
            <configuration>
                <release>17</release>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Why `release` is preferred

For modern Java, prefer:

```xml
<release>17</release>
```

over separately setting:

```xml
<source>17</source>
<target>17</target>
```

`release` ensures the compiled code only uses APIs available in that Java version.

## With Spring Boot

Spring Boot projects often define Java version like this:

```xml
<properties>
    <java.version>17</java.version>
</properties>
```

If you use `spring-boot-starter-parent`, Boot manages many plugin versions for you. You may not need to explicitly declare the compiler plugin unless you want custom behavior.

---

# 2. `maven-surefire-plugin`

## What it does

Runs **unit tests** during:

```text
mvn test
mvn package
```

Usually it runs tests matching names like:

```text
*Test.java
*Tests.java
*TestCase.java
```

## Essential configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.5.3</version>
    <configuration>
        <useModulePath>false</useModulePath>
    </configuration>
</plugin>
```

For many normal projects, you do not need much configuration.

## Common options

Skip tests completely:

```bash
mvn package -DskipTests
```

Run one test class:

```bash
mvn test -Dtest=UserServiceTest
```

Run one test method:

```bash
mvn test -Dtest=UserServiceTest#shouldCreateUser
```

## With Spring Boot

Spring Boot unit tests also run through Surefire.

Example:

```java
@SpringBootTest
class MyApplicationTests {
    @Test
    void contextLoads() {
    }
}
```

When you run:

```bash
mvn test
```

Surefire executes it.

Spring Boot does not replace Surefire. It adds testing support through dependencies like `spring-boot-starter-test`.

---

# 3. `maven-failsafe-plugin`

## What it does

Runs **integration tests**, usually during:

```text
integration-test
verify
```

This is different from Surefire.

Common naming pattern:

```text
*IT.java
*ITCase.java
```

Surefire is for fast unit tests. Failsafe is for slower integration tests that may need DB, server, Docker, external services, etc. The Failsafe plugin is designed for integration-test-style execution and uses a similar configuration style to Surefire. ([Apache Maven][2])

## Essential configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
    <version>3.5.3</version>
    <executions>
        <execution>
            <goals>
                <goal>integration-test</goal>
                <goal>verify</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

## Typical usage

```bash
mvn verify
```

This runs:

```text
compile
test
package
integration-test
verify
```

## With Spring Boot

Failsafe is very useful for Spring Boot when you want to start the application and run integration tests.

Example pattern:

```text
UserServiceTest.java     → unit test → Surefire
UserApiIT.java           → integration test → Failsafe
```

Spring Boot Maven Plugin can also start and stop the app around integration tests, but many teams use Testcontainers instead.

---

# 4. `maven-jar-plugin`

## What it does

Creates the normal JAR file during:

```text
mvn package
```

Output:

```text
target/my-app-1.0.jar
```

## Essential configuration

For a simple Java app, you may configure the `Main-Class`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.4.2</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.example.Main</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

Then you can run:

```bash
java -jar target/my-app-1.0.jar
```

But this normal JAR usually does **not** include dependency JARs.

## Without Spring Boot

For a plain Java application, `maven-jar-plugin` creates your app JAR, but you may still need Assembly or Shade to package dependencies.

## With Spring Boot

In Spring Boot, you usually do **not** rely on `maven-jar-plugin` alone for the final executable JAR.

Spring Boot uses:

```text
spring-boot-maven-plugin
```

to repackage the JAR into an executable Boot JAR with dependencies included.

---

# 5. `maven-war-plugin`

## What it does

Creates a WAR file for deployment to servlet containers like Tomcat, Jetty, or WebLogic.

Output:

```text
target/my-webapp.war
```

## Essential configuration

```xml
<packaging>war</packaging>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-war-plugin</artifactId>
            <version>3.4.0</version>
        </plugin>
    </plugins>
</build>
```

## Without Spring Boot

Traditional Java web apps often use:

```text
packaging = war
```

and deploy the WAR to an external application server.

## With Spring Boot

Spring Boot usually uses executable JARs. But if you need external Tomcat deployment, use WAR packaging:

```xml
<packaging>war</packaging>
```

And mark embedded Tomcat as provided:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```

---

# 6. `maven-resources-plugin`

## What it does

Copies resources into the build output.

Main resources:

```text
src/main/resources → target/classes
```

Test resources:

```text
src/test/resources → target/test-classes
```

## Common resources

```text
application.properties
application.yml
logback.xml
SQL files
templates
static files
```

## Essential configuration

Usually no explicit configuration is needed.

But if you want filtering, you can do:

```xml
<build>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
```

Then this file:

```properties
app.version=${project.version}
```

can become:

```properties
app.version=1.0.0
```

during build.

## Warning

Be careful with filtering binary files like images, certificates, fonts, etc. Filtering should usually be applied only to text resources.

## With Spring Boot

Spring Boot uses resources heavily:

```text
application.properties
application.yml
static/
templates/
```

Most of the time, leave the resource plugin alone.

---

# 7. `maven-dependency-plugin`

## What it does

Handles dependency-related tasks.

Useful goals include:

```text
dependency:tree
dependency:copy-dependencies
dependency:analyze
```

## Common commands

Show dependency tree:

```bash
mvn dependency:tree
```

Find where a dependency comes from:

```bash
mvn dependency:tree -Dincludes=org.slf4j
```

Copy dependencies:

```bash
mvn dependency:copy-dependencies
```

## Essential configuration example

Copy runtime dependencies into `target/lib`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <version>3.7.1</version>
    <executions>
        <execution>
            <id>copy-dependencies</id>
            <phase>package</phase>
            <goals>
                <goal>copy-dependencies</goal>
            </goals>
            <configuration>
                <outputDirectory>${project.build.directory}/lib</outputDirectory>
                <includeScope>runtime</includeScope>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## Without Spring Boot

Very useful when creating a `lib/` folder for a command-line or batch application.

## With Spring Boot

Less commonly needed because Spring Boot executable JAR already packages dependencies inside the Boot JAR.

---

# 8. `maven-assembly-plugin`

## What it does

Creates distribution packages like:

```text
zip
tar.gz
dir
jar-with-dependencies
```

The Assembly Plugin builds an archive from project files, dependencies, modules, and custom descriptors. ([Home][3])

## Common use

Create a package like:

```text
my-app.zip
 ├── bin/start.sh
 ├── config/application.properties
 ├── lib/my-app.jar
 └── lib/dependency-jars.jar
```

## Essential configuration

In `pom.xml`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
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
```

Example `assembly.xml`:

```xml
<assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0">
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

## Without Spring Boot

Very useful for normal Java apps, batch jobs, ETL jobs, and command-line tools.

## With Spring Boot

Usually less necessary because the Boot JAR is already executable. But Assembly is still useful if you want to ship:

```text
start.sh
stop.sh
application-prod.yml
README
systemd service file
```

along with the Boot JAR.

---

# 9. `maven-shade-plugin`

## What it does

Creates a **fat JAR / uber JAR** by merging your code and dependencies into one JAR.

Example:

```text
target/my-app-1.0-shaded.jar
```

## Essential configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.6.0</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                        <mainClass>com.example.Main</mainClass>
                    </transformer>
                </transformers>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## Without Spring Boot

Useful for:

```text
CLI tools
Spark jobs
batch jobs
small services
single-JAR deployments
```

For Spark, Shade is often used to relocate dependencies and avoid classpath conflicts.

Example relocation:

```xml
<relocations>
    <relocation>
        <pattern>com.google.common</pattern>
        <shadedPattern>myapp.shaded.com.google.common</shadedPattern>
    </relocation>
</relocations>
```

## With Spring Boot

Usually do **not** use Shade for normal Spring Boot apps.

Spring Boot has its own executable JAR layout. Use `spring-boot-maven-plugin` instead.

---

# 10. `spring-boot-maven-plugin`

## What it does

This is the main Spring Boot build plugin.

It can:

```text
create executable JAR/WAR
run the app
generate build-info
build container image
start/stop app for integration tests
```

Spring Boot’s Maven plugin provides Maven support for packaging executable JAR/WAR archives, running Boot apps, generating build information, and more. ([Home][4])

## Essential configuration

Typical Spring Boot `pom.xml`:

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.5.3</version>
    <relativePath/>
</parent>

<properties>
    <java.version>17</java.version>
</properties>

<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

## What happens during package

When you run:

```bash
mvn package
```

Spring Boot plugin repackages the normal JAR into an executable Boot JAR.

Output:

```text
target/my-service-1.0.0.jar
```

Run:

```bash
java -jar target/my-service-1.0.0.jar
```

Internally, the Boot JAR contains:

```text
BOOT-INF/classes
BOOT-INF/lib
META-INF
```

## Useful commands

Run app:

```bash
mvn spring-boot:run
```

Build executable JAR:

```bash
mvn clean package
```

Build container image:

```bash
mvn spring-boot:build-image
```

The Boot plugin can create an OCI image from a JAR or WAR using Cloud Native Buildpacks. ([Home][5])

## Common configuration

Set main class:

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <mainClass>com.example.MyApplication</mainClass>
    </configuration>
</plugin>
```

Exclude devtools from final package:

```xml
<configuration>
    <excludeDevtools>true</excludeDevtools>
</configuration>
```

Generate build info:

```xml
<executions>
    <execution>
        <goals>
            <goal>build-info</goal>
        </goals>
    </execution>
</executions>
```

This creates build metadata that can be exposed through Actuator.

---

# 11. `maven-install-plugin`

## What it does

Installs your built artifact into your local Maven repository:

```text
~/.m2/repository
```

When you run:

```bash
mvn install
```

your project artifact becomes available to other local Maven projects.

## Example

Project A:

```bash
mvn clean install
```

Project B can then depend on Project A:

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>project-a</artifactId>
    <version>1.0.0</version>
</dependency>
```

## Without Spring Boot

Very common for shared libraries.

## With Spring Boot

Use carefully.

If the project is a reusable library, do not make it a Boot executable JAR. For shared libraries, use normal JAR packaging.

---

# 12. `maven-deploy-plugin`

## What it does

Publishes your artifact to a remote Maven repository.

Examples:

```text
Nexus
Artifactory
GitHub Packages
company Maven repository
```

Command:

```bash
mvn deploy
```

## Essential configuration

In `pom.xml`:

```xml
<distributionManagement>
    <repository>
        <id>company-releases</id>
        <url>https://repo.company.com/releases</url>
    </repository>

    <snapshotRepository>
        <id>company-snapshots</id>
        <url>https://repo.company.com/snapshots</url>
    </snapshotRepository>
</distributionManagement>
```

Credentials usually go in `~/.m2/settings.xml`:

```xml
<servers>
    <server>
        <id>company-releases</id>
        <username>my-user</username>
        <password>my-password</password>
    </server>
</servers>
```

## Without Spring Boot

Used heavily for shared libraries.

## With Spring Boot

Usually deploy shared libraries, starters, or internal platform modules.

For runnable services, teams usually deploy the built JAR/container image to runtime infrastructure, not necessarily as a reusable Maven dependency.

---

# 13. `maven-clean-plugin`

## What it does

Deletes the build output directory:

```text
target/
```

Command:

```bash
mvn clean
```

Usually no configuration needed.

## Why it matters

If you suspect stale generated classes or old resources, run:

```bash
mvn clean package
```

---

# 14. `maven-enforcer-plugin`

## What it does

Enforces rules so the build fails early if the environment is wrong.

Useful for enforcing:

```text
Java version
Maven version
dependency convergence
banned dependencies
required properties
```

## Essential configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.5.0</version>
    <executions>
        <execution>
            <id>enforce-java</id>
            <goals>
                <goal>enforce</goal>
            </goals>
            <configuration>
                <rules>
                    <requireJavaVersion>
                        <version>[17,)</version>
                    </requireJavaVersion>
                    <requireMavenVersion>
                        <version>[3.9,)</version>
                    </requireMavenVersion>
                    <dependencyConvergence/>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## Why it is important

It prevents this kind of issue:

```text
Works on my machine, fails in Jenkins.
Works with Java 21, fails in production Java 17.
Different transitive dependency versions causing runtime errors.
```

## With Spring Boot

Very useful in Spring Boot projects too, especially for Java version and dependency convergence.

---

# 15. `jacoco-maven-plugin`

## What it does

Generates test coverage reports.

## Essential configuration

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.12</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>

        <execution>
            <id>report</id>
            <phase>verify</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

Run:

```bash
mvn verify
```

Report:

```text
target/site/jacoco/index.html
```

## With Spring Boot

Works normally with Spring Boot tests.

---

# Plain Maven vs Spring Boot Maven

## Plain Java Maven project

Typical plugins:

```text
maven-compiler-plugin
maven-surefire-plugin
maven-failsafe-plugin
maven-jar-plugin
maven-shade-plugin or maven-assembly-plugin
maven-dependency-plugin
maven-enforcer-plugin
jacoco-maven-plugin
```

Typical packaging choices:

```text
normal library JAR
CLI executable JAR
fat JAR
ZIP/TAR distribution
```

Example plain Java setup:

```xml
<project>
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>plain-java-app</artifactId>
    <version>1.0.0</version>

    <properties>
        <maven.compiler.release>17</maven.compiler.release>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.14.1</version>
                <configuration>
                    <release>17</release>
                </configuration>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.5.3</version>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.6.0</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.example.Main</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## Spring Boot Maven project

Typical plugins:

```text
spring-boot-maven-plugin
maven-compiler-plugin, often managed by Boot parent
maven-surefire-plugin
maven-failsafe-plugin
jacoco-maven-plugin
maven-enforcer-plugin
```

Usually avoid:

```text
maven-shade-plugin for normal Boot apps
manual dependency copying
custom JAR manifest handling
```

Example Spring Boot setup:

```xml
<project>
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.3</version>
        <relativePath/>
    </parent>

    <groupId>com.example</groupId>
    <artifactId>boot-service</artifactId>
    <version>1.0.0</version>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <version>3.5.3</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>integration-test</goal>
                            <goal>verify</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

---

# Simple decision guide

| Need                        | Plain Maven                          | Spring Boot                                    |
| --------------------------- | ------------------------------------ | ---------------------------------------------- |
| Compile Java                | `maven-compiler-plugin`              | Usually managed by Boot parent                 |
| Run unit tests              | `maven-surefire-plugin`              | Same                                           |
| Run integration tests       | `maven-failsafe-plugin`              | Same, often with Boot test support             |
| Create normal JAR           | `maven-jar-plugin`                   | Created first, then repackaged by Boot         |
| Create executable fat JAR   | `maven-shade-plugin`                 | Use `spring-boot-maven-plugin`                 |
| Create ZIP/TAR distribution | `maven-assembly-plugin`              | Optional, only if shipping scripts/config/docs |
| Copy dependencies to `lib/` | `maven-dependency-plugin`            | Usually unnecessary                            |
| Build Docker/OCI image      | External Docker plugin or Dockerfile | `spring-boot:build-image` available            |
| Enforce Java/Maven versions | `maven-enforcer-plugin`              | Same                                           |
| Test coverage               | `jacoco-maven-plugin`                | Same                                           |

---

# Practical recommendation

For a **plain Java 17 project**, start with:

```text
compiler
surefire
failsafe
shade or assembly
enforcer
jacoco
```

For a **Spring Boot Java 17 project**, start with:

```text
spring-boot-maven-plugin
surefire
failsafe
enforcer
jacoco
```

The biggest difference is packaging:

```text
Plain Java:
    You decide how to package dependencies.
    Use Shade, Assembly, or Dependency plugin.

Spring Boot:
    Boot plugin handles executable packaging.
    Avoid Shade unless you have a special reason.
```

[1]: https://maven.apache.org/ref/current/maven-core/default-bindings.html?utm_source=chatgpt.com "Plugin Bindings for Default Lifecycle Reference – Maven Core"
[2]: https://maven.apache.org/surefire/maven-failsafe-plugin/usage.html?utm_source=chatgpt.com "Usage – Maven Failsafe Plugin"
[3]: https://docs.spring.io/spring-boot/docs/3.1.3/maven-plugin/reference/htmlsingle/?utm_source=chatgpt.com "Spring Boot Maven Plugin Documentation"
[4]: https://docs.spring.io/spring-boot/docs/3.3.0-SNAPSHOT/maven-plugin/reference/htmlsingle/?utm_source=chatgpt.com "Spring Boot Maven Plugin Documentation"
[5]: https://docs.spring.io/spring-boot/maven-plugin/build-image.html?utm_source=chatgpt.com "Packaging OCI Images :: Spring Boot"
