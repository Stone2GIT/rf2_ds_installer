#
# simple script to install and base configure rFactor 2 dedicated server

# Stone, 07/2024, info@simracingjustfair.org
#

# Notes

$CURRENTVERSION=(Get-Date -Format "yyyy.MM.dd")
$CURRENTLOCATION=((Get-Location).Path)

# source variables
# as PS1 script is easiest way it leads to Windows security warning ... so ... :-/
#. ./variables.ps1
$VARS=(Get-Content -raw -Path $CURRENTLOCATION\variables.txt | ConvertFrom-StringData)
$RF2ROOT=$VARS.RF2ROOT

if (-not (Test-Path "$RF2ROOT")) {
 mkdir $RF2ROOT
 mkdir $RF2ROOT\SteamCMD
}

# download SteamCMD
$ARGUMENTS="Invoke-RestMethod -Uri https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -OutFile $RF2ROOT\SteamCMD\steamcmd.zip"
start-process -FilePath powershell -ArgumentList $ARGUMENTS -NoNewWindow -Wait

# extract SteamCMD
$ARGUMENTS="Expand-Archive -Force $RF2ROOT\SteamCMD\steamcmd.zip -DestinationPath ""$RF2ROOT\SteamCMD"""
start-process -FilePath powershell -ArgumentList $ARGUMENTS -NoNewWindow -Wait

# download and install rFactor 2 dedicated server
$ARGUMENTS="+force_install_dir $RF2ROOT +login anonymous +app_update 400300 +quit"
start-process -FilePath "$RF2ROOT\SteamCMD\steamcmd.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait

# install vcredist ... will prompt for Admin PW
start-process $RF2ROOT\support\runtimes\vcredist_2012_x64.exe " /install /quiet /log $HOME\Documents\vcredist2012.log" -Verb runAs -wait 
start-process $RF2ROOT\support\runtimes\vcredist_2013_x64.exe " /install /quiet /log $HOME\Documents\vcredist2013.log" -Verb runAs -wait


# generating the rfactor 2 dedicated server link ... it is not needed if DS is started from $RF2ROOT with leading bin64\ ... but
$LNKFILE = "$RF2ROOT\bin64\rFactor2 Dedicated.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$LNKFILE")
$Shortcut.TargetPath = "$RF2ROOT\bin64\rfactor2 dedicated.exe"
$Shortcut.Arguments = "+path="".."""
$Shortcut.WorkingDirectory = "$RF2ROOT\bin64"
$Shortcut.Save()

# downloading track and car initial mod
start-process $RF2ROOT\SteamCMD\steamcmd.exe "+force_install_dir $RF2ROOT +login anonymous +workshop_download_item 365960 2362626369 +quit" -nonewwindow -wait
start-process $RF2ROOT\SteamCMD\steamcmd.exe "+force_install_dir $RF2ROOT +login anonymous +workshop_download_item 365960 917386837 +quit" -nonewwindow -wait

write-host "Starting Mod Manager in order to set modmgr folders (closing in a couple of seconds)."
start-process $RF2ROOT\bin64\modmgr.exe "-q -c""$RF2ROOT"" "
timeout /t 5|out-null

# killing modmgr will write back path information
taskkill /IM modmgr.exe|out-null

# installing content
$FOLDERS=((gci $RF2ROOT\steamapps\workshop\content\365960\*).Name)
forEach ($FOLDER in $FOLDERS) {
 $RFCMPS=(gci $RF2ROOT\steamapps\workshop\content\365960\$FOLDER\*.rfcmp|select -Expand Name| sort)
 foreach ($RFCMP in $RFCMPS) {
  $ARGUMENTS=" -i""$RFCMP"" -p""$RF2ROOT\steamapps\workshop\content\365960\$FOLDER"" -d""$RF2ROOT"" -c""$RF2ROOT"" -o""$RF2ROOT"" "
  start-process -FilePath "$RF2ROOT\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -nonewwindow -wait
 }
}

# we change dir which saves some options on modmgr
cd $RF2ROOT

