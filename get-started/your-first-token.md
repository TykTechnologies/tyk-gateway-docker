This guide assumes you've been following the quick get-started installation guide.

### Your First Protected API

Let's look inside our apps directory at our protected API:

```json
{
    "name": "Tyk Test API",
    "api_id": "1",
    "org_id": "default",
    "definition": {
        "location": "header",
        "key": "version"
    },
    "auth": {
        "auth_header_name": "authorization"
    },
    "version_data": {
        "not_versioned": true,
        "versions": {
            "Default": {
                "name": "Default"
            }
        }
    },
    "proxy": {
        "listen_path": "/tyk-api-test/",
        "target_url": "http://httpbin.org",
        "strip_listen_path": true
    }
}
```

We can try to hit this API through Tyk:

```bash
$ curl http://localhost:8080/tyk-api-test/get
{
    "error": "Authorization field missing"
}
```

We need to create our first token through Tyk in order to access this API.
Looking at the Gateway's [REST API reference](https://site-dev.tykbeta.com/docs/tyk-gateway-api/), we can create a token through this API:
```bash
$ curl localhost:8080/tyk/keys -X POST --header "x-tyk-authorization: foo" -d '
{
  "quota_max": 0,
  "rate": 2,
  "per": 5,
  "org_id": "default",
  "access_rights": {
      "1": {
          "api_name": "Tyk Test API",
          "api_id": "1",
          "versions": [
              "Default"
          ],
          "allowed_urls": [],
          "limit": null,
          "allowance_scope": ""
      }
    }
}'

## Response
{"key":"default3349f3ea7d734d2b88e4d1e6baebcf89","status":"ok","action":"added","key_hash":"8bcf94d4"}
```

Now we can use the generated key to access our API:

```bash
$ curl http://localhost:8080/tyk-api-test/get -H "Authorization:default3349f3ea7d734d2b88e4d1e6baebcf89"
```
Response:
```json
{
  "args": {}, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip", 
    "Authorization": "default3349f3ea7d734d2b88e4d1e6baebcf89", 
    "Host": "httpbin.org", 
    "User-Agent": "curl/7.64.1", 
    "X-Amzn-Trace-Id": "Root=1-6005f28e-666d69ee5afca26c6a022cfb"
  }, 
  "origin": "192.168.112.1, 99.242.139.220", 
  "url": "http://httpbin.org/get"
}
```

Careful, we only gave this key access to 2 requests per 5 seconds.  If you exceed that, you'll get a `429 - rate limit exceeded` error.

