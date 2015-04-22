Official Tyk Gateway Docker Build (v1.5.1)
==========================================

This container only contains the tyk API gateway, the dashboard and host manager are provided as seperate containers and need to be configured differently.

This containerised build will work out of the box using v1.5.1 and a file-based setup. the /etc/tyk folder 
is exposed to mount and modify configuration data, however simply overriding the tyk.conf file with a `-v` parameter will work too.

Quickstart
----------

1. Get a redis container (not required): 

	`docker pull redis`

2. Run redis:
	
	`docker run -d --name tyk_redis redis`

3. Run Tyk:

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v /home/foo/custom.tyk.conf:/etc/tyk/tyk.conf tykio/tyk-gateway:v1.5.1`

You can use an external redis server, in wwhich case you don't need to run the link command, but you will still need to provide a custom configuration file:

	docker run -d --name tyk_gateway -p 8080:8080 -v /home/foo/custom.tyk.conf:/etc/tyk/tyk.conf tykio/tyk-gateway:v1.5.1