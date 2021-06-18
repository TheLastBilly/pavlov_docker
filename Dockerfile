FROM debian:buster-slim

ENV UID=1000
ENV GID=1000

RUN groupadd -g ${GID} steam
RUN useradd -m steam -u ${UID} -g ${GID}
RUN groupmod -g ${GID} steam

ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y
RUN apt install -y gdb curl lib32gcc1 libc++-dev unzip
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /steam
RUN chown -R steam:steam /steam

USER steam
WORKDIR /steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN chmod a=rx /steam/steamcmd.sh
RUN /steam/steamcmd.sh +login anonymous +force_install_dir /steam/pavlovserver +app_update 622970 +exit
RUN /steam/steamcmd.sh +login anonymous +app_update 1007 +quit
RUN mkdir -p ~/.steam/sdk64
RUN ls /steam
RUN cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ~/.steam/sdk64/steamclient.so
RUN cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /steam/pavlovserver/Pavlov/Binaries/Linux/steamclient.so
RUN chmod a=rx /steam/pavlovserver/PavlovServer.sh
RUN mkdir -p /steam/pavlovserver/Pavlov/Saved/Logs
RUN mkdir -p /steam/pavlovserver/Pavlov/Saved/Config/LinuxServer
RUN touch /steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini
RUN touch /steam/pavlovserver/Pavlov/Saved/Config/mods.txt
RUN touch /steam/pavlovserver/Pavlov/Saved/Config/RconSettings.txt
RUN touch /steam/pavlovserver/Pavlov/Saved/Config/blacklist.txt

USER root
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod a=rx /entrypoint.sh

CMD ["/entrypoint.sh"]