#!/bin/bash

TYKCONF=/opt/tyk-gateway/tyk.conf

# for backwards compatibility if TYKSECRET is not empty, then set TYK_GW_SECRET to TYKSECRET
if [[ -n "${TYKSECRET}" ]]; then
  export TYK_GW_SECRET="${TYKSECRET}"
fi

# for backwards compatibility if TYK_GW_SECRET is empty, then set to ensure no breaking changes
if [[ -z "${TYK_GW_SECRET}" ]]; then
  export TYK_GW_SECRET=352d20ee67be67f6340b4c0605b044b7
fi

cd /opt/tyk-gateway/
./tyk$TYKLANG --conf=${TYKCONF}
