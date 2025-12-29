## 🧱 **Java 9 (Sept 2017)**

**Major themes:** modularity and platform evolution

* **Java Platform Module System (Project Jigsaw):** Modules with dependencies, `module-info.java` for strong encapsulation. ([Baeldung on Kotlin][2])
* **JShell REPL:** Interactive Java shell for quick experimentation. ([Medium][3])
* **Private methods in interfaces:** Encapsulate shared code for default/static methods. ([Medium][4])
* **Factory methods for collections:** `List.of()`, `Set.of()` for easy immutable instances. ([Medium][3])
* **Stream API enhancements:** `takeWhile()`, `dropWhile()`, `ofNullable()`, etc. ([Medium][4])
* **Improved Process API & HTTP Client (incubator):** Better OS process control and new HTTP client (later finalized). ([Baeldung on Kotlin][2])

👉 Overview: *New Features in Java 9* — Baeldung. ([Baeldung on Kotlin][2])

---

## 🔍 **Java 10 (Mar 2018)**

**Focus:** developer ergonomics

* **Local-variable type inference (`var`)** for local code (not at class level), reducing boilerplate. ([JavaTechOnline][5])
* Other quality-of-life enhancements in GC and class data sharing. ([JavaTechOnline][5])

---

## ☕ **Java 11 (Sept 2018)** *(first LTS after 8)*

**Library & syntax improvements:**

* **Standard HTTP client finalized.** ([Baeldung on Kotlin][6])
* **String API enhancements:** `isBlank()`, `lines()`, `strip()`, `repeat()`, etc. ([Baeldung on Kotlin][6])
* **Files API enhancements:** `Files.readString()`, `writeString()`. ([Baeldung on Kotlin][6])
* **Local-variable syntax in lambda params:** use `var` in lambdas. ([Baeldung on Kotlin][6])
* **Epsilon no-op GC**, removed modules (e.g., Nashorn). ([Baeldung on Kotlin][6])

👉 Summary: *New Features in Java 11* — Baeldung. ([Baeldung on Kotlin][6])

---

## 🔄 **Java 12 (Mar 2019)**

**Transitions to expressions & utilities:**

* **Switch expressions (preview):** use `switch` as an expression with `yield`. ([Oracle Docs][7])
* **String and Collections API methods** (like `indent`). ([Baeldung on Kotlin][8])
* JVM and G1 GC enhancements. ([Oracle Docs][7])

---

## 📜 **Java 13 (Sept 2019)**

* **Text Blocks (preview):** multiline string literal support. ([Wikipedia][1])
* Other small refinements; focus on easing code formatting. ([Wikipedia][1])

---

## 🧠 **Java 14 (Mar 2020)**

* **Switch expressions (standard).** ([Oracle Docs][7])
* **Helpful `NullPointerException`s** (NPE details). ([Oracle Docs][7])
* Preview features like Records + pattern matching. ([Oracle Docs][7])

---

## 🧬 **Java 15 (Sept 2020)**

* **Text Blocks (standard).** ([Oracle Docs][7])
* Sealed classes (preview). ([Oracle Docs][7])
* Other GC and API improvements. ([Oracle Docs][7])

---

## 📦 **Java 16 (Mar 2021)**

* **Records (standard):** compact data classes. ([Oracle Docs][7])
* **Pattern matching for `instanceof` (standard).** ([Oracle Docs][7])
* JDK packaging tool `jpackage`. ([Oracle Docs][7])

---

## 🔐 **Java 17 (Sept 2021)** *(LTS)*

* **Sealed classes (standard):** tighter inheritance control. ([Baeldung on Kotlin][9])
* Strengthened encapsulation, performance tweaks. ([Baeldung on Kotlin][9])

---

## 🌐 **Java 18 (Mar 2022)**

* **UTF-8 default charset:** consistent cross-platform encoding. ([Medium][10])
* `@snippet` in Javadoc for code samples and minor utilities. ([Medium][10])

---

## 🚀 **Java 19 (Sept 2022)**

* **Virtual Threads (preview)** — lightweight threads (Project Loom). ([HappyCoders.eu][11])
* **Record Patterns (preview).** ([HappyCoders.eu][11])
* **Foreign Function & Memory API (preview)** — native interop (Project Panama). ([HappyCoders.eu][11])
* Structured concurrency incubator. ([HappyCoders.eu][11])

---

## 🪶 **Java 20 (Mar 2023)**

* **Scoped Values (incubator).** ([HappyCoders.eu][12])
* Refined **Record Patterns**, **Pattern Matching for switch** in preview. ([HappyCoders.eu][12])
* Continued preview of Virtual Threads, FFM API, Structured Concurrency. ([HappyCoders.eu][12])
* Minor deprecations and JVM refinements. ([HappyCoders.eu][12])

---

## 📈 **Java 21 (Sept 2023)** *(LTS)*

**Major updates:**

* **Virtual Threads finalized (Project Loom).** ([HappyCoders.eu][13])
* **Record Patterns & Pattern Matching for switch finalized.** ([HappyCoders.eu][13])
* **Sequenced Collections:** easier stable iteration access. ([HappyCoders.eu][13])
* Additional API methods and preview features (String Templates, unnamed patterns). ([HappyCoders.eu][13])

---

## 🔢 **Java 22 (Mar 2024)**

* **Unnamed Variables & Patterns (standard).** ([marcobehler.com][14])
* **Foreign Function & Memory API (standard).** ([Wikipedia][15])
* Other incubator/preview enhancements like Stream Gatherers. ([Wikipedia][15])

