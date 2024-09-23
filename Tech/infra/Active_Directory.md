
## Security Policy 

**Active Directory (AD) security ** focuses on securing the core components of an organization's IT infrastructure through:

1. **Authentication and Authorization**: Ensuring only authorized users have access to network resources via centralized control.
2. **Least Privilege Access**: Users are given the minimum access necessary for their roles.
3. **Segregation of Duties**: Dividing critical tasks among different users to prevent abuse.
4. **Encryption and Secure Communications**: Protecting sensitive information during transmission.
5. **Monitoring and Auditing**: Tracking activities to detect anomalies and prevent security breaches.

These principles form the foundation of secure identity and access management within AD.

## Architectural Model
The **Active Directory (AD) architectural model** is based on a hierarchical structure that organizes **users, groups, and devices** within a network. It consists of:

1. **Domains**: Core units of organization, grouping objects (users, devices).
2. **Organizational Units (OUs)**: Subdivisions within a domain, used to delegate control and manage policies.
3. **Trees**: Grouping of domains that share a contiguous namespace.
4. **Forest**: A collection of trees that share a common schema and global catalog.
5. **Global Catalog**: A searchable index containing information from all domains.

AD supports centralized management, authentication, and authorization across an enterprise.

## Example of AD usage
Let’s take a fictitious small company called **TechSol Ltd** as an example to explain the **Active Directory (AD) architectural model**:

### 1. **Domain**: 
   - TechSol sets up a domain named **techsol.local** to manage all users and resources. It contains the user accounts, computers, printers, and other network resources.

### 2. **Organizational Units (OUs)**:
   - Within the **techsol.local** domain, they create OUs for different departments:
     - **HR**
     - **IT**
     - **Sales**
   - Each department’s users and resources are grouped in their respective OUs. OUs allow delegation of control (e.g., the HR manager controls HR accounts).

### 3. **Tree**:
   - If TechSol expands, they may add a new domain like **sales.techsol.local** for a new sales branch. This new domain, sharing the same namespace as **techsol.local**, forms a **tree** in the AD structure.

### 4. **Forest**:
   - If TechSol acquires another company, say **DesignPro Ltd**, they might integrate the **designpro.local** domain into their AD structure. Together, **techsol.local** and **designpro.local** domains form an **Active Directory forest**, where both domains share the same schema but can have different security policies.

### 5. **Global Catalog**:
   - A **global catalog** holds information about all objects in the **techsol.local** domain and the **designpro.local** domain, allowing users to quickly search for and access resources across the entire forest.

In this architecture, TechSol Ltd can centrally manage users, devices, security policies, and authentication, ensuring streamlined access control and security.

## Alternatives
There are several open-source alternatives to **Active Directory (AD)** that offer similar functionalities for identity and access management. Some of the most popular ones are:

1. **FreeIPA**: Provides centralized authentication, authorization, and account information for Linux/Unix environments.
2. **OpenLDAP**: A widely-used open-source LDAP directory service that can be combined with Kerberos for authentication.
3. **Samba**: Provides AD-compatible domain controller functionality for Windows clients in Linux/Unix environments.
4. **389 Directory Server**: Another LDAP server that offers similar functionality to AD.

Each has different features depending on the specific needs of your organization.
