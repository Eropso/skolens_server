#Variabler for scriptet for mer oversikt

$computername = "PN-skoleserver"

$ip = "192.168.58.2"
$gateway = "192.168.58.1"
$length = 24

$vSwitchName = "External"
$netAdapterName = "Ethernet"
$vlanID = 358

$ouName1 = elev
$ouName2 = laerer

$domainName = skole
$domainSuffix = local

$domain = "$domainName.$domainSuffix"




#Scriptet for å sette opp serveren

#Setter navn på serveren
Rename-Computer -NewName $computername

#Setter IP-adresse, gateway og subnet
New-NetIPAddress -IPAddress $ip -PrefixLength $length -DefaultGateway $gateway -InterfaceAlias "Ethernet"


#Installerer funksjoner og roller
$features = @(
    "AD-Domain-Services", 
    "DHCP", 
    "DNS", 
    "Hyper-V")

Install-WindowsFeature -Name $features -IncludeAllSubFeature -IncludeManagementTools


#Lager en ny VM-switch og setter VLAN ID
New-VMSwitch -Name "VLAN-Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true

Set-VMNetworkAdapterVlan -VMNetworkAdapterName "Ethernet" -Access -VlanId 358
#Hvis du har problemer med å sette VLAN ID slik jeg gjorde, kan du gå inn i Hyper-V Manager og sette det manuelt der.




#Setter DNS-servere
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("1.1.1.1","1.0.0.1")

#Setter DNS-suffiks
Add-DhcpServerInDC

Add-DhcpServerv4Scope -Name "SkoleNettverk" -StartRange 192.168.58.100 -EndRange 192.168.58.200 -SubnetMask 255.255.255.0

Set-DhcpServerV4OptionValue -ScopeId 192.168.58.0 -OptionId 6 -Value 1.1.1.1, 1.0.0.1 


#Setter opp domenet
Install-ADDSForest -DomainName $domain -InstallDNS 

#Lager OUs
New-ADOrganizationalUnit -Name $ouName1 -Path “DC=$domainName,DC=$domainSuffix"

New-ADOrganizationalUnit -Name $ouName2 -Path “DC=$domainName,DC=$domainSuffix"



Restart-Computer