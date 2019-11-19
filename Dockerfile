FROM tykio/tyk-build-env:latest

ENV TYKVERSION 2.9.1

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

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
