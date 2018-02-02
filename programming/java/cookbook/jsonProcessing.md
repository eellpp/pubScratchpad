Major JSON libraries

1) Jackson 
2) Gson (google)
3) Json Simple
4) Jsonp (Oracle)

`BigFile`: 100MB +

`SmallFile` : 1 to 10 KB like in webrequests

### Select library based on speed vs file size
- If you have an environment that deals often or primarily with big JSON files, then Jackson is your library of interest. GSON struggles the most with big files.
- If your environment primarily deals with lots of small JSON requests, such as in a micro services or distributed architecture setup, then GSON is your library of interest. Jackson struggles the most with small files.
- If you end up having to often deal with both types of files, JSON.simple is a good workhorse for a variable environment. Neither Jackson nor GSON perform as well across multiple files sizes.

### Jackson
```java
// READ
ObjectMapper mapper = new ObjectMapper();
Staff obj = mapper.readValue("{'name':'john'}", Staff.class); // from string
Staff obj = mapper.readValue(new File("c:\\file.json"), Staff.class); // from file
Staff obj = mapper.readValue(new URL("http://example.com/api/staff.json"), Staff.class); // from url

// Write
String jsonInString = mapper.writeValueAsString(new Staff("john",22)); // to string
mapper.writeValue(new File("c:\\file.json"), new Staff("john",22)); // to file
```

### GSON
```java
// json serde of object
Gson gson = new Gson(); // Or use new GsonBuilder().create();
 MyType target = new MyType();
 String json = gson.toJson(target); // serializes target to Json
 MyType target2 = gson.fromJson(json, MyType.class); // deserializes json into target2
 
 // json serde of list of objects
 Type listType = new TypeToken<List<String>>() {}.getType();
 List<String> target = new LinkedList<String>();
 target.add("blah");

 Gson gson = new Gson();
 String json = gson.toJson(target, listType);
 List<String> target2 = gson.fromJson(json, listType);
 ```
 
