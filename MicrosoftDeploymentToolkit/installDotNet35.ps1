#########################################################################################
#                      Written by Heiko Horn - 2019.10.28                               #
#########################################################################################

# Import the module that specifies the functions to write to a log file
Import-Module .\writeToLog.psm1
Start-Log -FilePath "$LogPath\BDD.log"
Write-Log -Message '################'
Write-Log -Message 'Installing .NET-Framework-3.5. '
Write-Log -Message '################'

# Variables
$strHiveKey = 'HKLM'
$strRegPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing\"

# Enable Download repair content and optional features directly from Windows Update instead of Windows Server Update Services (WSUS)
Write-Log -Message "Creating Registry key $($strHiveKey):$($strRegPath)"
if (! (Get-ItemProperty -Path "Registry::$strRegPath" -ErrorAction SilentlyContinue) ) {
    New-Item -Path "$($strHiveKey):$($strRegPath)"
}
Write-Log -Message "Creating Registry value RepairContentServerSource"
New-ItemProperty -Path "Registry::$strHiveKey$strRegPath" -Name 'RepairContentServerSource' -Value '2' -PropertyType 'dword' -Force

# Install NET-Framework-Core WindowsFeature 
try {
    Write-Log -Message 'Installing NET-Framework-Core WindowsFeature.'
    Start-Process "DISM" -ArgumentList " /Online /Enable-Feature /FeatureName:NetFx3 /All" -Wait
    #Install-WindowsFeature -Name NET-Framework-Core -WarningAction SilentlyContinue
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}



