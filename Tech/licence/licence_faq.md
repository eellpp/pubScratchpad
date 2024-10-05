### If I use a Java library that has GPL v3, am I required to make the app open sourced?

Yes, if you use a Java library that is licensed under GPL v3 (GNU General Public License version 3), you are required to comply with the terms of the GPL v3 license, which generally includes making your application open-source under the same license (GPL v3) if you distribute it.

Here’s a breakdown of what this means:

1. GPL v3 and Copyleft

	•	GPL v3 is a strong copyleft license. This means that any derivative work or software that includes or links to a GPL v3-licensed library must also be released under GPL v3 if distributed.
	•	You are required to provide source code of your application under GPL v3 if you distribute the application (whether it’s distributed publicly or privately to others). This applies to both the library and your entire application, meaning anyone receiving your software can modify and redistribute it under the same license.

2. Key Obligations under GPL v3:

	•	Distribution: If you distribute the software (including internally in a company or to external users), you must provide the source code and allow others to modify and redistribute it under the same terms.
	•	Derived Works: If your application links to or includes a GPL v3 library, it is considered a derivative work, and the entire application must be licensed under GPL v3 if it is distributed.
	•	Modifications: Any changes you make to the GPL v3 library must also be open-sourced and provided under the same license.

3. What If You Don’t Distribute the Application?

	•	If you do not distribute the application and keep it for personal use or internal use within your organization (with no distribution outside), you are not required to release the source code. The GPL v3 license’s copyleft obligations only apply if you distribute the software to others.

4. Dynamic Linking and GPL v3

	•	Some developers try to avoid GPL v3 obligations by dynamically linking to a GPL v3 library instead of statically linking it. However, the FSF (Free Software Foundation) considers both static and dynamic linking to GPL-licensed code as creating a derivative work, meaning it still triggers the copyleft requirement if you distribute the application.

5. GPL-Compatible Licenses

	•	If you combine a GPL v3 library with other libraries in your app, the entire work must be compatible with GPL v3. You cannot combine it with non-GPL-compatible licenses (like proprietary licenses) unless those components are independently separable and do not form a single combined program.

6. Exceptions or Alternatives (GPL v3 with Classpath Exception)

	•	Some GPL licenses, such as GPL v2 with Classpath Exception (used by OpenJDK), explicitly allow linking to the library without imposing GPL obligations on the rest of the application. However, GPL v3 does not have such exceptions unless explicitly stated by the author of the library. If you are using a library with GPL v3 with an exception clause, it may allow you to link to it without making your application open-source.

Summary:

	•	Yes, if you use a GPL v3-licensed library in your app and you distribute that app, you will be required to release your entire application under the GPL v3 license and make it open-source.
	•	If you only use the app for personal use or internal use without distribution, you are not required to open-source it.
	•	Be cautious of the distinction between GPL v3 and other GPL variants, such as GPL v2 with the Classpath Exception, which might allow more flexibility.

If you don’t want to open-source your app, you would need to either avoid using GPL v3 libraries or find libraries under a more permissive license like MIT, Apache 2.0, or GPL v2 with Classpath Exception.
