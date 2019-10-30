#######################################################
###         Written by Heiko Horn 2019-09-09       ###
#######################################################

### Usage
installSophos -Location /Sophos/Clients -Token '<base64 encrypted password>' 

### Parameters for server and client installation
# Location for Clients: Windows
# Location for Servers: Server
# Token: Base 64 Encrypted Password
Param(
    [Parameter(Mandatory=$True)]
    [String]$Location, 
    [Parameter(Mandatory=$True)]
    [String]$Token
)
### Variables
$strSophos = 'Sophos'
$strShare = 'SophosUpdate'
$strUncPath = "\\$strSophos\$strShare"
$strDrive = 'P'

$strLocation = '\Sophos\'
$strUser = "$strSophos\Administrator"

# Import the module that specifies the functions to write to a log file
Import-Module .\writeToLog.psm1
Start-Log -FilePath "$LogPath\BDD.log"
Write-Log -Message '################'
Write-Log -Message " Installing Sophos in location: $strLocation$Location"
Write-Log -Message '################'

# Unencrypt the password, that should not never be tranferred in clear text.
$strPassword = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Token))
#Write-Log -Message "$strUncPath\CIDs\S000\SAVSCFXP\setup.exe -s -ni -user $strUser -pwd $strPassword -G ""$strLocation$Location"""

# Map Sophos network drive.
try {
    Write-Log -Message "Connecting to $strSophos server."
    $strSecure = $strPassword | ConvertTo-SecureString -asPlainText -Force
    $credSophos = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strSecure)
    New-PSDrive -Name $strDrive -PSProvider "FileSystem" -Root "$strUncPath" -Credential $credSophos
    } catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}
# Install Sophos Antivirus
try {
    Write-Log -Message "Installing Sophos Antivirus."
    Start-Process "$($strDrive):\CIDs\S000\SAVSCFXP\setup.exe" -ArgumentList " -s -ni -user $strUser -pwd $strPassword -G ""$strLocation$Location""" -Wait
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}
# Remove mapped network drive.
try {   
    Write-Log -Message "Removing mapped network drive."
    Get-PSDrive $strDrive | Remove-PSDrive
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}