Official Tyk Gateway Docker Build
=================================

This container only contains the Tyk API Gateway. The Tyk Dashboard is provided as a separate container and need to be configured separately. 

Tyk will run with a default configuration unless it has been overridden with the `-v` flag. Two sample configurations have been provided to run the Tyk Gateway either as a standalone (no DB or Dashboard, file-based configurations) or with the Dashboard and MongoDB.

The following ports are required to be open:

For Redis: 6379
For MongoDB: 27017

Quickstart
----------

1. Get a Redis container (required - or use an external Redis server): 

	`docker pull redis`

2. Get the Tyk Gateway

	`docker pull tykio/tyk-gateway`
    
3. Run Redis:
	
	`docker run -d --name tyk_redis redis`

4. Run a standalone Tyk Gateway with your (modified) tyk.conf (see sample configs in our Gateway github https://github.com/TykTechnologies/tyk/tree/master/apps repository):

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf -v $(pwd)/apps:/opt/tyk-gateway/apps tykio/tyk-gateway`

4b. Or to see the Gateway in action (non daemonised):

    docker run -p 8080:8080 --link tyk_redis:redis tykio/tyk-gateway

Make sure the `apps` folder has some API Definitions set, otherwise Tyk won't proxy any trafic.

5. Check it's running:

    curl -L http://localhost:8080//tyk-api-test/get

If you see:

    {
        "error": "Authorization field missing"
    }

Then Tyk is running, use our REST API to create some tokens and add some APIs!

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

For more information, check our [Rich Plugin documentation](https://tyk.io/tyk-documentation/customise-tyk/plugins/rich-plugins/what-are-they/).
