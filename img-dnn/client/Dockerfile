FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        libopencv-core-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c client.cpp -o client.o \
    && g++ -O3 -g -fPIC -std=c++0x -c tbench_client_networked.cpp -o tbench_client_networked.o \
    && g++ -g -O3 -std=c++0x -o img-dnn_client_networked \
        common.o imgdnn_client.o client.o tbench_client_networked.o \
        -lopencv_core -lrt -pthread

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libopencv-core3.2 \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/img-dnn_client_networked /img-dnn_client_networked
COPY mnist /opt/mnist
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh

WORKDIR /tmp
ENTRYPOINT ["/client-entrypoint.sh"]
