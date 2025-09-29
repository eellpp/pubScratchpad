
## What is the role of kafka consumer group ? How does kafka handle message consumption in a consumer group

A consumer group is a **shared cursor per partition** with automatic **membership, assignment, and recovery**, giving you parallelism (by partitions), ordering (within a partition), and resilience—with offsets as the durable progress marker.

#### What a Kafka **consumer group** does

* **Scales reads:** All consumers with the same `group.id` share the work of a topic. Each **partition** is assigned to **at most one** consumer in the group, so they can read in parallel.
* **Keeps ordering where it matters:** Ordering is guaranteed **within a partition** (since only one group member reads that partition).
* **Fault-tolerance:** If a consumer in the group dies, its partitions are reassigned to the remaining members and processing continues.
* **Independent audiences:** Different groups read the same topic **independently**. A message can be processed once per group (e.g., `billing-service` group and `analytics-service` group).

#### How Kafka handles consumption inside a group

1. **Join & coordinate**

   * Each consumer joins the group (`group.id`) and talks to a **Group Coordinator** (a broker).
   * The coordinator runs a **rebalance** to decide which partitions go to which consumer.

2. **Partition assignment strategies**

   * Common assignors: **Range**, **RoundRobin**, **Sticky**, and **CooperativeSticky** (incremental, minimizes stop-the-world rebalances).
   * Rules of thumb:

     * Partitions ≥ consumers → some consumers get multiple partitions.
     * Consumers > partitions → some consumers will be idle.

3. **Polling & heartbeats**

   * Your code calls `poll()` in a loop. A background heartbeat thread (or `poll()` itself) keeps session with the coordinator alive.
   * If heartbeats stop (`session.timeout.ms` / `max.poll.interval.ms`), the coordinator **revokes** partitions and triggers a rebalance.

4. **Offsets (progress tracking)**

   * Each partition has a **consumer offset** (the next record to read) stored in `__consumer_offsets` (a compacted internal topic).
   * **Commit modes:**

     * **Auto-commit** (`enable.auto.commit=true`): simple, but less precise.
     * **Manual commit** (`commitSync`/`commitAsync`): commit after you finish processing to get **at-least-once**.
   * **Delivery semantics:**

     * **At-least-once (default good practice):** process → commit. Possible duplicates if you crash after processing but before commit—handle with idempotency on the sink.
     * **At-most-once:** commit → process. No duplicates, but possible data loss if you crash during processing.
     * **Exactly-once (EOS):** use **transactional producers + read-process-write transactions** (or Kafka Streams). The consumer reads committed data and the producer writes atomically to outputs and offsets.

5. **Rebalancing**

   * Happens when group membership or subscribed partitions change.
   * With **cooperative** rebalancing, members can **incrementally** revoke/assign just the delta, reducing pauses.
   * On rebalance, consumers get `onPartitionsRevoked`/`onPartitionsAssigned` callbacks (in Java) to flush/commit before losing ownership.

6. **Backpressure & flow control**

   * Tune `max.poll.records`, `max.partition.fetch.bytes`, pause/resume partitions in code for slow downstreams.
   * Monitor **consumer lag** (difference between latest log end offset and committed/consumed offset) to see if the group keeps up.

7. **Failure handling**

   * If a consumer crashes: coordinator reassigns its partitions; another consumer continues from the **last committed offset**.
   * If a broker with a partition leader fails: Kafka elects a new leader; consumer transparently resumes after metadata refresh.


#### Mental model in one line


