Official Tyk Gateway Docker Build
=================================

This container only contains the Tyk API gateway, the dashboard is provided as a seperate container and need to be configured separately. 

Tyk will run with a defaut configuration unless it has been overriden ith the -v flag. Two sample configurations have been provided to run Tyk Gateway standalone (no DB or dashboard, file-based configurations) or with the dashboard and MongoDB.

Quickstart
----------

1. Get a redis container (required - or use an external redis server): 

	`docker pull redis`

2. Get Tyk Gateway

	`docker pull tykio/tyk-gateway`
    
3. Run redis:
	
	`docker run -d --name tyk_redis redis`

4. Run a standalone Tyk Gateway with your (modified) tyk.conf (see sample configs in our docker github repository):

	`docker run -d --name tyk_gateway -p 8080:8080 --link tyk_redis:redis -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf -v $(pwd)/apps:/opt/tyk-gateway/apps tykio/tyk-gateway`

4b. Or to see the gateway in action (non daemonised):

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

For more information you may check the official documentation, there's a section covering the rich plugins feature [here](https://tyk.io/tyk-documentation/customise-tyk/plugins/rich-plugins/what-are-they/).
