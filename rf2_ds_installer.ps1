#
# simple script to install and base configure rFactor 2 dedicated server

# Stone, 07/2024, info@simracingjustfair.org
#

# Notes

# source variables
. ./variables.ps1

$CURRENTVERSION=(Get-Date -Format "yyyy.MM.dd")
$CURRENTLOCATION=((Get-Location).Path)

# download SteamCMD
$ARGUMENTS="Invoke-RestMethod -Uri https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -OutFile $RF2ROOT\SteamCMD\steamcmd.zip"
start-process -FilePath powershell -ArgumentList $ARGUMENTS -NoNewWindow -Wait

# extract SteamCMD
$ARGUMENTS="Expand-Archive -Force $STEAMINSTALLDIR\steamcmd.zip -DestinationPath ""$RF2ROOT\SteamCMD""""
start-process -FilePath powershell -ArgumentList $ARGUMENTS -NoNewWindow -Wait