# create a dummy pkginfo.dat
$PKGINFO=@"
[Package]
Name=dummy
Type=0
Version=1.0
BaseVersion=
MinVersion=
Author=Stone of SRJF
Date=133380828671940000
ID=AAA9999
URL=simracingjustfair.org
Desc=Dummy mod from rFactor 2 dedicated server manager
Category=0
Origin=0
Flags=0
CurLocation=0
NumLocations=1
Location=$RF2ROOT\Packages\dummy.rfmod
CurRFM=0
NumRFM=1
RFM=$RF2ROOT\Packages\dummy.mas
NumTrackFiles=1
Track="AtlantaMP_2014 v1.32,0" "AtlantaMP -- Kart Layout A,0" "AtlantaMP -- Kart Layout B,0" "AtlantaMP -- Kart Layout B +,0" "AtlantaMP -- Kart Layout C,0" "AtlantaMP -- Race Track,1"
NumVehicleFiles=1
Vehicle="ER_AlpineSeries_rF2 v2.00,0" "18CUP| #02 Team CMR-CFF,1" "18CUP| #04 Racing Technology,1" "18CUP| #14 Autosport GP,1" "18CUP| #15 Milan Competition,1" "18CUP| #17 Autosport GP,1" "18CUP| #18 Autosport GP,1" "18CUP| #33 Team CMR GRR,1" "18CUP| #69 Autosport GP,1" "18CUP| #76 Team CMR,1" "18GT4FRA| #026 Team CMR,1" "18GT4FRA| #036 Team CMR,1" "18GT4FRA| #061 Zentech Sport,1" "18GT4INT| #036 Team CMR,1" "19CUP| #04 Racing Technology,1" "19CUP| #05 Racing Technology,1" "19CUP| #06 Milan Competition,1" "19CUP| #09 Milan Competition,1" "19CUP| #11 Racing Technology,1" "19CUP| #15 Team CMR,1" "19CUP| #21 Milan Competition,1" "19CUP| #29 Milan Competition,1" "19CUP| #64 Team CMR,1" "19GT4EUR| #009 Team CMR,1" "19GT4EUR| #048 Team CMR,1" "19GT4FRA| #002 Team Speed Car,1" "19GT4FRA| #007 Team Speed Car,1" "19GT4FRA| #008 Team Speed Car,1" "19GT4FRA| #035 Bodemer Auto,1" "19GT4FRA| #036 Team CMR,1" "19GT4FRA| #061 Zentech Sport,1" "19GT4FRA| #076 Bodemer Auto,1" "19GT4FRA| #616 Mirage Racing,1" "19GT4FRA| #919 Mirage Racing,1" "20CUP| #03 Racing Technology,1" "20CUP| #06 Tierce Racing,1" "20CUP| #44 Autosport GP,1" "20CUP| #69 Autosport GP,1" "20GT4FRA| #008 Speed Car,1" "20GT4FRA| #022 Mirage Racing,1" "20GT4FRA| #036 Team CMR,1" "20GT4FRA| #060 Team CMR,1" "21CUP| #001 Autosport GP,1" "21CUP| #002 BL Sport,1" "21CUP| #003 Chazel Technologie Course,1" "21CUP| #005 Herrero Racing,1" "21CUP| #007 Herrero Racing,1" "21CUP| #008 Autosport GP,1" "21CUP| #009 Chazel Technologie Course,1" "21CUP| #011 Herrero Racing,1" "21CUP| #018 Patrick Roger Autosport GT,1" "21CUP| #027 Herrero Racing,1" "21CUP| #031 Meric Competition,1" "21CUP| #033 Autosport GP,1" "21CUP| #040 Race Cars Consulting,1" "21CUP| #041 Race Cars Consulting,1" "21CUP| #044 Patrick Roger Autosport GT,1" "21CUP| #045 Herrero Racing,1" "21CUP| #063 Herrero Racing,1" "21CUP| #069 LSGROUP Autosport GP,1" "21CUP| #072 Autosport GP,1" "21CUP| #093 Chazel Technologie Course,1" "21CUP| #110 Chazel Technologie Course,1" "21GT4EUR| #030 Team CMR,1" "21GT4EUR| #036 Arkadia Racing,1" "21GT4FRA| #035 Bodemer Auto,1" "21GT4FRA| #036 Team CMR,1" "21GT4FRA| #076 Bodemer Auto,1" "21GT4FRA| #110 Team CMR,1"
NumOtherFiles=0
rFmFile=$RF2ROOT\Packages\default.rfm
IconFile=$RF2ROOT\Packages\icon.dds
SmallIconFile=$RF2ROOT\Packages\smicon.dds

CurPackage=0
"@

Set-Content -Path $RF2ROOT\Packages\dummy.dat -Value $PKGINFO -Encoding ASCII
timeout /t 5|out-null

ForEach($FILE in 'default.rfm', 'icon.dds', 'smicon.dds')
{
cp $CURRENTLOCATION\rfmodfiles\$FILE $RF2ROOT\Packages
}

# create MAS file
$ARGUMENTS="-q -c""$RF2ROOT"" -o""$RF2ROOT\Packages"" -m""dummy.mas"" ""$RF2ROOT\Packages\default.rfm"" ""$RF2ROOT\Packages\icon.dds"" ""$RF2ROOT\Packages\smicon.dds"" "
start-process -FilePath "$RF2ROOT\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait

timeout /t  5|out-null

# create RFMOD package
$ARGUMENTS="-q -c""$RF2ROOT"" -o""$RF2ROOT\Packages"" -b""$RF2ROOT\Packages\dummy.dat"" 0"
start-process -FilePath "$RF2ROOT\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait
timeout /t 5|out-null

# install RFMOD, TODO: respect exit codes
$ARGUMENTS="-q -p""$RF2ROOT\Packages"" -i""dummy.rfmod"" -c""$RF2ROOT"" "
start-process -FilePath "$RF2ROOT\bin64\ModMgr.exe" -ArgumentList $ARGUMENTS -NoNewWindow -Wait
timeout /t 5|out-null

# open default firewall ports, UDP+TCP 54297 TCP 64297 UDP 64298 UDP 64299
 
# TCP
$ARGUMENTS="advfirewall firewall add rule name= ""rFactor 2 TCP ports"" dir=in action=allow protocol=TCP localport=54297,64297"
start-process "netsh" $ARGUMENTS -Verb runAs -wait

# UDP
$ARGUMENTS="advfirewall firewall add rule name= ""rFactor 2 UDP ports"" dir=in action=allow protocol=UDP localport=54297,64298,64299"
start-process "netsh" $ARGUMENTS -Verb runAs -wait

# start the rf2 dedicated server with dummy mod
if (-not (Test-Path "$RF2ROOT\Userdata\player")) {
 mkdir $RF2ROOT\Userdata\player
}

$ARGUMENTS=" +profile=player +rfm=dummy_10.rfm +oneclick"
start-process -FilePath "$RF2ROOT\bin64\rFactor2 Dedicated.exe" -ArgumentList $ARGUMENTS -NoNewWindow

cd $CURRENTLOCATION
