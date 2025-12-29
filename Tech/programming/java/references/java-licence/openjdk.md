The licensing changes apply specifically to the Oracle JDK (Java Development Kit), which includes the JRE (Java Runtime Environment) as part of the package. Here’s how it breaks down:

1. JDK vs. JRE

	•	JDK (Java Development Kit): Includes development tools like the compiler (javac), debugger, libraries, and other components needed for both developing and running Java applications. It also includes the JRE.
	•	JRE (Java Runtime Environment): A subset of the JDK that includes only the libraries and tools needed to run Java applications but does not include development tools. It consists mainly of the Java Virtual Machine (JVM) and the standard class libraries.

2. Licensing Change Impact on JRE

In the past, you could download and use the Oracle JRE separately without concern for licensing for both commercial and personal use. However, with Oracle’s licensing changes that started with Java 11:

	•	Oracle no longer provides a standalone JRE download for Java 11 and later versions. Oracle JDK now includes the JRE, and the licensing model applies to the entire JDK package.
	•	Oracle JDK is now subject to the paid subscription model for commercial use, including the JRE that is bundled with it.

This means if you are using Oracle JRE (starting from Java 11), you need to follow the same licensing terms that apply to the Oracle JDK:

	•	For development, the Oracle JDK (and the JRE included in it) is free to use.
	•	For production or commercial use, it requires a paid subscription for receiving updates beyond the initial period (unless using versions under the newer NFTC licensing like Java 17).

3. OpenJDK and JRE Alternatives

If you need only a JRE and do not want to deal with Oracle’s subscription model, you have some alternatives:

	•	OpenJDK distributions from other vendors like Amazon Corretto, Azul Zulu, or AdoptOpenJDK provide a freely usable JRE and JDK under the GPL v2 with Classpath Exception license. These are often used for production environments in place of Oracle’s JDK.
	•	Some of these vendors also provide prebuilt JRE distributions that can be used in production environments for free, often with long-term support (LTS).

In Summary:

	•	Oracle no longer provides a standalone JRE from Java 11 onward, and the licensing changes for the Oracle JDK (which includes the JRE) are what apply.
	•	If you’re using the Oracle JDK/JRE for commercial production purposes, you need to subscribe for ongoing support and updates beyond the free period.
	•	OpenJDK-based JREs provide a free, long-term support alternative for production environments.
