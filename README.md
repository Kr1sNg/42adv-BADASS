# BGP At Doors of Autonomous Systems is Simple

The purpose of this project is to deepen the knowledge of `NetPractice` by simulating several networks (VXLAN+BGP-EVPN) in GNS3.

## Introduction

### Basic Networking

- Modem: Translates the internet signal from your Internet service provider, so your home devices can use it.
- Switch: Adds more wired ports and smartly sends data only to the intended device (LAN network).
- Router: Spreads the connection, creates your local network and broadcasts Wifi.
- Hub: Outdated device that adds wired ports but broadcast data (as Switch, but) to all connected devices.

### GNS3 (Graphical Network Simulator-3)

What is GNS3?

- Graphical Network Simulator-3 (GNS3) is a free, open-source network software emulator released in 2008.
- It lets network professionals and students build, design, and test network scenarios in a risk-free virtual environment without physical hardware.
- It combines virtual devices, containers, and real network hardware.

Key Features:

- Multi-vendor support: Works with equipment from various vendors like Cisco, Juniper, HP, and Fortinet.
- Real and virtual integration: Connects simulated topologies to physical real-world networks.
- Certification prep: Acts as a study tool for exams like CCNA and other professional networking certifications.
- Packet analysis: Integrates with tools like Wireshark to inspect traffic passing between nodes.

### busybox

BusyBox is a single software executable that combines tiny, stripped-down versions of hundreds of common Unix and Linux commands into one file.

Often called the "Swiss Army knife of Embedded Linux," it replaces the massive collection of individual core utilities (like `ls`, `mv`, `grep`, `cat`, and `sh`) usually found in full desktop or server Linux distributions.

### daemon

In operating systems like Unix and Linux, a `daemon` handles routine or hidden tasks.

A daemon process is a background process that runs independently of any user control and performs specific tasks for the system. Daemons are usually started when the system starts, and they run until the system stops.

- It waits for specific triggers or events rather than running through an active user interface.
- Common examples include print spoolers, system loggers (syslogd), and network connection managers.
- Names of these programs often end with the letter `"d"` (syslogd, dockerd,...)

### zebra - multi-server routing software

Zebra is the core routing manager daemon historically from GNU Zebra, and now used as the central abstraction layer in modern routing suites like `FRRouting (FRR)` and its predecessor Quagga.

What Zebra Does?

- Kernel Abstraction: Acts as a middle layer between the underlying Unix/Linux kernel and separate routing protocol daemons (like OSPF, BGP, and IS-IS).
- **Route Management**: **Manages the Routing Table** or Routing Information Base (RIB), computes the best paths, and updates the kernel's Forwarding Information Base (FIB).
- Redistribution: Handles the redistribution of routes dynamically across different routing protocols.

Modern Successors:

- `FRRouting (FRR)`: The active, widely-used open-source fork where the `zebra` daemon continues to manage core routing state for protocols like `BGP`, `OSPF`, and `IS-IS`.

### bgpd

`bgpd` is a routing daemon for the _Border Gateway Protocol_ (BGP) that manages network routing tables and exchanges routing information with other systems.

### ospfd

`ospfd` is a background software program (daemon) that runs on a computer or router to handle dynamic network routing using the _Open Shortest Path First (OSPF) protocol_.

### IS-IS

The `IS-IS` (Intermediate System-to-Intermediate System) routing service is a link-state interior gateway protocol used by large service providers and enterprise networks to exchange routing information.

### OSI Model

The OSI Model (Open Systems Interconnection model) is a conceptual blueprint that splits computer network communication into seven distinct layers.

- Layer 7: Application Layer
  - Interacts directly with software applications (like web browsers or email clients).
  - Examples: HTTP, DNS, SMTP.
- Layer 6: Presentation Layer
  - Translates, encrypts, and compresses data so the receiving application can understand it.
  - Examples: SSL/TLS, JPEG, MP3.
- Layer 5: Session Layer
  - Opens, manages, and closes communication sessions between devices.
  - Examples: NetBIOS, APIs.
- Layer 4: Transport Layer
  - Ensures complete, reliable, and orderly delivery of data packets using error-checking.
  - Examples: TCP, UDP.
