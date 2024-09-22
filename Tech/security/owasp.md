The “OWASP Top 10” web application security risks defined in 2021 are given below:  
https://owasp.org/Top10/  

1) `Broken Access Control` 
2) `Cryptographic Failures`  
3) `Injection`: 94% of the applications were tested for some form of injection with a max incidence rate of 19%, an average incidence rate of 3.37%, and the 33 CWEs mapped into this category have the second most occurrences in applications with 274k occurrences. Cross-site Scripting is now part of this category in this edition.
4) `Insecure Design` is a new category for 2021, with a focus on risks related to design flaws. If we genuinely want to "move left" as an industry, we need more threat modeling, secure design patterns and principles, and reference architectures. An insecure design cannot be fixed by a perfect implementation as by definition, needed security controls were never created to defend against specific attacks.
5) `Security Misconfiguration`: 90% of applications were tested for some form of misconfiguration, with an average incidence rate of 4.5%, and over 208k occurrences of CWEs mapped to this risk category. With more shifts into highly configurable software, it's not surprising to see this category move up. 
6) `Vulnerable and Outdated Components`  
7) `Identification and Authentication Failures`  
8) `Software and Data Integrity Failures` is a new category for 2021, focusing on making assumptions related to software updates, critical data, and CI/CD pipelines without verifying integrity. One of the highest weighted impacts from Common Vulnerability and Exposures/Common Vulnerability Scoring System (CVE/CVSS) data mapped to the 10 CWEs in this category. A8:2017-Insecure Deserialization is now a part of this larger category.
9) `Security Logging and Monitoring Failures` 
10) `Server-Side Request Forgery` 

### Input Validation 
https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html  

### Output Encoding 
encode the input before output to the browser  
https://owasp.org/www-project-proactive-controls/v3/en/c4-encode-escape-data  

### General Issues  
Default installation of docker punching a hole through UFW. Causes it to bypass UFW firewall  
Elasticsearch until recently did not nudge you to set up a username or password by default. Available for public users  
Mongo for years defaulted to being open to the internet, with no authentication.  
