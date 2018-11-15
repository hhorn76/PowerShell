#Set variables
$ErrorActionPreference="SilentlyContinue"
$objUser=Get-ADUser -Identity hhorn 
$arrGroups="test0","test1","test2","test3"

#Demonstrate group membership and group creation
ForEach($group in $arrGroups)
{
    $objGroup=Get-ADGroup -Identity $group
    IF($objGroup)
    {
        Write-Host "Group does EXISTS" -ForegroundColor Yellow
        Add-ADGroupMember -Identity $group -Members $objUser.SamAccountName
    }
    Else
    {
        Write-Host "Group does not exist" -ForegroundColor Magenta
        New-ADGroup -Name $group -samAccountName $group.ToLower() -GroupCategory Security -GroupScope Universal -DisplayName $group
        Add-ADGroupMember -Identity $group -Members $objUser.SamAccountName
    }
}

#Demonstrate removing AD users from group
Remove-ADGroupMember -Identity "test0" -Members $objUser.SamAccountName -Confirm:$false

#Demonstrate deleting AD groups
ForEach($group in $arrGroups)
{
    Remove-ADGroup -Identity $group -Confirm:$false
}
