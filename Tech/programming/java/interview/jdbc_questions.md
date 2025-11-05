# Database



### How would you configure JdbcTemplate for database access

**What is `JdbcTemplate`?**  

`JdbcTemplate` is a core class in Spring’s JDBC module that simplifies database access.
It manages:

* Connection acquisition and release
* Statement creation and execution
* Exception translation to Spring’s `DataAccessException` hierarchy
* Parameter binding and result mapping


#### ⚙️ 2. Dependencies

For **Spring Boot + PostgreSQL**, include in `pom.xml`:

```xml
<dependencies>
    <!-- Spring Boot Starter JDBC -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <!-- PostgreSQL Driver -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
    </dependency>
</dependencies>
```

#### 🏗️ 3. Configuration Approaches

##### **A. Spring Boot (Recommended)**

Spring Boot auto-configures `JdbcTemplate` if it finds:

1. A `DataSource` bean
2. The `spring-boot-starter-jdbc` dependency

Just add database details in `application.properties` (or `application.yml`):

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/employees
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.datasource.driver-class-name=org.postgresql.Driver
```

Spring Boot will automatically:

* Create a `DataSource`
* Create a `JdbcTemplate` bean linked to that DataSource

Then inject and use it:

```java
@Repository
public class EmployeeRepository {

    private final JdbcTemplate jdbcTemplate;

    public EmployeeRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Employee> findAll() {
        return jdbcTemplate.query(
            "SELECT id, name, department FROM employees",
            (rs, rowNum) -> new Employee(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("department")
            )
        );
    }
}
```

---

##### **B. Manual Configuration (Non-Boot Spring)**

define the beans manually in a `@Configuration` class:

```java
@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl("jdbc:postgresql://localhost:5432/employees");
        dataSource.setUsername("postgres");
        dataSource.setPassword("postgres");
        return dataSource;
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
```

Then inject as usual:

```java
@Service
public class EmployeeService {
    private final JdbcTemplate jdbcTemplate;

    public EmployeeService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int countEmployees() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM employees", Integer.class);
    }
}
```

##### 🧠 4. Notes & Best Practices

*  **Prefer NamedParameterJdbcTemplate** for readability:

  ```java
  @Bean
  public NamedParameterJdbcTemplate namedParameterJdbcTemplate(DataSource ds) {
      return new NamedParameterJdbcTemplate(ds);
  }
  ```

* ✅ **Transaction Management:**
  Add `@EnableTransactionManagement` and annotate methods with `@Transactional`.

* ✅ **Error Handling:**
  Spring converts SQL exceptions into `DataAccessException` — catch that instead of `SQLException`.

* ✅ **Connection Pooling:**
  In Boot, HikariCP is used automatically; for non-Boot, configure `HikariDataSource`.

### Assume you have to connect to multiple databases, then how would you configure

When you need **more than one database** in Spring, the trick is: **define more than one `DataSource`, give each one its own `JdbcTemplate`, and tell Spring which one to inject using qualifiers.** That’s it. Everything else is variations.


#### 1. Spring Boot way (two DBs: e.g. Postgres + Oracle)

**application.yml** (cleaner than properties):

```yaml
spring:
  datasource:
    primary:
      url: jdbc:postgresql://localhost:5432/employees
      username: postgres
      password: postgres
      driver-class-name: org.postgresql.Driver

  datasource:
    secondary:
      url: jdbc:oracle:thin:@//localhost:1521/ORCLCDB
      username: hr
      password: hr
      driver-class-name: oracle.jdbc.OracleDriver
```

Now define 2 data sources + 2 jdbc templates:

```java
@Configuration
public class MultiDbConfig {

    @Bean
    @Primary
    @ConfigurationProperties("spring.datasource.primary")
    public DataSource primaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @ConfigurationProperties("spring.datasource.secondary")
    public DataSource secondaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @Primary
    public JdbcTemplate primaryJdbcTemplate(DataSource primaryDataSource) {
        return new JdbcTemplate(primaryDataSource);
    }

