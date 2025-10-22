# Enumerations (enums)

* Provide a type-safe way of defining a fixed set of constants.
* Each `enum` value is actually an object of the `enum` type.
* Can have fields, methods, and constructors.

When you create an enum, an associated class is produced for you by the compiler. This class is automatically inherited from java.lang.Enum, which provides certain capabilities

Except for the fact that you can’t inherit from it, an enum can be treated much like a regular class. This means that you can add methods to an enum. It’s even possible for an enum to have a main( ).

if you are going to define methods you must end the sequence of enum instances with a semicolon. 

Also, Java forces you to define the instances as the first thing in the enum. You’ll get a compile-time error if you try to define them after any of the methods or fields.

### Enum vs Class Initialization
When the JVM initializes Enum, it creates enum singleton objects immediately. Class objects are created when new is called.    
Enum objects are thread safe and no need to protected by synchornized   



### Enum instance vs Class fields


### 1. Enum instances in Java

When you write:

```java
public enum Day {
    MONDAY, TUESDAY, WEDNESDAY;
}
```

What actually happens is:

* `Day` is a **class** (the compiler generates it).
* `MONDAY`, `TUESDAY`, and `WEDNESDAY` are **public static final objects** (instances) of that class.
* Each one is constructed exactly once, when the enum class is loaded.

So under the hood it’s as if the compiler wrote:

```java
public final class Day extends java.lang.Enum<Day> {
    public static final Day MONDAY = new Day("MONDAY", 0);
    public static final Day TUESDAY = new Day("TUESDAY", 1);
    public static final Day WEDNESDAY = new Day("WEDNESDAY", 2);

    private Day(String name, int ordinal) {
        super(name, ordinal);
    }
}
```

That’s why they’re called **instances**: each constant (`MONDAY`, `TUESDAY`, …) is literally an object of type `Day`.


### 2. Why not call them “fields” like class fields?

* Fields are just data slots (e.g., `int x = 5;`).
* Enum constants are not *just* data. They are **fully constructed objects** with identity, methods, and fields of their own.
* Example:

  ```java
  public enum Operation {
      PLUS { double apply(double x, double y) { return x + y; } },
      TIMES { double apply(double x, double y) { return x * y; } };

      abstract double apply(double x, double y);
  }
  ```

Here, `PLUS` and `TIMES` are not primitive-like values or fields; they are **different subclasses of `Operation` with their own method implementations**. That’s why the language treats them as instances, not fields.


## Enum example to organise constants in better way 

```java
public final class Food {
    private Food() {} // no instances

    // Common type for all menu items
    public sealed interface MenuItem permits Appetizers, Coffee, Dessert {
        Category category();
        String label();
    }

    public enum Category { APPETIZERS, COFFEE, DESSERT }

    public enum Appetizers implements MenuItem {
        BRUSCHETTA("Bruschetta"),
        GARLIC_BREAD("Garlic Bread");

        private final String label;
        Appetizers(String label) { this.label = label; }
        public Category category() { return Category.APPETIZERS; }
        public String label() { return label; }
    }

    public enum Coffee implements MenuItem {
        ESPRESSO("Espresso"),
        CAPPUCCINO("Cappuccino");

        private final String label;
        Coffee(String label) { this.label = label; }
        public Category category() { return Category.COFFEE; }
        public String label() { return label; }
    }

    public enum Dessert implements MenuItem {
        TIRAMISU("Tiramisu"),
        CHEESECAKE("Cheesecake");

        private final String label;
        Dessert(String label) { this.label = label; }
        public Category category() { return Category.DESSERT; }
        public String label() { return label; }
    }

    // --- Helpers to treat everything "under FOOD" ---
    public static List<MenuItem> all() {
        return Stream.of(Appetizers.values(), Coffee.values(), Dessert.values())
                     .flatMap(Arrays::stream)
                     .map(mi -> (MenuItem) mi)
                     .toList();
    }

    public static Map<Category, List<MenuItem>> byCategory() {
        return all().stream().collect(
            Collectors.groupingBy(MenuItem::category,
                () -> new EnumMap<>(Category.class), Collectors.toList()));
    }
}

```

This keep the Food constants organised and readable. 


### Enum as replacement for constant + switch antipattern 

Enum has this property : If the enum declares an abstract method, then each constant must override it, just like subclasses would.