- Layer 3: Network Layer
  - Handles logical addressing (IP addresses) and routes data across different networks.
  - Examples: IP, routers.
- Layer 2: Data Link Layer
  - Organizes raw bits into frames and uses hardware (MAC) addresses for node-to-node delivery.
  - Examples: Ethernet, switches.
- Layer 1: Physical Layer
  - Transmits raw electrical, optical, or radio signals across physical cables or wireless media.
  - Examples: Cables, network hubs, radio frequencies.

### VLAN

A VLAN splits a single physical network switch into multiple virtual switches.

- How it works: It injects a small "tag" (VLAN ID) into the Ethernet frame. Only devices assigned to that specific ID can talk to each other.
- The Problem: Modern data centers have millions of virtual machines (VMs). A maximum of 4,094 networks is no longer enough. Additionally, VLANs require all interconnected switches to physically share the same Layer 2 (of OSI model) domain, which restricts flexibility.

### VXLAN - A framework for Overlaying Virtualized Layer 2 Networks over Layer 3 Networks

`VXLAN`, or `Virtual Extensible LAN`, is a network virtualization technology widely used on large Layer 2 (of OSI model) networks. VXLAN establishes a logical tunnel between the source and destination network devices, through which it uses MAC-in-UDP encapsulation for packets.

- How it works: It takes a standard Layer 2 (of OSI model) Ethernet frame and wraps it inside a Layer 4 (of OSI model) UDP packet.
- The Benefit: Because it uses standard IP packets, VXLAN traffic can travel across any standard routed network (like the internet or a massive corporate backbone). This allows virtual machines in different parts of a data center—or even different countries—to behave as if they are plugged into the exact same physical switch.

### VNI and VTEP

#### VNI

- VNI = VXLAN Network Identifier
- Similar function to VLANs
- Uniquely identifies a Layer 2 segment or domain

#### VTEP

- VTEP = VXLAN Tunnel Endpoint
- Device at which VXLAN encapsulation and decapsulation takes place
- Connected to the Underlay Network
- Creates tunneling mechanism for VXLAN



---

## Part 1: GNS3 configuration with Docker

### Host PC Image

- contains at least `busybox`

### Routeur Image

Requirements:

- zebra
- service BGDP active and configured
- service OSPFD active and configured
- IS-IS routing engine service
- busybox

```
Alpine Linux
├── BusyBox
├── FRRouting
│   ├── zebra
│   ├── bgpd       ← active
│   ├── ospfd      ← active
│   └── isisd      ← active
└── Docker/GNS3 networking
```

Pour le routeur, on prend une image `frrouting` avec dedans un logiciel appelé `FRRouting`, ou `FRR`. `FRR` transforme une machine Linux normale en routeur logiciel.

Un routeur, au fond, c’est une machine qui reçoit des paquets réseau (network packets) et décide :

- Ce paquet doit aller vers ce réseau.
- Par quelle interface dois-je l’envoyer ?

Pour prendre ces décisions, le routeur utilise `une table de routage`.

> A routing table, or routing information base (RIB), is a data table stored in a router or a network host that lists the routes to particular network destinations, and in some cases, metrics (distances) associated with those routes. The routing table contains information about the _topology_ of the network immediately around it.

> Network topology is the arrangement of the elements (links, nodes, etc.) of a communication network.

Dans FRR, chaque protocole est géré par un daemon séparé.

Le sujet demande explicitement de configurer différents daemon tel que :

- `zebra` → gérer la table de routage Linux
- `bgpd` → gérer BGP
- `ospfd` → gérer OSPF
- `isisd` → gérer ISIS

> Le `d` à la fin veut dire `daemon` !

#### `vtysh_enable=yes`

- `vtysh` provides a combined frontend to all FRR daemons in a single combined session.

### Add a network to a PC (host)

> In real life, it's automatic done by DHCP (Dynamic Host Configuration Protocol) inside Wifi/Internet Box.
> So we don't do that manually with new PC, new Internet Box, etc...

In case cannot connect directly from GNS3 Interface, using:

```
// /opt/homebrew/bin/telnet {IP address of host} {port}
telnet 192.168.64.13 5004
```

