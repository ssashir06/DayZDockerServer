# Description
Running DayZ Server on Docker.

# Requirements
- Your Steam account
- Windows Container
- Windows 10 build 1809 or above

# Usage
## Preparation
Copy X3DAudio1_7.dll and XAPOFX1_5.dll to the Dockerfile's directory from your PC. They are located in the C:\Windows\System32.
## Build
To start setting up DayZ Server container image, in the Dockerfile's directory, please run this command.
```
docker build --build-arg steamlogin=STEAM_USERNAME --build-arg steampasswd=STEAM_PASSWORD --build-arg steamguard=STEAM_GUARD -t dayzdockerserver .
```
This might cause error because the steam guard can be expired while this install process.
By default, this install process will use Windows Server Core 1809 to use process isolation. If your environment is not this, it can be customized by using 'tag' build argument. (See the Full Tag Listing section: https://hub.docker.com/_/microsoft-windows-servercore )

## Run
To start the DayZ Server in the docker container, please run these commands.
```
docker run --rm -it --isolation=process dayzdockerserver
docker ps
docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}'  7ba8716b0e65
```
In the last line of the inspect command, you can get the IP address of the container. And also, the container id is an example.

After starting this server, you can connect to this server from same PC.
In addition, Using Dayz Launcher is easier to use because it can specify the server IP address.

# Notification
Please do not make the server's image which named 'dayzdockerserver' public like in DockerHub because it contains licensed files of DayZ Server.

# Current issues
X3DAudio1_7.dll and XAPOFX1_5.dll cannot be copied from build image, because of the installation of DirectX failure.

# TODO
- Creating a docker compose file.
- Creating a volume to customize  configuration.

# Links
- https://write.corbpie.com/installing-and-setting-up-a-dayz-standalone-server-on-windows-server-2016-guide/
- https://developer.valvesoftware.com/wiki/Command_Line_Options#SteamCMD
