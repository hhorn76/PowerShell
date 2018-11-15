#Demonstrate Get-Item
Get-Item -Path C:\Windows
Get-Item -Path "C:\Test\Test.txt" | fl FullName, Extension
Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object -ExpandProperty Property

#Demonstrate reading registry key
Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | fl ProductName, CurrentBuildNumber
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | fl ProductName, CurrentBuild

#Demonstarate Get-ItemPropertyValue Windows PowerShell 5.0 ONLY 
Write-Host "PowerShellVersion    : $($PSVersionTable.PSVersion)"
Write-Host "PSCompatibleVersions : $($PSVersionTable.PSCompatibleVersions)"
Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine" | fl PowerShellVersion, PSCompatibleVersion

Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName,CurrentBuild

#Demonstrate Set-Location
Set-Location -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
Get-ItemPropertyValue -Path . -Name ProductName,CurrentBuild
Set-Location -Path "C:\"
Set-Location -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"

#Demonstrate creating registry key
Get-ItemProperty -path ./PowerShellPath -ErrorAction SilentlyContinue
New-ItemProperty -Path . -Name PowerShellPath -PropertyType String -Value $PSHome
Get-ItemPropertyValue -path . -Name PowerShellPath

#Demonstrate rename registry key
Rename-ItemProperty -Path . -Name PowerShellPath -NewName PSHome -PassThru
Get-ItemProperty -path . | fl PowerShellPath
Get-ItemProperty -path . | fl PSHome

#Demonstrate deleting registry key
Remove-ItemProperty -Path . -Name PSHome
Get-ItemProperty -path . | fl PSHome

