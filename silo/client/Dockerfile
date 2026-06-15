FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        libnuma-dev \
        libjemalloc-dev \
        libdb5.3++-dev \
        libssl-dev \
        libaio-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c client.cpp -o client.o \
    && g++ -O3 -g -fPIC -std=c++0x -c tbench_client_networked.cpp -o tbench_client_networked.o \
    && g++ -g -W -Wall -O2 -o dbtest_client_networked \
        bench_client.o client.o tbench_client_networked.o \
        -L. -llz4 -Wl,-rpath,/usr/local/lib \
        -lpthread -lnuma -lrt -ljemalloc -ldb_cxx -lz -lcrypt -laio -ldl -lssl -lcrypto

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libnuma1 \
        libjemalloc1 \
        libdb5.3++ \
        libssl1.1 \
        libaio1 \
        zlib1g \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/dbtest_client_networked /dbtest_client_networked
COPY --from=builder /build/liblz4.so /usr/local/lib/liblz4.so
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh

WORKDIR /tmp
ENTRYPOINT ["/client-entrypoint.sh"]
