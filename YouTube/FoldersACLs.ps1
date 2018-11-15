#Create active directory & file server variables
$objUser=Get-ADUser hhorn
$strDNSRoot=(Get-ADDomain).DNSRoot
$strHomeDir="\\MyServer\Share\home\$($objUser.SamAccountName)"
$strHomeDir="C:\Test\Home\$($objUser.SamAccountName)"

#Demonstrate folder creation
if(!(Test-Path -Path "filesystem::$($strHomeDir)"))
{
    New-Item –Path "filesystem::$($strHomeDir)" -Type Directory
    Write-Host "Home Directory created for $($objUser.Name)." -ForegroundColor Yellow
}

#Demonstrate ACLs for Homefolder On File Server
$Acl=Get-Acl "filesystem::$($strHomeDir)"
Get-Acl $strHomeDir | %{$_.Access} | ?{$_.IdentityReference -eq "BUILTIN\Administrators"}
Get-Acl $strHomeDir | %{$_.Access.Count}

#Demonstrate Remove inheritance from directory
$Acl.SetAccessRuleProtection($true,$false)
Set-Acl -Path "filesystem::$($strHomeDir)" -AclObject $Acl
Get-Acl $strHomeDir | %{$_.Access.Count}

#Create new ACE with SetAccessRule
$Acl=Get-Acl "filesystem::$($strHomeDir)"
$acePerm = "$($strDNSRoot)\Domain Admins","FullControl","ContainerInherit,ObjectInherit","None","Allow"    
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acePerm)
$Acl.SetAccessRule($AccessRule)
$acePerm = "SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow"    
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acePerm)
$Acl.SetAccessRule($AccessRule)
$acePerm = "$($strDNSRoot)\$($objUser.SamAccountName)","FullControl","ContainerInherit,ObjectInherit","None","Allow"    
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acePerm)
$Acl.SetAccessRule($AccessRule)

#Set ACL for directory
Get-Acl $strHomeDir | %{$_.Access.Count}
Set-Acl -Path "filesystem::$($strHomeDir)" -AclObject $Acl
Get-Acl $strHomeDir | %{$_.Access.Count}
Get-Acl $strHomeDir | %{$_.Access} | ?{$_.IdentityReference -eq "BUILTIN\Administrators"}
Get-Acl $strHomeDir | %{$_.Access} | ?{$_.IdentityReference -eq "NT AUTHORITY\SYSTEM"}

#Check inheritance
New-Item –Path "filesystem::$($strHomeDir)\Documents" -Type Directory
$Acl=Get-Acl "filesystem::$($strHomeDir)\Documents"
Get-Acl $strHomeDir | %{$_.Access} | ?{$_.IdentityReference -eq "NT AUTHORITY\SYSTEM"}
Get-Acl $strHomeDir | %{$_.Access.Count}

#Remove all ACEs from directory
$Acl=Get-Acl "filesystem::$($strHomeDir)"
$Acl.Access | % {$Acl.PurgeAccessRules($_.IdentityReference)}
Set-Acl -Path "filesystem::$($strHomeDir)" -AclObject $Acl
Get-Acl $strHomeDir | %{$_.Access.Count}

#Remove-Item
$ace = "$($strDNSRoot)\$($objUser.SamAccountName)","FullControl","ContainerInherit,ObjectInherit","None","Allow"    
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ace)
$Acl.SetAccessRule($AccessRule)
Set-Acl -Path "filesystem::$($strHomeDir)" -AclObject $Acl

rm -Path $strHomeDir -Recurse -Confirm:$false
