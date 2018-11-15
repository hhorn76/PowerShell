#Throw a command not found exception error  
Get-ThisDoesNotExist
#View $error variable
$Error
#View Properties and methods of $error variable
$Error.Count
#View DataType of $error variable
$Error.GetType().Name
#Show $error variable exception message
$Error[0].Exception
#Show $error variable exception type
$error[0].Exception.GetType().Name

#Trow a Parameter Binding Exception error
New-Object -PropertyDoesNotExist
#Show number of errors that have occured
$Error.Count
#Show $error variable exception type
$Error[0].Exception.GetType().Name

#Trow a Runtime Exception error
$Error[1].Message.GetType().Name
#Show number of errors that have occured
$Error.Count
#Show $error variable exception type
$Error[0].Exception.GetType().Name

#Call index of error message
$Error[0]
$Error[1]
$Error[2]
$Error


#Trow a Parameter Binding Validation Exception
new-object $objNew
$Error[0].Exception.GetType().Name

#View Error Action Preferance
$ErrorActionPreference
#Set Error Action Preferance
$ErrorActionPreference = "Stop"
#Subpress Error messages
$ErrorActionPreference = "SilentlyContinue"
$Error.Count
1/0
$Error.Count
$Error[0].Exception

Get-ChildItem "H:\DoesNotExit" -ErrorAction Inquire
Get-ChildItem "H:\DoesNotExit" -ea SilentlyContinue

#Demonstrate Try, Catch, Finally
Try
{
new-object $objNew
}
Catch
{
"caught a system exception"
}
Finally
{
"Clean up"
}

#Demonstrate Write Host
Write-Host $Error[0].Exception -ForegroundColor Yellow
Write-Host $Error[0].Exception -ForegroundColor Green

#Demonstrate Send-MailMessage
$EmailTo="error@mydomain.com"
$EmailFrom="script@mydomain.com"
$EmailSubject="Script Error"
$EmailhtmlErrorBody="The follow error occoured: "+$Error[0].Exception
$EmailServer="mail.mydomain.com"

Send-MailMessage -to $EmailTo -from $EmailFrom -subject $EmailSubject -BodyAsHtml $EmailhtmlErrorBody -SmtpServer $EmailServer

#Open Event Viewer

#Before using Write-EventLog You will have to create a New-EventLog
$strLogSource = "New Test Event"
New-EventLog –LogName Application –Source $strLogSource

#Demonstarate Write-EventLog
$LogMessage = "Processing started (on $date )"
Write-EventLog –LogName Application –Source $strLogSource –EntryType Warning –EventID 1 -Message $strErrorMessage
