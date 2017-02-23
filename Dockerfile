FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y wget curl ca-certificates apt-transport-https curl
RUN curl https://packagecloud.io/gpg.key | apt-key add -
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

RUN apt-get update && apt-get install -y ca-certificates
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN apt-get install -y libluajit-5.1-2
RUN apt-get install -y luarocks
RUN luarocks install lua-cjson

RUN wget https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-python-3.1.0.tar.gz
RUN tar -xvzf protobuf-python-3.1.0.tar.gz
RUN cd protobuf-3.1.0/ &&  ./configure -prefix=/usr && make && make install

RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-dev
RUN cd protobuf-3.1.0/python && python3 setup.py build --cpp_implementation && python3 setup.py install --cpp_implementation
RUN apt-get install -y libpython3.4
RUN apt-get install -y python3-pip
RUN pip3 install grpcio

RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main" | sudo tee /etc/apt/sources.list.d/tyk_tyk-gateway.list

RUN echo "deb-src https://packagecloud.io/tyk/tyk-gateway/ubuntu/ trusty main" | sudo tee -a /etc/apt/sources.list.d/tyk_tyk-gateway.list

RUN apt-get update
RUN apt-get install -y tyk-gateway=2.3.3

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway
COPY entrypoint.sh /opt/tyk-gateway/entrypoint.sh

CMD ["./entrypoint.sh"]
EXPOSE 8080
