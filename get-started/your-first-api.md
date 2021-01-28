This guide assumes you've been following the quick get-started installation guide.

### Your First API

Now that Tyk is running, we are ready to protect our APIs.

On the Tyk Gateway's file system, there is an "apps" directory.  That is where we place our API definitions that tell Tyk how to protect and reverse proxy our APIs.

#### Included API

Inside the docker-compose directory:
```bash
$ ls -l apps
keyless-plugin-api.json
protected-api.json
```

Let's look at our keyless API

`"apps/keyless-plugin-api.json"`
```json 
{
    "name": "Tyk Test Keyless API",
    "api_id": "keyless",
    "org_id": "default",
    "definition": {
        "location": "header",
        "key": "version"
    },
    "use_keyless": true,
    "version_data": {
        "not_versioned": true,
        "versions": {
            "Default": {
                "name": "Default"
            }
        }
    },
    "custom_middleware": {
        "pre": [
          {
            "name": "testJSVMData",
            "path": "./middleware/injectHeader.js",
            "require_session": false,
            "raw_body_only": false
          }
        ]
  },
    "driver": "otto",
    "proxy": {
        "listen_path": "/keyless-test/",
        "target_url": "http://httpbin.org",
        "strip_listen_path": true
    }
}
```

The things we care about are:

```json
"proxy": {
    "listen_path": "/keyless-test/",
    "target_url": "http://httpbin.org",
    "strip_listen_path": true
}
```

So we can see that the Gateway is listening on the `/keyless-test/` path for this API, and reverse proxying that traffic to `http://httpbin.org`, which is a mock server that will echo our HTTP request.

Let's try hitting the equivalent of `http://httpbin.org/get`
```bash
$ curl http://httpbin.org/get
{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.64.1",
    "X-Amzn-Trace-Id": "Root=1-6005eefc-339c26631235a98376c98973"
  },
  "origin": "99.242.139.220",
  "url": "http://httpbin.org/get"
}

$ curl http://localhost:8080/keyless-test/get
{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Custom-Header": "hello world",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.64.1",
    "X-Amzn-Trace-Id": "Root=1-6005ef18-3c24aa511227f7384b0213b7"
  },
  "origin": "192.168.112.1, 99.242.139.220",
  "url": "http://httpbin.org/get"
}
```
We can see the only difference between the two responses is the "custom-header" that was added by Tyk, as well as the extra hop in `origin`.

**Some of Tyk's built-in capabilities:**

- Rate Limiting
- Authentication (Auth token, JWT, OAuth, OIDC, mTLS, more!)
- Native Plugins
- Round Robin Load Balancing




