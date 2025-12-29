
# ✅ What is `random`?

Python’s `random` module provides **pseudo-random numbers** suitable for:

* Simulations
* Games
* Sampling
* Shuffling
* Simple randomness in applications

It is **NOT cryptographically secure**.

```python
import random
```

---

# ✔️ 1️⃣ Generating Numbers

## Random float (0.0 ≤ x < 1.0)

```python
random.random()
```

## Random float in a range

```python
random.uniform(10, 20)   # e.g., 13.56
```

## Random integer (inclusive)

```python
random.randint(1, 10)    # 1 to 10 inclusive
```

## Random number in a *range step*

```python
random.randrange(0, 100, 5)   # multiples of 5
```

---

# ✔️ 2️⃣ Random Choice from Sequence

## Single choice

```python
random.choice(["red", "blue", "green"])
```

## Multiple unique choices (no repeat)

```python
random.sample([1,2,3,4,5], k=2)
```

## Multiple with replacement

```python
random.choices([1,2,3,4,5], k=3)
```

---

# ✔️ 3️⃣ Shuffle a List (In-place)

```python
items = [1,2,3,4,5]
random.shuffle(items)
```

---

# ✔️ 4️⃣ Working with Distributions

## Gaussian / Normal

```python
random.gauss(mu=50, sigma=10)
```

## Other useful ones

```python
random.expovariate(lambda)
random.paretovariate(alpha)
random.betavariate(alpha, beta)
```

---

# ✔️ 5️⃣ Seeding (Reproducibility)

If you want repeatable results (e.g., tests):

```python
random.seed(42)
```

This ensures the same random sequence each run.

---

# ⚠️ When You **MUST NOT USE** `random`

`random` is NOT secure because:

* It is deterministic
* Outputs can be predicted if seed is known
* Not resistant to attacks

❌ DO NOT USE for:

* Password generation
* Tokens / API keys
* Session identifiers
* OTPs
* Encryption
* Gambling
* Lottery systems
* Any security-sensitive randomness

---

# ✅ Use `secrets` Instead (Crypto-Secure)

For production-grade randomness:

```python
import secrets
```

## Secure random integer

```python
secrets.randbelow(10)
```

## Secure token

```python
secrets.token_hex(16)
```

## Secure random choice

```python
secrets.choice(["A", "B", "C"])
```

---

# 🧠 `random` vs `secrets` vs `os.urandom`

| Use Case                    | Module                       |
| --------------------------- | ---------------------------- |
| Simulation / Games          | `random`                     |
| Machine Learning / Sampling | `random`                     |
| Unit test reproducibility   | `random.seed()`              |
| Passwords / Keys / Tokens   | `secrets`                    |
| Cryptography internals      | `os.urandom()` (lower-level) |

---

# 🎯 Quick Reference Cheat Sheet

| Task               | Code                      |
| ------------------ | ------------------------- |
| Random float       | `random.random()`         |
| Float in range     | `random.uniform(a,b)`     |
| Random int         | `random.randint(a,b)`     |
| Range int          | `random.randrange()`      |
| Pick one           | `random.choice(seq)`      |
| Pick many (unique) | `random.sample(seq, k)`   |
| Pick many (repeat) | `random.choices(seq, k)`  |
| Shuffle            | `random.shuffle(seq)`     |
| Normal dist        | `random.gauss(mu, sigma)` |
| Secure randomness  | `secrets.*`               |


