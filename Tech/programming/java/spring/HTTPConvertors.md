https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.spring-mvc

https://stackoverflow.com/a/40741427. 



Spring uses HttpMessageConverters to negotiate content conversion in an HTTP exchange.  

Spring uses HttpMessageConverters to render @ResponseBody. 

 You can contribute additional converters by adding beans of the appropriate type in a Spring Boot context.   

 >> Just extend your custom converter from AbstractHttpMessageConverter and mark the class with @Component annotation.

```java
// Example to encrypt the json messages
// modify the writeInternal method add custom logic on how the reponse body will be redered
@Component
public class Converter extends AbstractHttpMessageConverter<Object> {

    public static final Charset DEFAULT_CHARSET = Charset.forName("UTF-8");

    @Inject
    private ObjectMapper objectMapper;

    public Converter(){
        super(MediaType.APPLICATION_JSON_UTF8,
            new MediaType("application", "*+json", DEFAULT_CHARSET));
    }

    @Override
    protected boolean supports(Class<?> clazz) {
        // if this convertor is to applied to only on controller that have return type MyCustomPOJO
        // return MyCustomPOJO.class.isAssignableFrom(clazz)
        return true; // to support all classes

    }

    @Override
    protected Object readInternal(Class<? extends Object> clazz,
                                  HttpInputMessage inputMessage) throws IOException, HttpMessageNotReadableException {
        return objectMapper.readValue(decrypt(inputMessage.getBody()), clazz);
    }

    @Override
    protected void writeInternal(Object o, HttpOutputMessage outputMessage) throws IOException, HttpMessageNotWritableException {
        outputMessage.getBody().write(encrypt(objectMapper.writeValueAsBytes(o)));
    }

    private InputStream decrypt(InputStream inputStream){
        // do your decryption here 
        return inputStream;
    }

    private byte[] encrypt(byte[] bytesToEncrypt){
        // do your encryption here 
        return bytesToEncrypt;
    }
}
```