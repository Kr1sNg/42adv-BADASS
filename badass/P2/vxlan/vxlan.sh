#!/bin/bash

set -e

# Configuration
VNI=100
VXLAN_IF=vxlan100
LOCAL_IP=192.168.1.10
REMOTE_IP=192.168.1.20

# Create VXLAN interface
ip link add $VXLAN_IF type vxlan \
    id $VNI \
    local $LOCAL_IP \
    remote $REMOTE_IP \
    dstport 4789

# Bring interface up
ip link set $VXLAN_IF up

# Display configuration
ip -d link show $VXLAN_IF