    @Bean
    public JdbcTemplate secondaryJdbcTemplate(@Qualifier("secondaryDataSource") DataSource ds) {
        return new JdbcTemplate(ds);
    }
}
```

What happened here?

* `@Primary` = “if you don’t say which one, use this”.
* We gave **names** to beans (`primaryJdbcTemplate`, `secondaryJdbcTemplate`), so we can inject them.

Use them like this:

```java
@Repository
public class EmployeeRepository {

    private final JdbcTemplate primaryJdbcTemplate;   // Postgres
    private final JdbcTemplate secondaryJdbcTemplate; // Oracle

    public EmployeeRepository(
            @Qualifier("primaryJdbcTemplate") JdbcTemplate primaryJdbcTemplate,
            @Qualifier("secondaryJdbcTemplate") JdbcTemplate secondaryJdbcTemplate) {
        this.primaryJdbcTemplate = primaryJdbcTemplate;
        this.secondaryJdbcTemplate = secondaryJdbcTemplate;
    }

    public List<Employee> findInPrimary() {
        return primaryJdbcTemplate.query("select id, name from employees", 
            (rs, n) -> new Employee(rs.getInt("id"), rs.getString("name")));
    }

    public List<Dept> findInSecondary() {
        return secondaryJdbcTemplate.query("select deptno, dname from dept",
            (rs, n) -> new Dept(rs.getInt("deptno"), rs.getString("dname")));
    }
}
```

That’s the basic multi-DB pattern.

---

#### 2. Transactions with multiple DBs

If you want **separate transactions per DB** (most common), define 2 tx managers:

```java
@Configuration
@EnableTransactionManagement
public class TxConfig {

    @Bean
    @Primary
    public PlatformTransactionManager primaryTxManager(
            @Qualifier("primaryDataSource") DataSource ds) {
        return new DataSourceTransactionManager(ds);
    }

    @Bean
    public PlatformTransactionManager secondaryTxManager(
            @Qualifier("secondaryDataSource") DataSource ds) {
        return new DataSourceTransactionManager(ds);
    }
}
```

Then:

```java
@Service
public class BillingService {

    @Transactional("primaryTxManager")
    public void doOnPrimary() {
        // uses primary db
    }

    @Transactional("secondaryTxManager")
    public void doOnSecondary() {
        // uses secondary db
    }
}
```

##### 3. Non-Boot / plain Spring Java config

Same idea, just build datasources yourself:

```java
@Configuration
public class MultiDbConfig {

    @Bean
    @Primary
    public DataSource primaryDataSource() {
        var ds = new DriverManagerDataSource();
        ds.setDriverClassName("org.postgresql.Driver");
        ds.setUrl("jdbc:postgresql://localhost:5432/employees");
        ds.setUsername("postgres");
        ds.setPassword("postgres");
        return ds;
    }

    @Bean
    public DataSource secondaryDataSource() {
        var ds = new DriverManagerDataSource();
        ds.setDriverClassName("oracle.jdbc.OracleDriver");
        ds.setUrl("jdbc:oracle:thin:@//localhost:1521/ORCLCDB");
        ds.setUsername("hr");
        ds.setPassword("hr");
        return ds;
    }

    @Bean
    @Primary
    public JdbcTemplate primaryJdbcTemplate(DataSource primaryDataSource) {
        return new JdbcTemplate(primaryDataSource);
    }