```bash
ip addr add 192.168.0.2/24 dev eth0
```

Means: "ajoute l'address 192.168.0.1/24 sur l'interface eth0"

- `ip`: l'outil réseau de Linux
- `addr`: "je veux travailler sur les addresses"
- `add`
- `192.168.0.2/24`: address and mask (in the same network with Router)
- `dev eth0`: on that specific network interface, eth0 short for first Ethernet (wired) network interface on Linux

```bash
ip link set eth0 up
```

Means: "active l'interface eth0"

```bash
ip addr show eth0 # to check if ip address is well added
ip route
```

### Configure a Router

> Of couse a Router can have multiple IP Addresses
> router has multiple ports or interfaces, it needs at least one unique IP address for every network segments or subnet it connects to.

In case cannot connect directly from GNS3 Interface, using:

```
// /opt/homebrew/bin/telnet {IP address of router} {port}
telnet 192.168.64.13 5000
```


- Using `vtysh` (vty shell) of `FRRouting`

```sh
vtysh

show interface

# put the mode config on
configure terminal

# choose interface eth
interface eth2 # interface connect to the host PC 1

# set an IP address to this interface
ip address 192.168.0.1/24   # in the same network with PC 1

# annule le shutdown = rallume l’interface
no shutdown

end # end configure terminal

exit # vtysh

ip addr show eth2 # to check if ip address is well added
ip route
```

To change ip address from one to other

```sh
# in router terminal (not vtysh)
ip addr del 192.144.0.2/24 dev eth2
ip addr add 192.168.0.2/24 dev eth2

ip addr show eth2
```

- To save config (IP address, etc)

```sh
vtysh

write memory
```

### Testing

1. Make sure there are 2 Docker images in VM: `host` and `router`.

2. Run `gns3server` on VM.

3. Connect to GNS3 Interface on host machine.

4. 

## Part 2: Discovering a VXLAN

### [Intro: Cours VXLAN](https://youtube.com/playlist?list=PLmVr8r1kmMm1LucO47Ch5CDJWgBb2X6YE&si=pRrnY0TlgMFllbFj)

### Step 0: Understand what you're building

The physical topology is one flat network `routeur_tat-nguy-1 eth0` ↔ `Switch_tat-nguy` ↔ `routeur_tat-nguy-2 eth0`.
This is the underlay, meaning ordianry IP connectivity between the two routeurs.

On top of it you build an overlay: a virtual Layer 2 segment (VXLAN, VNI 10) that makes `host_tat-nguy-1` and `host_tat-nguy-2` behave as if they were plugged into the same switch, even though routers sit between them.

Key terms to know:

- VTEP (VXLAN Tunnel End Point): each router. It encapsulates the host's Ethernet frame inside UDP/IP, sends it to the other VTEP, and decapsulates frames it receives.
- VNI (VXLAN Network Identifier): the 24-bit segment ID, here 10. VLANs only allow about 4096 IDs, while VXLAN allows about 16 million.
- UDP port 4789: the IANA-standard VXLAN port. Linux defaults to 8472 for legacy reasons, so always set `dstport 4789` explicitly.
- Bridge (`br0`): a software switch inside each router. It joins the host-facing port (`eth1`) and the tunnel interface (`vxlan10`), so frames from the host go into the tunnel and vice versa. It also learns MACs, which is what `brctl showmacs` displays.
- BUM traffic (Broadcast, Unknown unicast, Multicast): ARP requests, for example. The VTEP has to know where to send these.
  - Static mode: you hardcode the remote VTEP IP (`remote 10.1.1.2`).
  - Multicast mode: VTEPs join a multicast group (`239.1.1.1`) using IGMP, and BUM traffic is sent to the group. Any VTEP in the group receives it, with no need to list peers. This scales better than static mode.
- Encapsulation overhead is about 50 bytes (outer Ethernet 14 + IP 20 + UDP 8 + VXLAN 8). That's why `vxlan10` shows MTU 1450 in the subject's screenshots.

### Step 1: Addressing plan

