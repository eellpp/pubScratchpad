# 🗺️ Study Map Across Books

### **Stage 1: Foundations (OS & Spooling Origins)**

* **Tanenbaum – *Operating Systems: Design & Implementation***

  * Ch. 5 – *Input/Output* → history of **spooling** (printers, batch systems).
  * Ch. 6 – *File Systems* → buffering, sync vs async writes (precursor to fsync).

---

### **Stage 2: Storage Engines and Queues (Modern Abstractions)**

* **Kleppmann – *Designing Data-Intensive Applications***

  * Ch. 3 – *Storage and Retrieval* → log-structured storage, segment files (spool queues).
  * Ch. 5 – *Replication* → logs as disk queues between replicas.
  * Ch. 11 – *Stream Processing* → Kafka-style append-only queues, commit offsets.

---

### **Stage 3: Database Internals (Durability Guarantees)**

* **Hellerstein, Stonebraker – *Architecture of a Database System***

  * Sec. 2 – *Storage & Buffer Management* → how DBs spool to disk buffers.
  * Sec. 3 – *Transaction Management* → WAL (append-only disk log).
  * Sec. 6 – *Logging & Recovery* → crash-safe logs, checkpoints, segment recycling.

---

### **Stage 4: Disk-Level Mechanics (Algorithms & Access Patterns)**

* **Healey – *Disk-Based Algorithms for Big Data***

  * Ch. 2 – *External Memory Models* → random vs sequential I/O, batching.
  * Ch. 3 – *Sorting and Merging* → classic **spool file merges**.
  * Ch. 7 – *Streaming Algorithms* → spill-to-disk strategies.

---

### **Stage 5: Performance & fsync in Practice**

* **Brendan Gregg – *Systems Performance***

  * Ch. 4 – *CPU, Memory, and I/O* → page cache, fsync explained.
  * Ch. 5 – *Filesystems* → journaling, log replay, sync semantics.
  * Ch. 7 – *Disk I/O* → queue depths, latency, workload tuning.

---

# ✅ Recommended Reading Order

1. **Tanenbaum** (Ch. 5, 6) → Why spooling exists.
2. **Kleppmann** (Ch. 3, 5, 11) → Modern log-structured storage and queues.
3. **Hellerstein DB Architecture** (Sec. 2, 3, 6) → Implementation of durable spool-like logs.
4. **Healey** (Ch. 2, 3, 7) → Disk access models and algorithmic consequences.
5. **Gregg** (Ch. 4, 5, 7) → OS-level mechanics of fsync and queue performance.
