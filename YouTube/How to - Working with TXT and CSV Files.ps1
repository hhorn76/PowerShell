#Demonstrate reading file content with Get-Content
Get-Content -Path C:\Test\Sort.txt
Get-Content C:\Test\Sort.txt | Sort-Object
Get-Content C:\Test\Sort.txt | Sort-Object -Descending
Get-Content C:\Test\Sort.txt | Sort-Object -Unique

#Demonstrate Measure-Object
Get-Content C:\Test\NewsArticle.txt | Measure-Object –Line
Get-Content C:\Test\NewsArticle.txt | Measure-Object -Character
Get-Content C:\Test\NewsArticle.txt | Measure-Object –Word

#Limiting the output
(Get-Content C:\Test\Test1.txt)[0 .. 2]
Get-Content C:\Test\Test1.txt -TotalCount 3
Get-Content C:\Test\Test1.txt -Head 3
Get-Content C:\Test\Test1.txt -First 3

(Get-Content C:\Test\Test1.txt)[-3 .. -1]
Get-Content C:\Test\Test1.txt -Tail 3
Get-Content C:\Test\Test1.txt -Last 3

(Get-Content C:\Test\Test1.txt)[-1 .. -3]
(Get-Content C:\Test\Test1.txt)[3 .. 5]

#Demonstrate Set-Content
Set-Content -Path C:\Test\TestHello.txt -Value "Hello, World"
Get-Content -Path C:\Test\TestHello.txt
Get-Content C:\Test\Sort.txt -Head 3 | Set-Content C:\Test\Sample.txt
Get-Content C:\Test\Sample.txt

#Demonstrate Export-Csv
$service=Get-Service | ?{$_.Name -eq "Spooler"}
$service | Export-Csv -Path C:\Test\Services.csv

#Demonstrate Export-Csv -NoTypeInformation
Get-Content C:\Test\Services.csv -TotalCount 1
$service | Export-Csv C:\Test\Services.csv -NoTypeInformation
Get-Content C:\Test\Services.csv -TotalCount 1

#Demonstrate Export-Csv -Encoding
$service | Export-Csv C:\Test\Services.csv -Encoding "Unicode" -NoType

#Demonstrate Export-Csv -Delimiter
$service | Export-Csv C:\Test\Services.csv -Delimiter ";" -NoType
Get-Content C:\Test\Services.csv

#Demonstrate Export-Csv -Force
$service | Export-Csv C:\Test\Services.csv -Force -NoType

#Demonstrate Export-Csv -UseCulture
Get-Date | Export-Csv –Path C:\Test\Date.csv -NoType -UseCulture
Get-Content C:\Test\Date.csv -TotalCount 1

#Demonstrate Export-Csv -Append
Get-Date | Select-Object Second,MilliSecond | Export-Csv –Path C:\Test\Append.csv -NoT
For($i=1; $i -lt 8; $i++)
{
    Get-Date | Select-Object Second,MilliSecond | Export-Csv –Path C:\Test\Append.csv -Append 
    Start-Sleep -Milliseconds 10
}
Get-Content C:\Test\Append.csv

#Demonstrate Export-Csv -Append with New-Object
Get-Content C:\Test\Employees.csv -Head 1
$csv=Get-Content C:\Test\Employees.csv
$csv.Count
$obj=New-Object -TypeName PSObject -Property @{"Name"="Heiko Horn";"Department"="IT";"Jobtitle"="PowerShell Admin"}
Export-Csv -InputObject $obj -Path C:\Test\Employees.csv -Append
$csv=Get-Content C:\Test\Employees.csv
$csv.Count
$csv
#Delete last line from $csv
$csv=$csv[0..($csv.count - 2)]
Set-Content -Value $csv –Path C:\Test\Employees.csv
$csv=Get-Content C:\Test\Employees.csv
$csv

#Demonstrate Import-Csv
Import-Csv -Path C:\Test\Services.csv
Import-Csv C:\Test\Employees.csv | ?{$_.Department -eq "Finance"}

#Demonstrate ConvertTo-Csv
$obj = Get-Process | ?{$_.Name -eq "spoolsv"} | ConvertTo-Csv

#Demonstrate ConvertFrom-Csv with Header
$obj.Count
$obj[0]
$obj[1]
$arrHeader = "MoreData","StatusMessage","Location","Command","State","Finished","InstanceId","SessionId","Name","ChildJobs","Output","Error","Progress","Verbose","Debug","Warning","StateChanged"
#Delete header from $obj
$obj = $obj[0], $obj[2..($obj.Count - 1)]
$obj | ConvertFrom-Csv -Header $arrHeader

#Cleanup Variable
Clear-Variable j,csv,obj,service