| Device	| Interface |	IP  |	Role  |
|---------|-----------|-----|-------|
| routeur_tat-nguy-1	| eth0  |	10.1.1.1/24 |	underlay  |
| routeur_tat-nguy-1  |	eth1  | none  |	bridged to host |
| routeur_tat-nguy-2  | eth0  | 10.1.1.2/24 |	underlay
| routeur_tat-nguy-2  |	eth1  |	none  |	bridged to host |
| host_tat-nguy-1 |	eth1  |	30.1.1.1/24 |	overlay |
| host_tat-nguy-2 |	eth1  |	30.1.1.2/24 |	overlay |

The hosts sit in the same subnet with no gateway. That proves the traffic is pure Layer 2 across the tunnel.

### Step 2: Build the topology in GNS3

1. Create a new project named `P2`.

2. Drag in two routers (your FRR image), two hosts (your Alpine/busybox image), and a built-in Ethernet switch. The switch needs no configuration.

3. Rename them `routeur_tat-nguy-1`, `routeur_tat-nguy-2`, `host_tat-nguy-1`, `host_tat-nguy-2`, and `Switch_tat-nguy`.

4. Make sure each Docker node has enough adapters. Right-click → Configure → Adapters: set `4` for the routers, and `2` for the hosts if you use `eth1`.

5. Cable it like the subject diagram:
  - `routeur_tat-nguy-1 eth0` → `Switch_tat-nguy e0`
  - `routeur_tat-nguy-2 eth0` → `Switch_tat-nguy e1`
  - `routeur_tat-nguy-1 eth1` → `host_tat-nguy-1 eth1`
  - `routeur_tat-nguy-2 eth1` → `host_tat-nguy-2 eth1`

6. Start all nodes and open their consoles.

```sh

# /opt/homebrew/bin/telnet {IP address of router} {port}
telnet 192.168.64.13 5013
```

### Step 3: Static mode configuration

`routeur_tat-nguy-1` (save as `P2/_tat-nguy-1_s`):

```sh
# Underlay: give eth0 an IP to reach the other VTEP
ip addr add 10.1.1.1/24 dev eth0
ip link set eth0 up

# VXLAN interface, VNI 10, unicast tunnel to the remote VTEP
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.1 remote 10.1.1.2 dstport 4789
ip link set vxlan10 up

# Bridge joining host-facing port and tunnel
ip link add br0 type bridge
ip link set br0 up
ip link set eth1 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

`routeur_tat-nguy-2` (save as `P2/_tat-nguy-2_s`): the same script with `10.1.1.2` as the `eth0` address and `local`, and remote `10.1.1.1`.

```sh
# Underlay: give eth0 an IP to reach the other VTEP
ip addr add 10.1.1.2/24 dev eth0
ip link set eth0 up

# VXLAN interface, VNI 10, unicast tunnel to the remote VTEP
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
ip link set vxlan10 up

# Bridge joining host-facing port and tunnel
ip link add br0 type bridge
ip link set br0 up
ip link set eth1 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

`host_tat-nguy-1` (save as `P2/_tat-nguy-1_host`):

```sh
ip addr add 30.1.1.1/24 dev eth1
ip link set eth1 up
```

`host_tat-nguy-2` (save as `P2/_tat-nguy-2_host`): the same, with `30.1.1.2/24`.

```sh
ip addr add 30.1.1.2/24 dev eth1
ip link set eth1 up
```

#### Test static mode

Run these checks in order:

1. From `routeur_tat-nguy-1`, run `ping 10.1.1.2`. If this fails, stop and fix it first. The underlay must work before the overlay can.

2. From `host_tat-nguy-1`, run `ping 30.1.1.2`. You should get replies.

3. In GNS3, right-click the link `routeur_tat-nguy-1 eth0 ↔ Switch_tat-nguy` → Start capture. In Wireshark you should see:
  - an outer IP header `10.1.1.1 → 10.1.1.2`
  - UDP destination port 4789
  - a VXLAN header showing VNI 10
  - an inner frame carrying ICMP `30.1.1.1 → 30.1.1.2`
This matches the subject screenshot on page 8.

If Wireshark shows the packet as plain UDP, right-click it → Decode As → UDP 4789 → VXLAN.

### Step 4: Dynamic multicast mode

Only the router's VXLAN line changes.

