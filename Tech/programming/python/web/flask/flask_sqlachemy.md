

https://github.com/edkrueger/sars-flask  

SQLAlchemy is a Python SQL toolkit and Object Relational Mapper (ORM) that allows app developers to use SQL for smooth and fault-tolerant transactional database operations. The ORM translates Python classes to tables for relational databases and automatically converts Pythonic SQLAlchemy Expression Language to SQL statements. This conversion allows developers to write SQL queries with Python syntax. SQLAlchemy also abstracts database connections and provides connection maintenance automatically. 


Flask-SQLAlchemy is an extension for Flask that aims to simplify using SQLAlchemy with Flask by providing defaults and helpers to accomplish common tasks.  

### Using Flask and SqlAlchemy instead of the another layer of extension
Flask-SQLAlchemy has its own API. This adds complexity by having its different methods for ORM queries and models separate from the SQLAlchemy API.

Another disadvantage is that Flask-SQLAlchemy makes using the database outside of a Flask context difficult. This is because, with Flask-SQLAlchemy, the database connection, models, and app are all located within the app.py file. Having models within the app file, we have limited ability to interact with the database outside of the app. This makes loading data outside of your app difficult. Additionally, this makes it hard to retrieve data outside of the Flask context.

Flask and SQLAlchemy work well together if used correctly. Therefore, you don’t have to hybridize Flask and SQLAlchemy into Flask-SQLalchemy!

https://towardsdatascience.com/use-flask-and-sqlalchemy-not-flask-sqlalchemy-5a64fafe22a4  

### SqlAlchemy Sessions
https://docs.sqlalchemy.org/en/13/orm/session_basics.html#session-faq-whentocreate  

A Session is typically constructed at the beginning of a logical operation where database access is potentially anticipated.  

The Session, whenever it is used to talk to the database, begins a database transaction as soon as it starts communicating. Assuming the autocommit flag is left at its recommended default of False, this transaction remains in progress until the Session is rolled back, committed, or closed. The Session will begin a new transaction if it is used again, subsequent to the previous transaction ending; from this it follows that the Session is capable of having a lifespan across many transactions, though only one at a time. We refer to these two concepts as transaction scope and session scope.  

The Session is very much intended to be used in a non-concurrent fashion, which usually means in only one thread at a time.  


SqlAlchemy Sessions in Web Apps  
Integrating web applications with the Session is then the straightforward task of linking the scope of the Session to that of the request. The Session can be established as the request begins, or using a lazy initialization pattern which establishes one as soon as it is needed. The request then proceeds, with some system in place where application logic can access the current Session in a manner associated with how the actual request object is accessed. As the request ends, the Session is torn down as well, usually through the usage of event hooks provided by the web framework. The transaction used by the Session may also be committed at this point, or alternatively the application may opt for an explicit commit pattern, only committing for those requests where one is warranted, but still always tearing down the Session unconditionally at the end.

```bash 
# query from a class
session.query(User).filter_by(name='ed').all()

user1 = User(name='user1')
user2 = User(name='user2')
session.add(user1)
session.add(user2)
session.commit()

session.add_all([item1, item2, item3])  

# mark two objects to be deleted
session.delete(obj1)
session.delete(obj2)
# commit (or flush)
session.commit()


session.query(User).filter(User.id==7).delete()

```
