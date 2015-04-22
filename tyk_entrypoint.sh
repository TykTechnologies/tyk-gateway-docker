#!/bin/bash

cd /opt/tyk-dashboard/host-manager/ && 
./tyk-host-manager & 
cd /etc/tyk/ && 
/usr/bin/tyk