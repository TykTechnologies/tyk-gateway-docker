
This guide assumes you've been following the quick get-started installation guide.

## Custom Plugins

What does the flow of developing a custom plugin look like?

We have a plugin included in the middleware directory.  It's a JS plugin that injects a header.  We can cURL the API that runs the plugin:

```bash
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

`./middleware/injectHeader.js`
from:
```bash 
request.SetHeaders['custom-header'] = create_UUID();
```

to:
```bash
request.SetHeaders['custom-header'] = 'hello-world'
```


2. Reload Tyk in order to pick up the plugin changes
```bash
$ curl localhost:8080/tyk/reload --header "x-tyk-authorization: foo"
{"status":"ok","message":""}
```

3. Try the curl again:
```bash
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








