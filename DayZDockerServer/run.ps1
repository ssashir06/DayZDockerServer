$ErrorActionPreference = 'Stop';
Set-Location C:\DayZServer\ ;

# copy config file
if (-Not(Test-Path -Path C:\DayZConfig\serverDZ.cfg)) {
    Write-Host 'Copying default configuration';
    Copy-Item -Path .\serverDZ.cfg -Destination C:\DayZConfig\ ;
}

# copy mission file and make a link
if (-Not(Test-Path -Path C:\DayZMission\mpmissions)) {
    Write-Host 'Copying default mpmissions';
    Copy-Item -Path .\mpmissions -Destination C:\DayZMission\mpmissions -Recurse;
}
Remove-Item -Recurse .\mpmissions ;
New-Item -ItemType Junction -Path .\mpmissions -Value C:\DayZMission\mpmissions ;

# start server
try {
    Write-Host 'Start DayZ Docker Server.';
    & .\DayZServer_x64.exe -config=C:\DayZConfig\serverDZ.cfg -profiles=C:\DayZProfiles -port=2302 -dologs -adminlog -netlog -freezecheck;
    Wait-Process -Name DayZServer_x64 ;
} catch {
    throw;
} finally {
    Write-Host 'End DayZ Docker Server';
}