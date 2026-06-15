FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        libnuma-dev \
        libgoogle-perftools-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c tbench_server_networked.cpp -o tbench_server_networked.o \
    && g++ -g -W -Wall -O2 -o mttest_server_networked \
        tbench_server_networked.o mttest.o misc.o checkpoint.o \
        masstree.o value_string.o value_array.o value_versioned_array.o perfstat.o string_slice.o \
        kvio.o libjson.a \
        -ltcmalloc_minimal -lnuma -lpthread -lm -lrt

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libtcmalloc-minimal4 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/mttest_server_networked /mttest_server_networked
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh

WORKDIR /tmp
EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
