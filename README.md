


# Tyk Gateway Docker

## About
This repository is used to try out and demo Tyk OSS Gateway. It contains a docker compose to spin up the gateway and also a few example API definitions and plugins to demo and quickly learn its capabilities.


## Purpose

This repo's goal is to reduce frictions in getting started with Tyk OSS gateway.
1. Redis - Tyk gateway requires a running Redis. To make an easy start this repo has a docker compose that spins up the gateway and Redis. The config of the gateway is already set up to find this Redis service. As soon as it's up the gateway is ready to use.
2. API definitions - to quickly get from zero to a live API behind Tyk gateway you can find API defintion examples
3. Gateway configurations - `tyk.conf` is set up appropriately and ready to use, including the API key to access/config the the gateway via its APIs.

* If you want to build Tyk docker image yourself please use this [Dockerfile](https://github.com/TykTechnologies/tyk/blob/master/ci/Dockerfile.slim)

### Todo

Add pump to the `docker compose` so we can stream analytics to a data sink.



## Running Tyk Gateway

### Requirements

Before you start, please install the following binaries before starting:
- docker compose
- curl

### Option #1 - using docker compose

Use [docker-compose.yaml](./docker-compose.yml) to spin up a Tyk OSS environment with one command. This will start two services, Tyk gateway and Redis use the following command

``` curl
$ docker-compose up -d
```

#### Check everything is up and running

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

##### Check the loaded apis

To get the list of APIs that Tyk gateway is service run the following:

```bash
curl http://localhost:8080/tyk/apis -H "X-Tyk-Authorization: foo"
```

or in vscode in a `some-file.http`: 
```
http://localhost:8080/tyk/apis
X-Tyk-Authorization: foo
```


#### Option #2 - using docker

If you want to run docker (not docker compose), use the instructions in this [doc](get-started/docker-run.md) to get up and running.

### Getting started

1. [Your First API](get-started/your-first-api.md)

2. [Your first token](get-started/your-first-token.md)

3. [Your First Plugin](get-started/your-first-plugin.md)


## Hybrid Gateway

Hybrid gateway is an OSS gateway that connect to a control plane layer. The control plane can be self hosted (paying users) or on Tyk cloud.


**FYI** Tyk cloud has also a [Cloud Free plan](https://tyk.io/docs/tyk-cloud/account-billing/plans/) and you can use it without any cost.

To set up a Hybrid gateway/cluster of gateways, do the following:

1. Change the following 3 values in the gateway config file (in this repo it is referred as [tyk.hybrid.conf](./tyk.hybrid.conf):
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

2. Use the hybrid config file in docker compose by mounting it into the Gateway in `docker-compose.yml`

Change from
```json
- ./tyk.standalone.conf:/opt/tyk-gateway/tyk.conf
```

To:
```json
- ./tyk.hybrid.conf:/opt/tyk-gateway/tyk.conf
```

That's it!  Now run `docker-compose up`


## How to use the project

This repo has a few libraries that contain the file required to demo some of the Tyk gateway capabilities:
- [./get-started](./get-started/) - to help you get start, this docs directory has instructions to create your first API, API key, first plugin etc.
- [./app/](./apps/) - Store your API configurations inside local directory `./apps`. You can also find in it example api definitions ready to use.
- [./middleware/](./middleware/) - Store your plugins in this directory. For more information, Check [JavaScript Middleware documentation](https://tyk.io/docs/plugins/supported-languages/javascript-middleware/install-middleware/tyk-ce/). You can also find a Javascript example ready to use.
- [./cloud-plugin/](./cloud-plugin/) - Many times you wouldn't want to store your plugin in the gateway, for that you can also use [a server to serve your plugins](https://tyk.io/docs/plugins/how-to-serve-plugins/plugin-bundles/) and the Tyk gateway will load them from that service. This directory explains how to do that when using [Tyk cloud](https://tyk.io/docs/tyk-cloud/configuration-options/using-plugins/uploading-bundle/#how-do-i-upload-my-bundle-file-to-my-amazon-s3-bucket) while the gateway is functioning as a Hybrid gateway.
- [./certs](./certs/) - 



## PRs
PRs with new examples and fixes are most welcomed.
A contributor guide will be added in the future but for the time being, please explain your PR in the description and provide evidence for manual testing of the code.

#### SLA
First response (clarifying questions/guidance on improvements/answering questions) - target of **48 hours**
Detailed review and feedback on PRs - target 7 days

----
## Bugs

We'd love to know about any bug or defect you find, no matter how small it is.

#### SLA
First response (clarifying questions/guidance on improvements/answering questions) - target of **48 hours**


## Features

We'd love to hear from you. Any feedback, idea or feature request is most welcomed.

#### SLA
First response (clarifying questions/guidance on improvements/answering questions) - target **72 hours**


## Questions
For question on products, please use [Tyk Community forum](https://community.tyk.io/).

Clients can also use support@tyk.io.

Potential clients and evaluators, please use info@tyk.io.
