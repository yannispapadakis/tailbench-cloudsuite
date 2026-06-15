#!/bin/bash
# Extracts the img-dnn binaries and datasets needed to build the
# tailbench-img-dnn server/client images out of a local TailBench v0.9
# archive (binaries + tailbench.inputs/, e.g. as produced by
# https://github.com/yiwenzhang92/tailbench or the TailBench release tarball).
#
# Usage: ./extract.sh /path/to/tailbench.tar.gz
set -e

ARCHIVE=${1:?Usage: $0 /path/to/tailbench.tar.gz}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SERVER_DIR="$DIR/img-dnn/server"
CLIENT_DIR="$DIR/img-dnn/client"
MT_SERVER_BUILD="$DIR/masstree/server/build"
MT_CLIENT_BUILD="$DIR/masstree/client/build"
SILO_SERVER_BUILD="$DIR/silo/server/build"
SILO_CLIENT_BUILD="$DIR/silo/client/build"
SPHINX_SERVER_BUILD="$DIR/sphinx/server/build"
SPHINX_CLIENT_BUILD="$DIR/sphinx/client/build"
MOSES_SERVER_BUILD="$DIR/moses/server/build"
MOSES_CLIENT_BUILD="$DIR/moses/client/build"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

tar -xzf "$ARCHIVE" -C "$TMP" \
    tailbench-v0.9/img-dnn/img-dnn_server_networked \
    tailbench-v0.9/img-dnn/img-dnn_client_networked \
    tailbench.inputs/img-dnn/models/model.xml \
    tailbench.inputs/img-dnn/mnist/t10k-images-idx3-ubyte \
    tailbench.inputs/img-dnn/mnist/t10k-labels-idx1-ubyte \
    tailbench-v0.9/masstree/mttest.o \
    tailbench-v0.9/masstree/misc.o \
    tailbench-v0.9/masstree/checkpoint.o \
    tailbench-v0.9/masstree/masstree.o \
    tailbench-v0.9/masstree/value_string.o \
    tailbench-v0.9/masstree/value_array.o \
    tailbench-v0.9/masstree/value_versioned_array.o \
    tailbench-v0.9/masstree/perfstat.o \
    tailbench-v0.9/masstree/string_slice.o \
    tailbench-v0.9/masstree/kvio.o \
    tailbench-v0.9/masstree/libjson.a \
    tailbench-v0.9/masstree/kvclient.o \
    tailbench-v0.9/harness/dist.h \
    tailbench-v0.9/harness/helpers.h \
    tailbench-v0.9/harness/msgs.h \
    tailbench-v0.9/harness/server.h \
    tailbench-v0.9/harness/client.h \
    tailbench-v0.9/harness/tbench_server.h \
    tailbench-v0.9/harness/tbench_client.h \
    tailbench-v0.9/harness/tbench_server_networked.cpp \
    tailbench-v0.9/harness/tbench_client_networked.cpp \
    tailbench-v0.9/harness/client.cpp \
    tailbench-v0.9/silo/out-perf.masstree/allocator.o \
    tailbench-v0.9/silo/out-perf.masstree/btree.o \
    tailbench-v0.9/silo/out-perf.masstree/core.o \
    tailbench-v0.9/silo/out-perf.masstree/counter.o \
    tailbench-v0.9/silo/out-perf.masstree/memory.o \
    tailbench-v0.9/silo/out-perf.masstree/rcu.o \
    tailbench-v0.9/silo/out-perf.masstree/stats_server.o \
    tailbench-v0.9/silo/out-perf.masstree/thread.o \
    tailbench-v0.9/silo/out-perf.masstree/ticker.o \
    tailbench-v0.9/silo/out-perf.masstree/tuple.o \
    tailbench-v0.9/silo/out-perf.masstree/txn_btree.o \
    tailbench-v0.9/silo/out-perf.masstree/txn.o \
    tailbench-v0.9/silo/out-perf.masstree/txn_proto2_impl.o \
    tailbench-v0.9/silo/out-perf.masstree/varint.o \
    tailbench-v0.9/silo/out-perf.masstree/compiler.o \
    tailbench-v0.9/silo/out-perf.masstree/str.o \
    tailbench-v0.9/silo/out-perf.masstree/string.o \
    tailbench-v0.9/silo/out-perf.masstree/straccum.o \
    tailbench-v0.9/silo/out-perf.masstree/json.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/bdb_wrapper.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/bench.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/encstress.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/bid.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/queue.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/tpcc.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/ycsb.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/masstree/kvrandom.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/dbtest.o \
    tailbench-v0.9/silo/out-perf.masstree/benchmarks/client.o \
    tailbench-v0.9/silo/third-party/lz4/liblz4.so \
    tailbench-v0.9/sphinx/decoder.o \
    tailbench-v0.9/sphinx/client.o \
    tailbench-v0.9/sphinx/audio_samples \
    tailbench-v0.9/sphinx/sphinx-install/lib/libpocketsphinx.so \
    tailbench-v0.9/sphinx/sphinx-install/lib/libpocketsphinx.so.3 \
    tailbench-v0.9/sphinx/sphinx-install/lib/libpocketsphinx.so.3.0.0 \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxbase.so \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxbase.so.3 \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxbase.so.3.0.0 \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxad.so \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxad.so.3 \
    tailbench-v0.9/sphinx/sphinx-install/lib/libsphinxad.so.3.0.0 \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us-phone.lm.bin \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us.lm.bin \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/cmudict-en-us.dict \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/feat.params \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/means \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/variances \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/mdef \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/sendump \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/README \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/transition_matrices \
    tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/noisedict \
    tailbench-v0.9/moses/bin/moses_server_networked \
    tailbench-v0.9/moses/bin/moses_client_networked \
    tailbench-v0.9/moses/moses.ini.template

