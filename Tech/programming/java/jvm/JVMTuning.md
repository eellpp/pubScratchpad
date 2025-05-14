

* **Avoid over-provisioning heap**.
* **Reduce unused buffers, caches, and thread stacks**.
* **Tune GC and memory pools** so that allocated memory is needed, not just reserved.

---

## 🛠️ Strategies to Reduce Non-Active Memory in Java 17

### 1. **Right-Size the Heap (`-Xmx`, `-Xms`)**

* Avoid large `-Xmx` unless you're actually using that much memory.
* Match `-Xmx` to **expected peak active memory usage** (add 20-30% headroom).
* Don’t use `-Xms = -Xmx` unless you know it’s fully required. Otherwise, JVM commits the whole heap upfront, inflating RSS even when mostly unused.

✔️ **Tip**: Let the JVM grow the heap gradually if active memory demand is unpredictable.

---

### 2. **Use G1GC (default in Java 17) with Proper Tuning**

G1GC is optimized for applications with large heaps and concurrent processing.

You can tune it to shrink unused regions:

```sh
-XX:+UseG1GC
-XX:MaxHeapFreeRatio=20
-XX:MinHeapFreeRatio=5
```

These tell JVM to **shrink the heap** when a large portion of it is unused. This helps reduce resident size.

---

### 3. **Enable Heap Shrinking at Runtime**

Make sure heap is not pinned in memory:

```sh
-XX:+ShrinkHeapInSteps
-XX:+ExplicitGCInvokesConcurrent
```

If your app goes through memory spikes (e.g., Kafka batch bursts), this helps JVM **return memory to OS** when usage dips.

---

### 4. **Tune Metaspace and Thread Stack Size**

Java apps often use more memory than heap due to:

* **Metaspace**
* **Thread stacks**
* **Buffers (especially in Kafka)**

Control metaspace and thread stack size:

```sh
-XX:MaxMetaspaceSize=128m
-Xss512k
```

---

### 5. **Control Buffer Allocations (Netty, Kafka, NIO)**

Kafka clients use **off-heap ByteBuffers**:

* Monitor and limit **off-heap allocation**.
* Use `-XX:MaxDirectMemorySize` to control this:

```sh
-XX:MaxDirectMemorySize=256m
```

Also check:

* Kafka consumer `fetch.max.bytes`
* Batch size in stream processing framework
* Temporary buffers used in S3 clients

---

### 6. **Monitor `smaps_rollup` Per Process**

To correlate JVM tuning and Linux memory footprint:

```bash
grep -E 'Private|Shared|Active' /proc/<pid>/smaps_rollup
```

---

## Example Java Options for Real-Time Streaming with Low Non-Active Memory

```sh
-Xmx2g
-XX:+UseG1GC
-XX:MaxHeapFreeRatio=20
-XX:MinHeapFreeRatio=5
-XX:+ShrinkHeapInSteps
-XX:+ExplicitGCInvokesConcurrent
-XX:MaxDirectMemorySize=256m
-XX:MaxMetaspaceSize=128m
-Xss512k
```

---

## 📉 Pros and Cons of Reducing Non-Active Memory

| ✅ **Pros**                           | ⚠️ **Cons / Tradeoffs**                        |
| ------------------------------------ | ---------------------------------------------- |
| Reduces memory waste (RSS shrink)    | Can cause more GC activity if heap too small   |
| Better behavior in container/cloud   | Risk of OOM if not enough buffer for spikes    |
| Less memory pressure on host         | Shrinking heap may cause latency spikes        |
| Easier monitoring/debugging          | Kafka bursts or S3 write retries may overwhelm |
| Better JVM-to-Linux memory alignment | Less tolerance for memory fragmentation        |

---

## 🧠 When Is It Worth Doing?

* ✅ Your app **memory usage is spiky**, but mostly low.
* ✅ You're running in **containers with hard memory limits**.
* ✅ You want **real-time performance** and **predictable footprint**.

But if you're on a **large, memory-rich VM** and GC pause latency is more critical than memory waste, then **you may benefit from a bigger heap and let JVM hold it**.

---

### 📄 What is `smaps_rollup`?

`/proc/<pid>/smaps_rollup` is a **Linux kernel interface** that provides a **summary view** of a process's memory usage — specifically, a **rolled-up (aggregated)** version of the detailed `/proc/<pid>/smaps`.

---

### 🔍 Why It Exists

* `/proc/<pid>/smaps` gives **per-memory-region** statistics (e.g., heap, stack, mmap'd files).
* But parsing all regions can be **slow** and **inefficient**, especially for Java or big apps with thousands of mappings.
* `/proc/<pid>/smaps_rollup` was introduced to provide **fast, aggregated totals** for the entire process.

---

### 📌 Location

```bash
/proc/<pid>/smaps_rollup
```

Only exists in **Linux kernel 4.15+**, and only if your distro enables it.

---

### 🧠 What It Shows

Example:

```bash
$ grep -E 'Size|Rss|Pss|Shared|Private|Referenced|Anonymous|LazyFree|Active|Inactive' /proc/1234/smaps_rollup
Size:              123456 kB
Rss:               102400 kB
Pss:               101200 kB
Shared_Clean:        3000 kB
Shared_Dirty:        2000 kB
Private_Clean:       5000 kB
Private_Dirty:      92400 kB
Referenced:        100000 kB
Anonymous:          97000 kB
LazyFree:               0 kB
Active:             85000 kB
Inactive:           18000 kB
```

---

### 🔎 Key Fields Explained

| Field        | What It Means                                             |
| ------------ | --------------------------------------------------------- |
| `Rss`        | **Resident Set Size** — total memory currently in RAM     |
| `Private_*`  | Memory exclusive to the process (not shared)              |
| `Shared_*`   | Memory shared with other processes (like libraries)       |
| `Active`     | Pages recently used (hot memory)                          |
| `Inactive`   | Pages not used recently (can be swapped out)              |
| `Anonymous`  | Pages not backed by a file (e.g., heap, malloc)           |
| `Pss`        | Proportional Set Size — a fair share of shared memory     |
| `Referenced` | Pages recently referenced (GC cycles, buffer usage, etc.) |

---

### ✅ Use Cases (Especially for Java Apps)

* Measure **actual private memory** used vs shared libraries
* Understand **hot vs cold** memory (Active vs Inactive)
* Track memory leaks or uncollected buffers
* Tune JVM to make RSS reflect true active working set

---

### 🧪 Example Command

```bash
grep -E 'Rss|Private|Shared|Active|Inactive' /proc/<pid>/smaps_rollup
```

Or per-field:

```bash
cat /proc/<pid>/smaps_rollup | awk '/Private/ {p+=$2} /Shared/ {s+=$2} /Active:/ {a+=$2} END {print "Private:", p, "Shared:", s, "Active:", a}'
```



### JVM Tuning

https://dzone.com/articles/java-performance-tuning

