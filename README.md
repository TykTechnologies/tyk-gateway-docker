Tyk Gateway Docker
=================================

This container only contains the Tyk OSS API Gateway, the Tyk Dashboard is provided as a separate container and needs to be configured separately.

Tyk will run with a default configuration unless it has been overridden with the `-v` flag. Two sample configurations have been provided to run the Tyk Gateway as standalone (no DB or dashboard, file-based configurations) or with the Tyk Dashboard and MongoDB.

# Installation


## Docker-Compose

With docker-compose, simply run 
```
$ docker-compose up -d
```

This will run both Tyk GW & Redis.  It mounts two directories, `middleware` and `apps` to add your APIs as well as your custom plugins.

## Docker

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

You will need a local Redis container or external Redis server for the Gateway to communicate with.

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

Now that you have the Gateway locally, you will need to grab a configuration file. You may use `tyk.standalone.conf` or
`tyk.with_dashboard.conf` from https://github.com/TykTechnologies/tyk-gateway-docker as a base template using the
appropriate version for your use-case.

Documentation for gateway configuration can be found here: https://tyk.io/docs/tyk-configuration-reference/tyk-gateway-configuration-options/

Alternatively, should you wish to configure tyk using environment variables, see https://tyk.io/docs/tyk-configuration-reference/environment-variables/ for details of how our environment variables are constructed.

Please note that you should set the Gateway secret in the `TYK_GW_SECRET` environment variable.  If you do not, the entrypoint script will attempt to set `TYK_GW_SECRET` environment variable from the value of `secret` in tyk.conf.

```
TYK_GW_SECRET=foo
```

We will now run the Gateway by mounting our modified `tyk.conf`.

## Custom Plugins

How does a Custom plugin flow look like?

We have a plugin included in the [middleware](./middleware) direction.  It's a JS plugin that injects a header.  We can cURL the API that runs the plugin:

```
$ curl localhost:8080/keyless-test/get

{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Custom-Header": "f4ce942f-63ee-4dde-b58d-00df0d666f7f",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.64.1",
    "X-Amzn-Trace-Id": "Root=1-5fff2f39-0ffa06383a4261810e20439b"
  },
  "origin": "172.29.0.1, 99.242.139.220",
  "url": "http://httpbin.org/get"
}
```

1. Let's modify the plugin to change the value of custom-header to something else:
[injectHeader.js](./middleware/injectHeader.js)

from:
```
request.SetHeaders['custom-header'] = create_UUID();
```

to:
```
request.SetHeaders['custom-header'] = 'hello-world'
```


2. Reload Tyk in order to pick up the plugin changes
```
$ curl localhost:8080/tyk/reload --header "x-tyk-authorization: foo"
{"status":"ok","message":""}
```

3. Try the curl again:
```
$ curl localhost:8080/keyless-test/get
{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Custom-Header": "hello world",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.64.1",
    "X-Amzn-Trace-Id": "Root=1-5fff2fc2-7ee63c03157a338531f31c1a"
  },
  "origin": "172.29.0.1, 99.242.139.220",
  "url": "http://httpbin.org/get"
}
```

That's it!  You're now writing custom plugins in Tyk.

**Note**, the process for Go plugins and gRPC plugins is different.