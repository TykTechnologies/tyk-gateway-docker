Official Tyk Gateway Docker Build
=================================

This container only contains the Tyk API gateway, the dashboard is provided as a seperate container and need to be configured separately. 

Tyk will run with a default configuration unless it has been overriden with the -v flag. Two sample configurations have been provided to run Tyk Gateway standalone (no DB or dashboard, file-based configurations) or with the dashboard and MongoDB.

### Configure a network

```
docker network create tyk
ab1084d034c7e95735e10de804fc54aa940c031d2c4bb91d984675e5de2755e7

docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
---snip---
ab1084d034c7        tyk                 bridge              local
```

### Redis Dependency 

You will need a local redis container or external redis server for the gateway to communicate with.

In a production environment, we would recommend that Redis is highly available and deployed as a cluster. 

```
# NOT FOR PRODUCTION
docker pull redis:4.0-alpine
docker run -itd --rm --name redis --network tyk -p 127.0.0.1:6379:6379 redis:4.0-alpine

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                        NAMES
b713c61fd8fe        redis:4.0-alpine    "docker-entrypoint.s…"   5 seconds ago       Up 4 seconds        127.0.0.1:6379->6379/tcp     redis
```

### Deploy Tyk Gateway

```
docker pull tykio/tyk-gateway:latest
```

Now that you have the gateway locally, you will need to grab a configuration file. You may use `tyk.standalone.conf` or 
`tyk.with_dashboard.conf` from https://github.com/TykTechnologies/tyk-gateway-docker as a base template using the 
appropriate version for your use-case. 

Documentation for gateway configuration can be found here: https://tyk.io/docs/configure/tyk-gateway-configuration-options/

Alternatively, should you wish to configure tyk using environment variables, then you can find the mappings here: https://tyk.io/docs/configure/environment-variables/

Please note that you should set the gateway secret in the `TYKSECRET` environment variable.  If you do not, the entrypoint script will attempt to read the gateway secret into the `TYKSECRET` environment variable from the tyk.conf file.

```
TYKSECRET=foo
```

We will now run the gateway by mounting our modified `tyk.conf`.

### Gateway - Headless

You may use example api definitions from https://github.com/TykTechnologies/tyk/tree/master/apps
Store your API configurations inside local directory `./apps`.

We may now start the gateway:

```
docker run -d \
  --name tyk_gateway \
  --network tyk \
  -p 8080:8080 \
  -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf \
  -v $(pwd)/apps:/opt/tyk-gateway/apps \
  tykio/tyk-gateway:latest
```

### Gateway - Pro installation with Dashboard

The gateway in a Pro installation is dependent on the dashboard service. We will assume that the dashboard service is
installed, up and running. If not, we would recommend that you follow the dashboard installation guide here:

https://github.com/TykTechnologies/tyk-dashboard-docker

The gateway relies upon the dashboard service to load it's api definitions & proxy configurations.
As such, there is no need to mount any app directory.

```
docker run -d \
  --name tyk_gateway \
  --network tyk \
  -p 8080:8080 \
  -v $(pwd)/tyk.with_dashboard.conf:/opt/tyk-gateway/tyk.conf \
  tykio/tyk-gateway:latest
```

### Check everything is up and running

```
curl http://localhost:8080/hello -i
HTTP/1.1 200 OK
Date: Fri, 11 Jan 2019 15:53:29 GMT
Content-Length: 10
Content-Type: text/plain; charset=utf-8

Hello Tiki
```

Rich plugins
----------

To run Tyk with rich plugins support, you must set the `TYKLANG` environment variable. Currently supported values are `-python` and `-lua` (for Python/Lua support).

An additional requirement is to provide a directory for the plugin bundles:
```
$ mkdir bundles
$ docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf -v $(pwd)/apps:/opt/tyk-gateway/apps -v $(pwd)/bundles:/opt/tyk-gateway/middleware/bundles -e TYKLANG='-python' tykio/tyk-gateway`
```

Remember to modify your `tyk.conf` to include the required global parameters, essentially:

```json
"coprocess_options": {
  "enable_coprocess": true,
},
"enable_bundle_downloader": true,
"bundle_base_url": "http://my-bundle-server.com/bundles/",
```

These global parameters are covered in [this page](https://tyk.io/tyk-documentation/customise-tyk/plugins/rich-plugins/python/tutorial-add-demo-plugin-api/).

For more information you may check the official documentation, there's a section covering the rich plugins feature [here](https://tyk.io/tyk-documentation/customise-tyk/plugins/rich-plugins/what-are-they/).
