FROM ubuntu:14.04

ENV PROTOVERSION 3.2.0
ENV TYKVERSION 2.3.7
ENV TYKLANG ""

ENV TYKLISTENPORT 8080
ENV TYKSECRET 352d20ee67be67f6340b4c0605b044b7

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            wget curl ca-certificates apt-transport-https gnupg unzip \
 && curl https://packagecloud.io/gpg.key | apt-key add - \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
 && apt-get install -y --no-install-recommends \
            build-essential \
            libluajit-5.1-2 \
            luarocks \
 && luarocks install lua-cjson \
 && wget -nv -O  /protobuf-python-$PROTOVERSION.tar.gz https://github.com/google/protobuf/releases/download/v$PROTOVERSION/protobuf-python-$PROTOVERSION.tar.gz \
 && cd / && tar -xzf protobuf-python-$PROTOVERSION.tar.gz \
 && cd /protobuf-$PROTOVERSION/ && ./configure -prefix=/usr && make && make install \
 && apt-get install -y --no-install-recommends \
            python3-setuptools \
            python3-dev \
 && cd /protobuf-$PROTOVERSION/python \
 && python3 setup.py build   --cpp_implementation \
 && python3 setup.py install --cpp_implementation \
 && apt-get install -y --no-install-recommends \
            libpython3.4 \
            python3-pip \
 && pip3 install grpcio \
 && cd / && rm -rf /protobuf-$PROTOVERSION && rm -f /protobuf-python-$PROTOVERSION.tar.gz \
 && echo "deb https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main"      | tee /etc/apt/sources.list.d/tyk_tyk-gateway.list \
 && echo "deb-src https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main"  | tee -a /etc/apt/sources.list.d/tyk_tyk-gateway.list \
 && apt-get update \
 && apt-get install -y tyk-gateway=$TYKVERSION \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
COPY ./entrypoint.sh /opt/tyk-gateway/entrypoint.sh

VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway/

EXPOSE $TYKLISTENPORT

CMD ["./entrypoint.sh"]
