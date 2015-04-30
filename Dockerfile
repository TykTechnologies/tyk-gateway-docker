FROM ubuntu
RUN apt-get update && apt-get install -y wget

# Set up Tyk
RUN wget https://github.com/lonelycode/tyk/releases/download/1.6/tyk.linux.amd64_1.6-1_all.deb
RUN sudo dpkg -i tyk.linux.amd64_1.6-1_all.deb

# Set up a docker-safe config
COPY tyk.local.conf /etc/tyk/tyk.conf

VOLUME ["/etc/tyk/"]

WORKDIR /etc/tyk

CMD ["tyk"]
EXPOSE 8080