mkdir -p "$CLIENT_DIR/mnist"
cp "$TMP/tailbench-v0.9/img-dnn/img-dnn_server_networked" "$SERVER_DIR/"
cp "$TMP/tailbench.inputs/img-dnn/models/model.xml" "$SERVER_DIR/"
cp "$TMP/tailbench-v0.9/img-dnn/img-dnn_client_networked" "$CLIENT_DIR/"
cp "$TMP/tailbench.inputs/img-dnn/mnist/t10k-images-idx3-ubyte" "$CLIENT_DIR/mnist/"
cp "$TMP/tailbench.inputs/img-dnn/mnist/t10k-labels-idx1-ubyte" "$CLIENT_DIR/mnist/"

# masstree's prebuilt mttest_*_networked binaries hit a bug in TailBench's
# shared recvfull() helper: each retry re-requests the *original* length
# instead of the remaining bytes, so a partial read can overshoot into the
# next message. This only surfaces for masstree's 10240-byte aggregated
# requests (img-dnn's small per-image requests always complete in one recv()).
# Rather than patch prebuilt binaries, recompile the harness against the
# existing masstree object files with the one-line fix below, and relink
# using the same recipe as masstree/GNUmakefile.
mkdir -p "$MT_SERVER_BUILD" "$MT_CLIENT_BUILD"

cp "$TMP"/tailbench-v0.9/masstree/{mttest.o,misc.o,checkpoint.o,masstree.o,value_string.o,value_array.o,value_versioned_array.o,perfstat.o,string_slice.o,kvio.o,libjson.a} "$MT_SERVER_BUILD/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,server.h,client.h,tbench_server.h,tbench_server_networked.cpp} "$MT_SERVER_BUILD/"

cp "$TMP/tailbench-v0.9/masstree/kvclient.o" "$MT_CLIENT_BUILD/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,client.h,tbench_client.h,tbench_client_networked.cpp,client.cpp} "$MT_CLIENT_BUILD/"

# silo's dbtest_server_networked/dbtest_client_networked hit the same
# recvfull() bug as masstree (its TPC-C requests are also multi-recv-sized).
# Reuse the relink approach: take the prebuilt silo .o files (core silo,
# silo's own masstree variant, and the TPC-C benchmark) plus the prebuilt
# third-party/lz4/liblz4.so as-is, and recompile only the small harness
# .cpp files against the patched helpers.h.
mkdir -p "$SILO_SERVER_BUILD" "$SILO_CLIENT_BUILD"

cp "$TMP"/tailbench-v0.9/silo/out-perf.masstree/{allocator,btree,core,counter,memory,rcu,stats_server,thread,ticker,tuple,txn_btree,txn,txn_proto2_impl,varint,compiler,str,string,straccum,json}.o "$SILO_SERVER_BUILD/"
cp "$TMP"/tailbench-v0.9/silo/out-perf.masstree/benchmarks/{bdb_wrapper,bench,encstress,bid,queue,tpcc,ycsb,dbtest}.o "$SILO_SERVER_BUILD/"
cp "$TMP/tailbench-v0.9/silo/out-perf.masstree/benchmarks/masstree/kvrandom.o" "$SILO_SERVER_BUILD/"
cp "$TMP/tailbench-v0.9/silo/third-party/lz4/liblz4.so" "$SILO_SERVER_BUILD/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,server.h,client.h,tbench_server.h,tbench_server_networked.cpp} "$SILO_SERVER_BUILD/"

# silo's own benchmarks/client.cc (renamed to avoid clashing with the
# harness's own client.cpp -> client.o, both needed to link the client).
cp "$TMP/tailbench-v0.9/silo/out-perf.masstree/benchmarks/client.o" "$SILO_CLIENT_BUILD/bench_client.o"
cp "$TMP/tailbench-v0.9/silo/third-party/lz4/liblz4.so" "$SILO_CLIENT_BUILD/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,client.h,tbench_client.h,tbench_client_networked.cpp,client.cpp} "$SILO_CLIENT_BUILD/"

