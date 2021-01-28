FROM debian:buster-slim

ENV GRPCVERSION 1.24.0
ENV TYKVERSION 3.0.4
ENV TYKLANG ""

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            wget curl ca-certificates apt-transport-https gnupg unzip \
 && curl -L https://packagecloud.io/tyk/tyk-gateway/gpgkey | apt-key add - \
 && apt-get install -y --no-install-recommends \
            build-essential \
            python3-setuptools \
            libpython3.7 \
            python3.7-dev \
            jq \
 && rm -rf /usr/include/* && rm /usr/lib/x86_64-linux-gnu/*.a && rm /usr/lib/x86_64-linux-gnu/*.o \
 && rm /usr/lib/python3.7/config-3.7m-x86_64-linux-gnu/*.a \
 && wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py \
 && pip3 install protobuf grpcio==$GRPCVERSION \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y \
 && rm -rf /root/.cache

# The application RUN command is separated from the dependencies to enable app updates to use docker cache for the deps
RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/debian/ buster main" | tee /etc/apt/sources.list.d/tyk_tyk-gateway.list \
 && apt-get update \
 && apt-get install --allow-unauthenticated -f --force-yes -y tyk-gateway=$TYKVERSION \
 && rm -rf /var/lib/apt/lists/*

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
COPY ./entrypoint.sh /opt/tyk-gateway/entrypoint.sh

VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway/

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
