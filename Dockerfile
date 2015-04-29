FROM ubuntu

# Set up Tyk
RUN wget https://github.com/lonelycode/tyk/releases/download/1.6/tyk.linux.amd64_1.6-1_all.deb
RUN sudo dpkg -i tyk.linux.amd64_1.6-1_all.deb

VOLUME ["/etc/tyk/"]

WORKDIR /etc/tyk

CMD ["tyk"]
EXPOSE 8080