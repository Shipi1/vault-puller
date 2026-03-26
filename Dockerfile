FROM alpine:latest
RUN apk add --no-cache git openssh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 9000
RUN git config --global --add safe.directory '*'
ENTRYPOINT ["/entrypoint.sh"]
