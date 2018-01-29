

### Generic exceptions Error, RuntimeException, Throwable and Exception should never be thrown

- catch (Throwable ex) { //Non-compliant code
- public void doSomething() throws Exception {...} // Non-compliant code
```java
public void foo(String bar) { 
  throw new CustomRuntimeException("My Message");    // Compliant
}
```

The primary reason why one should avoid throwing Generic Exceptions, Throwable, Error etc is that doing in this way prevents classes from catching the intended exceptions. Thus, a caller cannot examine the exception to determine why it was thrown and consequently cannot attempt recovery.

### Catching Runtime exceptions
```java
public void foo(String bar) throws Throwable { // Non-compliant
  throw new RuntimeException("My Message");    // Non-Compliant
}
```
catching RuntimeException is considered as a bad practice. RuntimeException is intended to be used for programmer errors. And, thus, throwing Generic Exceptions/Throwable would lead the developer to catch the exception at a later stage which would eventually lead to further code smells.

There are a few cases where you can catch runtime exceptions:

1) You are calling code that comes from a 3rd party where you do not have control over when they throw exception. I would argue that you should do this on a case by case basis and wrap the usage of the 3rd party code within your own classes so you can pass back non-runtime exceptions.
2) Your program cannot crash and leave a stack trace for the user to see. In this case it should go around main and around any threads and event handling code. The program should probably exit when such exception occurs as well.

### Capturing exception in log message
```java
try { 
  /* ... */ 
} catch( Exception e ) {
  SomeLogger.info( "some context message", e ); // Context message is there. Also, exception object is present
}
```
printStackTrace is not a good coding practice

### Throwable vs Exception

catch(Throwable e) vs catch(Exception e)

Thowable catches really everything even ThreadDeath which gets thrown by default to stop a thread from the now deprecated Thread.stop() method. So by catching Throwable you can be sure that you'll never leave the try block without at least going through your catch block, but you should be prepared to also handle OutOfMemoryError and InternalError or StackOverflowError.

 You should generally not do that, except perhaps at the very highest "catch all" level of a thread where you want to log or otherwise handle absolutely everything that can go wrong. It would be more typical in a framework type application (for example an application server or a testing framework) where it can be running unknown code and should not be affected by anything that goes wrong with that code, as much as possible.
