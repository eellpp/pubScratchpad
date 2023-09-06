### Exception org.apache.kafka.common.errors.DisconnectException: null

Basically, your application is continuously listening the messages from the topic, suppose if there is no message published in the topic you will get this type of exception.

org.apache.kafka.common.errors.DisconnectException: null

Disconnect Exception class

If we start sending messages to topic, application will start running and consume those messages.

Here you need to increase the request timeout in your properties files.

consumer.request.timeout.ms:


