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

### Add a network to a PC

> In real life, it's automatic done by DHCP (Dynamic Host Configuration Protocol) inside Wifi/Internet Box.
> So we don't do that manually with new PC, new Internet Box, etc...

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
ip addr show eth2 # to check if ip address is well added
```

### Configure a Router

> Of couse a Router can have multiple IP Addresses
> router has multiple ports or interfaces, it needs at least one unique IP address for every network segments or subnet it connects to.

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

## Part 2: Discovering a VXLAN

###

## Part 3: Discovering BGP with EVPN

## Additional Information

### Docker commands

- Build image: `docker build -t my-username/my-image .`

```
