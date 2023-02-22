It has spring underneath. 

Has autoconfiguration. 

Has @annotations based configurations (Spring by itself has xml based configs). Springboot simplifies  

Spring Uses Inversion of Control (IOC)
- instead of program flow being decided by programmer, it is decided by the framework 


Spring bean is an instance of class managed by spring container

Spring container is the core of spring framework that
- manages all the beans required by spring
- performes dependency injection. Instantiates and Injects these beans wherever required. 

Whenever we add annotations like @Service etc over a class, spring will create a bean with the name of the class   

Some of the annotations like @Repository is internally also have their class annotated by @Service etc and which are spring beans themself.  

By adding these annotations, we are asking spring to manage the class.  


Spring Boot does component scan to scan for components in all the nested packages from where @SpringBootApplication is declared. 


