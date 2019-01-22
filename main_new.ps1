Set-Item wsman:\localhost\client\trustedhosts *
cd C:\aspnethelloworld1

#Get dotnet-install script Install netcore2.1
Invoke-Expression .\dotnet-install

#build project
dotnet build

#publish project
dotnet publish -o publish

#Get remoute script revers1 Create reverse proxy
Invoke-Expression C:\revers1.ps1


$ServerBIpAddress = read-host "IP-address"
$Username = read-host "Username"
$Password = read-host "Password"

$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$pass


#Create PSSession
$testServerSession = New-PSSession -ComputerName $ServerBIpAddress -Credential $MySecureCreds

#Copy
Copy-Item "C:\aspnethelloworld1\" -Destination "C:\aspnethelloworld1\" -ToSession $testServerSession -Recurse

#Close All PSSession
Get-PSSession | Remove-PSSession

#Get remoute script
Invoke-Command -ComputerName $ServerBIpAddress -FilePath C:\remoute_new.ps1 -Credential $MySecureCreds



