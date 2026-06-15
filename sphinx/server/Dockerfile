FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c tbench_server_networked.cpp -o tbench_server_networked.o \
    && g++ -pthread tbench_server_networked.o decoder.o -o decoder_server_networked \
        -L. -lpocketsphinx -lsphinxbase -lsphinxad -lpthread -lm -lrt \
        -Wl,-rpath,/usr/local/lib

FROM ubuntu:18.04

COPY --from=builder /build/decoder_server_networked /decoder_server_networked
COPY --from=builder /build/libpocketsphinx.so* /build/libsphinxbase.so* /build/libsphinxad.so* /usr/local/lib/
COPY --from=builder /build/model /opt/tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod +x /server-entrypoint.sh

WORKDIR /tmp
EXPOSE 8080
ENTRYPOINT ["/server-entrypoint.sh"]
