Function Composition
In mathematics, function composition is an operation  ∘  that takes two functions f and g, and produces a function h = g  ∘  f such that h(x) = g(f(x)). In this operation, the function g is applied to the result of applying the function f to x.  

In computer science, function composition is an act or mechanism to combine simple functions to build more complicated ones. Like the usual composition of functions in mathematics, the result of each function is passed as the argument of the next, and the result of the last one is the result of the whole.

Thus it’s easier to debug, test, maintain, reuse and even more fun to develop functions. Instead of the old way of jamming all the code into one single area.

### Example 

The bad way of building a calculator
``` bash
const priceCalculator = (
  taxPercentage = 0.3, 
  serviceFees = 10, 
  price, 
  discount, 
  percentCoupon, 
  valueCoupon,
  weight, 
  $PerKg
) => {
  return (
    price
    - (price * percentCoupon) 
    - discount 
    - couponValue 
    + (weight * $PerKg) 
    + serviceFees
  ) * (1 + taxPercentage)
}
```

The good way 
```bash
const priceCalculator = (
  taxPercentage = 0.3, 
  serviceFees = 10, 
  price, 
  discount, 
  percentCoupon, 
  valueCoupon,
  weight, 
  $PerKg
) => {
  const applyTax           = (val) => val * (1 + taxPercentage)
  const applyServiceFees   = (val) => val + serviceFees
  const applyPercentCoupon = (val) => val - val * percentCoupon
  const applyValueCoupon   = (val) => val - valueCoupon
  const applyDiscount      = (val) => val - discount
  const applyShippingCost  = (val) => val + weight * $PerKg
return pipe(
    applyPercentCoupon,
    applyDiscount,
    applyValueCoupon,
    applyShippingCost,
    applyServiceFees,
    applyTax
  )(price)
}

```

### Compose vs Pipe
pipe is very similar to compose, they have the same purpose. Both are here to chain functions, however they have different implementations and workflows.  

```bash
const compose = 
  (...fns) => 
    (x) => fns.reduceRight((acc, fn) => fn(acc), x)

const pipe = 
  (...fns) => 
    (x) => fns.reduce((acc, fn) => fn(acc), x)


```

`compose` is from right to left. Eg: compose(h,g,f) means h(g(f())).  
`pipe` is from left to right. Eg: pipe(h,g,f) means f(g(h())).  


