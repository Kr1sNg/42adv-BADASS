FROM alpine:3.20

# Install networking tools
RUN apk add --no-cache \
    iproute2 \
    iproute2-ss \
    iputils \
    tcpdump \
    bash \
    bridge-utils

# Create working directory
WORKDIR /app

# Copy VXLAN setup script
COPY vxlan.sh /app/vxlan.sh

RUN chmod +x /app/vxlan.sh

CMD ["/bin/bash"]