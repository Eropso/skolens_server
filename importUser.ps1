# Skriver variablerne som skal brukes til å oprette brukere i AD
$domain1 = "skolen"
$domain2 = "local"
$domain = "$domain1.$domain2"
$ouName1 = "laerer"
$ouName2 = "elever"

$csvPath = "\TreyUsers.csv"
 
# Impoterer brukere fra CSV-fil
$users = Import-Csv -Path $csvPath

# For hver bruker i CSV-filen
foreach ($user in $users) {
    $userFirstName = $user.GivenName
    $userLastName = $user.Surname
    $userName = $user.SAMAccountName
    $userDisplayName = $user.DisplayName
    $userDescription = $user.Description
    $userRole = $user.Rolls
    
    # Setter OU basert på brukerens rolle
    if ($userRole -eq "Teacher") {
        $ouPath = "OU=$ouName1,DC=$domain1,DC=$domain2" 
    } else {
        $ouPath = "OU=$ouName2,DC=$domain1,DC=$domain2"
    }
    
    $userPassword = ConvertTo-SecureString "IMKuben1337!" -AsPlainText -Force
 
    # Oppretter bruker i AD
    New-ADUser -Name $userDisplayName `
               -GivenName $userFirstName `
               -Surname $userLastName `
               -SamAccountName $userName `
               -UserPrincipalName "$userName@$domain" `
               -Path $ouPath `
               -Description $userDescription `
               -AccountPassword $userPassword `
               -Enabled $true
}