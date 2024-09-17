
## Package by feature, Layer and others 

http://www.javapractices.com/topic/TopicAction.do?Id=205
#### package by feature
Package-by-feature uses packages to reflect the feature set. It tries to place all items related to a single feature (and only that feature) into a single directory/package. This results in packages with high cohesion and high modularity, and with minimal coupling between packages. Items that work closely together are placed next to each other. They aren't spread out all over the application. It's

For example, a drug prescription application might have these packages:

- com.app.doctor
- com.app.drug
- com.app.patient and so on...

Each package usually contains only the items related to that particular feature, and no other feature. For example, the com.app.doctor package might contain these items:
- DoctorController.java - an action or controller object
- Doctor.java - a Model Object
- DoctorDAO.java - Data Access Object

### package by layer
The competing package-by-layer style is different. In package-by-layer, the highest level packages reflect the various application "layers", instead of features, as in:
- com.app.action
- com.app.model
- com.app.dao
- com.app.util
Here, each feature has its implementation spread out over multiple directories, over what might be loosely called "implementation categories". Each directory contains items that usually aren't closely related to each other. This results in packages with low cohesion and low modularity, with high coupling between packages.

## Principles of OOD - Packages
http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod

A package is a binary deliverable like a .jar file, or a dll as opposed to a namespace like a java package or a C++ namespace.

The first three package principles are about package cohesion, they tell us what to put inside packages:

1) REP	The Release Reuse Equivalency Principle	The granule of reuse is the granule of release.
2) CCP	The Common Closure Principle	Classes that change together are packaged together.
3) CRP	The Common Reuse Principle	Classes that are used together are packaged together.

The last three principles are about the couplings between packages, and talk about metrics that evaluate the package structure of a system.

4) ADP	The Acyclic Dependencies Principle	The dependency graph of packages must have no cycles.
5) SDP	The Stable Dependencies Principle	Depend in the direction of stability.
6) SAP	The Stable Abstractions Principle	Abstractness increases with stability

#### Example of putting classes that are used together in same package
For example, your Logging utility classes are not necessarily used together with your file io classes. So package all logging them separately. But logging classes could be related to one another. So create a sort of complete product for logging, say, for the want of better name commons-logging package it in a (re)usable jar and another separate complete product for io utilities, again for the want of better name, say commons-io.jar. 

Now, let's say you wanted your logging utility classes to support structured logging for say some sort of log analysis by tools like splunk. Some clients of your logging utility may want to update to your newer version; some others may not. So when you release a new version, package all classes which are needed and reused together for migration. So some clients of your utility classes can safely delete your old commons-logging jar and move to commons-logging-new jar. Some other clients are still ok with older jar. However no clients are needed to have both these jars (new and old) just because you forced them to use some classes for older packaged jar.

