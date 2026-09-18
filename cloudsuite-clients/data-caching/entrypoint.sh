#!/bin/bash

ARGS=()
MODE="bash"
SERVER_IP=127.0.0.1
WORKERS=4
SERVER_MEMORY=4096
SCALE=30
INTERVAL=1
TIMEOUT=100
GET_RATIO=0.8
CONNECTION=200
RPS=10000
RATIO=0.9
NEGATIVE_EXPONENTIAL=false

while (( ${#@} )); do
	case ${1} in
		--m=*)	MODE=${1#*=} ;;
		--ip=*)	SERVER_IP=${1#*=} ;;
		--w=*)	WORKERS=${1#*=} ;;
		--D=*)	SERVER_MEMORY=${1#*=} ;;
		--T=*)	INTERVAL=${1#*=} ;;
		--t=*)	TIMEOUT=${1#*=} ;;
		--g=*)	GET_RATIO=${1#*=} ;;
		--c=*)	CONNECTION=${1#*=} ;;
		--r=*)	RPS=${1#*=} ;;
		--R=*)	RATIO=${1#*=} ;;
		--ne)	NEGATIVE_EXPONENTIAL=true ;;
		*)	ARGS+=(${1}) ;;
	esac
	
	shift
done

set -- ${ARGS[@]}
echo "Server IP: ${SERVER_IP}, Mode: ${MODE}, Memory: ${SERVER_MEMORY}, Workers: ${WORKERS}, Timeout: ${TIMEOUT}, Get/Set Ratio: ${GET_RATIO}"

SCALE=$((SERVER_MEMORY / 360))
echo "${SERVER_IP}, ${MEMCACHED_PORT:-11211}" > /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt
if [ "$NEGATIVE_EXPONENTIAL" = true ]; then
	NEG_EXP="-e"
fi

if [ ! -f /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x ]; then
	echo "Scaling dataset to ${SCALE}x and warming up"
        /usr/src/memcached/memcached_client/loader \
                -a /usr/src/memcached/twitter_dataset/twitter_dataset_unscaled \
                -o /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
                -s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
                -w ${WORKERS} -S ${SCALE} -D ${SERVER_MEMORY} -j -T ${INTERVAL} > /dev/null
else
        echo "Warming up"
        /usr/src/memcached/memcached_client/loader \
                -a /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
                -s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
                -w ${WORKERS} -S 1 -D ${SERVER_MEMORY} -j -T ${INTERVAL} > /dev/null
fi

if [ "$MODE" = 'TH' ]; then
	echo "Finding max throughput, running for ${TIMEOUT} seconds"
        /usr/src/memcached/memcached_client/loader \
                -a /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
                -s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
                -g ${GET_RATIO} -w ${WORKERS} -c ${CONNECTION} -T ${TIMEOUT} -t ${TIMEOUT}
elif [ "$MODE" = 'RPS' ]; then
	echo "Running for ${TIMEOUT} seconds with ${RPS} requests per second"
        /usr/src/memcached/memcached_client/loader \
                -a /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
                -s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
                -g ${GET_RATIO} -w ${WORKERS} -c ${CONNECTION} -T ${TIMEOUT} $NEG_EXP -r ${RPS} -t ${TIMEOUT}
elif [ "$MODE" = 'ALL' ]; then
	echo "Finding max throughput, running for $((TIMEOUT / 10)) seconds"
	max_rps=$(/usr/src/memcached/memcached_client/loader \
		-a /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
		-s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
		-g ${GET_RATIO} -w ${WORKERS} -c ${CONNECTION} -T ${TIMEOUT} -t ${TIMEOUT} \
		| awk -F', ' '/^   unix_ts/ {next} /^-+$/ {next} {if ($3 > max) max=$3} END {print max}')
	RPS=$(awk -v max_rps="$max_rps" -v ratio="$ratio" 'BEGIN {print max_rps * ratio}')
	echo "Found max throughput, running for ${TIMEOUT} seconds with ${RPS} requests per second"
        /usr/src/memcached/memcached_client/loader \
                -a /usr/src/memcached/twitter_dataset/twitter_dataset_${SCALE}x \
                -s /usr/src/memcached/memcached_client/docker_servers/docker_servers.txt \
                -g ${GET_RATIO} -w ${WORKERS} -c ${CONNECTION} -T ${TIMEOUT} $NEG_EXP -r ${RPS} -t ${TIMEOUT}
fi
