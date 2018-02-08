

Create a demo project and public to github

http://www.technicalkeeda.com/spring-tutorials/spring-4-jdbctemplate-annotation-example

### Increasing the JVM Heap size
The first option in handling large number of rows is to increase the JVM heap. 

-Xmx

Find out the default heap size
- java -XX:+PrintFlagsFinal -version | grep HeapSize

Often its default value is 1/4th of your physical memory or 1GB (whichever is smaller).


### Using setFetchSize for fetching large number of rows

Most of the JDBC drivers’ default fetch size is 10. In normal JDBC programming if you want to retrieve 1000 rows it requires 100 network round trips between your application and database server to transfer all data. Definitely this will impact your application response time. The reason is JDBC drivers are designed to fetch small number of rows from database to avoid any out of memory issues. For example if your query retrieves 1 million rows, the JVM heap memory may not be good enough to hold that large amount of data hence JDBC drivers are designed to retrieve small number (10 rows) of rows at a time that way it can support any number of rows as long as you have better design to handle large row set at your application coding. If you configure fetch size as 100, number of network trips to database will become 10. This will dramatically improve performance of your application.

By default, when Oracle JDBC executes a query, it receives the result set 10 rows at a time from the database cursor. 

Fetch size is also used in a result set. When the statement object executes a query, the fetch size of the statement object is passed to the result set object produced by the query. However, you can also set the fetch size in the result set object to override the statement fetch size that was passed to it. 

### Dynamically changing the fetchsize inside the rowmapper
```java
public T mapRow(ResultSet rs, int index) {
    T dto = null;

    if (index == 0) {
        setFetchSize(rs, 50);
    } else if (index == 50) {
        setFetchSize(rs, 500);
    } else if (index == 1000) {
        setFetchSize(rs, 1000);
    }

    try {
        dto = mapRowToDto(rs, index);
    } catch (SQLException e) {
        throw new RuntimeException(e.getMessage(), e);
    }

    return dto;
}
```
### RowCallbackHandler vs RowMapper

`RowCallbackHandler` 
This is an interface with the method 
```java
void processRow(java.sql.ResultSet rs)throws java.sql.SQLException
```
Note that it returns void. It is left to the implementation to extract value out of row.

> Implementations must implement this method to process each row of data in the ResultSet. This method should not call next() on the ResultSet; it is only supposed to extract values of the current row. Exactly what the implementation chooses to do is up to it: A trivial implementation might simply count rows, while another implementation might build an XML document.

`RowMapper`
This interface has the method

```java
T mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException
```
Note that it returns object of type T
> Implementations must implement this method to map each row of data in the ResultSet. This method should not call next() on the ResultSet; it is only supposed to map values of the current row.

### Fetching big data
The Oracle JDBC driver has proper support for the setFetchSize() method on java.sql.Statement, which allows you to control how many rows the driver will fetch in one go.

However, RowMapper as used by Spring works by reading each row into memory, getting the RowMapper to translate it into an object, and storing each row's object in one big list. If your result set is huge, then this list will get big, regardless of how JDBC fetches the row data.

If you need to handle large result sets, then RowMapper isn't scaleable. You might consider using RowCallbackHandler instead, along with the corresponding methods on JdbcTemplate. RowCallbackHandler doesn't dictate how the results are stored, leaving it up to you to store them.

```java
final int[] bigArray = new int[8];
public void readMillionsOfRows() {
    String sql= "SELECT col1,col2 from MY_BIG_TABLE";
    jdbc().query(sql, new RowCallbackHandler(){
        public void processRow(ResultSet rs) throws SQLException {
            int index = rs.getInt("COL1");
            int value = rs.getInt("COL2");
          
            bigArray[index] = value;
            
        }
        
    });
}
```

### Serializing and compressing objects in big hash map

If you want to compress instances of MyObject you could have it implement Serializable and then stream the objects into a compressed byte array, like so:
```java
ByteArrayOutputStream baos = new ByteArrayOutputStream();
GZIPOutputStream gzipOut = new GZIPOutputStream(baos);
ObjectOutputStream objectOut = new ObjectOutputStream(gzipOut);
objectOut.writeObject(myObj1);
objectOut.writeObject(myObj2);
objectOut.close();
byte[] bytes = baos.toByteArray();
Then to uncompress your byte[] back into the objects:

ByteArrayInputStream bais = new ByteArrayInputStream(bytes);
GZIPInputStream gzipIn = new GZIPInputStream(bais);
ObjectInputStream objectIn = new ObjectInputStream(gzipIn);
MyObject myObj1 = (MyObject) objectIn.readObject();
MyObject myObj2 = (MyObject) objectIn.readObject();
objectIn.close();
```

### Using Trove for optimized hash map

The Trove library has optimized HashMap and HashSet classes for primitives
 
