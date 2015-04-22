Official Tyk Gateway Docker Build (v1.5.1)
==========================================

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

This containerised build will work out of the box using v1.5.1 and a file-based setup. the /etc/tyk folder 
is exposed to mount and modify configuration data, however simply overriding the tyk.conf file with a `-v` parameter will work too.

Quickstart
----------

1. Get a redis container (not required): 

	`docker pull redis`

2. Run redis:
	
	`docker run -d --name tyk_redis redis`

3. Run Tyk:

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v /home/foo/custom.tyk.conf:/etc/tyk/tyk.conf -v /home/foo/custom.host_manager.json:/opt/tyk-dashboard/host-manager/host_manager.json tykio/tyk-gateway:v1.5.1`

You can use an external redis server, in which case you don't need to run the link command, but you will still need to provide a custom configuration file:

	docker run -d --name tyk_gateway -p 8080:8080 -v /home/foo/custom.tyk.conf:/etc/tyk/tyk.conf tykio/tyk-gateway:v1.5.1