    @Bean
    public JdbcTemplate secondaryJdbcTemplate(@Qualifier("secondaryDataSource") DataSource ds) {
        return new JdbcTemplate(ds);
    }
}
```

---

#### 4. If DB is chosen at runtime (multi-tenant / per-customer)

If your code says “for customer X use DB A, for customer Y use DB B”, then create a **Routing DataSource**:

```java
public class TenantRoutingDataSource extends AbstractRoutingDataSource {
    @Override
    protected Object determineCurrentLookupKey() {
        return TenantContext.getCurrentTenant(); // e.g. "tenantA"
    }
}
```

Then register it with map of target datasources. Your `JdbcTemplate` then points to the routing datasource, and Spring will pick the right DB per thread. This is for dynamic / per-request switching.

---

#### 5. Things to watch out for

* ✅ **Name everything** (`@Qualifier`) to avoid “expected single matching bean but found 2”.
* ✅ **Mark one as `@Primary`** so Spring Boot autoconfig doesn’t get confused.
* ✅ **Use separate connection pools** (Boot’s Hikari config per datasource).
* ✅ **Use separate transaction managers** if you’re mutating on both DBs.
* ⚠️ **Don’t mix reads/writes for 2 DBs in one method** unless you’re okay with them not being in one ACID tx.
* ⚠️ If two DBs are the **same vendor but different schemas**, it’s still easier to treat them as two datasources.




### What does Statement.setFetchSize(nSize) method really do in SQL Server JDBC driver?   
### In the JDBC driver, what is the actual effect of calling Statement.setFetchSize(n)? Does it influence how data is retrieved from the server or just how the client buffers results?

What should you take care while choosing fetch size parameter in jdbc.  
In JDBC, the setFetchSize(int) method is very important to performance and memory-management within the JVM as it controls the number of network calls from the JVM to the database and correspondingly the amount of RAM used for ResultSet processing.

The **RESULT-SET** is the number of rows marshalled on the DB in response to the query. The **ROW-SET** is the chunk of rows that are fetched out of the RESULT-SET per call from the JVM to the DB. The number of these calls and resulting RAM required for processing is dependent on the fetch-size setting.

So if the RESULT-SET has 100 rows and the fetch-size is 10, there will be 10 network calls to retrieve all of the data, using roughly 10*{row-content-size} RAM at any given time.

The default fetch-size is 10, which is rather small. In the case posted, it would appear the driver is ignoring the fetch-size setting, retrieving all data in one call (large RAM requirement, optimum minimal network calls).

What happens underneath ResultSet.next() is that it doesn't actually fetch one row at a time from the RESULT-SET. It fetches that from the (local) ROW-SET and fetches the next ROW-SET (invisibly) from the server as it becomes exhausted on the local client.


 **Most of the JDBC drivers’ default fetch size is 10**. In normal JDBC programming if you want to retrieve 1000 rows it requires 100 network round trips between your application and database server to transfer all data. Definitely this will impact your application response time. The reason is JDBC drivers are designed to fetch small number of rows from database to avoid any out of memory issues.   

 Type of Application: Consider the nature of your application. For interactive applications, a lower fetchSize might be preferable to provide faster initial results, while for batch processing, a larger fetchSize can improve throughput.


### Is fetch size param literally executed by jdbc driver 
The fetchSize parameter is a hint to the JDBC driver as to many rows to fetch in one go from the database. But the driver is free to ignore this and do what it sees fit. Some drivers, like the Oracle one, fetch rows in chunks, so you can read very large result sets without needing lots of memory. Other drivers just read in the whole result set in one go, and I'm guessing that's what your driver is doing.


### For Oracle database, say you have to download 5 million rows. Explain the pros and cons of approaches taken when the row size is small vs when the row size is large . The application is interactive website vs batch eod job etc. 

Great—since you’re on **Oracle + Java 17 (JDBC)**, here’s a crisp, practical playbook with trade-offs and settings for different situations.


* **Interactive/low-latency reads:** small–medium `fetchSize` (200–1,000), show first rows fast.
* **Backend/EOD huge exports (>10M rows):** larger `fetchSize` (5k–20k), stream to disk (optionally **.gz**), avoid sorting unless needed, chunk by PK for resumability.
* **Small/narrow rows:** push `fetchSize` higher (10k–20k).
* **Wide rows / LOBs:** keep `fetchSize` modest (200–1,000), stream LOBs.



#### Oracle specifics that matter

###### 1) Row fetching knobs

* `PreparedStatement.setFetchSize(N)`
  Tells Oracle JDBC how many rows to fetch per round trip. Fewer round trips = better throughput, but higher client memory per fetch.
* `oracle.jdbc.OraclePreparedStatement#setRowPrefetch(N)`
  Oracle’s native equivalent; either is fine. (Use via cast only if you already depend on Oracle types.)
