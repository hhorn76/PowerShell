#########################################################################################
#                      Written by Heiko Horn - 2019.10.28                               #
#########################################################################################

# Import the module that specifies the functions to write to a log file
Import-Module .\writeToLog.psm1
Start-Log -FilePath "$LogPath\BDD.log"
Write-Log -Message '################'
Write-Log -Message 'Start WSUS service and update OS. '
Write-Log -Message '################'

# Stop the WSUS service if running and disable it
$serviceWsus = Get-Service -Name wuauserv
if ($serviceWsus.StartType -eq 'Disabled') {
    Write-Log -Message 'Enabling WSUS service.'
    Set-Service -Name $serviceWsus -StartupType Manual
} else {
    Write-Log -Message 'WSUS service is already enabled.'
}

try {
    Write-Log -Message "Installing NuGet Package."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}

try {
    Write-Log -Message "Installing PSWindowsUpdate Module."
    Install-Module PSWindowsUpdate -AllowClobber -Force
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}

try {
    Write-Log -Message "Installing Microsoft Updates."
    Install-WindowsUpdate -AcceptAll -Install -MicrosoftUpdate -AutoReboot
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}