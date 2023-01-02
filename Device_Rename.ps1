$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

## What is our public IP
Write-Output "$(date) | Looking up public IP"
##$myip=(dig +short myip.opendns.com resolver1.opendns.com)
$myip=(Invoke-WebRequest -uri "https://api.ipify.org/").Content
Write-Output "$myip"
$Country= (Invoke-WebRequest -uri https://ipapi.co/$myip/country).Content
##$Country= (curl -s https://ipapi.co/$myip/country)

$Computer = "$Country-$SerialNumber"

Write-Output "$Computer"

Rename-Computer -NewName $computer -Force
