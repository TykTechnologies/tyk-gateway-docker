FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y wget curl ca-certificates apt-transport-https curl
RUN curl https://packagecloud.io/gpg.key | apt-key add -
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN apt-get update

RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main" | sudo tee /etc/apt/sources.list.d/tyk_tyk-gateway.list

RUN echo "deb-src https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main" | sudo tee -a /etc/apt/sources.list.d/tyk_tyk-gateway.list

RUN apt-get update
RUN apt-get install -y tyk-gateway=2.1.0.1

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway

CMD ["/opt/tyk-gateway/tyk", "--conf=/opt/tyk-gateway/tyk.conf"]
EXPOSE 8080
