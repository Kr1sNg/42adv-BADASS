FROM frrouting/frr:10.0

RUN apk add --no-cache busybox

COPY daemons /etc/frr/daemons
COPY frr.conf /etc/frr/frr.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh && \
    chown frr:frr /etc/frr/frr.conf

ENTRYPOINT [ "/start.sh" ]