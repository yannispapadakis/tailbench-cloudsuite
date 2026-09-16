FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        libopencv-core-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c tbench_server_networked.cpp -o tbench_server_networked.o \
    && g++ -g -O3 -std=c++0x -o img-dnn_server_networked \
        img-dnn.o common.o tbench_server_networked.o \
        -lopencv_core -lrt -pthread

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libopencv-core3.2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/img-dnn_server_networked /img-dnn_server_networked
COPY model.xml /opt/model.xml
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
