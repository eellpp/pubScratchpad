
Consider the feature set of JavaFX when used in combination with the AtlantaFX theme/widget pack. It isn't well known, but is maintained and has an active open source community today.
- All the same controls as mui.com shows and more advanced ones too, like a rich text editor, a way more advanced table view, tree views, table tree views, etc.
- Media and video support.
- 3D scene graph support. HTML doesn't have this! If you want to toss some 3D meshes into your UI you have to dive into OpenGL programming.
- When using FXML, semantic markup (<TabView> etc)
- Straightforward layout management.
- A dialect of CSS2.something for styling, a TextFlow widget for styling and flowing rich text.
- Fully reactive properties and collections, Svelte style (or moreso).
- Icon fonts and SVG works.
- Sophisticated animations and timelines API.
And so on. It's also cross platform on desktop and mobile, and can run in a web browser (see https://jpro.one where the entire website is a javafx app), and can be accessed from many different languages.
Flutter is actually not quite as featureful in comparison, for example there's no WebView control or multi-window support on desktop, though Flutter has other advantages like the hot reload feature, better supported mobile story. The community is lovely too.
Then you have AppKit, which is also very feature rich.
So it's definitely a task that people have done. Many of these toolkits have features HTML doesn't even try to have. The main thing they lack is that, well, they aren't the web. People often find out about apps using hypertext and being able to have a single space for documents and apps is convenient. When you're not heavily reliant on low friction discovery though, or have alternatives like the app stores, then web-beating UI toolkits aren't that big of a lift in comparison.

Electron isn't to blame for the issues with Teams. VS Code pretty much proves you can create a relatively responsive application in a browser interface
Electron is great, but most apps aren't VS Code. On my 2019 Intel MacBook Terminal.app starts in <1 second and WhatsApp starts in about 7 seconds. Electron is Chrome and Chrome's architecture is very specifically designed for being a web browser. The multi-process aspect of Chrome is for example not a huge help for Electron where the whole app is trusted anyway, though because HTML is so easy to write insecurely, sandboxing that part of it can still be helpful even with apps that don't display untrusted data. That yields a lot of overhead especially on Windows where processes are expensive.

---
I think the best way to get started would be to download the sampler application from https://github.com/mkpaz/atlantafx. That is state of the art, good implementation. You can play around with it and jump to the source code to see how it is implemented. It contains almost everything an application needs.
Also depending how old your general Java knowledge is, the modern way of creating applications is through the module system and the jlink/jpackage tools. There are many outdated solutions for application packaging out there as well. If anything you see is using the classpath, builds jars or fat jars, or is using external tools outside the JDK, it's probably old and no longer appropriate.

https://docs.oracle.com/en/java/javase/17/docs/specs/man/jpackage.html

---
JavaFX and Compose for Desktop are the ones I know best. They can be used from high level and popular languages. JavaFX is particularly good for desktop apps and can be compiled down to purely native code that starts as fast as an app written in C++ (likewise for Compose but the experiments with that are newer).
There are some downsides: fewer people know them than with HTML. There are a few tweaks like window styles on macOS it could use to be more modern. On the other hand, it's easy to learn and you benefit from a proper reactively bindable widget library, like table and tree views if you need those. For developer tools such widgets can be useful.

There's a modern theme for JavaFX here:  
https://github.com/mkpaz/atlantafx

CfD uses Material Design of course, but you can customize it.
Having written desktop apps of varying complexity in all these frameworks, I can't say Electron is clearly superior. It is in some cases (e.g. if I was wanting to write a video conferencing app then it makes sense to re-use Google's investment into Hangouts/Meet for that), but it's also worse in some cases. For instance the multi-process model constantly gets in the way, but you can't disable it as otherwise XSS turns into RCE.

---
JVM UI isn't so bad. I've written some pretty modern looking UI with it. The sophisticated controls are all there.  
Modern JavaFX theme: https://github.com/mkpaz/atlantafx  
Modern Swing theme: https://github.com/JFormDesigner/FlatLaf  
And these days Compose Multiplatform: https://www.jetbrains.com/lp/compose-multiplatform/  
I tend to use Kotlin rather than Java but of course Java is perfectly fine too. You can also use Clojure.  
If you use any of those frameworks you can distribute to Win/Mac/Linux in one command with Conveyor. It's free for open source apps and can do self-signing for Windows if you don't want to pay for the certificates or the Store (but the Store is super cheap these days, $19 one off payment for an individual). Also supports Electron and Flutter if you want to use those.
From those frameworks you can then access whatever parts of the Windows API you want. Flutter even has WinRT bindings these days! So it's not quite so bad.  


