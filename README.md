Official Tyk Gateway Docker Build
=================================

This container only contains the Tyk API gateway, the dashboard is provided as a seperate container and need to be configured separately.

This container will attempt to run with the host maanger enabled (for dashboard access), this will require you to provide your own host manager configuration to override the local one, here is a sample:

	{
	    "mongo_url": "mongodb://mongo:27017/tyk_analytics",
	    "redis_port": 6379,
	    "redis_host": "redis",
	    "redis_password": "",
	    "tyk_ports": [8080],
	    "tyk_secret": "352d20ee67be67f6340b4c0605b044b7"
	}

This containerised build assumes a linked mongo and redis container, to use your own configuration simply override the tyk.conf file with a `-v` mount.

Quickstart
----------

1. Get a redis container (not required): 

	`docker pull redis`

2. Get a mongo (not required): 

	`docker pull redis`

3. Run redis and mongo:
	
	`docker run -d --name tyk_redis redis`
	`docker run -d --name tyk_redis mongo`

4. Get Tyk Gateway

	`docker pull tykio/tyk-gateway`

5. Run Tyk:

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis --link tyk_mongo:mongo tykio/tyk-gateway`

