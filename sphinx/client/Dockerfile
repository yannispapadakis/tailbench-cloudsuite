FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY build/ ./
RUN g++ -O3 -g -fPIC -std=c++0x -c client.cpp -o client.o \
    && g++ -O3 -g -fPIC -std=c++0x -c tbench_client_networked.cpp -o tbench_client_networked.o \
    && g++ -pthread asr_client.o client.o tbench_client_networked.o \
        -o decoder_client_networked -lrt

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/decoder_client_networked /decoder_client_networked
COPY --from=builder /build/wav /opt/tailbench.inputs/sphinx/wav
COPY --from=builder /build/audio_samples /opt/tailbench.inputs/sphinx/audio_samples
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh

WORKDIR /tmp
ENTRYPOINT ["/client-entrypoint.sh"]
