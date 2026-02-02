Below is a **short, clean, no-fluff user guide** that builds the **minimum mental model** you need to understand **SCD-2** correctly.

---

# 1. Core concepts (must understand first)

Every column in a data model is **one of three things**:

## 1️⃣ Keys — identity & linkage

**Purpose:** identify and connect records

* **Business (natural) key**
  Real-world ID
  e.g. `customer_id`, `product_id`

* **Surrogate key**
  Warehouse-generated ID
  e.g. `customer_sk`, `product_sk`

* **Foreign key**
  Reference to another table’s key

**Rules**

* Keys are **not analyzed**
* Keys are **not aggregated**
* Facts point to **surrogate keys**, not business keys

---

## 2️⃣ Dimensions — descriptive context

**Purpose:** describe *who / what / where / how*

Examples:

* `city`
* `customer_type`
* `product_category`
* `status`
* `plan`

**Rules**

* Used for grouping & filtering
* Usually change slowly
* Live in **dimension tables**
* Can have history (SCD)

---

## 3️⃣ Facts — events & measurements

**Purpose:** capture *what happened*

Examples:

* `price`
* `quantity`
* `revenue`
* `duration`
* `count`

**Rules**

* Numeric & aggregatable
* Occur at a point in time
* Usually immutable
* Live in **fact tables**

---

### Classification shortcut (use this always)

| Question             | Answer        |
| -------------------- | ------------- |
| Identifies or links? | **Key**       |
| Can I SUM it?        | **Fact**      |
| Descriptive context? | **Dimension** |

---

# 2. Why SCD-2 exists

**Problem:**
Dimensions change, but facts must remain historically correct.

**Wrong approach**

* Overwriting dimension values destroys history

**SCD-2 solution**

> **Keep multiple versions of a dimension row, each valid for a time period**

---

# 3. What SCD-2 is (one sentence)

> **SCD-2 tracks dimension changes by inserting new rows and time-bounding old ones.**

---

# 4. Minimal SCD-2 structure

A Type-2 dimension needs:

* `surrogate_key`
* `business_key`
* dimension attributes
* `start_date`
* `end_date` (NULL = current)
* *(optional)* `is_current`

---

# 5. Small example

## Customer dimension (SCD-2)

| customer_sk | customer_id | city      | start_date | end_date   |
| ----------- | ----------- | --------- | ---------- | ---------- |
| 1           | C001        | Singapore | 2023-01-01 | 2024-05-31 |
| 2           | C001        | London    | 2024-06-01 | NULL       |

**Meaning**

* Same customer
* Two valid versions
* Only one active at a time

---

## Fact table

| purchase_id | customer_sk | amount | purchase_date |
| ----------- | ----------- | ------ | ------------- |
| P1001       | 1           | 100    | 2024-03-01    |

**Meaning**

> This purchase belongs to the **Singapore version** of the customer.

---

# 6. The golden rule of SCD-2

> **Facts must link to the dimension version that was valid when the fact occurred.**

That’s why:

* Facts store **surrogate keys**
* Not business keys
* Not dimension attributes

---

# 7. How queries work

### Current view

```sql
WHERE end_date IS NULL
```

### As-of view

```sql
WHERE '2024-03-01' BETWEEN start_date AND end_date
```

---

# 8. When to use SCD-2

Use it when:

* Historical accuracy matters
* Dimension changes affect analysis

Examples:

* Customer location
* Employee department
* Product category
* Pricing tier

---

# 9. When NOT to use SCD-2

Avoid it when:

* History is irrelevant
* Only latest value matters
* Changes happen extremely frequently

Use:

* **SCD-1** (overwrite) or
* Event tables instead

---

# 10. One-page mental model

```
FACT  = event
DIM   = context
KEY   = glue

FACT → DIM (specific version)
DIM → time-bounded truth
```

---

## Final takeaway (memorize this)

> **Keys identify, dimensions describe, facts measure — and SCD-2 preserves how dimensions were true at the time facts happened.**
