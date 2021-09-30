We would like to deprecate this repo as the release automation builds official images from the repo itself.

If you'd like this repo to keep going, please do describe your use case in an issue and we can work something out.

Tyk Gateway Docker
=================================

This container only contains the Tyk OSS API Gateway, the Tyk Dashboard is provided as a separate container and needs to be configured separately.


# Installation

Want to install using only Docker, or want a more advanced guide?  Visit the [Docker install](get-started/install-with-docker.md) page.

## Docker-Compose

With docker-compose, simply run 
```
$ docker-compose up -d
```

[1. Your First API](get-started/your-first-api.md)

[2. Your first token](get-started/your-first-token.md)

[3. Your First Plugin](get-started/your-first-plugin.md)


## Hybrid

If you are setting up a Hybrid cluster, do the following:

**NOTE:** If you are using Tyk Classic Cloud your `<MDCB-INGRESS>` url is: "hybrid.cloud.tyk.io:9091"

1. Change the following 3 values in `tyk.hybrid.conf`:
```json
    "slave_options": {
        "rpc_key": "<ORG_ID>",
        "api_key": "<API-KEY>",
        "connection_string": "<MDCB-INGRESS>:443",
```

it should look like this:

```json
    "slave_options": {
        "rpc_key": "j3jf8as9991ad881349",
        "api_key": "adk12k9d891j48df824",
        "connection_string": "persistent-bangalore-hyb.aws-usw2.cloud-ara.tyk.io:443",
```

2. Mount the hybrid conf into the Gateway in `docker-compose.yml`

From
```
- ./tyk.standalone.conf:/opt/tyk-gateway/tyk.conf
```

To:
```
- ./tyk.hybrid.conf:/opt/tyk-gateway/tyk.conf
```

That's it!  Now run `docker-compose up`
