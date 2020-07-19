# Download server
FROM cm2network/steamcmd AS builder
### Login and install DayZ Server ..
WORKDIR /home/steam
ARG steamlogin=anonymous
ARG steampasswd=
ARG steamguard=
RUN steamcmd/steamcmd.sh \
    +login ${steamlogin} $steampasswd ${steamguard} \
    +force_install_dir ~/DayZServer \
    +@sSteamCmdForcePlatformType windows +@sSteamCmdForcePlatformBitness 64 \
    +app_update 223350 \
    +quit

# Wine env
FROM mcr.microsoft.com/powershell:lts-ubuntu-bionic AS wine-env
USER root
WORKDIR /root
RUN apt-get update && apt-get install -y wget gnupg2 software-properties-common xvfb cabextract dos2unix p7zip-full winbind zip unzip
RUN dpkg --add-architecture i386
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - &&\
    apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ bionic main' &&\
    wget -O - https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add - &&\
    sh -c 'echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./" > /etc/apt/sources.list.d/obs.list'
RUN apt-get update &&\
    apt-get install -y --install-recommends winehq-stable &&\
    apt-get clean
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/local/bin/winetricks &&\
    chmod +x /usr/local/bin/winetricks
ENV WINEARCH win64
ENV WINEPREFIX=/opt/win
RUN mkdir -p $WINEPREFIX
RUN winetricks win10
RUN wineboot -r

# setting up server
FROM wine-env AS server
COPY --from=builder /home/steam/DayZServer /DayZServer
COPY run.sh /DayZServer

VOLUME /DayZProfiles
VOLUME /DayZConfig
VOLUME /DayZMission

WORKDIR /DayZServer
EXPOSE 2302/tcp 27015-27030/tcp 27036-27037/tcp 2302/udp 4380/udp 27000-27031/udp 27036/udp
ENTRYPOINT [ "/DayZServer/run.sh" ]