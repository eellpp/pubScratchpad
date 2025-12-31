# 🌐 DNS — The Foundation

## **DNS Server (Domain Name System Server)**

Think of DNS as the **phonebook of the internet**.

* Humans use names: `google.com`, `youtube.com`
* Computers need IP addresses: `142.250.183.14`

A DNS server’s job:
➡️ Convert domain name → IP address
➡️ Return it to your device so it can connect

Every device uses DNS:

* Router DNS
* ISP DNS
* Google DNS (8.8.8.8)
* Cloudflare DNS (1.1.1.1)

Without DNS, typing a website name would not work.

---

# 🚫 DNS Filtering / DNS Sinkhole

## **DNS Filtering Solution**

Instead of blindly resolving everything, it checks:

> “Is this domain safe? Is it an ad? Is it a tracker? Is it malware?”

If it’s bad:
❌ returns nothing / blocks it

If safe:
✔️ returns real IP

So:

* Ads don’t load
* Trackers can’t send data
* Malicious domains are stopped early

Pi-hole = DNS server + filtering brain.

This is why Pi-hole blocks ads in:

* Apps
* Smart TVs
* Browsers
* Games
* Phones
* All devices

Because everything uses DNS.

---

# 🧠 DHCP — Who Gives IP Addresses?

## **DHCP Server (Dynamic Host Configuration Protocol)**

When a device joins your network (WiFi or LAN), it asks:

> “Can someone give me IP, Gateway, DNS, etc.?”

The **DHCP server** replies with:

* Device IP address
* Router gateway
* DNS Server
* Lease time

Normally your router is DHCP server.

### Why Pi-hole sometimes becomes DHCP server?

Some routers **don’t let you force devices** to use Pi-hole DNS.
Then you can:

* Disable DHCP in router
* Enable DHCP in Pi-hole

Now every device automatically uses Pi-hole DNS 🎯

---

# 🔐 Securing DNS Queries

Normally DNS requests are:
❌ Unencrypted
❌ Visible to ISP
❌ Can be snooped / modified

So new secure DNS standards were created.

---

## **DoH — DNS over HTTPS**

DNS queries travel encrypted inside **HTTPS traffic**.

Meaning:

* Looks like normal web browsing
* Hidden from ISP / snoopers
* Harder to block or spy on

Uses port **443**

---

## **DoT — DNS over TLS**

Same idea, but uses:

* A dedicated encryption layer (TLS)
* Uses port **853**

It’s cleaner and more “pure DNS security”, but easier to firewall-block than DoH.

### So summary:

| Feature              | DoH        | DoT              |
| -------------------- | ---------- | ---------------- |
| Encryption           | ✔️         | ✔️               |
| Uses HTTPS           | ✔️         | ❌                |
| Uses TLS             | indirectly | directly         |
| Default Port         | 443        | 853              |
| Hard to block by ISP | ✔️         | ❌                |
| Performance          | Good       | Fast & efficient |

Pi-hole can use:

* Cloudflare (1.1.1.1)
* Quad9
* Google DNS
* NextDNS
* etc.

over DoH or DoT as **upstream encrypted DNS**.

---

# 🏡 Conditional Forwarding

Imagine this:
You see `192.168.1.23` in Pi-hole dashboard.
You want to know who that is.
Laptop? TV? Phone?

But device names are stored on your router / local DNS.

### Conditional forwarding means:

“If the domain/IP belongs to my local home network → ask the router instead of external DNS”.

Result:
✔️ Instead of IPs, you see device names like:

* `john-laptop.local`
* `livingroom-tv`
* `iphone13`

This makes logs meaningful.

---

# 🧩 How These Fit Together in Pi-hole

When Pi-hole is your DNS:

1️⃣ Your device asks Pi-hole for domain
2️⃣ Pi-hole checks blocklists
3️⃣ If blocked → returns nothing
4️⃣ If safe → forwards to upstream DNS (Cloudflare / Google / ISP / DoH / DoT)
5️⃣ That DNS returns IP
6️⃣ Pi-hole sends IP to your device
7️⃣ Device connects to site

Optional:

* If Pi-hole is DHCP → devices automatically use it
* If Conditional Forwarding → devices show by name
* If DoH/DoT → privacy + encryption

---

# ✅ One-Line Summaries

* **DNS Server** → Converts website names to IPs
* **DNS Filtering** → Blocks bad / ad / tracking DNS requests
* **DHCP Server** → Gives devices IP + DNS settings
* **DoH** → DNS encrypted inside HTTPS
* **DoT** → DNS encrypted using TLS
* **DNS-over-HTTPS / TLS** → Stops spying / snooping on DNS
* **Conditional Forwarding** → Shows local device names instead of IPs



Just tell me 👍
