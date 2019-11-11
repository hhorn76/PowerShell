### Enale Windows Optional Features on Windows 10
### This script needs Administrative privileges

# Function to enable a Windows optional feature
function enableFeature ($strFeature) {
    $objState = Get-WindowsOptionalFeature -Online | Where featurename -Like $strFeature
    if ($objState.State -eq 'Disabled') {
        Write-Host "Enabeling Windows Optional Feature: $strFeature." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName $strFeature
    } else {
        Write-Host "Windows Optional Feature: $strFeature is already enabled."
    }
}

# Function to enable a Windows optional feature
function disableFeature ($strFeature) {
    $objState = Get-WindowsOptionalFeature -Online | Where featurename -Like $strFeature
    if ($objState.State -eq 'Enabled') {
        Write-Host "Disabling Windows Optional Feature: $strFeature." -ForegroundColor Yellow
        Disable-WindowsOptionalFeature -Online -FeatureName $strFeature
    } else {
        Write-Host "Windows Optional Feature: $strFeature is already disabled."
    }
}

# Enable NET-Framework-Core Windows Feature.
$strFeature = 'NetFx3'
enableFeature $strFeature
# Disable NET-Framework-Core Windows Feature.
disableFeature $strFeature

# Enable ASP.NET Windows Feature.
$strFeature = 'NetFx4Extended-ASPNET45'
enableFeature $strFeature
# Disable ASP.NET Windows Feature.
disableFeature $strFeature

# Enable .NET TCP Activation Windows Feature 
$strFeature = 'WCF-TCP-Activation45'
enableFeature $strFeature
# Disable ASP.NET Windows Feature.
disableFeature $strFeature