API keys are for projects, authentication is for users.  

https://cloud.google.com/endpoints/docs/openapi/when-why-api-key

API keys are generally not considered secure; they are typically accessible to clients, making it easy for someone to steal an API key. Once the key is stolen, it has no expiration, so it may be used indefinitely, unless the project owner revokes or regenerates the key. While the restrictions you can set on an API key mitigate this, there are better approaches for authorization.

While API keys identify the calling project, they don't identify the calling user. For instance, if you have created an application that is calling an API, an API key can identify the application that is making the call, but not the identity of the person who is using the application.

