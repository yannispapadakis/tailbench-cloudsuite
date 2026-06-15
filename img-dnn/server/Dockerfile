FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libopencv-core3.2 \
    && rm -rf /var/lib/apt/lists/*

COPY img-dnn_server_networked /img-dnn_server_networked
COPY model.xml /opt/model.xml
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
