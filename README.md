Official Tyk Gateway Docker Build
=================================

This container only contains the Tyk API gateway, the dashboard is provided as a seperate container and need to be configured separately. 

Tyk will run with a defaut configuration unless it has been overriden ith the -v flag. Two sample configurations have been provided to run Tyk Gateway standalone (no DB or dashboard, file-based configurations) or with the dashboard and MongoDB.

Quickstart
----------

1. Get a redis container (required - or use an external redis server): 

	`docker pull redis`

2. Get Tyk Gateway

	`docker pull tykio/tyk-gateway`

3. Run a standalone Tyk Gateway with your (modified) tyk.conf (see sample configs in our docker github repository):

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis tykio/tyk-gateway -v ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf` -v ./apps /opt/tyk-gateway/apps

Make sure the `apps` folder has some API Definitions set, otherwise Tyk won't proxy any trafic.

