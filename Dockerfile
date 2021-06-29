FROM alpine:3.14

RUN apk add --no-cache openssl

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
