# BGP At Doors of Autonomous Systems is Simple

The purpose of this project is to deepen the knowledge of `NetPractice` by simulating several networks (VXLAN + BGP-EVPN) in GNS3.

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

### BGP EVPN (Border Gateway Protocol - Ethernet Virtual Private Network)

RFC 7432 defines BGP EVPN (Ethernet Virtual Private Network), a standards-based control plane protocol that uses Multiprotectocol Border Gateway Protocol (MP-BGP) to advertise Layer 2 MAC addresses and Layer 3 IP bindings.

RFC 7432 introduces specific EVPN Route Types encapsulated in MP-BGP Network Layer Reachability Information (NLRI):

- Type 1 (Ethernet Auto-Discovery Route): Used for fast convergence and aliasing on multi-homed Ethernet segments.
- Type 2 (MAC/IP Advertisement Route): Advertises host MAC addresses and optional IP address bindings.
- Type 3 (Inclusive Multicast Ethernet Tag Route): Builds the replication/flooding tree for BUM traffic across PEs.
- Type 4 (Ethernet Segment Route): Discovers other PEs attached to the same multi-homed Ethernet segment and assists in DF election.
- Type 5 (IP Prefix Route): Added by later extensions to advertise routed IP prefixes instead of host-specific MAC/IP routes.

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

### Intro

