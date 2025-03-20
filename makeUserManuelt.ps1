# Varirabler for å lage bruker
$userName = "Paul Nguyen"
$samAccountName = "paul"
$userPrincipalName = "paul@PaulDomain.com"
$userPath = "OU=$ouName,DC=$domainName,DC=$domainSuffix"
$userPassword = "IMKuben1337!"

# Lager bruker
New-ADUser -Name $userName -SamAccountName $samAccountName -UserPrincipalName $userPrincipalName -Path $userPath -AccountPassword (ConvertTo-SecureString $userPassword -AsPlainText -Force) -Enabled $true