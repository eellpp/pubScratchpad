To use JavaFX with Maven without manually downloading an SDK, you can utilize Maven's dependency management system. Here's a step-by-step guide:

1. Create a new Maven project or open an existing one.

2. Add the JavaFX dependencies to your `pom.xml` file. You'll need to include the JavaFX base, controls, and graphics modules at minimum:

```xml
<dependencies>
    <dependency>
        <groupId>org.openjfx</groupId>
        <artifactId>javafx-controls</artifactId>
        <version>17.0.2</version>
    </dependency>
    <dependency>
        <groupId>org.openjfx</groupId>
        <artifactId>javafx-fxml</artifactId>
        <version>17.0.2</version>
    </dependency>
</dependencies>
```

3. Add the JavaFX Maven Plugin to your `pom.xml`. This plugin helps with running JavaFX applications:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.openjfx</groupId>
            <artifactId>javafx-maven-plugin</artifactId>
            <version>0.0.8</version>
            <configuration>
                <mainClass>your.package.MainClass</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

4. Set the Java version in your `pom.xml` if you haven't already:

```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```

5. Create your JavaFX application class:

```java
package your.package;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

public class MainClass extends Application {

    @Override
    public void start(Stage stage) {
        String javaVersion = System.getProperty("java.version");
        String javafxVersion = System.getProperty("javafx.version");
        Label label = new Label("Hello, JavaFX " + javafxVersion + ", running on Java " + javaVersion + ".");
        Scene scene = new Scene(new StackPane(label), 640, 480);
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
```

6. To run your JavaFX application, use the following Maven command:

```
mvn javafx:run
```

This approach allows you to use JavaFX without manually downloading an SDK. Maven will handle downloading the necessary JavaFX modules and dependencies.

Would you like me to explain any part of this setup in more detail?
