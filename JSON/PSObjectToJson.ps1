#Create variables
$var1 = "10"
$var2 = "above"

#Create a new object
$objUser=New-Object -TypeName PSObject

#Add property values to the object
Add-Member -InputObject $objUser -MemberType NoteProperty -Name duration -Value "$var1"
Add-Member -InputObject $objUser -MemberType NoteProperty -Name operator -Value "$var2"
Add-Member -InputObject $objUser -MemberType NoteProperty -Name priority -Value "critical" 
Add-Member -InputObject $objUser -MemberType NoteProperty -Name threshold -Value "1" 
Add-Member -InputObject $objUser -MemberType NoteProperty -Name time_function -Value "all" 

#Convert the object to JSON
$objUser | ConvertTo-Json
