### API to accept one optional param and one required param with Json NOde

```java
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.HashSet;
import java.util.Set;

@RestController
public class ApiController {

    private final ObjectMapper objectMapper;

    public ApiController(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @PostMapping("/api")
    public ResponseEntity<String> postData(@Valid @RequestBody JsonNode requestBody, BindingResult result) {
        if (result.hasErrors()) {
            return ResponseEntity.badRequest().body("Invalid request body");
        }

        String user = requestBody.get("user").asText();
        JsonNode menuNode = requestBody.get("menu");

        Set<String> menuSet = null;
        if (menuNode != null && menuNode.isArray()) {
            menuSet = new HashSet<>();
            for (JsonNode itemNode : menuNode) {
                menuSet.add(itemNode.asText());
            }
        }

        // Process the request
        // ...

        return ResponseEntity.status(HttpStatus.CREATED).body("Data posted successfully");
    }
}

```

### Same API instead using DTO
data transfer object 


```java
import javax.validation.constraints.NotBlank;
import java.util.Set;

public class RequestDTO {
    @NotBlank(message = "User field is required")
    private String user;
    private Set<String> menu;

    // Getters and Setters

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public Set<String> getMenu() {
        return menu;
    }

    public void setMenu(Set<String> menu) {
        this.menu = menu;
    }
}

```
Controller
```java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
public class ApiController {

    @PostMapping("/api")
    public ResponseEntity<String> postData(@Valid @RequestBody RequestDTO requestDTO, BindingResult result) {
        if (result.hasErrors()) {
            return ResponseEntity.badRequest().body("Invalid request body");
        }

        // Process the request
        // ...

        return ResponseEntity.status(HttpStatus.CREATED).body("Data posted successfully");
    }
}

In the above example, the @Valid annotation is used to trigger the validation of the RequestDTO object. The BindingResult object holds the validation result, and if there are any validation errors, a bad request response is returned with an appropriate message.
```

### Streaming data example

Streaming data is advantageous for big files for several reasons:

`Reduced memory usage`: Streaming data allows you to process and transmit data in small, manageable chunks rather than loading the entire file into memory. This significantly reduces memory usage, making it possible to handle large files that may exceed available memory resources.

`Faster response times`: Streaming data enables the client to receive and process data as it becomes available, without having to wait for the entire file to be loaded. This leads to faster response times, as the client can start processing the data while it is being streamed.

`Efficient network utilization`: Streaming data reduces network overhead by transmitting the data in smaller chunks. This can improve overall network utilization, especially when dealing with slow or unreliable connections. It also allows the client to start receiving and processing data earlier, even if the entire file has not been transmitted yet.

`Scalability`: Streaming data allows for efficient handling of concurrent requests for large files. By streaming the data, the server can handle multiple requests simultaneously without being constrained by memory limitations. This improves the scalability of the system, enabling it to handle a higher volume of concurrent requests.

`Real-time processing`: Streaming data enables real-time or near real-time processing of data as it is being received. This is particularly beneficial for applications that require immediate processing or analysis of large datasets, such as real-time analytics or data streaming platforms.

Overall, streaming data offers better performance, reduced memory usage, improved network utilization, and increased scalability when dealing with large files. It enables efficient processing and transmission of data, making it a preferred approach for handling big files in various scenarios.


In this modified code, the /api/csv endpoint is configured to stream JSON data using the Consumer<JsonGenerator> object. The JsonFactory and JsonGenerator are used to write the JSON data directly.

You can customize the dataWriter consumer to write the data to the JsonGenerator as per your specific logic. In the provided example, a sample JSON object is written, but you can modify it to read data from a CSV file or any other data source.

Please note that you need to adjust the code inside the dataWriter consumer to write the actual data based on your specific use case.
```java
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.function.Consumer;

@RestController
public class CsvApiController {

    @GetMapping("/api/csv")
    public void getCsvData(HttpServletResponse response) throws IOException {
        ClassPathResource resource = new ClassPathResource("data.csv");
        InputStream inputStream = resource.getInputStream();

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=data.json");

        JsonFactory jsonFactory = new JsonFactory();
        OutputStream outputStream = response.getOutputStream();
        JsonGenerator jsonGenerator = jsonFactory.createGenerator(outputStream, JsonEncoding.UTF8);

        jsonGenerator.writeStartArray();

        Consumer<JsonGenerator> dataWriter = generator -> {
            // Write data to the generator as per your specific logic
            // Example: Read CSV data and write JSON object for each row
            // ...

            // Example: Writing a sample JSON object
            try {
                generator.writeStartObject();
                generator.writeStringField("name", "John Doe");
                generator.writeNumberField("age", 30);
                generator.writeEndObject();
            } catch (IOException e) {
                // Handle any exceptions
            }
        };

        dataWriter.accept(jsonGenerator);

        jsonGenerator.writeEndArray();
        jsonGenerator.flush();
        jsonGenerator.close();

        outputStream.close();
        inputStream.close();
    }
}


```