* `connection.setReadOnly(true)`
  A hint; can enable some optimizations.
* Auto-commit can stay **on** for long reads in Oracle; no special cursor rules (unlike Postgres). You can safely keep it **on**.

**Rules of thumb**

* Narrow rows (≲ 200–300 bytes): `fetchSize = 10_000–20_000`.
* Medium rows (1–2 KB): `fetchSize = 2_000–10_000`.
* Wide rows (≥ 8 KB, or have LOBs): `fetchSize = 200–1_000`.

###### 2) Snapshot consistency & ORA-01555

Long scans read from a consistent SCN. If writers keep churning and your **UNDO** can’t retain old versions long enough, you can hit **ORA-01555: snapshot too old**.

**Mitigations (pick what fits):**

* Run exports during quieter windows (EOD).
* Increase `UNDO_RETENTION` or size.
* Make the export **faster** (bigger `fetchSize`, fewer per-row transformations, gzip to reduce I/O).
* If you chunk, consider **Flashback Query** with a captured SCN:
  `SELECT /*+ PARALLEL(n) */ ... AS OF SCN :scn WHERE id BETWEEN :lo AND :hi`
  so all chunks see the **same point-in-time** view.

###### 3) Sorting & indexing

* `ORDER BY` a **primary key** if you need determinism/resume-ability. Sorting a huge set on a non-indexed expression will spill to TEMP and slow your job.
* If you don’t need order, **skip ORDER BY** to maximize scan speed (especially with `PARALLEL`).

###### 4) LOBs & very wide rows

* Read **LOBs via streams** (`getBinaryStream` / `getCharacterStream`) and **write straight out**; avoid `getBytes()` on giant BLOBs.
* Keep `fetchSize` modest for LOB queries (200–500), because each “row” can be large.
* If possible, **avoid exporting gigantic LOBs to CSV**; use file dumps or object storage pointers.

###### 5) Parallelism

* You can parallelize on the **application side** by splitting the PK/ROWID ranges into N shards, each with its own connection and output file (later merge if truly needed).
  Example shard predicate: `WHERE id BETWEEN :lo AND :hi`.
* Or use Oracle hints: `SELECT /*+ PARALLEL(8) */ ...` for the scan itself (coordinate with your DBA; don’t hurt prod).

###### 6) CSV correctness & I/O

* Use an RFC-4180-ish escape (quotes doubled, wrap if comma/quote/CR/LF).
* **Gzip on the fly** (`.gz`)—often 3–10× smaller, significantly faster end-to-end when I/O bound.
* Use big buffers (≥ 1MB) for writer and gzip.



#### Scenario guide (pros/cons & settings)

###### A) Small row size (e.g., 5–10 narrow columns, no LOBs)

**Pros:** High throughput, minimal memory per row; can push fetch size high.
**Cons:** Network round trips dominate if fetch size is too small.

**Use:**

* `fetchSize = 10_000–20_000`.
* Optional `/*+ PARALLEL(8) */` if the table and system allow.
* Chunk by PK for resume and parallel workers (e.g., 1–5M rows per chunk).

**When interactive:** lower `fetchSize` (200–500) so first page returns fast.

###### B) Medium row size (1–2 KB)

**Pros:** Still streamable with good throughput.
**Cons:** Memory per batch grows; “too large” fetch size adds client pressure.

