
A key aspect of the Google Cloud Platform (GCP) is its project-centered organization. All billing, permissions, resources and settings are grouped within a user-defined project which basically acts as a global namespace. This not only simplifies the interconnected mapping of the resources you use (storage, databases, instances, ...) but also access management from role-based permissions to actual ssh keys and security.  

### Best Practices for Enterprise customers
https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations


### Using Dev and Prod env

https://cloud.google.com/appengine/docs/standard/go/creating-separate-dev-environments

If you choose to create your microservices application by using only multiple services, you can create a single GCP project for each of your environments and name them accordingly, such as web-app-dev, web-app-qa, and web-app-prod.  

Alternatively, if you choose to create your microservices application by using multiple projects, you can achieve the same separation between environments, but you'll need to use more projects, such as web-app-dev, web-app-prod, user-service-dev, and user-service-prod. You will need to use code patterns to ensure that the dev projects only call other dev projects and the prod projects only call other prod projects.  

`Deploying in DEV, UAT and Production environment`  
The recommended way to isolate environments in Google Cloud Platform (and therefore also Firebase) is to create different projects for each environment.  
Store the environment related data (cloud storage bucket, Cloud SQL url etc) in a configuration file that is loaded by the application. If you use Java, I personnally use a properties file that is populated by Maven based on two profiles (dev and prod, dev being the default one).  
Another important point is to separate environments from the start. Once you've started assuming that both environments will live in the same application, a lot of your code will be developed based on that assumption and it will be harder to move back to two different projects.  

#### Project Naming
https://cloud.google.com/solutions/securing-rendering-workloads  
Each project has a universally unique project ID, which is a short string of lowercase letters, digits, and dashes. When you create a project, you specify your own project name. The project ID is based on this name, with numbers appended to make it globally unique. You can override the assigned project ID, but the name must be globally unique.  

Your project is also assigned a long, globally unique, random project number, which is automatically generated. Project IDs can be from 6 to 30 characters long, while project names can be from 4 to 30 characters long.  

After project creation, the project ID and project number stay the same, even if you change the project name.  

We recommend that you spend some time planning your project names for manageability. Properly named projects can sort correctly and reduce confusion.  

A typical project-naming convention might use the following pattern:  

[studio]-[project]-[role (rnd, dev, prod)]
A resulting file name might be, for example: mystudio-myproject-rnd.  

Recommendation: Define a project naming convention used by all your projects on GCP.  
