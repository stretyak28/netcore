
$newip = "172.16.7.2"
$mac = "24"
$Servername = "ServerB"

#Create new Remoute IP Address
$netadapter = Get-NetAdapter -Name Ethernet
$netadapter | New-NetIPAddress -IPAddress $newip -PrefixLength $mac

#Rename NET Adapter
Rename-NetAdapter -Name "Ethernet" -NewName "LAN"

#Create rules on Firewall open port 9000
New-NetFirewallRule -Name "CoreNet IIS" -DisplayName "Allow HTTP on TCP/9000" -Protocol TCP -LocalPort 9000 -Action Allow -Enabled True

#Install IIS Server
#Add-WindowsFeature -name Web-Server

#Install IIS Manager
#Install IIS Server and dependencies
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools

#Create IIS Site
New-IISSite -Name "NetCore" -PhysicalPath C:\aspnethelloworld1\publish -BindingInformation "*:9000:"

#Install dotnet-hosting-2.1.5-win
Start-Process -Wait -FilePath "C:\aspnethelloworld1\dotnet-hosting-2.1.5-win" -ArgumentList "/S" -PassThru

#Delete Old IP Address
#Remove-NetIPAddress -IPAddress $ServerBIpAddress -PrefixLength $mac

#Rename Computer_Name
Rename-Computer -NewName $Servername -Restart