**Use:**

* `fetchSize = 2_000–10_000` (start ~5k; tune).
* Gzip output; keep transformations light.
* Consider partition-wise chunking to keep ranges aligned with storage.

**Interactive:** `fetchSize = 200–1_000`.

###### C) Wide rows (≥ 8 KB) or with LOBs (CLOB/BLOB)

**Pros:** Few round trips even with small fetch sizes.
**Cons:** Client buffering and GC pressure; CSV bloats; Excel consumers choke.

**Use:**

* `fetchSize = 200–1_000`.
* Stream LOBs; avoid building huge strings.
* Consider exporting **metadata + externalized LOBs** (files/URIs) instead of raw CSV when possible.

**Interactive:** `fetchSize = 100–300`.

###### D) Interactive ad-hoc (dashboards, tools)

**Goal:** low latency for first rows.
**Use:** `fetchSize = 200–500`; no gzip; smaller buffers; possibly server-side pagination (`ROWNUM`/`OFFSET` style) for UI.

###### E) Backend/EOD batch (10M–100M rows)

**Goal:** sustained throughput, reliability, repeatability.
**Use:**

* `fetchSize = 5_000–20_000` (tune by row width).
* **No ORDER BY** unless needed. If needed, sort by indexed PK.
* **Chunk by PK**; write one file per chunk (or append), checkpoint last PK.
* Capture an **SCN** and use `AS OF SCN` in all chunks for a consistent snapshot, or run in a quiet window to avoid ORA-01555.
* Gzip on the fly; 1–8MB buffers.
* Consider `/*+ PARALLEL(n) */` with DBA approval.



###### Example: Oracle-tuned exporter snippet

```java
try (PreparedStatement ps = conn.prepareStatement(
        "SELECT /*+ PARALLEL(8) */ id, col1, col2, created_at FROM big_table /* add WHERE if chunked */ ORDER BY id",
        ResultSet.TYPE_FORWARD_ONLY,
        ResultSet.CONCUR_READ_ONLY)) {

    // Tune per row width
    ps.setFetchSize(10_000); // small/narrow rows ⇒ higher; wide/LOB ⇒ 200–1000

    try (ResultSet rs = ps.executeQuery();
         OutputStream os = Files.newOutputStream(Path.of("export.csv.gz"));
         GZIPOutputStream gz = new GZIPOutputStream(os, 1 << 20);
         BufferedWriter w = new BufferedWriter(new OutputStreamWriter(gz, StandardCharsets.UTF_8), 1 << 20)) {

        writeCsv(rs, w); // your streaming CSV writer
    }
}
```

**Chunked with consistent snapshot:**

```java
// Capture SCN once:
long scn = getCurrentScn(conn); // SELECT CURRENT_SCN FROM V$DATABASE

String sql = """
  SELECT id, col1, col2, created_at
  FROM big_table AS OF SCN ?
  WHERE id > ? AND id <= ?
  ORDER BY id
""";

try (PreparedStatement ps = conn.prepareStatement(sql)) {
  ps.setLong(1, scn);
  ps.setLong(2, lastId);
  ps.setLong(3, nextId);
  ps.setFetchSize(10_000);
  // stream to file...
}
```


### How to get export a large amount of data (greater > 10 million) from database in csv format
Approach 1 : get rows in result set and store in list and return csv
Approach 2: return csv in streaming manner

read the result set and stream the results (based on each implementation) directly to the OutputStream using our CSVWriterWrapper.  

Json streaming out result set with object mapper.  
https://www.javacodegeeks.com/2018/09/streaming-jdbc-resultset-json.html

csv streaming out result set with printer writer
https://www.javacodegeeks.com/2018/12/java-streaming-jdbc-resultset-csv.html  


The flush() method of PrintWriter Class in Java is used to flush the stream. By flushing the stream, it means to clear the stream of any element that may be or maybe not inside the stream. 

