Oracle has made significant changes to the licensing and distribution of Java over the years, particularly with its Oracle JDK (Java Development Kit), which has led to confusion for many developers and organizations. Here’s an overview of the key changes in Oracle’s licensing policy for Java:

1. Pre-Java 8 (Before 2014)

Oracle’s Java SE (Standard Edition) was free to use under the Oracle Binary Code License (BCL) for both personal and commercial use, with certain restrictions. You could use Oracle JDK freely for development, testing, and running production workloads without the need for a commercial license.

2. Java 8 (2014 - 2019)

Java 8 was released under the same Oracle BCL license, and it remained free for all purposes (both commercial and non-commercial). However, Oracle’s support for Java 8 was originally planned to end in 2019, after which Oracle offered two options:

	•	Oracle JDK (commercial): Oracle JDK updates would require a paid subscription for commercial users if they wanted long-term updates and support.
	•	OpenJDK (open source): Oracle simultaneously started to contribute more to the OpenJDK project, which is the open-source version of the JDK. OpenJDK is licensed under the GPL v2 with Classpath Exception, making it free to use in production, but it lacks long-term support from Oracle.

This change introduced a dual-path system: one for Oracle’s commercially licensed JDK and one for the free and open-source OpenJDK.

3. Java 11 (2018 - present)

Starting with Java 11, Oracle introduced a significant change:

	•	Oracle JDK: Oracle JDK would now require a paid subscription for commercial use. Updates and security patches are only available to customers with a subscription to Oracle’s Java SE Subscription.
	•	OpenJDK: OpenJDK remains free and open-source, licensed under GPL v2 with Classpath Exception, but Oracle provides updates for only six months. After six months, you’d need to switch to the next version of OpenJDK or rely on other vendors that provide long-term support (LTS) for OpenJDK distributions (e.g., AdoptOpenJDK, Amazon Corretto, Azul Zulu, etc.).

Key Changes in Licensing with Java 11:

	•	Oracle JDK no longer has free commercial use beyond the six-month update window after a new version’s release.
	•	Oracle moved to a subscription model for ongoing support and updates for Oracle JDK in production environments.
	•	Non-commercial and personal use of Oracle JDK remains free for development, testing, and learning purposes.

4. Java 17 and Later (2021 - Present)

With Java 17, Oracle introduced some new changes and clarified their licensing structure:

	•	Oracle JDK would continue to follow a free-for-development model, but production use in commercial settings would require a subscription after the first 6 months of updates.
	•	Oracle began releasing LTS (Long-Term Support) versions every two years, with Java 17 being the most recent LTS version as of this writing. Production users who want Oracle’s LTS versions need to subscribe to Oracle’s paid support plans.
	•	OpenJDK continues to be free, and multiple vendors provide long-term support distributions, including Amazon Corretto, Azul, and Red Hat, for those who want free alternatives with long-term updates.

5. Oracle No-Fee Terms and Conditions (NFTC) - 2023

In 2023, Oracle introduced No-Fee Terms and Conditions (NFTC) for Oracle JDK. This new license allows free use of Oracle JDK for all users, including commercial and production use, as long as you are using a version that was released under the NFTC terms. The key highlights of NFTC are:

	•	Free for all use, including commercial, without any fees.
	•	Applies only to versions released under NFTC.
	•	The caveat is that you only get updates for the first year of release. After that, updates require a subscription.

This was an attempt by Oracle to simplify its licensing and provide more flexibility, but organizations still need to be aware that long-term support for critical security and performance updates still requires a paid subscription beyond the initial year for a given JDK version.

Conclusion

	•	Oracle JDK: Commercial use requires a subscription beyond the first six months of updates for each version (unless covered under specific free terms like the NFTC for certain versions).
	•	OpenJDK: Open-source and free, but updates are not supported by Oracle after six months, meaning you’ll need to rely on other vendors for LTS versions if needed.
	•	Organizations need to carefully evaluate their Java needs and decide whether Oracle’s paid support, or an alternative OpenJDK distribution, best suits their requirements.