# sphinx's decoder_server_networked/decoder_client_networked hit the same
# recvfull() bug as masstree/silo (AN4 .raw audio samples are up to ~150KB,
# well over a single recv()). decoder.o and sphinx's own client.o are
# prebuilt and used as-is: decoder.o has MODELDIR baked in at compile time as
# the absolute path /opt/tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model,
# so the model files must land there in the final image. Only the harness's
# tbench_server_networked.cpp / client.cpp / tbench_client_networked.cpp get
# recompiled against the patched helpers.h. sphinx's own client.o is renamed
# to asr_client.o to avoid clashing with the harness's client.cpp -> client.o.
mkdir -p "$SPHINX_SERVER_BUILD/model/en-us/en-us" "$SPHINX_CLIENT_BUILD"

cp "$TMP/tailbench-v0.9/sphinx/decoder.o" "$SPHINX_SERVER_BUILD/"
cp "$TMP"/tailbench-v0.9/sphinx/sphinx-install/lib/lib{pocketsphinx,sphinxbase,sphinxad}.so* "$SPHINX_SERVER_BUILD/"
cp "$TMP"/tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/{en-us-phone.lm.bin,en-us.lm.bin,cmudict-en-us.dict} "$SPHINX_SERVER_BUILD/model/en-us/"
cp "$TMP"/tailbench-v0.9/sphinx/sphinx-install/share/pocketsphinx/model/en-us/en-us/{feat.params,means,variances,mdef,sendump,README,transition_matrices,noisedict} "$SPHINX_SERVER_BUILD/model/en-us/en-us/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,server.h,client.h,tbench_server.h,tbench_server_networked.cpp} "$SPHINX_SERVER_BUILD/"

cp "$TMP/tailbench-v0.9/sphinx/client.o" "$SPHINX_CLIENT_BUILD/asr_client.o"
cp "$TMP/tailbench-v0.9/sphinx/audio_samples" "$SPHINX_CLIENT_BUILD/"
cp "$TMP"/tailbench-v0.9/harness/{dist.h,msgs.h,client.h,tbench_client.h,tbench_client_networked.cpp,client.cpp} "$SPHINX_CLIENT_BUILD/"

# AN4 corpus: too many files to list individually, so extract the
# an4_clstk/ subtree (the only one referenced by audio_samples) separately
# with a wildcard, stripping the tailbench.inputs/sphinx/wav/ prefix so it
# lands at $SPHINX_CLIENT_BUILD/wav/an4_clstk/... (matching the relative
# paths in audio_samples).
mkdir -p "$SPHINX_CLIENT_BUILD/wav"
tar -xzf "$ARCHIVE" -C "$SPHINX_CLIENT_BUILD/wav" --wildcards --strip-components=3 \
    'tailbench.inputs/sphinx/wav/an4_clstk/*'

for dir in "$MT_SERVER_BUILD" "$MT_CLIENT_BUILD" "$SILO_SERVER_BUILD" "$SILO_CLIENT_BUILD" "$SPHINX_SERVER_BUILD" "$SPHINX_CLIENT_BUILD"; do
    sed 's/recv(fd, reinterpret_cast<void\*>(cur), len, flags)/recv(fd, reinterpret_cast<void*>(cur), remaining, flags)/' \
        "$TMP/tailbench-v0.9/harness/helpers.h" > "$dir/helpers.h"
done

# moses_{server,client}_networked are prebuilt link-static monoliths with no
# recoverable harness object files to relink. moses's per-request messages
# (testTerms lines, max 45 chars) are tiny single-recv sizes, so the
# recvfull() bug is not expected to trigger; used as-is without patching
# helpers.h. @DATA_ROOT in moses.ini is resolved at extract time since the
# dataset path is fixed inside the image.
mkdir -p "$MOSES_SERVER_BUILD/tailbench.inputs/moses" "$MOSES_CLIENT_BUILD"

cp "$TMP/tailbench-v0.9/moses/bin/moses_server_networked" "$MOSES_SERVER_BUILD/"
cp "$TMP/tailbench-v0.9/moses/bin/moses_client_networked" "$MOSES_CLIENT_BUILD/"
sed 's#@DATA_ROOT#/opt/tailbench.inputs#g' "$TMP/tailbench-v0.9/moses/moses.ini.template" > "$MOSES_SERVER_BUILD/moses.ini"

# testTerms + translation-model/ + language-model/ total ~4.4GB: extract
# directly into the build context (bypassing $TMP) to avoid doubling disk
# usage for this large dataset.
tar -xzf "$ARCHIVE" -C "$MOSES_SERVER_BUILD/tailbench.inputs/moses" --strip-components=2 \
    tailbench.inputs/moses/testTerms \
    tailbench.inputs/moses/translation-model \
    tailbench.inputs/moses/language-model

echo "Extracted img-dnn artifacts into $SERVER_DIR and $CLIENT_DIR"
echo "Extracted masstree build contexts into $MT_SERVER_BUILD and $MT_CLIENT_BUILD"
echo "Extracted silo build contexts into $SILO_SERVER_BUILD and $SILO_CLIENT_BUILD"
echo "Extracted sphinx build contexts into $SPHINX_SERVER_BUILD and $SPHINX_CLIENT_BUILD"
echo "Extracted moses build contexts into $MOSES_SERVER_BUILD and $MOSES_CLIENT_BUILD"
