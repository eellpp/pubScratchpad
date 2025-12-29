DAO is an abstraction of data persistence. 

Repository is an abstraction of a collection of objects.

DAO would be considered closer to the database, often table-centric. Repository would be considered closer to the Domain, dealing only in Aggregate Roots. A Repository could be implemented using DAO's, but you wouldn't do the opposite.
Also, a Repository is generally a narrower interface. It should be simply a collection of objects, with a Get(id), Find(ISpecification), Add(Entity). A method like Update is appropriate on a DAO, but not a Repository - when using a Repository, changes to entities would usually be tracked by separate UnitOfWork.


REPOSITORY a repository of a specific type of objects - it allows you to search for a specific type of objects as well as store them. Usually it will ONLY handle one type of objects. E.g. AppleRepository would allow you to do AppleRepository.findAll(criteria) or AppleRepository.save(juicyApple). Note that the Repository is using Domain Model terms (not DB terms - nothing related to how data is persisted anywhere).


A DAO is a class that locates data for you (it is mostly a finder, but it's commonly used to also store the data). The pattern doesn't restrict you to store data of the same type, thus you can easily have a DAO that locates/stores related objects.E.g. you can easily have UserDao that exposes methods like
```java
Collection<Permission> findPermissionsForUser(String userId)
User findUser(String userId)
Collection<User> findUsersForPermission(Permission permission)
```


