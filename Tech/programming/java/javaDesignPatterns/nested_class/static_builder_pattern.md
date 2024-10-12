 Builder Pattern: Often used for complex object creation.

```java
public class Pizza {
       private final int size;
       private final boolean cheese;
       private final boolean pepperoni;

       private Pizza(Builder builder) {
           this.size = builder.size;
           this.cheese = builder.cheese;
           this.pepperoni = builder.pepperoni;
       }

       public static class Builder {
           private int size;
           private boolean cheese;
           private boolean pepperoni;

           public Builder(int size) {
               this.size = size;
           }

           public Builder cheese(boolean value) {
               cheese = value;
               return this;
           }

           public Builder pepperoni(boolean value) {
               pepperoni = value;
               return this;
           }

           public Pizza build() {
               return new Pizza(this);
           }
       }
   }

   // Usage
   Pizza pizza = new Pizza.Builder(12)
                   .cheese(true)
                   .pepperoni(true)
                   .build();
   
```
