New-Item -Type Directory -Path "C:\Intune-Scripts-Logs"
$Logfile = "C:\Intune-Scripts-Logs\$(get-date -f dd-MM).log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}


$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

## What is our public IP
LogWrite "$(date) | Looking up public IP"

$SleepTimer = 2

for ($i=0; $i -le 5 ; $i++) {
$Request=Invoke-WebRequest -uri "https://api.ipify.org/"
if ($Request.StatusCode -ne 200) {
LogWrite "IP LookUp Failed Sleeping for $SleepTimer"
Start-Sleep -Seconds $SleepTimer
}
else {break}
$SleepTimer = $SleepTimer + 1
}

$MyIp = $Request.Content
LogWrite "IP is $MyIp"



$SleepTimer = 2

for ($i=0; $i -le 5 ; $i++) {
$Request=Invoke-WebRequest -uri https://ipapi.co/$MyIp/country
if ($Request.StatusCode -ne 200) {
LogWrite "Country LookUp Failed Sleeping for $SleepTimer"
Start-Sleep -Seconds $SleepTimer
}
else {break}
$SleepTimer = $SleepTimer + 1
}

$Country= $Request.Content
LogWrite "Country Code is $Country"

$Computer = "$Country-$SerialNumber"
LogWrite "New Computer name $Computer"

Rename-Computer -NewName $computer -Force
