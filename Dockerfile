FROM dockerfile/ubuntu
RUN wget https://github.com/lonelycode/tyk/releases/download/1.5/tyk.linux.amd64_1.5-1_all.deb
RUN sudo dpkg -i tyk.linux.amd64_1.5-1_all.deb
RUN wget https://github.com/lonelycode/tyk/releases/download/1.5.1/tyk_linux_amd64
RUN sudo rm /usr/bin/tyk
RUN sudo mv ~/tyk_linux_amd64  /usr/bin/tyk
RUN sudo chmod +x /usr/bin/tyk
VOLUME ["/etc/tyk/"]

WORKDIR /etc/tyk

CMD ["tyk"]
EXPOSE 8080