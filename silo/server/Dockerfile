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
RUN g++ -O3 -g -fPIC -std=c++0x -c tbench_server_networked.cpp -o tbench_server_networked.o \
    && g++ -g -W -Wall -O2 -o dbtest_server_networked \
        dbtest.o \
        allocator.o btree.o core.o counter.o memory.o rcu.o stats_server.o thread.o \
        ticker.o tuple.o txn_btree.o txn.o txn_proto2_impl.o varint.o \
        compiler.o str.o string.o straccum.o json.o \
        bdb_wrapper.o bench.o encstress.o bid.o kvrandom.o queue.o tpcc.o ycsb.o \
        tbench_server_networked.o \
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
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/dbtest_server_networked /dbtest_server_networked
COPY --from=builder /build/liblz4.so /usr/local/lib/liblz4.so
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh

WORKDIR /tmp
EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
