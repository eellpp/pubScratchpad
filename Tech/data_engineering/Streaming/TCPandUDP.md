### Differences in Data Transfer Features
TCP ensures a reliable and ordered delivery of a stream of bytes from user to server or vice versa. UDP is not dedicated to end to end connections and communication does not check readiness of receiver.

### Reliability
TCP is more reliable since it manages message acknowledgment and retransmissions in case of lost parts. Thus there is absolutely no missing data. UDP does not ensure that communication has reached receiver since concepts of acknowledgment, time out and retransmission are not present.

### Ordering
TCP transmissions are sent in a sequence and they are received in the same sequence. In the event of data segments arriving in wrong order, TCP reorders and delivers application. In the case of UDP, sent message sequence may not be maintained when it reaches receiving application. There is absolutely no way of predicting the order in which message will be received.

### Connection
TCP is a heavy weight connection requiring three packets for a socket connection and handles congestion control and reliability. UDP is a lightweight transport layer designed atop an IP. There are no tracking connections or ordering of messages.

### Method of transfer
TCP reads data as a byte stream and message is transmitted to segment boundaries. UDP messages are packets which are sent individually and on arrival are checked for their integrity. Packets have defined boundaries while data stream has none.

### Error Detection
UDP works on a "best-effort" basis. The protocol supports error detection via checksum but when an error is detected, the packet is discarded. Retransmission of the packet for recovery from that error is not attempted. This is because UDP is usually for time-sensitive applications like gaming or voice transmission. Recovery from the error would be pointless because by the time the retransmitted packet is received, it won't be of any use.

TCP uses both error detection and error recovery. Errors are detected via checksum and if a packet is erroneous, it is not acknowledged by the receiver, which triggers a retransmission by the sender. This operating mechanism is called Positive Acknowledgement with Retransmission (PAR).

### How TCP and UDP work
A TCP connection is established via a three way handshake, which is a process of initiating and acknowledging a connection. Once the connection is established data transfer can begin. After transmission, the connection is terminated by closing of all established virtual circuits.

UDP uses a simple transmission model without implicit hand-shaking dialogues for guaranteeing reliability, ordering, or data integrity. Thus, UDP provides an unreliable service and datagrams may arrive out of order, appear duplicated, or go missing without notice. UDP assumes that error checking and correction is either not necessary or performed in the application, avoiding the overhead of such processing at the network interface level. Unlike TCP, UDP is compatible with packet broadcasts (sending to all on local network) and multicasting (send to all subscribers).
