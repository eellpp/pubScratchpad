The process for getting a new feature into the Java SDK involves several formal steps that ensure community review, standardization, and quality. Historically, many features have been introduced via the **Java Specification Request (JSR)** process, while more recent changes often follow the **JDK Enhancement Proposal (JEP)** route. Here’s an overview that combines these approaches:


```mermaid
flowchart TD
    A[Feature Request / Idea]
    B[Draft Proposal (JSR/JEP)]
    C[Formation of Expert/Working Group]
    D[Draft Specification & Design Document]
    E[Public Review & Feedback]
    F[Reference Implementation & TCK Development]
    G[Final Review & Approval]
    H[Integration into Codebase]
    I[Milestone/Beta Releases & Testing]
    J[Final Release in Java SDK]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J

```
---

### **1. Idea and Proposal**

- **Initial Request/Idea:**  
  A developer or group of developers identifies a need or an improvement for the Java platform. This idea is discussed informally within the community or with relevant stakeholders.

- **Drafting a Proposal:**  
  The idea is formalized into a document. For standardized APIs and technologies, this document becomes a **JSR proposal**; for changes directly related to the JDK (language features, VM improvements, etc.), a **JEP proposal** might be drafted.

---

### **2. Formation of a Working or Expert Group**

- **JSR Process:**  
  Once the proposal is submitted, the Java Community Process (JCP) may approve the formation of an Expert Group. This group, composed of community experts and interested parties, is responsible for developing the specification in detail.

- **JEP Process:**  
  In the JDK realm, a JEP is reviewed by the OpenJDK community. A champion (often a core developer) is assigned to shepherd the proposal through discussions and design reviews.

---

### **3. Specification and Design**

- **Draft Specification/Design Document:**  
  The Expert Group (or the JEP champion in the JDK process) prepares a detailed specification. This document outlines:
  - The rationale behind the feature.
  - Detailed design and API contracts.
  - Impact analysis on existing components.

- **Public Review:**  
  The draft specification is published for public review. Feedback is collected from the broader Java community, which may lead to revisions and refinements.

---

### **4. Reference Implementation and Testing**

- **Building a Reference Implementation (RI):**  
  To demonstrate that the specification is implementable, the Expert Group (or the proposing team) creates an RI. In parallel, a **Technology Compatibility Kit (TCK)** is developed to ensure that any compliant implementation meets the specification.

- **Integration with Test Suites:**  
  Extensive testing is performed to validate both the RI and the specification. This phase helps identify any issues early and ensures the new feature will work reliably within the Java ecosystem.

---

### **5. Final Review and Approval**

- **JSR Approval:**  
  For JSRs, after revisions and successful testing, the final draft specification is submitted to the JCP Executive Committee. The committee votes on the specification, and upon approval, the JSR becomes an official part of the Java platform standard.

- **JEP Finalization:**  
  For JDK-related changes, once the proposal has been refined and tested through experimental and milestone builds, it undergoes a final review by the OpenJDK community. Approval by the relevant maintainers is required before merging the changes.

---

### **6. Integration into the Java SDK**

- **Merging into the Codebase:**  
  The approved feature (whether from a JSR or a JEP) is then integrated into the OpenJDK codebase. It goes through the regular development cycle, which includes additional code reviews and integration tests.

- **Milestone and Beta Releases:**  
  The feature is included in milestone or early-access builds. These builds are distributed to developers for further testing in real-world scenarios, ensuring that any remaining issues are caught before the final release.

- **Final Release:**  
  Once the feature has proven stable through these iterative testing cycles, it is included in the final release of the Java SDK (Java SE). This release is then adopted by developers worldwide.

---

### **Summary**

- **Idea → Proposal:** An idea is formalized into a JSR or JEP.
- **Expert/Working Group Formation:** A group is formed to develop the specification.
- **Drafting and Public Review:** Detailed specifications are drafted and publicly reviewed.
- **Reference Implementation and TCK:** An RI and testing frameworks are created to validate the proposal.
- **Approval:** The specification is approved by the JCP or OpenJDK community.
- **Integration and Release:** The feature is merged into the codebase, undergoes further testing, and finally becomes part of the official Java SDK release.

This structured process ensures that any new feature is well-thought-out, rigorously reviewed, and thoroughly tested before it becomes part of the Java platform, maintaining the high standards of reliability and interoperability that Java is known for.
