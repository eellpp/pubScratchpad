### Configuration
```java
@Configuration
@ComponentScan("org.baeldung.jdbc")
public class SpringJdbcConfig {
    @Bean
    public DataSource mysqlDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/springjdbc");
        dataSource.setUsername("guest_user");
        dataSource.setPassword("guest_password");
 
        return dataSource;
    }
}

JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
```
### Querying
```java
int result = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM EMPLOYEE", Integer.class);
jdbcTemplate.update("INSERT INTO EMPLOYEE VALUES (?, ?, ?, ?)", 5, "Bill", "Gates", "USA");
```
### Mapping results to java object
```java
public class EmployeeRowMapper implements RowMapper<Employee> {
    @Override
    public Employee mapRow(ResultSet rs, int rowNum) throws SQLException {
        Employee employee = new Employee();
 
        employee.setId(rs.getInt("ID"));
        employee.setFirstName(rs.getString("FIRST_NAME"));
        employee.setLastName(rs.getString("LAST_NAME"));
        employee.setAddress(rs.getString("ADDRESS"));
 
        return employee;
    }
}

String query = "SELECT * FROM EMPLOYEE WHERE ID = ?";
List<Employee> employees = jdbcTemplate.queryForObject(query, new Object[] { id }, new EmployeeRowMapper());
```

### Using the Row Callback handler to process results in batches
```java
JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

jdbcTempate.setFetchSize(1000);

jdbcTemplate.query("select first_name from customer", new RowCallbackHandler() {
      public void processRow(ResultSet resultSet) throws SQLException {
        while (resultSet.next()) {
          // send email to resultSet.getString(1)
        }
      }
    });
 ```