---

## 📑 **Java 23 (Sept 2024)**

* **Markdown in Javadoc** (new doc support). ([Scribd][16])
* Other patterns and preview feature refinements (e.g., primitive type patterns). ([Scribd][16])

---

## 📅 **Java 24 (Mar 2025)**

* **Simple Source Files & Instance Main Methods.** ([Scribd][16])
* Additional refinements in preview features. ([Scribd][16])
* JVM/source tooling improvements. ([Wikipedia][15])

---

## 🏁 **Java 25 (Sept 2025)** *(LTS)*

**Notable finalized features:**

* **Scoped Values finalized (JEP 506).** ([HappyCoders.eu][17])
* **Module Import Declarations (JEP 511).** ([HappyCoders.eu][17])
* **Compact Source Files & Instance Main Methods (JEP 512).** ([HappyCoders.eu][17])
* **Flexible Constructor Bodies (JEP 513).** ([HappyCoders.eu][17])
* **Compact Object Headers & GC improvements.** ([HappyCoders.eu][17])
* Several preview features (e.g., primitive types in patterns). ([HappyCoders.eu][17])

---

## 🧠 Summary Table (Language Focus)

| Version | Key Language Features                     |
| ------- | ----------------------------------------- |
| 9       | Modules, JShell                           |
| 10      | `var`                                     |
| 11      | Lambda var in params                      |
| 14      | Switch Expr                               |
| 15      | Text Blocks                               |
| 16      | Records, Pattern matching instanceof      |
| 17      | Sealed classes                            |
| 19      | Preview: Virtual Threads, Record Patterns |
| 20      | Refined previews                          |
| 21      | Finalized Virtual Threads, Patterns       |
| 22      | Unnamed Variables & Patterns              |
| 24      | Simple Source Files                       |
| 25      | Compact Source Files, Module Import       |

*(Language summary from Oracle’s Language Changes Summary)* ([Oracle Docs][7])

---

## 📌 More In-Depth Resources

Here are **great comprehensive resources** that track features across releases:

* **Oracle’s official “Java Language Changes Summary”** — authoritative tables of language features since Java 9. ([Oracle Docs][7])
* **Marco Behler’s Java versions & features guide** — good high-level list per release. ([marcobehler.com][14])
* **HappyCoders feature pages** — detailed with examples per Java version. ([HappyCoders.eu][18])
* **Wikipedia — Java version history** — release dates and feature lists. ([Wikipedia][1])

---

If you want, I can also generate **download links and JEP numbers for each feature**, or a **PDF/cheat sheet summarizing them all**!

[1]: https://en.wikipedia.org/wiki/Java_version_history?utm_source=chatgpt.com "Java version history"
[2]: https://www.baeldung.com/new-java-9?utm_source=chatgpt.com "New Features in Java 9"
[3]: https://medium.com/%40techie_arbaaz/main-java-versions-and-their-key-features-from-9-to-21-977ac97e9f18?utm_source=chatgpt.com "Main Java Versions and Their Key Features from 9 to 21"
[4]: https://medium.com/%40vijayaneraye/important-features-java-9-java-10-java-11-java-12-java13-java-14-java-15-java-16-java-17-650420ee7337?utm_source=chatgpt.com "Important Features — Java 9, Java 10, Java 11, Java 12 ..."
[5]: https://javatechonline.com/java-features-after-java-8/?utm_source=chatgpt.com "Java Features After Java 8"
[6]: https://www.baeldung.com/java-11-new-features?utm_source=chatgpt.com "New Features in Java 11"
[7]: https://docs.oracle.com/en/java/javase/24/language/java-language-changes-summary.html?utm_source=chatgpt.com "1 Java Language Changes Summary"
[8]: https://www.baeldung.com/java-12-new-features?utm_source=chatgpt.com "New Features in Java 12"
[9]: https://www.baeldung.com/java-17-new-features?utm_source=chatgpt.com "New Features in Java 17"
[10]: https://medium.com/%40vijayaneraye/important-features-java-18-java-19-java-20-java-21-java-23-and-java-22-742d1527da7b?utm_source=chatgpt.com "Important Features — Java 18, Java 19, Java 20, Java 21 ..."
[11]: https://www.happycoders.eu/java/java-19-features/?utm_source=chatgpt.com "Java 19 Features (with Examples)"
[12]: https://www.happycoders.eu/java/java-20-features/?utm_source=chatgpt.com "Java 20 Features (with Examples)"
[13]: https://www.happycoders.eu/java/java-21-features/?utm_source=chatgpt.com "Java 21 Features (with Examples)"
[14]: https://www.marcobehler.com/guides/a-guide-to-java-versions-and-features?utm_source=chatgpt.com "Java Versions and Features"
[15]: https://zh.wikipedia.org/wiki/Java%E7%89%88%E6%9C%AC%E6%AD%B7%E5%8F%B2?utm_source=chatgpt.com "Java版本歷史"
[16]: https://www.scribd.com/document/914801569/Java-Versions-Cheat-Sheet-Happycoders-eu-v24-0?utm_source=chatgpt.com "Java Versions Cheat Sheet Happycoders - Eu v24.0"
[17]: https://www.happycoders.eu/java/java-25-features/?utm_source=chatgpt.com "Java 25 Features (with Examples)"
[18]: https://www.happycoders.eu/java/?utm_source=chatgpt.com "Java - Updates, How-Tos, and Tutorials"
