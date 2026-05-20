FROM    alpine:3.22

RUN     apk add --no-cache redis

RUN     mkdir -p /data && chown redis:redis /data
COPY    config/def.conf /etc/redis/redis.conf
RUN     chown redis:redis /etc/redis/redis.conf

USER    redis

WORKDIR /data

CMD     ["redis-server", "/etc/redis/redis.conf"]
