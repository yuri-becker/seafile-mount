FROM debian:stable-slim
LABEL version="1.0.0" \
    maintainer="Yuri Becker <hi@yuri.li>"

# Install deps
RUN apt-get update &&\
    apt-get install --yes --no-install-recommends\
        ca-certificates\
        wget\
        lsb-release\
        curl

RUN wget https://linux-clients.seafile.com/seafile.asc -O /usr/share/keyrings/seafile-keyring.asc
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/seafile-keyring.asc] https://linux-clients.seafile.com/seadrive-deb/$(lsb_release -cs)/ stable main" | tee -a /etc/apt/sources.list.d/seadrive.list > /dev/null
RUN echo "deb [arch=arm64 signed-by=/usr/share/keyrings/seafile-keyring.asc] https://linux-clients.seafile.com/seadrive-arm-deb/$(lsb_release -cs)/ stable main" | tee -a /etc/apt/sources.list.d/seadrive.list > /dev/null
RUN apt-get update &&\
  apt-get install --no-install-recommends --yes seadrive-daemon

COPY scripts scripts
ENTRYPOINT scripts/entrypoint.sh