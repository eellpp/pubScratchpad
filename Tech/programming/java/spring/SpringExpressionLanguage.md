### SpEL

https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#expressions

With Spring Boot, you can use these conditional annotations:
- @ConditionalOnBean
- @ConditionalOnClass
- @ConditionalOnExpression
- @ConditionalOnJava
- @ConditionalOnMissingBean
- @ConditionalOnMissingClass
- @ConditionalOnNotWebApplication
- @ConditionalOnProperty
- @ConditionalOnResource
- @ConditionalOnWebApplication

#### Property Placeholder syntax
${...} is the property placeholder syntax. It can only be used to dereference properties.

This has immediate evaluation.Immediate evaluation means that the expression is evaluated and the result returned as soon as the page is first rendered


### Spel syntax
#{...} is SpEL syntax, which is far more capable and complex. It can also handle property placeholders, and a lot more besides.

This has deferred evaluation. 

Deferred evaluation means that the technology using the expression language can use its own machinery to evaluate the expression sometime later during the page’s lifecycle, whenever it is appropriate to do so.


@Value("#{ systemProperties['user.region'] }")

@ConditionalOnExpression("'${zk.client.connect}'.isEmpty()") 

@ConditionalOnExpression("${properties.first.property.enable:true} " +
        "&& ${properties.second.property.enable:true} " +
        "&& ${properties.third.property.enable:true}")
        
@ConditionalOnExpression("'${com.property1}'.equals('${com.property2}')")


@Value("#{systemProperties['pop3.port'] ?: 25}") //This will inject a system property pop3.port if it is defined or 25 if not.

