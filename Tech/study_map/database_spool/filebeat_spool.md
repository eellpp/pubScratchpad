Filebeat originally had a **“spool file”** feature (basically a simple disk buffer of events before shipping). That was later deprecated and replaced with the **“disk queue”**. The change wasn’t just renaming — the disk queue is a new subsystem designed to fix shortcomings in the spool file.

Here’s the breakdown:

---

## 1. Spool File (old model)

* **Design**: Filebeat collected events into a memory spool. Once full, they were flushed as batches, optionally persisted to disk (spool file).
* **Issues**:

  * **No backpressure control**: If the downstream (e.g., Elasticsearch, Logstash) slowed down, the spool file could grow but didn’t handle flow control gracefully.
  * **Durability gaps**: Crash recovery could lose the “last batch” (not fsynced yet).
  * **Limited visibility/metrics**: Hard to know how much was queued, oldest event age, etc.
  * **Scaling issues**: It was optimized for log batching, but not for long-running queues or high-volume edge cases.
  * **Rigid lifecycle**: Once a spool file reached its limit, Filebeat basically stopped until the batch was shipped.

---

## 2. Disk Queue (new model)

* **Design**: A proper, append-only, segment-based queue on disk (very much like Kafka/Chronicle Queue patterns).
* **Advantages**:

  * **Durable, crash-safe**: Every record is written with framing, fsynced; recovery is guaranteed.
  * **Backpressure built-in**: Producer is blocked (or drops per policy) when queue reaches configured size.
  * **Configurable retention**: Size- and time-based policies, predictable disk usage.
  * **Better metrics**: Exposes queue depth, disk usage, oldest event age → integrates with monitoring.
  * **Consumer acknowledgment model**: Events only dropped from the queue once downstream confirms success. This gives stronger at-least-once delivery.
  * **Multi-segment architecture**: Avoids large monolithic files → faster GC, rotation, and less corruption risk.
  * **Future extensibility**: Basis for multi-input/output pipelines in Beats.

---

## 3. Why deprecate spool file

* **Maintainability**: Disk queue is a unified, general-purpose queue; maintaining two different buffering systems (spool + queue) was extra complexity.
* **Correctness**: Spool file could lose data on crashes or force weird batching semantics. Disk queue fixes that with transactional appends.
* **Operational clarity**: “Disk queue” matches user expectation (“durable message queue on disk”) much better than “spool file,” which was confusing (people thought “print spooler” style).
* **Consistency across Beats**: Metricbeat, Winlogbeat, etc., all benefit from one reliable disk queue implementation instead of per-beat hacks.

---

✅ **In short**:
The spool file was a *stopgap buffering hack*; the disk queue is a *first-class, durable message queue* integrated into Filebeat. It offers stronger guarantees (at-least-once, durability, observability), better flow control, and easier maintenance — so Elastic moved everyone to the disk queue and deprecated the spool file.

---

Would you like me to also show you **internals of Filebeat disk queue design** (segment files, ACK handling, recovery), so you can compare it directly to the “spool queue” design we just discussed? That way you’ll see how Filebeat solved the same issues we were talking about.
