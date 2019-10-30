#########################################################################################
#                      Written by Heiko Horn - 2019.10.30                               #
#########################################################################################

# Import the module that specifies the functions to write to a log file
Import-Module .\writeToLog.psm1
Start-Log -FilePath "$LogPath\BDD.log"
Write-Log -Message '################'
Write-Log -Message 'Stop and disable WSUS service.'
Write-Log -Message '################'

# Stop the WSUS service if running
$serviceWsus = Get-Service -Name wuauserv
if (!($serviceWsus.Status -eq 'Stopped')) {
    Write-Log -Message 'Stopping WSUS service.'
    try {
        Stop-Service $serviceWsus
    } catch {
        Write-Log -Message $_.Exception.Message -LogLevel 3
    }
} else {
    Write-Log -Message 'WSUS service is already stopped.'
}

# Disable the WSUS service
Write-Log -Message 'Disabling WSUS service.'
try {
    Set-Service -Name $serviceWsus -StartupType Disabled
} catch {
    Write-Log -Message $_.Exception.Message -LogLevel 3
}