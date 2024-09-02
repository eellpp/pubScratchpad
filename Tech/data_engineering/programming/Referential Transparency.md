
**Referential Transparency**
   - **Concept**: A function is referentially transparent if it can be replaced with its output value without changing the behavior of the program. This is a key concept in functional programming.
   - **Importance**: Referential transparency makes reasoning about code easier, allows for optimizations like memoization, and leads to more predictable and testable code.
   - **Example**: In a pure function like `int add(int a, int b) { return a + b; }`, the result depends only on the inputs and does not have side effects. Anywhere in the program, `add(2, 3)` can be replaced with `5` without affecting the program's behavior.
