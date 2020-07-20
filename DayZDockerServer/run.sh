#!/bin/sh

cd /DayZServer/

# copy config file
if [ ! -f "/DayZConfig/serverDZ.cfg" ]; then
    echo "Copying default configuration"
    cp ./serverDZ.cfg /DayZConfig
fi

# copy mission file and make a link
if [ ! -f /DayZMission/mpmissions ]; then
    echo "Copying default mpmissions"
    cp -r ./mpmissions /DayZMission/mpmissions
fi
rm -rf ./mpmissions
ln -s /DayZMission/mpmissions ./mpmissions

# run dbus
service dbus start

# launch X server
Xvfb :99 -screen 0 640x480x24:32 &
export DISPLAY=:99

# start server
wine64 DayZServer_x64.exe -config=Z:\\DayZConfig\\serverDZ.cfg -profiles=Z:\\DayZProfiles -port=2302 -dologs -adminlog -netlog -freezecheck;
echo "End DayZ Docker Server"
