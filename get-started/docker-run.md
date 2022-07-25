# Running Tyk gateway using docker

Tyk will run with a default configuration unless it has been overridden with the `-v` flag. Two sample configurations have been provided to run the Tyk Gateway as standalone (no DB or dashboard, file-based configurations) or with the Tyk Dashboard and MongoDB.

## Configure a network

```
docker network create tyk
ab1084d034c7e95735e10de804fc54aa940c031d2c4bb91d984675e5de2755e7

docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
---snip---
ab1084d034c7        tyk                 bridge              local
```

## Redis Dependency

You will need a local Redis container or external Redis server for the Gateway to communicate with.

In a production environment, we would recommend that Redis is highly available and deployed as a cluster.

```bash
# NOT FOR PRODUCTION
docker pull redis:4.0-alpine
docker run -itd --rm --name redis --network tyk -p 127.0.0.1:6379:6379 redis:4.0-alpine

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                        NAMES
b713c61fd8fe        redis:4.0-alpine    "docker-entrypoint.s…"   5 seconds ago       Up 4 seconds        127.0.0.1:6379->6379/tcp     redis
```

## Deploy Tyk Gateway

```bash
docker pull docker.tyk.io/tyk-gateway/tyk-gateway:latest
```

Now that you have the Gateway locally, you will need to grab a configuration file. You may use `tyk.standalone.conf` or
`tyk.with_dashboard.conf` from https://github.com/TykTechnologies/tyk-gateway-docker as a base template using the
appropriate version for your use-case.

Documentation for gateway configuration can be found here: https://tyk.io/docs/tyk-configuration-reference/tyk-gateway-configuration-options/

Alternatively, should you wish to configure tyk using environment variables, see https://tyk.io/docs/tyk-configuration-reference/environment-variables/ for details of how our environment variables are constructed.

Please note that you should set the Gateway secret in the `TYK_GW_SECRET` environment variable.  If you do not, the entrypoint script will attempt to set `TYK_GW_SECRET` environment variable from the value of `secret` in tyk.conf.

```bash
TYK_GW_SECRET=foo
```

We will now run the Gateway by mounting [tyk.standalone.conf](./../tyk.standalone.conf), our modified version of `tyk.conf`.

### Run Tyk OSS Gateway

You may use example api definitions from https://github.com/TykTechnologies/tyk/tree/master/apps
Store your API configurations inside local directory [./apps](./../apps/).

You can now start the Gateway:

```bash
docker run -d \
  --name tyk_gateway \
  --network tyk \
  -p 8080:8080 \
  -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf \
  -v $(pwd)/apps:/opt/tyk-gateway/apps \
  docker.tyk.io/tyk-gateway/tyk-gateway:latest
```

### Tyk OSS Gateway used by Tyk Self Managed

The OSS Gateway is also used with the Tyk Self managed installation (Tyk's licensed product). We will assume that the Tyk manager service is
installed, and running. If not, we would recommend that you follow the [instructions](https://tyk.io/docs/tyk-self-managed/install/) for Tyk manager installation or this [doc](https://github.com/TykTechnologies/tyk-dashboard-docker). 

**FYI** For a quick docker compsoe of Tyk Self managed switch to [Tyk docker demo repo](https://github.com/TykTechnologies/tyk-pro-docker-demo).


The Gateway relies upon the Dashboard service to load its API definitions & proxy configurations.
As such, there is **no need** to mount any app directory.

```bash
docker run -d \
  --name tyk_gateway \
  --network tyk \
  -p 8080:8080 \
  -v $(pwd)/tyk.with_dashboard.conf:/opt/tyk-gateway/tyk.conf \
  docker.tyk.io/tyk-gateway/tyk-gateway:latest
```

### Check everything is up and running

```bash
curl http://localhost:8080/hello -i
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 25 Jul 2022 19:16:45 GMT
Content-Length: 156

{
  "status": "pass",
  "version": "v3.2.1",
  "description": "Tyk GW",
  "details": {
    "redis": {
      "status": "pass",
      "componentType": "datastore",
      "time": "2022-07-25T19:16:16Z"
    }
  }
}

```

## Rich plugins

The Tyk Gateway supports rich plugins as a part of the main binary since v2.9.0, making the `TYKLANG` environment variable deprecated and it is now ignored.

If you're running an image tag older than v2.9.0, To run Tyk with rich plugins support, you must set the `TYKLANG` environment variable. Currently supported value is `-python` for Python support.

An additional requirement is to provide a directory for the plugin bundles:
```
$ mkdir bundles
$ docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf -v $(pwd)/apps:/opt/tyk-gateway/apps -v $(pwd)/bundles:/opt/tyk-gateway/middleware/bundles -e TYKLANG='-python' docker.tyk.io/tyk-gateway/tyk-gateway`
```

Remember to modify your `tyk.conf` to include the required global parameters, essentially:

```json
"coprocess_options": {
  "enable_coprocess": true,
},
"enable_bundle_downloader": true,
"bundle_base_url": "http://my-bundle-server.com/bundles/",
```

These global parameters are covered in this [Python Tutorial](https://tyk.io/docs/plugins/rich-plugins/python/tutorial-add-demo-plugin-api/#a-name-global-settings-a-global-settings).

For more information, see our [rich plugins documentation](https://tyk.io/docs/plugins/rich-plugins/).
