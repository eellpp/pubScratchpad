In the employee,department,salary table.  

### Show max salary in each group
```bash
select department,
       max ( salary )
from   co.orders
group  by department;

```

### Show top 3 employees in each deparment
```bash
select employee,department,salary 
from (select employee,department,salary ,
             row_number() over (partition by department order by salary desc) as seqnum
      from salary table
     ) t

group by employee,department,salary 
where seqnum <= 3;
```
