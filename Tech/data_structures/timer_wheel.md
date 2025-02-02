

The **timer wheel** (also known as a **timing wheel**) is a data structure used to efficiently manage and schedule timers in systems where a large number of timers need to be handled, such as in operating systems, networking stacks, or real-time systems. It is particularly useful for managing timeouts, delays, and periodic events.

### Key Concepts of Timer Wheel

1. **Timers**:
   - A timer is a mechanism to trigger an event after a specified amount of time has elapsed.
   - Timers are often used for tasks like retransmission in networking, garbage collection, or scheduling periodic tasks.

2. **Challenges with Timers**:
   - Managing a large number of timers efficiently can be challenging, especially when timers expire at different times.
   - Naive approaches (e.g., using a sorted list or priority queue) can have high time complexity for insertion, deletion, and expiration handling.

3. **Timer Wheel Structure**:
   - A timer wheel is a circular buffer (array) divided into "slots" or "buckets," each representing a time interval.
   - Each slot contains a list of timers that expire in that time interval.
   - The wheel "ticks" at regular intervals, advancing the current position and processing timers in the current slot.

4. **Components**:
   - **Wheel Granularity**: The time interval represented by each slot (e.g., 1ms, 10ms).
   - **Wheel Size**: The number of slots in the wheel, which determines the maximum time range the wheel can handle.
   - **Current Pointer**: Points to the current slot being processed.
   - **Timer Lists**: Each slot contains a list of timers that expire in that slot's time range.

5. **How It Works**:
   - When a timer is added, its expiration time is mapped to a specific slot in the wheel.
   - As time progresses, the wheel's current pointer advances, and timers in the current slot are processed (e.g., expired timers are executed or removed).
   - If a timer's expiration time exceeds the wheel's range, it is placed in an overflow structure (e.g., a hierarchical timer wheel).

6. **Hierarchical Timer Wheels**:
   - For systems requiring a wide range of timer durations, multiple levels of timer wheels can be used.
   - Each level represents a different granularity (e.g., milliseconds, seconds, minutes).
   - Timers are cascaded from higher-level wheels to lower-level wheels as time progresses.

### Example

Consider a simple timer wheel with:
- 8 slots (0 to 7).
- Each slot represents 1 second.
- Current pointer at slot 0.

- If a timer is set to expire in 3 seconds, it is placed in slot 3.
- After 1 second, the pointer moves to slot 1, and timers in slot 0 are processed.
- After 3 seconds, the pointer reaches slot 3, and the timer is processed.

### Advantages
- **Efficiency**: Insertion, deletion, and expiration handling are O(1) in the best case.
- **Scalability**: Can handle a large number of timers efficiently.
- **Low Overhead**: Minimal CPU and memory usage compared to other data structures like heaps or lists.

### Use Cases
- Operating systems (e.g., Linux kernel's timer management).
- Networking protocols (e.g., TCP retransmission timers).
- Real-time systems and event-driven applications.

### Limitations
- Fixed granularity may not suit all use cases.
- Requires careful tuning of wheel size and granularity for optimal performance.

In summary, the timer wheel is a highly efficient data structure for managing timers, especially in systems with high timer density and strict performance requirements.

**Use Cases **
- https://adriacabeza.github.io/2024/07/12/caffeine-cache.html In Caffeine cache . Hierarchical Timer Wheel: TimerWheel.java . Hierarchical Timer Wheel: TimerWheel.java.
In the case of Caffeine, the entries are added to these buckets based on their expiration times, allowing efficient addition, removal and expiration in O(1) time. Each bucket contains a linked list where the items are added. Given that the circular buffer size is limited, we would have problems when an event needs to be scheduled for a moment in future larger than the size of the ring. That is why we use a hierarchical timer wheel which simply layers multiple timer wheels with different resolutions.
