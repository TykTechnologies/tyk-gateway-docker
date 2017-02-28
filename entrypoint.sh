#!/bin/bash

TYKCONF=/opt/tyk-gateway/tyk.conf

sed -i 's/TYKLISTENPORT/'${TYKLISTENPORT}'/g' ${TYKCONF}
sed -i 's/TYKSECRET/'${TYKSECRET}'/g' ${TYKCONF}

cd /opt/tyk-gateway/
./tyk$TYKLANG --conf=${TYKCONF}