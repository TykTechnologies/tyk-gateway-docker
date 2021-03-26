#!/usr/bin/env bash


# toyed around with a network
docker network create tyk-community-network

# Tutorial https://hub.docker.com/r/tykio/tyk-gateway
# start the redis up no config yet
docker pull redis
docker run -d --name tyk_redis redis

# Was using this but no setup was included so I found the other mongo with express stack
# docker pull mongo
# docker run -d --name tyk_mongo mongo

# startup the mongo no config yet
docker-compose -f tyk_mondo.yml up

#--  the gateway with links to the other boxes- working???
docker run -d --name tyk_gateway -p 8080:8080 \
  --link tyk_redis:redis --link tyk_mongo:mongo \
  -v $(pwd)/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf \
  -v $(pwd)/apps:/opt/tyk-gateway/apps \
  -v $(pwd)/policies:/opt/tyk-gateway/policies \
  tykio/tyk-gateway

# started