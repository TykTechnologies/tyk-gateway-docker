FROM debian:jessie-slim

ENV GRPCVERSION 1.7.0
ENV TYKVERSION 2.8.5
ENV TYKLANG ""

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            wget curl ca-certificates apt-transport-https gnupg unzip \
 && curl -L https://packagecloud.io/tyk/tyk-gateway/gpgkey | apt-key add - \
 && apt-get install -y --no-install-recommends \
            build-essential \
            libluajit-5.1-2 \
            luarocks \
 && luarocks install lua-cjson \
 && apt-get install -y --no-install-recommends \
            python3-setuptools \
            libpython3.4 \
            jq \
 && wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py \
 && pip3 install grpcio==$GRPCVERSION \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y \
 && rm -rf /root/.cache

# The application RUN command is separated from the dependencies to enable app updates to use docker cache for the deps
RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/debian/ jessie main" | tee /etc/apt/sources.list.d/tyk_tyk-gateway.list \
 && apt-get update \
 && apt-get install --allow-unauthenticated -f --force-yes -y tyk-gateway=$TYKVERSION \
 && rm -rf /var/lib/apt/lists/*

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
COPY ./entrypoint.sh /opt/tyk-gateway/entrypoint.sh

VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway/

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
