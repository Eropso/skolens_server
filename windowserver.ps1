# Variabler for scriptet for mer oversikt

$computername = "PN-skoleserver"

# Nettverksinnstillinger
$ip = "192.168.58.2"
$gateway = "192.168.58.1"
$length = 24

# Hyper-V og VLAN
$vSwitchName = "VLAN-Switch"
$netAdapterName = "Ethernet"
$vlanID = 358

# DHCP-innstillinger
$dhcpScopeName = "SkoleNettverk"
$dhcpStartRange = "192.168.58.100"
$dhcpEndRange = "192.168.58.200"
$dhcpSubnetMask = "255.255.255.0"
$opnSense = "192.168.58.99"
$dhcpScopeId = "192.168.58.0"

# Organisatoriske enheter
$ouName1 = "Elev"
$ouName2 = "Laerer"

# Domeneinnstillinger
$domainName = "skole"
$domainSuffix = "local"
$domain = "$domainName.$domainSuffix"


# Scriptet for å sette opp serveren

# Setter navn på serveren
Rename-Computer -NewName $computername

# Setter IP-adresse, gateway og subnet
New-NetIPAddress -IPAddress $ip -PrefixLength $length -DefaultGateway $gateway -InterfaceAlias $netAdapterName

# Installerer funksjoner og roller
$features = @(
    "AD-Domain-Services", 
    "DHCP", 
    "DNS", 
    "Hyper-V"
)
Install-WindowsFeature -Name $features -IncludeAllSubFeature -IncludeManagementTools

# Lager en ny VM-switch og setter VLAN ID
New-VMSwitch -Name $vSwitchName -NetAdapterName $netAdapterName -AllowManagementOS $true
Set-VMNetworkAdapterVlan -VMNetworkAdapterName $netAdapterName -Access -VlanId $vlanID

# Setter DNS-servere
Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses $opnSense

# Konfigurerer DHCP-server
Add-DhcpServerInDC
Add-DhcpServerv4Scope -Name $dhcpScopeName -StartRange $dhcpStartRange -EndRange $dhcpEndRange -SubnetMask $dhcpSubnetMask
Set-DhcpServerV4OptionValue -ScopeId $dhcpScopeId -OptionId 6 -Value $opnSense

# Setter opp domenet
Install-ADDSForest -DomainName $domain -InstallDNS

# Lager OUs
New-ADOrganizationalUnit -Name $ouName1 -Path "DC=$domainName,DC=$domainSuffix"
New-ADOrganizationalUnit -Name $ouName2 -Path "DC=$domainName,DC=$domainSuffix"

# Restarter serveren
Restart-Computer