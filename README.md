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

`bgpd` is a routing daemon for the *Border Gateway Protocol* (BGP) that manages network routing tables and exchanges routing information with other systems.

### ospfd

`ospfd` is a background software program (daemon) that runs on a computer or router to handle dynamic network routing using the *Open Shortest Path First (OSPF) protocol*.

### IS-IS

The `IS-IS` (Intermediate System-to-Intermediate System) routing service is a link-state interior gateway protocol used by large service providers and enterprise networks to exchange routing information.

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

> A routing table, or routing information base (RIB), is a data table stored in a router or a network host that lists the routes to particular network destinations, and in some cases, metrics (distances) associated with those routes. The routing table contains information about the *topology* of the network immediately around it.

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


## Part 2: Discovering a VXLAN


## Part 3: Discovering BGP with EVPN


## Docker commands

- Build image: `docker build -t my-username/my-image .`
