$ErrorActionPreference = 'Stop';
Write-Host 'Start DayZ Docker Server.';
try {
    if (-Not(Test-Path -Path C:\DayZConfig\serverDZ.cfg)) {
        Write-Host 'Copying default configuration';
        Copy-Item -Path C:\DayZServer\serverDZ.cfg -Destination C:\DayZConfig\ ;
    }
    Set-Location C:\DayZServer\ ;
    Start-Process -Wait .\DayZServer_x64.exe -ArgumentList "-config=C:\DayZConfig\serverDZ.cfg -profiles=C:\DayZProfiles -port=2302 -dologs -adminlog -netlog -freezecheck" ;
} catch {
    throw;
} finally {
    Write-Host 'End DayZ Docker Server';
}