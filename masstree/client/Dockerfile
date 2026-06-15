FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        libnuma-dev \
        libgoogle-perftools-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c client.cpp -o client.o \
    && g++ -O3 -g -fPIC -std=c++0x -c tbench_client_networked.cpp -o tbench_client_networked.o \
    && g++ -g -W -Wall -O2 -o mttest_client_networked \
        client.o tbench_client_networked.o kvclient.o \
        -ltcmalloc_minimal -lnuma -lpthread -lm -lrt

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libtcmalloc-minimal4 \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/mttest_client_networked /mttest_client_networked
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh

WORKDIR /tmp
ENTRYPOINT ["/client-entrypoint.sh"]
