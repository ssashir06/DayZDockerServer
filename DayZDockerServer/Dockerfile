#escape=`
ARG tag=1809

## get steamcmd.zip and extract
FROM mcr.microsoft.com/windows/servercore:${tag} AS builder
SHELL ["PowerShell.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:\Installer
### Install Microsoft Visual C++ 2015 Redistributable Update 3
ADD https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe vc_redist.x64.exe
RUN Start-Process -FilePath '.\vc_redist.x64.exe' -ArgumentList '/install /passive /norestart' -Wait;
### Install DirectX (for XAPOFX1_5.dll)
ADD https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe dxwebsetup.exe
RUN Start-Process -FilePath '.\dxwebsetup.exe' -ArgumentList '/Q' -Wait;
### Setting up steamcmd.exe
ADD https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip steamcmd.zip
RUN Expand-Archive -Path steamcmd.zip ; `
    $ErrorActionPreference='Continue'; `
    & steamcmd\steamcmd.exe +quit ; `
    Exit-PSSession ;
### Login and install DayZ Server ..
ARG steamlogin
ARG steampasswd
ARG steamguard=
ENV steamlogin=${steamlogin}
ENV steampasswd=${steampasswd}
ENV steamguard=${steamguard}
RUN Write-Output "LOGIN:$ENV:steamlogin" ; `
    & steamcmd\steamcmd.exe +login $ENV:steamlogin $ENV:steampasswd $ENV:steamguard +force_install_dir C:\DayZServer +app_update 223350 +quit ;

## setting up server
FROM mcr.microsoft.com/windows/servercore:${tag} AS server
SHELL ["PowerShell.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder C:\windows\system32\msvcp140.dll C:\windows\system32
COPY --from=builder C:\windows\system32\vcruntime140.dll C:\windows\system32
COPY --from=builder C:\DayZServer C:\DayZServer
COPY run.ps1 C:\DayZServer
COPY X3DAudio1_7.dll C:\DayZServer
COPY XAPOFX1_5.dll C:\DayZServer

VOLUME C:\DayZProfiles
VOLUME C:\DayZConfig
VOLUME C:\DayZMission

WORKDIR C:\DayZServer
EXPOSE 2302/tcp 27015-27030/tcp 27036-27037/tcp 2302/udp 4380/udp 27000-27031/udp 27036/udp
ENTRYPOINT [ "PowerShell.exe", "-Command", "C:\\DayZServer\\run.ps1" ]