#Run once on remote server
Enable-PSRemoting -force

#Demonstrate Import-Module via PSSession with Invoke-Command
$strSQLServer="MySQLServer"
$strSQLDatabase="MySQLDatabase"
$strSQLUser="MySQLUser"
$strSQLPassword="MySQLPassword"

$psSession = New-PSSession -Computer $strSQLServer
Invoke-Command -Session $psSession -ScriptBlock {Import-Module SQLPS -ErrorAction Continue}
$objDataset=Invoke-Command -Session $psSession -ArgumentList $strSQLServer,$strSQLDatabase,$strSQLUser,$strSQLPassword -ScriptBlock {Invoke-Sqlcmd -query "Select * from staff" -server $args[0] -database $args[1] -Username $args[2] -Password $args[3]}

#Clean up PSSession Variable
$psSession | Remove-PSSession
Remove-PSSession $psSession

#Demonstrate Invoke-Sqlcmd with Query
$strSQLQuery="select * from users"
$objDataset=Invoke-Sqlcmd -Query $strSQLQuery -Server $strSQLServer -Database $strSQLDatabase -Username $strSQLUser -Password $strSQLPassword
$objDataset.GetType() | fl Name, BaseType
$objDataset.Count

#Demonstrate Invoke-Sqlcmd with InputFile
$strFileLocation="c:/TEST/test.sql"
$objDataset=Invoke-Sqlcmd -InputFile $strFileLocation -Server $strSQLServer -Database $strSQLDatabase -Username $strSQLUser -Password $strSQLPassword
$objDataset.Count

#Demonstrate ForEach object in ArrayCollection
ForEach ($item in $objDataSet)
{
    "User ID: "+$item.UserIdent
}

#Demonstrate ForEach-Object
$objDataSet | ForEach-Object {$_.UserIdent}