[Intro: Cours VXLAN](https://youtube.com/playlist?list=PLmVr8r1kmMm1LucO47Ch5CDJWgBb2X6YE&si=pRrnY0TlgMFllbFj)

#### 1. Two kinds of addresses

- MAC address (Layer 2, Ethernet), for example `62:b7:1f:a6:5a:34`. It's burned into the network card and used to deliver frames inside one local network, meaning between machines on the same switch.

- IP address (Layer 3), for example `30.1.1.1`. It's a logical address, and routers use it to move packets between networks.

When `host_tat-nguy-1` wants to reach `30.1.1.2`, it looks at its netmask (`/24`) and concludes that `30.1.1.2` is in its own network. So it doesn't need a router. It only needs the destination's MAC address, and it finds it by shouting an `ARP request` (Address Resolution Protocol Request) to everyone: "Who has 30.1.1.2? Tell 30.1.1.1" This shout is a `broadcast`, send to MAC `ff:ff:ff:ff:ff:ff`, which every machine on the local network receives.

The catch: the two hosts are **not** on the same local network. Two routers and a switch separate them, and a broadcast never crosses a router. Without help, the ARP never reaches host 2 and the ping fails. That's the problem VXLAN solves.

#### 2. The idea of VXLAN: an envelope inside an envelope

Picture the host's Ethernet frame as a letter. VXLAN puts that whole letter, MAC addresses included, inside a second envelope addressed from router to router:

```
┌────────────────────────── outer envelope (underlay) ──────────────────────────┐
│ Ethernet | IP 10.1.1.1 → 10.1.1.2 | UDP port 4789 | VXLAN VNI 10 |            │
│   ┌──────────────── inner letter (overlay, untouched) ────────────────┐       │
│   │ Ethernet MAC host1 → MAC host2 | IP 30.1.1.1 → 30.1.1.2 | ping    │       │
│   └───────────────────────────────────────────────────────────────────┘       │
└───────────────────────────────────────────────────────────────────────────────┘
```

This is exactly what you'll see in Wireshark. It creates two separate networks, and you need these terms at the defense:

- **Underlay** (`10.1.1.0/24`): the real network between the routers, through the switch. It carries the envelopes.
- **Overlay** (`30.1.1.0/24`): the virtual network the hosts believe they're on. The hosts never see `10.x`

The other key terms:

- VTEP (VXLAN Tunnel End Point): whatever puts letters into envelopes and takes them out. Each router is one, through its `vxlan10` interface.
- VNI (VXLAN Network Identifier) `10`: a number written on the envelope that says which virtual network the letter belongs to. One underlay can carry many virtual networks, up to about 16 million VNIs (compared with 4096 VLANs), and each stays separate.
- UDP port `4789`: the official port for VXLAN. The envelope is a normal UDP packet, so any IP network can carry it.

#### 3. The bridge: a switchc inside the router

A **bridge** (`br0`) is a software switch. In each router, it has two ports:

- `eth1`, the cable to the host (`host_tat-nguy-1` and `host_tat-nguy-2`)
- `vxlan10`, the tunnel to the `switch_tat-nguy` and to other router

Like any switch, it forwards frames between its ports and learns MAC addresses, remembering "MAC X was seen on port Y". That table is what `brctl showmacs br0` displays.

So each router behaves like half of a switch, and the tunnel is the cable joining the two halves. From the host's POV, they're plugged into one switch.

That's also why `eth1` has no IP. It's a switch port, working only at Layer 2, and router doesn't route anything here.

#### 4. The journey of one ping

1. Host 1 broadcasts an ARP request: "Who has 30.1.1.2?"

2. Router 1 receives it on `eth1`. The bridge floods the broadcast to its other port, `vxlan10`, and learns "Host 1's MAC is behind `eth1`".

3. `vxlan10` wraps the frame in an envelops `10.1.1.1 -> 10.1.1.2`, UDP 4789, VNI 10, and sends it out `eth0`.

4. The switch delivers the envelope to Router 2, which recognizes UDP 4789 with VNI 10 and unwraps it. Its bridge learns "Host's 1 MAC is behind `vxlan10`" and floods the frame out `eth1`.

5. Host 2 receives a normal ARP request and replies with its MAC. The reply travels back the same way.

6. Host 1 now knows Host 2's MAC and sends the ping, which follows the same path.

Point out the TTL in the ping output: it stays at `64`, the starting value. Every router hop decreases TTL, so an unchanged TTL proves the packet was never routed. It crossed at Layer 2, as if through a single switch.

#### 5. Static (Unknown Unicast) vs Dynamic Multicast

Both modes differ only in how the VTEP handles Broadcast, Unknown unicast, Multicast (BUM) traffic, frames it doesn't know where to send, like that first ARP.

- **Static** (`remote 10.1.1.2`): you write the other VTEP's address by hand, and all BUM traffic goes there. It's simple, but with 50 routers each one would need 49 peers listed manually, so it doesn't scale.
  - Unknown Unicast: Frames directed to a specific MAC address that the switch or VTEP does not currently have in its forwarding or MAC address table.

- **Multicast** (`group 239.1.1.1`): nobody is listed. Each VTEP joins a multicast group on `eth0` using the IGMP protocol, and BUM traffic is sent to the group, so every member receives it. Adding a VTEP just means joining the group.
  - Multicast: Traffic sent by a single source to a defined logical group of subscribing recipient devices.

In both modes, once the reply comes back, the VTEP records which MAC is behind which VTEP IP, and later frames go directly unicast. This is called flood-and-learn. You can show the learned entries with:

```bash
bridge fdb show dev vxlan10
```

In Wireshark, the difference shows on the first ARP only:

- Static mode: the outer destination is `10.1.1.2`
- Multicast mode: the outer destination is `239.1.1.1`, with a MAC starting `01:00:5e`

Otherwise, Broadcast: Layer 2 frames sent to a destination address of all ones (`FF:FF:FF:FF:FF:FF`), destined for every device on the local network segment (e.g., ARP requests).


### Step 0: Understand what you're building

The physical topology is one flat network `routeur_tat-nguy-1 eth0` ↔ `Switch_tat-nguy` ↔ `routeur_tat-nguy-2 eth0`.
This is the underlay, meaning ordianry IP connectivity between the two routeurs.

On top of it you build an overlay: a virtual Layer 2 segment (VXLAN, VNI 10) that makes `host_tat-nguy-1` and `host_tat-nguy-2` behave as if they were plugged into the same switch, even though routers sit between them.

Key terms to know:

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

The `dev eth0` part is mandatory in multicast mode. It tells the kernel which interface (here `eth0`) should join the IGMP group.

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

Part 2 found remote MACs through static peers or a multicast group. In this Part 3, BGP tells every router which MAC lives behind which router.

### Step 0: The concepts

#### Underlay vs Overlay

Every **VXLAN** network has 2 layers:
- **The underlay** is the real IP network between routers. Its only job is to let any router reach any other router's IP. In this part 3, routers are connected with `/30` links (4 total IP addresses), and OSPF (Open Shortest Path First) builds this network.

- **The overlay** is the virtual Layer 2 network that the hosts see. Hosts think they're all plugged into the same switch (`VNI 10`). In reality, their Ethernet frames are wrapped inside UDP packets (`port 4789`) and carried across the underlay.

A router that wraps and unwraps these frames is a VTEP. Three leaves in this Part 3 are VTEPs. The Route Reflector (RR) is not a VTEP; it only forwards IP packets and relays BGP information.

#### Loopback addresses (lo)

The `lo` (loopback) interface is a virtual network device built into your operating system that allows your computer to communicate directly with itself.

Each router gets a `/32` addresson its `lo` interface: `1.1.1.1` through `1.1.1.4`. A loopback never goes down as long as the router is alive, so it's the stable identify of the router. BGP sessions and VXLAN tunnels use loopbacks instead of physical link IPs. OSPF advertises the loopbacks so every router can reach every other router's loopback. That's why the subject's `show ip route` screenshot shows `1.1.1.x/32` routes learned via OSPF (`0>*`).

#### OSPF (Open Shortest Path First)

OSPF is an IGP (Interior Gateway Protocol). Routers in the same organization run it to discover each other automatically and compute the shortest paths. Routers send "Hello" packets to their neighbors, exchange their link information, and each one builds a full map of the network. You don't write any static routes. Everything here is in **area 0**, the backbone area.

#### BGP, AS and iBGP

BGP is the routing protocol of the Internet. Routers exchange "I can reach X" messages over TCP port 179. A group of routers under one administration is an Autonomous System (AS). All your routers are in **AS 1**. When BGP neighbours are in the same AS, the session is called **iBGP**.

iBGP has a rule: a route learned from one iBGP peer is not passed on to another iBGP peer. The rule prevents loops. The consequence is that normally every router would need a session with every other router (a full mesh). With N routers, that's Nx(N-1)/2 sessions, which doesn't scale.

#### Route Reflector (RR)

A RR is an exception to that rule. The leaves peer only with the RR, and the RR reflects each leaf's routes to all the other leaves. So you need 3 sessions instead of a full mesh. The leaves are the RR's route-reflector clients.

"Dynamic relationships" in the subject means the RR doesn't list each leaf by IP. It uses `bgp listen range 1.1.1.0/29` and accepts any router from that range that connects. The RR is the "controller" of the data center.

#### MP-BGP and EVPN

Original BGP only carried IPv4 prefixes. MP-BGP (Multi-Protocol BGP) adds address families, so the same BGP session can carry other kinds of information. EVPN is the address familly `12vpn evpn`. Instead of IP prefixes, it carries MAC addressses and VTEP information.

The subject shows 2 EVPN route types:

| Type | Name | Meaning | When it appears |
|------|------|---------|-----------------|
| Type 3 | Inclusive Multicast Ethernet Tag | "I am VTEP 1.1.1.2 and I have VNI 10. Send me broadcast/unknown traffic for VNI 10" | As soon as the VNI is configured, even with no hosts |
| Type 2 | MAC/IP Advertisement | "MAC 62:b7:1f:a6:5a:34 is behind me (1.1.1.2) in VNI 10" | When a host sends a frame and the leaf learns its MAC |

Type 3 routes replace Part 2's multicast group. Each VTEP learns the list of other VTEPs from BGP and sends a unicast copy of broadcast traffic (like ARP) to each one. This is called ingress replication.

Type 2 routes replace Part 2's food-and-learn. MACs are learned by the control plane (BGP) instead of by watching data traffic.

#### Info in `show bgp 12vpn evpn`

- RD (Route Distinguisher), eg `1.1.1.2:2`, makes each route unique, so two leaves advertising similar things don't collide.
- RT (Route Target), eg `RT:1:10`, means "AS 1, VNI 10". A leaf imports routes whose RT matches its VNI. FRR builds the RD and RT automatically.
- `ET:8` means "encapsulation type 8 = VXLAN"
- `i` means the route was learned via iBGP.
- `32768` is the local weight, which marks a route this router originated itself.

### Step 1: The addressing plan

| Node | Interface | Address | Connected to |
|------|-----------|---------|--------------|
| host_tat-nguy-1 | eth1 | 20.0.0.1/24 | _tat-nguy-2 |
| host_tat-nguy-2 | eth0 | 20.0.0.2/24 | _tat-nguy-3 |
| host_tat-nguy-3 | eth0 | 20.0.0.3/24 | _tat-nguy-4 |
| _tat-nguy-1 (RR) | lo   | 1.1.1.1/32  | none        |
|                  | eth0 | 10.1.1.1/30 | _tat-nguy-2 |
|                  | eth1 | 10.1.1.5/30 | _tat-nguy-3 |
|                  | eth2 | 10.1.1.9/30 | _tat-nguy-4 |
| _tat-nguy-2 (leaf) | lo   | 1.1.1.2/32      | none                 |
|                    | eth0 | 10.1.1.2/30     | RR eth0              |
|                    | eth1 | (no IP, in br0) | host_tat-nguy-1 eth1 |
| _tat-nguy-3 (leaf) | lo   | 1.1.1.3/32      | none                 |
|                    | eth0 | (no IP, in br0) | host_tat-nguy-2 eth0 |
|                    | eth1 | 10.1.1.6/30     | RR eth1              |
| _tat-nguy-4 (leaf) | lo   | 1.1.1.4/32      | none                 |
|                    | eth0 | (no IP, in br0) | host_tat-nguy-3 eth0 |
|                    | eth2 | 10.1.1.10/30    | RR eth2              |

- A `/30` subnet has exactly 2 usable addresses, which is perfect for a point-to-point link.
- The hosts share one `/24` subnet because the overlay makes them look like they're on the same LAN, even though they're far apart physically.
- The leaves's host-facing ports have no IP. They are pure Layer 2 bridge ports.

### Step 2: Configure the hosts

For `host_tat-nguy-1`:

```
# host_tat-nguy-1: end device plugged into leaf _tat-nguy-2
# All hosts share 20.1.1.0/24 because VXLAN 10 makes them one L2 LAN
auto eth1
iface eth1 inet static
    address 20.1.1.1
    netmask 255.255.255.0
```

For `host_tat-nguy-2`:

```
# host_tat-nguy-2: end device plugged into leaf tat-nguy-3
# All hosts share 20.1.1.0/24 because VXLAN 10 makes them one L2 LAN
auto eth0
iface eth0 inet static
    address 20.1.1.2
    netmask 255.255.255.0
```

For `host_tat-nguy-3`:

```
# host_tat-nguy-3: end device plugged into leaf tat-nguy-4
# All hosts share 20.1.1.0/24 because VXLAN 10 makes them one L2 LAN
auto eth0
iface eth0 inet static
    address 20.1.1.3
    netmask 255.255.255.0
```

Version using command terminal (for `host_tat-nguy-1`):

```sh
# Gives the interface eth1 the IP 20.1.1.1.
# The /24 tells host that everything from 20.1.1.0 to .255 is on the same LAN, so it will send ARP requests directly for those addresses instead of looking for a gateway. 
ip addr add 20.1.1.1/24 dev eth1

# Turns the interface eth1 on.
# A Linux interface is down by default and can't send or receive anything until we put it up
ip link set eth1 up
```

### Step 3: Configure the leaves on Linux side (VXLAN 2, 3, 4)

There's 2 side to config for leaves routers 2, 3, 4:
  - Linux side (The kernel's devices: br0, vxlan10, ports plugged into the bridge)
  - FRR side (inside vtysh for software interface IPs, OSPF, BGP, EVPN)

- Leaf `_tat-nguy-2` (copy - paste to Termial)

```sh
# Create a virtual switch named br0 inside router.
# Anything plugged into it can exchange Ethernet frames, just like ports on a real switch
ip link add br0 type bridge
ip link set br0 up

# Create tunnel interface
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.2 nolearning

# Plug the tunnel into the bridge. From now on, a frame that enters br0 and must reach a remote host goes into the tunnel
ip link set vxlan10 master br0
# = `brctl addif br0 vxlan10`
ip link set vxlan10 up

# Plugs the host-facing port into the same bridge. The local host and tunnel are now on the same virtual switch
ip link set eth1 master br0
# = `brctl addif br0 eth1`
ip link set eth1 up
```

- Leaf `_tat-nguy-3`

```sh
ip link add br0 type bridge
ip link set br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.3 nolearning
ip link set vxlan10 master br0
ip link set vxlan10 up
ip link set eth0 master br0
ip link set eth0 up
```

- Leaf `_tat-nguy-4`

```sh
ip link add br0 type bridge
ip link set br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.4 nolearning
ip link set vxlan10 master br0
ip link set vxlan10 up
ip link set eth0 master br0
ip link set eth0 up
```

Check the work with 

```sh
ip -d link show vxlan10
bridge link
```

### Step 4: Configure Route Reflector (RR - 1)

- On `_tat-nguy-1`:

```vtysh
configure terminal
  no ipv6 forwarding
  interface lo
    ip address 1.1.1.1/32
  exit
  interface eth0
    ip address 10.1.1.1/30
  exit
  interface eth1
    ip address 10.1.1.5/30
  exit
  interface eth2
    ip address 10.1.1.9/30
  exit

  router bgp 1
    neighbor ibgp peer-group
    neighbor ibgp remote-as 1
    neighbor ibgp update-source lo
    bgp listen range 1.1.1.0/29 peer-group ibgp
    address-family l2vpn evpn
      neighbor ibgp activate
      neighbor ibgp route-reflector-client
    exit-address-family
  exit

  router ospf
    network 1.1.1.1/32 area 0
    network 10.1.1.0/30 area 0
    network 10.1.1.4/30 area 0
    network 10.1.1.8/30 area 0
  exit
end
write memory

show ip route
```

### Step 5: Configure the leaves on FRR side (vtysh 2, 3, 4)

- On `_tat-nguy-2`:

```vtysh
configure terminal
  no ipv6 forwarding
  interface lo
    ip address 1.1.1.2/32
    no shutdown
  exit
  interface eth0
    ip address 10.1.1.2/30
  exit

  router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    address-family l2vpn evpn
      neighbor 1.1.1.1 activate
      advertise-all-vni
    exit-address-family
  exit

  router ospf
    network 1.1.1.2/32 area 0
    network 10.1.1.0/30 area 0
  exit
end
write memory

show ip route
```

- On `_tat-nguy-3`:

```vtysh
configure terminal
  no ipv6 forwarding
  interface lo
    ip address 1.1.1.3/32
  exit
  interface eth1
    ip address 10.1.1.6/30
    no shutdown
  exit

  router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    address-family l2vpn evpn
      neighbor 1.1.1.1 activate
      advertise-all-vni
    exit-address-family
  exit

  router ospf
    network 1.1.1.3/32 area 0
    network 10.1.1.4/30 area 0
  exit  
end
write memory

show ip route
```

- On `_tat-nguy-4`:

```vtysh
configure terminal
  no ipv6 forwarding
  interface lo
    ip address 1.1.1.4/32
  exit
  interface eth2
    ip address 10.1.1.10/30
    no shutdown
  exit

  router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    address-family l2vpn evpn
      neighbor 1.1.1.1 activate
      advertise-all-vni
    exit-address-family
  exit

  router ospf
    network 1.1.1.4/32 area 0
    network 10.1.1.8/30 area 0
  exit

end
write memory

show ip route



```


## Additional Information

### Docker commands

- Build Docker image: `docker build -t my-username/my-image .`

### vtysh

```bash
vtysh   # _tat-nguy-1#

# global configuration
configure terminal  # (config)#

# sub-modes for one interface or one protocol
interface eth0  # (config-if)#
# or
router bgp 1    # (config-router)#

# goes up one level
exit

# jumps straight back to _tat-nguy-1#
end

# to save the running config to /etc/frr/frr.conf
# Because /etc/frr is persistent in Docker, the config survives a restart.
write memory 
```