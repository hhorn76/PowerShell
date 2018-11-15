#Demonstrate single pipe to cmdlets
Get-Service spooler | Restart-Service
Get-Process notepad | Stop-Process

#Demonstrate single pipe, formatting output
Get-Service spooler
Get-Service spooler | Format-Table
Get-Service spooler | Format-List
Get-Service spooler | ft DisplayName
Get-Service spooler | fl Status,DisplayName

#Demonstrate single pipe formatting, Select-Object
Get-Service spooler | Select-Object DisplayName
Get-Service spooler | Select DisplayName

#Demonstrate two pilelines filtering, Where-Object & formatting
Get-Service *win* | Where-Object status -EQ Stopped | fl
Get-Service *win* | where status -EQ Stopped | fl
Get-Service *win* | ? status -EQ Stopped | fl

#Demonstrate four pipelines formatting, Select-Object & filtering, Where-Object & acting on, Export-Csv
Get-Process | Select-Object Name, ID, Path | Where-Object Name -Like *Edge* | Export-Csv "C:\Test\Services.csv"

#Demonstrate pipeline variables
Get-Service | Where-Object {$_.name -Match "win"} | ft Name, Status
Get-WmiObject -List | Where-Object {$_.name -Like "CIM_Network*"} | ft Name
