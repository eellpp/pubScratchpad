
### SQL Injection protection
If you pass in raw SQL with values interpolated, SQL Alchemy will not sanitise it.  

You are better off starting with SQLAlchemy’s ORM for most things and only writing SQL by hand for the more complex cases or where there are big efficiency gains to be had.,Never ever use any form of string interpolation, format strings, or string concatenation, when dealing with SQL queries, unless you know exactly what you are doing  


Bad way (Sql Injectable):
```bash
Session.execute("select * form users where name = %s" % request.GET['name'])
```
Good way (Not Sql Injectable):
```bash
Session.execute(model.users.__table__.select().where(model.users.name == request.GET
```

https://newbedev.com/sqlalchemy-sql-injection  

filter   - uses _literal_as_text (NOT SAFE)  
having   - uses _literal_as_text (NOT SAFE)  
  
distinct - uses _literal_as_label_reference (NOT SAFE)  
group_by - uses _literal_as_label_reference (NOT SAFE)  
order_by - uses _literal_as_label_reference (NOT SAFE)  

Examples of exploits:  
```bash
db.session.query(User.login).group_by('login').having('count(id) > 4; select name from roles').all()
db.session.query(User.login).distinct('name) name from roles /*').order_by('*/').all()
db.session.query(User.login).order_by('users_login; select name from roles').all()
db.session.query(User.login).group_by('login union select name from roles').all()
```


