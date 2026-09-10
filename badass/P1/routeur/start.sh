#!/bin/sh

set -e

echo "Starting FRRouting..."

mkdir -p /var/run/frr
chown -R frr:frr /var/run/frr

# Start zebra at first
/usr/lib/frr/zebra -d

sleep 1

# Start routing daemons
/usr/lib/frr/bgpd -d
/usr/lib/frr/ospfd -d
/usr/lib/frr/isisd -d

echo "FRRouting started."
echo "BGP, OSPF and IS-IS are active."

# Keep container alive
exec tail -f /dev/null