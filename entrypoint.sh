#!/bin/bash

TYKCONF=/opt/tyk-gateway/tyk.conf

export TYK_GW_LISTENPORT="$TYKLISTENPORT"
export TYK_GW_SECRET="$TYKSECRET"

cd /opt/tyk-gateway/
./tyk$TYKLANG --conf=${TYKCONF}
