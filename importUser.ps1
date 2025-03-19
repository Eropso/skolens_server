

$domain1 = "skolen"
$domain2 = "local"
$domain = "$domain1.$domain2"
$ouName = "users"
 
$csvPath = "C:\path\to\users.csv"
 
$users = Import-Csv -Path $csvPath
 
foreach ($user in $users) {
    $userFirstName = $user.FirstName
    $userLastName = $user.LastName
    $userName = "$userFirstName.$userLastName"
    $userPassword = ConvertTo-SecureString $user.Password -AsPlainText -Force
 
    New-ADUser -Name $userName -GivenName $userFirstName -Surname $userLastName -SamAccountName $userName -UserPrincipalName "$userName@$domain" -Path "OU=$ouName,DC=$domain1,DC=$domain2" -AccountPassword $userPassword -Enabled $true
}
 