```java
public enum Operation {
    PLUS {
        @Override
        public double apply(double x, double y) {
            return x + y;
        }
    },
    MINUS {
        @Override
        public double apply(double x, double y) {
            return x - y;
        }
    },
    TIMES {
        @Override
        public double apply(double x, double y) {
            return x * y;
        }
    },
    DIVIDE {
        @Override
        public double apply(double x, double y) {
            return x / y;
        }
    };

    // Abstract method to be implemented by each constant
    public abstract double apply(double x, double y);
}

```

```java
double result = Operation.PLUS.apply(2, 3);   // 5.0
double product = Operation.TIMES.apply(4, 5); // 20.0

```

### State machine with enum

Java enums are a very *popular* and idiomatic way to model small/medium, fixed-set state machines. They give you exhaustiveness checks, clean code, and great performance with `EnumMap`/`EnumSet`.

### Why enums fit FSMs

* **Finite, known states** → perfect match for `enum`.
* **Compiler help** → `switch` on an enum is exhaustiveness-checked.
* **Fast & lean** → `EnumMap`/`EnumSet` are array-backed.
* **Constant-specific behavior** → each state can override methods (strategy per state).

### Two common patterns

#### 1) Constant-specific behavior (polymorphic states)

```java
enum State {
  NEW {
    @Override State on(Event e) {
      return switch (e) {
        case PAY    -> PROCESSING;
        case CANCEL -> CANCELED;
        default     -> illegal(this, e);
      };
    }
  },
  PROCESSING {
    @Override State on(Event e) {
      return switch (e) {
        case PACK   -> SHIPPED;
        case CANCEL -> CANCELED;
        default     -> illegal(this, e);
      };
    }
  },
  SHIPPED   { @Override State on(Event e) { return e == Event.DELIVER ? DELIVERED : illegal(this, e); } },
  DELIVERED { @Override State on(Event e) { return this; } },
  CANCELED  { @Override State on(Event e) { return this; } };

  abstract State on(Event e);
  static State illegal(State s, Event e) { throw new IllegalStateException(s+" cannot handle "+e); }
}
enum Event { PAY, PACK, DELIVER, CANCEL }
```

* Pros: logic lives with the state; no giant switch elsewhere.
* Easy to add **entry/exit hooks** as methods on the enum (just keep mutable data outside the enum singletons).

#### 2) Table-driven with `EnumMap`

```java
enum State { NEW, PROCESSING, SHIPPED, DELIVERED, CANCELED }
enum Event { PAY, PACK, DELIVER, CANCEL }

final class FSM {
  private static final EnumMap<State, EnumMap<Event, State>> T = new EnumMap<>(State.class);
  static {
    put(State.NEW,        Event.PAY,    State.PROCESSING);
    put(State.NEW,        Event.CANCEL, State.CANCELED);
    put(State.PROCESSING, Event.PACK,   State.SHIPPED);
    put(State.PROCESSING, Event.CANCEL, State.CANCELED);
    put(State.SHIPPED,    Event.DELIVER,State.DELIVERED);
  }
  private static void put(State s, Event e, State to) {
    T.computeIfAbsent(s, k -> new EnumMap<>(Event.class)).put(e, to);
  }
  static State next(State s, Event e) {
    var row = T.get(s);
    if (row == null || !row.containsKey(e)) throw new IllegalStateException(s+" cannot handle "+e);
    return row.get(e);
  }
}
```

* Pros: data-driven (easy to visualize/test), simple to attach **actions/guards** via another map keyed by `(state,event)`.

### When enums are a great choice

* State set is **small and stable**.
* You want **compile-time safety** and simple, fast lookups.
* Transitions are straightforward (no complex hierarchy or dynamic states).

### When to consider alternatives

* **Dynamic/extendable states** at runtime → enums are fixed; use classes/`sealed` hierarchies.
* **Hierarchical/orthogonal states, timers, guards, async effects** → consider a framework (e.g., Spring Statemachine) or a composable design (state interface + handlers).
* **Per-entity mutable state in the enum** → avoid; keep mutable data in the entity/context, not in the enum singletons.

**Bottom line:** Enums are a *popular, clean, and efficient* way to build many Java FSMs. Start with enums; if the machine grows complicated or needs runtime extensibility, graduate to a more flexible design.
