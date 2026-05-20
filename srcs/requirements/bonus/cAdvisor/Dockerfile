FROM    alpine:3.22

RUN     apk add --no-cache \
        libc6-compat \
        device-mapper \
        thin-provisioning-tools \
        ca-certificates \
        curl

RUN     curl -L https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64 -o /usr/bin/cadvisor && \
        chmod +x /usr/bin/cadvisor

COPY    tools/cAdvisor_init.sh  /usr/local/bin/cAdvisor_init.sh
RUN     chmod +x /usr/local/bin/cAdvisor_init.sh

CMD ["/usr/local/bin/cAdvisor_init.sh"]
