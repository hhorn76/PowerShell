#Set Variables
$strTaskName="PowerShellTest"
$strTaskPath="\Powershell\"
$strDescription="This is a task created with Windows PowerShell"
$strUser="Administrator"
$strPassword="MyPassword"

#Demonstrate New-ScheduledTaskAction
$strExec="$($PSHOME)\powershell.exe"
$strArg="-File ""C:\Scripts\W32Time.ps1"""
$objAction=New-ScheduledTaskAction –Execute $strExec -Argument $strArg

#Demonstrate New-ScheduledTaskTrigger
$objTrigger=New-ScheduledTaskTrigger -Daily -At 6am

#Demonstrate New-ScheduledTaskPrincipal
$objPrincipal=New-ScheduledTaskPrincipal -UserId "LOCALSERVICE" -LogonType ServiceAccount

#Demonstrate New-ScheduledTask
$objTask=New-ScheduledTask -Action $objAction -Trigger $objTrigger -Description $strDescription -Principal $objPrincipal

#Demonstrate Register-ScheduledTask
Register-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName -InputObject $objTask -User $strUser -Password $strPassword
Start-Process "$($env:windir)\system32\taskschd.msc"

#Demonstrate Get-ScheduledTask
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | fl Actions,Principal,Settings,State,TaskName,TaskPath,Triggers,URI
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | %{$_.Actions}
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | %{$_.Settings}
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | %{$_.Triggers}
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | %{$_.Principal}

#Demonstrate Get-ScheduledTaskInfo
Get-ScheduledTaskInfo -TaskPath $strTaskPath -TaskName $strTaskName | fl 

#Demonstrate Disable-ScheduledTask
Disable-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName

#Demonstrate Enable-ScheduledTask
Enable-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName

#Demonstrate Set-ScheduledTask
$objTrigger=New-ScheduledTaskTrigger -Daily -At 3:00
Set-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName -Trigger $objTrigger -User $strUser -Password $strPassword

#Demonstrate Start-ScheduledTask
Start-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | fl State 
Get-ScheduledTaskInfo -TaskPath $strTaskPath -TaskName $strTaskName | %{"{0:X0}" -f $_.LastTaskResult} 

#Demonstrate Stop-ScheduledTask
Start-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName
Stop-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName
Get-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName | fl State 
Get-ScheduledTaskInfo -TaskPath $strTaskPath -TaskName $strTaskName | %{"{0:X0}" -f $_.LastTaskResult} 

#Demonstrate Export-ScheduledTask
$strFilePath="C:\Test\$($strTaskName).xml"
$objTask=Export-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName
$objTask | Out-File -FilePath $strFilePath 
$objTask > $strFilePath
Set-Content -Value $objTask -Path $strFilePath
Get-Content -Path $strFilePath
ii $strFilePath

#Demonstrate Import task
$xml=Get-Content $strFilePath
$strTaskNameImport=(Get-Item -Path $strFilePath).Name.Replace(".xml","")+"_Import"
Register-ScheduledTask -Xml $xml.OuterXml -TaskName $strTaskNameImport -TaskPath $strTaskPath -User $strUser -Password $strPassword

#Demonstrate Unregister-ScheduledTask
Unregister-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskName -Confirm:$false
Unregister-ScheduledTask -TaskPath $strTaskPath -TaskName $strTaskNameImport -Confirm:$false

#Demonstrate DeleteFolder
$scheduleObject=New-Object -ComObject schedule.service
$scheduleObject.connect("localhost")
$rootFolder=$scheduleObject.GetFolder("\")
$rootFolder.DeleteFolder("Powershell",$null)
Start-Process "$($env:windir)\system32\taskschd.msc"
