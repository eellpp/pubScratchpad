The licensing changes Oracle made for Java also affect JavaFX, but in a slightly different way due to JavaFX’s history and its decoupling from the JDK. Here’s how the changes impact JavaFX:

1. JavaFX’s Evolution and Decoupling from JDK

	•	JavaFX was originally bundled with the Oracle JDK, starting from Java 7 and fully integrated with Java 8. This meant that when you downloaded Oracle JDK or JRE during that time, you also received JavaFX as part of the standard package.
	•	However, starting with Java 11, Oracle decoupled JavaFX from the JDK. This means JavaFX is no longer included with the Oracle JDK or OpenJDK distributions. If you need JavaFX for your application, you must install it separately.

2. JavaFX Now as a Standalone Open Source Project

After its removal from the JDK, JavaFX became an open-source project, hosted under the OpenJFX project, which is licensed under the GPL v2 with Classpath Exception. This allows developers to use JavaFX independently, and it remains free to use, distribute, and modify under this open-source license.

3. JavaFX and Oracle JDK Licensing

Since JavaFX is no longer part of the Oracle JDK starting from Java 11, it is not directly impacted by Oracle’s commercial licensing changes for the JDK itself. However, if you’re using Oracle JDK to run JavaFX applications, the licensing terms of Oracle JDK still apply for the production environment, meaning:

	•	For development or non-commercial use, you can use Oracle JDK (with a separately installed JavaFX) without needing a commercial license.
	•	For commercial production environments, Oracle JDK (even if you’re using it with JavaFX) requires a paid subscription if you want long-term support and updates.

If you’re using OpenJDK or any other non-Oracle JDK distribution, and you separately download and use JavaFX from the OpenJFX project, then your licensing would be purely based on the open-source GPL license of OpenJFX.

4. JavaFX Alternatives and Usage with JDKs

To continue using JavaFX in your applications, you have a few options:

	•	OpenJFX: You can download JavaFX separately from the OpenJFX project, which is the open-source version of JavaFX. It works with OpenJDK and other JDK distributions (Amazon Corretto, Azul Zulu, etc.), and you do not need to worry about Oracle’s JDK licensing here.
	•	Third-Party JDK Distributions with JavaFX Support: Some third-party vendors offer JDK distributions that bundle JavaFX:
	•	Gluon provides a JavaFX distribution with long-term support for developers and enterprises. Gluon specializes in making JavaFX available on mobile devices (Android and iOS).
	•	You can also get JavaFX bundled with certain custom JDKs, such as those provided by Azul Systems.

Summary of the Impact on JavaFX:

	•	JavaFX is no longer bundled with the JDK starting from Java 11.
	•	JavaFX is now maintained as an open-source project under OpenJFX, which is free to use under the GPL v2 with Classpath Exception license.
	•	If you use Oracle JDK with JavaFX in a commercial production environment, you will still need to comply with Oracle’s JDK subscription model for updates and support.
	•	You can use OpenJFX with OpenJDK or other third-party JDKs without the commercial licensing constraints from Oracle.

In short, JavaFX itself remains unaffected by the Oracle JDK licensing changes, but your choice of JDK (Oracle vs. OpenJDK or others) will determine whether you need to deal with Oracle’s licensing fees and updates.
