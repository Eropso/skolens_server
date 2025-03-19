$computername = "PN-skoleserver"

$ip = "192.168.58.1"
$gateway = "192.168.58.1"
$length = 24

$vSwitchName = "External"
$netAdapterName = "Ethernet"
$vlanID = 358

$domain = "skole.local"
$ouName1 = elev
$ouName2 = laerer

$domainParts = $domain.Split(".")

$domainName = $domainParts[0]
$domainSuffix = $domainParts[1]


Rename-Computer -NewName $computername -Restart

New-NetIPAddress -IPAddress $ip -PrefixLength $length -DefaultGateway $gateway -InterfaceAlias "Ethernet"



$features = @(
    "AD-Domain-Services", 
    "DHCP", 
    "DNS", 
    "Hyper-V")

Install-WindowsFeature -Name $features -IncludeAllSubFeature -IncludeManagementTools -Restart



New-VMSwitch -Name "VLAN-Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true

Set-VMNetworkAdapterVlan -VMNetworkAdapterName "Ethernet" -Access -VlanId 358

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("1.1.1.1","1.0.0.1")

Install-ADDSForest -DomainName $domain -InstallDNS 

New-ADOrganizationalUnit -Name $ouName1 -Path “DC=$domainName,DC=$domainSuffix"

New-ADOrganizationalUnit -Name $ouName2 -Path “DC=$domainName,DC=$domainSuffix"


#redirusr "OU=$ouName,DC=$domainName,DC=$domainSuffix"



