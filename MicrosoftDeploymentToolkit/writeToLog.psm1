#########################################################################################
#                      Written by Heiko Horn - 2019.10.28                               #
#########################################################################################

### Usage
# Create a log file if it does not exist
# Start-Log -FilePath C:\MyLog.log
# Start-Log -FilePath "$LogPath\BDD.log"

# Create a information, warning and error message
# Write-Log -Message 'inforational message'
# Write-Log -Message 'warning message' -LogLevel 2
# Write-Log -Message 'error message' -LogLevel 3

# Function to create the log file if it does not exist
function Start-Log {
    param (
        [ValidateScript({ Split-Path $_ -Parent | Test-Path })]
        [string]$FilePath
    )
	
    try {
        if (!(Test-Path $FilePath)) {
	    ## Create the log file
	    New-Item $FilePath -Type File | Out-Null
    }
    $global:ScriptLogFilePath = $FilePath
    } catch {
        Write-Error $_.Exception.Message
    }
}

# Function to create write to the log file.
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter()]
        [ValidateSet(1, 2, 3)]
        [int]$LogLevel = 1
    )
    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
    $Line = $Line -f $LineFormat
    Add-Content -Value $Line -Path $ScriptLogFilePath
}
# Set global variables for the server deplyment root and srver logging root locations
$global:tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$global:DeployRoot = $tsenv.Value('DeployRoot')
$global:LogPath = $tsenv.Value('SLShareDynamicLogging')

### Usage in another PowerShell script.
# Import-Module .\writeToLog.psm1
# Start-Log -FilePath "$LogPath\BDD.log"
# Write-Log -Message '################'
# Write-Log -Message "Executing PowerShell script $MyInvocation.ScriptName."
# Write-Log -Message '################'