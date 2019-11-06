#######################################################
###         Written by Heiko Horn 2019-10-31       ###
#######################################################

### Usage:
### $Token = "[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("MyPassword"))"
### .\bindToAD.ps1 -Token $Token -AD_Domain 'mydomain.com' -AD_OU 'CN=Computers,DC=mydomain,DC=com' -AD_User 'MYDOMAIM\USER'

### Parameters
Param (
    [Parameter(Mandatory=$True)] # Token: Base 64 Encrypted Password
    [String]$Token,
    [Parameter(Mandatory=$True)] # AD_Domain: Domain name of your organization
    [String]$AD_Domain,
    [Parameter(Mandatory=$True)] # AD_OU: Organisational Unit where to bind the computer
    [String]$AD_OU,
    [Parameter(Mandatory=$True)] # AD_User: Domain user account to authenticate to Active Directory
    [String]$AD_User
)

### Variables
# Username and Domaind for binding credentials
$strDomain = $AD_Domain
$strOU = $AD_OU
$strUser = $AD_User

# Unencrypt the password, that should not never be tranferred in clear text.
$strPassword = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Token))
$strSecure = $strPassword | ConvertTo-SecureString -asPlainText -Force
$credAD = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strSecure)

# Import the module that specifies the functions to write to a log file
Import-Module .\writeToLog.psm1
Start-Log -FilePath "$LogPath\BDD.log"
Write-Log -Message '################'
Write-Log -Message " Active Directory binding."
Write-Log -Message '################'

try {
    Write-Log -Message "Binding $env:COMPUTERNAME to Active Directory $strDomain."
    Add-Computer -DomainName $strDomain -OUPath $strOU -Credential $credAD -Restart
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}