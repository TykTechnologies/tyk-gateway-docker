# Tyk Gateway Docker

## About
This repository serves as a playground to help you experiment with `Tyk Gateway`. It includes a _Docker Compose_ file that allows you to quickly set up _Tyk Gateway_ and _Redis_. Additionally, the repository provides several example API definitions and plugins to showcase the gateway's capabilities and help you learn some of its features.

## Getting started 
Click [here](#start-up-the-deployment) to get up and running but please remember to revisit the [next section](#useful-reading) later as it provides valuable yet concise insights on how to make the most of your time while using this repository and learning to know Tyk

## Useful Reading 

### Important settings when using Tyk
These settings apply to any Tyk OSS deployment, this one using Docker Compose as well as test and production environments.

1. [**Redis**](https://redis.io/docs/about/) - Tyk gateway requires a running Redis. To make an easy start this repo has a _Docker Compose_ that spins up the gateway and Redis. If you use our `docker compose`, [the config of the gateway](./tyk.standalone.conf) is already set up to connect to the Redis service. As soon as it's up the gateway is ready to use.
2. **API definitions** - This is the way to set Tyk Gateway to service your API. To quickly get from zero to a live API behind _Tyk Gateway_ use the API definition examples under the [./apps](./apps) directory. 
3. **Gateway configurations** - `tyk.conf` is set up appropriately and ready to use, including the API key to access/config the gateway via its APIs.

### Project Structure 
This repo has a few libraries that contain the file required to demo some of the Tyk gateway capabilities:
- This README - please continue reading it before anything else, it will get you up and running.
- [./get-started](./get-started/) - this docs directory has instructions to create your first API, API key, first plugin etc.
  -  [Your First API](get-started/your-first-api.md)
  -  [Your first token](get-started/your-first-token.md)
  -  [Your First Plugin](get-started/your-first-plugin.md)
- [./app/](./apps/) - Store your API configurations inside local directory `./apps`. You can also find in it example API definitions ready to use.
- [./middleware/](./middleware/) - Store your plugins in this directory. For more information, Check [JavaScript Middleware documentation](https://tyk.io/docs/plugins/supported-languages/javascript-middleware/install-middleware/tyk-ce/). You can also find a Javascript example ready to use.
- [./cloud-plugin/](./cloud-plugin/) - Many times you wouldn't want to store your plugin in the gateway, for that you can also use [a server to serve your plugins](https://tyk.io/docs/plugins/how-to-serve-plugins/plugin-bundles/) and the Tyk gateway will load them from that service. This directory explains how to do that when using [Tyk cloud](https://tyk.io/docs/tyk-cloud/configuration-options/using-plugins/uploading-bundle/#how-do-i-upload-my-bundle-file-to-my-amazon-s3-bucket) while the gateway is functioning as a Hybrid gateway.
- [./certs](./certs/) - 

## Getting Started 
In this section, you will spin up a full Tyk OSS Deployment Using *Docker Compose*

### Requirements

Before you start, please install the following binaries:
- `docker compose`
- An HTTP Client - There are lots of options in the market: 
  - Most common command line - [curl](https://everything.curl.dev/get)
  - For GUI users, the most common one is [Postman](https://www.postman.com/downloads/) 
  - For VS Code users, you can get any of these [VSCode extensions](https://marketplace.visualstudio.com/search?term=http%20client&target=VSCode&category=All%20categories&sortBy=Relevance)). 
    - If you chose [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extention, then you can use our example file [./useful_api_calls.http](useful_api_calls.http) to quickly get up and running.
- [jq](https://stedolan.github.io/jq/download/) - Optional. If you are using a command line HTTP client like `curl`, `jq` will help you to beautify the returned JSON.

### Start up the deployment
Use [docker-compose.yml](./docker-compose.yml) to spin up a Tyk OSS environment with one command. This will start two services, Tyk gateway and Redis use the following command

```curl
$ docker-compose up -d
```

### Check everything is up and running

In the example below we call the `/hello` endpoint using curl (you can use any HTTP client you want):


```curl
curl http://localhost:8080/hello -i
```

It returns the gateway's version and the connection status of Redis.

```bash
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

### Check the loaded APIs

To get the list of APIs that Tyk gateway services, run the following:

```curl
curl http://localhost:8080/tyk/apis -H "X-Tyk-Authorization: foo"
```

or in VS Code in a `some-file.http`: 
```curl
http://localhost:8080/tyk/apis
X-Tyk-Authorization: foo
```

The response is a JSON array of the API definitions. 
To beautify the list, use `jq`:
```bash
curl http://localhost:8080/tyk/apis -H "X-Tyk-Authorization: foo" | jq .
```

Notice that we used the API key (secret) to connect to the gateway. 
`/tyk/apis` is the way to configure or check the configuration of Tyk Gateway via APIs and as such it must be protected so only you can connect it.

---

## Getting started using Tyk using *Docker*

For production, in which you use `docker` (not `docker compose`), check the [instructions](get-started/docker-run.md) on our docs website.

### Build your own Tyk Docker image
To you want to build an image yourself please use this [Dockerfile](https://raw.githubusercontent.com/TykTechnologies/tyk/master/Dockerfile)

## Tyk Hybrid Gateway - for paying users only!

*Tyk Hybrid Gateway* is the same Tyk OSS gateway but here it's connecting to a control plane layer (specifically to a component called [MDCB](https://tyk.io/docs/tyk-multi-data-centre/)). The [control plane](https://tyk.io/price-comparison/) can be self-managed or via the SaaS offering on Tyk cloud. As such, this option can be used only by paying clients (including users that trial the paying option). 


**FYI** Tyk cloud has also a [Cloud Free plan](https://tyk.io/docs/tyk-cloud/account-billing/plans/) but Hybrid gateways are not part of it.

To set up a Hybrid gateway/cluster of gateways, do the following:

1. Change the following 3 values in the gateway config file (in this repo it is referred to as [tyk.hybrid.conf](./tyk.hybrid.conf):
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

2. Use the hybrid config file in `docker compose` by mounting it into the Gateway in `docker-compose.yml`

Change from
```bash
- ./tyk.standalone.conf:/opt/tyk-gateway/tyk.conf
```

To:
```bash
- ./tyk.hybrid.conf:/opt/tyk-gateway/tyk.conf
```

That's it!  Now run `docker-compose up`

---

## PRs
PRs with new examples and fixes are most welcome.
A contributor guide will be added in the future but for the time being, please explain your PR in the description and provide evidence for manual testing of the code.

### SLA
First response (clarifying questions/guidance on improvements/answering questions) - Target: 48 hours
Detailed review and feedback on PRs - Target: 7 days

----

## Bugs

We'd love to know about any bug or defect you find, no matter how small it is.

### SLA
First response (clarifying questions/guidance on improvements/answering questions) - Target: 48 hours

---

## Features

We'd love to hear from you. Any feedback, idea or feature request is most welcomed.

### SLA
First response (clarifying questions/guidance on improvements/answering questions) - Target: 72 hours

---

## Todo

Add Tyk pump to the `docker compose` so we can stream analytics to a data sink.

---

## Questions
For question on products, please use [Tyk Community forum](https://community.tyk.io/).

Clients can also use support@tyk.io.

Potential clients and evaluators, please use info@tyk.io.
