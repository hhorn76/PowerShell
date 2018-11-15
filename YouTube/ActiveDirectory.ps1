#Demonstarte Import-Module ActiveDirectory
$strADServer="ad.mydomain.com"
$strADServer="ad1.mis-munich.de"
$psSession = New-Pssession -computer $strADServer
Invoke-Command -Session $psSession -Script {Import-Module ActiveDirectory}
Export-PSSession -Session $psSession -Commandname *-AD* -Outputmodule MyAD -Allowclobber -Force
Import-Module MyAD

#Remove Active Direcroty Module
Remove-Module MyAD
rm .\Documents\WindowsPowerShell\Modules\MyAD -Recurse

#Demonstarte Get-ADUser -Identity hhorn | fl name
Get-ADUser -Identity hhorn | fl SamAccountName

#Demonstarte Get-ADUser -Filter
Get-ADUser -Filter {sAMAccountName -eq "hhorn"} | fl SamAccountName
Get-ADUser -Filter 'sAMAccountName -eq "hhorn"' | fl SamAccountName

#Demonstarte Get-ADUser -LDAPFilter
Get-ADUser -LDAPFilter “(sAMAccountName=hhorn)” | fl SamAccountName

#Demonstarte -Properties
$objUser=Get-ADUser -Identity hhorn | Get-Member -MemberType Properties 
$objUser.Count
$objUser=Get-ADUser -Identity hhorn -Properties * | Get-Member -MemberType Properties 
$objUser.Count

#Demonstarte ResultSetSize
$objUsers=Get-ADUser -Filter * -ResultSetSize 10
$objUsers.Count

#Demonstarte SearchBase
$strSearchBase="OU=servers,DC=mydomain,DC=com"
$objUsers=Get-ADComputer -SearchBase $strSearchBase -Filter *
$objUsers.Count

#Demonstarte SearchScope
$objUsers=Get-ADComputer -SearchBase $strSearchBase -SearchScope OneLevel -Filter *
$objUsers.Count

$objUsers=Get-ADComputer -SearchBase $strSearchBase -SearchScope 2 -Filter *
$objUsers.Count

#Demonstarte Sort
Get-ADComputer -SearchBase $strSearchBase -Filter * | Sort Name | ft Name

#Demonstarte Get-ADObject
$objUser=Get-ADObject -Filter {(mail -like "hhorn*") -and (ObjectClass -eq "user")}
$objUser.Name

#Demonstarte New-ADUser
New-ADUser -Name 123
Get-ADUser -Identity 123 | fl Enabled

#Demonstarte Set-ADUser
Set-ADUser -Identity 123 -Description "Test"

#Demonstrate resetting a password
$strPassword="Test345!"
$securePassword = ConvertTo-SecureString -AsPlainText $strPassword -force
Set-ADAccountPassword -Identity 123 -Reset -NewPassword $securePassword

#Demonstrate Enable-ADAccount
Enable-ADAccount -Identity 123
Get-ADUser -Identity 123 | fl Enabled
#Demonstrate Disable-ADAccount
Disable-ADAccount -identity 123 -confirm:$false
Get-ADUser -Identity 123 | fl Enabled
#Demonstrate Remove-ADUser
$objDelete=Get-ADUser 123
IF($objDelete)
{
    Remove-ADUser -Identity $objDelete.SamAccountName -Confirm:$false
}

