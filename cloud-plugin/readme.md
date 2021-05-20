How to generate a bundle to publish to the Tyk Cloud

### 1. Generate bundle

```bash
$ cd cloud-plugin

$ docker run \
--rm \
-v $(pwd):/cloudplugin \
--entrypoint "/bin/sh" -it \
-w "/cloudplugin" \
docker.tyk.io/tyk-gateway/tyk-gateway:v3.2.1 \
-c '/opt/tyk-gateway/tyk bundle build -y'

[Jan 25 21:50:38]  INFO tyk: Building bundle using 'manifest.json'
[Jan 25 21:50:38]  WARN tyk: Using default bundle path 'bundle.zip'
[Jan 25 21:50:38]  WARN tyk: The bundle will be unsigned
[Jan 25 21:50:38]  INFO tyk: Wrote 'bundle.zip' (890 bytes)
```

### 2. Push it to Cloud

```bash
$ ~/mservctl.macos.amd64 --config ~/tyk/ara.mservctl.yaml push bundle.zip
INFO[0000] Using config file:/Users/sedky/tyk/ara.mservctl.yaml  app=mservctl
Middleware uploaded successfully, ID: fdb89c5d-c698-433c-8ffe-f921da0b13db
```

### 3. Update API definition with following ID from above:

`fdb89c5d-c698-433c-8ffe-f921da0b13db`