`routeur_tat-nguy-1` (save as `P2/_tat-nguy-1_g`):

```sh
# Remove old interface first
ip link del vxlan10
ip link del br0

ip addr add 10.1.1.1/24 dev eth0
ip link set eth0 up

# Multicast group instead of a fixed remote peer
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip link set vxlan10 up

ip link add br0 type bridge
ip link set br0 up
ip link set eth1 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

`routeur_tat-nguy-2` (save as `P2/_tat-nguy-2_g`): the same script with `10.1.1.2/24`.

```sh
# Remove old interface first
ip link del vxlan10
ip link del br0

ip addr add 10.1.1.2/24 dev eth0
ip link set eth0 up

# Multicast group instead of a fixed remote peer
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip link set vxlan10 up

ip link add br0 type bridge
ip link set br0 up
ip link set eth1 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

The `dev eth0` part is mandatory in multicast mode. It tells the kernel which interface should join the IGMP group.

#### Test multicast mode

1. From `host_tat-nguy-1`, run `ping 30.1.1.2` again.

2. Capture on the underlay link. The first ARP request now goes to destination `239.1.1.1`, with a multicast MAC starting `01:00:5e:...`. After both sides learn each other, the ICMP replies go unicast between `10.1.1.1` and `10.1.1.2`. That behavior is called flood-and-learn, and it matches the subject screenshot on page 9.

3. On each router, run `ip -d link show vxlan10`. The output should include `vxlan id 10 group 239.1.1.1 dev eth0 ... dstport 4789`.

4. On each router, run `brctl showmacs br0` (or `bridge fdb show br br0`). The table lists:
  - local MACs (`is local? yes`): the bridge's own ports
  - learned remote MACs (`no`) with an ageing timer
The remote host's MAC should appear behind the `vxlan10` port number.

5. Optionally run `bridge fdb show dev vxlan10`. It shows which remote VTEP IP each MAC was learned from, which is a good thing to show at defense.

### Step 5: Making configs reproducible

Containers in GNS3 lose runtime config when stopped, so keep your scripts as the source of truth. You have two practical options:

- Paste each script into the node console when you demo. It's simple and the evaluator sees exactly what happens.

- Push them from the VM:

```sh
docker exec -i <container_id> sh < P2/_tat-nguy-1_s
```

Use `docker ps` to find which container belongs to which GNS3 node. The hostname matches the node name.

Add comments to every file, as the subject asks. The comments in the scripts above are a good baseline.

### Step 6: Export and submit

1. In GNS3, go to File → Export portable project. Choose Zip compression and check Include base images. Save it as `P2/P2.gns3project`.

2. Check the export with file `P2/P2.gns3project`. It should say "Zip archive data".

3. Your P2 folder should contain:

```
   P2/P2.gns3project
   P2/_tat-nguy-1_host   P2/_tat-nguy-2_host
   P2/_tat-nguy-1_s      P2/_tat-nguy-2_s      # static mode
   P2/_tat-nguy-1_g      P2/_tat-nguy-2_g      # group / multicast mode
```

4. Commit and push.

### Common pitfalls

- Host ping fails in both modes. Check the underlay ping first. Then check that every interface is `up`, including `eth1`, `br0`, and `vxlan10`. Downed interfaces are the number one cause.

- Wireshark shows no VXLAN. You probably forgot `dstport 4789`, so the traffic uses port 8472.

- Multicast mode never learns. You probably left out `dev eth0`, or the old static `vxlan10` still exists. Check with `ip -d link show`.

- Evaluator asks why routers have no IP on `eth1`. Because it's a bridge port. The router forwards Layer 2 frames there and doesn't route them.

- Evaluator asks why the hosts need no gateway. Because both hosts are in the same broadcast domain, stretched across the tunnel.

Once this works, Part 3 reuses this same VXLAN 10 and bridge setup. It replaces flood-and-learn with BGP EVPN, which advertises MACs through type 2 routes and VTEPs through type 3 routes, so keep these scripts handy.

## Part 3: Discovering BGP with EVPN

## Additional Information

### Docker commands

- Build Docker image: `docker build -t my-username/my-image .`

```
