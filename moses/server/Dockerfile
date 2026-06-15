FROM ubuntu:18.04

COPY build/moses_server_networked /moses_server_networked
COPY build/moses.ini /moses.ini
COPY build/tailbench.inputs /opt/tailbench.inputs
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh /moses_server_networked

WORKDIR /data
EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
