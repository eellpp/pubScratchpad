## References

- http://www.oopweb.com/Java/Documents/JavaNotes/VolumeFrames.html

##  When to use getters and setters

(stackoverflow)[http://stackoverflow.com/a/36891]

Use common sense really. If you have something like:
```java
public class ScreenCoord2D{
    public int x;
    public int y;
}
```
Then there's little point in wrapping them up in getters and setters. You're never going to store an x, y coordinate in whole pixels any other way. Getters and setters will only slow you down.

On the other hand, with:
```java
public class BankAccount{
    public int balance;
}
```
You might want to change the way a balance is calculated at some point in the future. This should really use getters and setters.

It's always preferable to know why you're applying good practice, so that you know when it's ok to bend the rules.

http://stackoverflow.com/a/8565711

One example of appropriate public instance variables is the case where the class is essentially a data structure, with no behavior. *In other words, if you would have used a struct instead of a class (if Java supported struct), then it's appropriate to make the class's instance variables public.*
