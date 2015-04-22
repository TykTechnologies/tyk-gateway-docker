FROM dockerfile/ubuntu

# Get the host manager
RUN wget https://github.com/lonelycode/tyk/releases/download/1.5/tyk-dashboard-amd64-v0.9.3.tar.gz
RUN sudo tar -xvzf tyk-dashboard-amd64-v0.9.3.tar.gz -C /opt
RUN sudo mv /opt/tyk-analytics-v0.9.3 /opt/tyk-dashboard
RUN sudo chmod +x /opt/tyk-dashboard/host-manager/tyk-host-manager 

# Set up Tyk
RUN wget https://github.com/lonelycode/tyk/releases/download/1.5/tyk.linux.amd64_1.5-1_all.deb
RUN sudo dpkg -i tyk.linux.amd64_1.5-1_all.deb
RUN wget https://github.com/lonelycode/tyk/releases/download/1.5.1/tyk_linux_amd64
RUN sudo rm /usr/bin/tyk
RUN sudo mv ~/tyk_linux_amd64  /usr/bin/tyk
RUN sudo chmod +x /usr/bin/tyk

ADD tyk_entrypoint.sh /usr/bin/tyk_entrypoint.sh
RUN sudo chmod +x /usr/bin/tyk_entrypoint.sh

VOLUME ["/etc/tyk/"]

WORKDIR /etc/tyk

CMD ["/usr/bin/tyk_entrypoint.sh"]
EXPOSE 8080