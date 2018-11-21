#Install IIS on ServerA
Install-WindowsFeature -name Web-Server -IncludeManagementTools -PassThru | Wait-Process

Invoke-WebRequest 'http://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi' -OutFile "$($env:TEMP)/WebPlatformInstaller_amd64_en-US.msi"
Start-Process "$($env:TEMP)/WebPlatformInstaller_amd64_en-US.msi" '/qn' -PassThru | Wait-Process
cd 'C:/Program Files/Microsoft/Web Platform Installer'; .\WebpiCmd.exe /Install /Products:'UrlRewrite2,ARRv3_0' /AcceptEULA

$site = "iis:\sites\Default Web Site"
$filterRoot = "system.webServer/rewrite/rules/rule[@name='serverb$_']"

Clear-WebConfiguration -pspath $site -filter $filterRoot
Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{name='serverb' + $_ ;patternSyntax='Regular Expressions';stopProcessing='True'}
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/match" -name "url" -value ".*"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/conditions" -name . -value @{ input = '{SERVER_PORT}'; matchType = '0'; pattern ="80"; ignoreCase ='True'; negate ='False' }
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "type" -value "Rewrite"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "url" -value "http://serverb:9000"