#
# AWS Setup commands
sudo yum update
sudo amazon-linux-extras install docker
# sudo yum install docker # redundant?
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo shutdown -r now # may need to restart
docker info

# ----
sudo curl -L https://github.com/docker/compose/releases/download/1.26.x/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

docker network create tyk-community-network

# Tutorial https://hub.docker.com/r/tykio/tyk-gateway
# start the redis up no config yet
docker pull redis
docker run -d --name tyk_redis redis

# Was using this but no setup was included so I found the other mongo with express stack
# docker pull mongo
docker run -d --name tyk_mongo mongo

# startup the mongo no config yet
# docker-compose -f tyk_mondo.yml up

#--  the gateway with links to the other boxes- working???
docker run -d --name tyk_gateway -p 8080:8080 \
  --link tyk_redis:redis --link tyk_mongo:mongo \
  -v $(pwd)/tyk/tyk.standalone.conf:/opt/tyk-gateway/tyk.conf \
  tykio/tyk-gateway
# the linking above is important: we need to make sure the /apps, /policies
# started

curl -i -X GET https://tyk.byu-oit-toolsteam-dev.amazon.byu.edu:8080/