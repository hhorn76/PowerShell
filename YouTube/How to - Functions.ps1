#Demonstrate function
Function Date {Get-Date}
Date

#Demonstrate function with parameters
Function AddInt ($intX, $intY)
{
    $intAnswer = $intX + $intY
    Write-Host “The Answer is $intAnswer”
}
AddInt 23 56

Function AddParam
{
    param ($intX, $intY)
    $intAnswer = $intX + $intY
    Write-Host “The Answer is $intAnswer”
}
AddParam 200 23

#Demonstrate function with parameters and ForEach loop
Function AddForEach ($intValues)
{
    ForEach ($item in $intValues)
    {
        $intAnswer+=$item
    }
    Write-Host “The Answer is $intAnswer”
}
AddForEach 200, 23, 234, 32, 434, 124324

#Demonstrate with arguments
Function Hello {“What are you doing $args ?”}
Hello today

#Demonstrate function with ForEach-Object loop
Function HelloFEO {$args | % {“What are you doing $_ ?”}}
HelloFEO today tomorrow "on Tuesday" "next week"

#Demonstrate with multiple arguments
Function AddArgs {$args[0]+$args[1]}
AddArgs 45 63

#Demonstrate arguments function with for loop
Function AddArgsFor
{
    For ($i=0; $i -le $args.count;$i++)
    {
        $sum+=$args[$i]
    }
    Write-Host $sum
}
AddArgsFor 45 63 34 435 2134

#Demonstrate datatypes in functions
Function AgeInt
{
    Param ([int]$x)
    Write-Host “You are $x years old.”
}
AgeInt 26
AgeInt A

Function AgeNotInt
{
    Param ($x)
    If ($x -isnot [int])
    {Write-Host “The value needs to be an Integer"}
    Else
    {Write-Host “You are $x years old.”}
}
AgeNotInt AD
AgeNotInt 24

#Demonstrate function with default values
Function AddIntAssigned
{
    Param ($x=9,$y=1)
    $Ans=$x+$y
    Write-Host $Ans
}
AddIntAssigned
AddIntAssigned 23 21

#Demonstrate fuction with return keyword
Function DoesExist($strName)
{
    IF (Get-ChildItem -Path C:\ | ? {$_.Name -eq $strName})
    {
        Return
    }
    Write-Host "This will not Execute!!!"
}
DoesExist Windows

#Demonstrate search functions with files with pipeline
Function FindTextFile
{
    $input | ? {$_.Name -eq “Text.txt”} | ft FullName
}
Get-ChildItem -Path C:\Test -Recurse | FindTextFile

#Demonstrate search functions with sub-directories
Function FindFolders
{
    $input | ? {$_.Name -like “Folder*”} | ft FullName
}
Get-ChildItem -Path C:\Test -Recurse | FindFolders

#Demonstrate processor information function
Function ProcessorInfo ($strComputer)
{
    $mboProcessor=Get-WmiObject -Class “Win32_Processor” -Namespace “root\CIMV2” -ComputerName $strComputer
    ForEach ($objItem in $mboProcessor)
    {
        Write-Host “Name: ” $objItem.Name
        Write-Host “Description: ” $objItem.Caption
        Write-Host “Device ID: ” $objItem.DeviceID
        Write-Host “CPU Status: ” $objItem.CpuStatus
        Write-Host “Current Clock Speed: ” $objItem.CurrentClockSpeed
        Write-Host ""
    }
}
ProcessorInfo Localhost

#Demonstrate disk information function
Function DiskInfo ($strComputer)
{
    $mboObjDisk = Get-WmiObject -Class “Win32_DiskDrive” -Namespace “root\CIMV2” -ComputerName $strComputer
    ForEach ($objItem in $mboObjDisk)
    {
        Write-Host “Description: ” $objItem.Description
        Write-Host “Interface Type: ” $objItem.InterfaceType
        Write-Host “Media Type: ” $objItem.MediaType
        Write-Host “Model: ” $objItem.Model
        Write-Host “Partitions: ” $objItem.Partitions
        Write-Host “Size: ” $objItem.Size
        Write-Host “Status: ” $objItem.Status
        Write-Host
        }
}
DiskInfo localhost
