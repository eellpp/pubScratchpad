
### Documentation for Jackson 
https://github.com/FasterXML/jackson-docs. 

### Combining the Jackson Streaming API with ObjectMapper for parsing JSON
https://cassiomolin.com/2019/08/19/combining-jackson-streaming-api-with-objectmapper-for-parsing-json/ 


```java

private void parseJson(InputStream is) throws IOException {

    // Create and configure an ObjectMapper instance
    ObjectMapper mapper = new ObjectMapper();
    mapper.registerModule(new JavaTimeModule());
    mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);

    // Create a JsonParser instance
    try (JsonParser jsonParser = mapper.getFactory().createParser(is)) {

        // Check the first token
        if (jsonParser.nextToken() != JsonToken.START_ARRAY) {
            throw new IllegalStateException("Expected content to be an array");
        }

        // Iterate over the tokens until the end of the array
        while (jsonParser.nextToken() != JsonToken.END_ARRAY) {

            // Read a contact instance using ObjectMapper and do something with it
            Contact contact = mapper.readValue(jsonParser, Contact.class);
            doSomethingWithContact(contact);
        }
    }
}
```


Output stream with json generator

```java
private void generateJson(List<Contact> contacts, OutputStream os) throws IOException {

    // Create and configure an ObjectMapper instance
    ObjectMapper mapper = new ObjectMapper();
    mapper.registerModule(new JavaTimeModule());
    mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    mapper.enable(SerializationFeature.INDENT_OUTPUT);

    // Create a JsonGenerator instance
    try (JsonGenerator jsonGenerator = mapper.getFactory().createGenerator(os)) {

        // Write the start array token
        jsonGenerator.writeStartArray();

        // Iterate over the contacts and write each contact as a JSON object
        for (Contact contact : contacts) {
            
             // Write a contact instance as JSON using ObjectMapper
             mapper.writeValue(jsonGenerator, contact);
        }

        // Write the end array token
        jsonGenerator.writeEndArray();
    }
}
```

