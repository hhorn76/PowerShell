#Demonstrate ForEach-Object loop
$arrCollection = 1,2,3,4,5
$arrCollection | ForEach-Object {Write-Host $_}
$arrCollection | ForEach {Write-Host $_}
$arrCollection | % {Write-Host $_}

#Demonstrate Performance difference between ForEach-Object and ForEach
.\ForEach-ObjectPerformance.ps1

#Demonstrate ForEach loop
ForEach ($strItem in $arrCollection)
{
    Write-Host "Item"$strItem
}

ForEach ($strNumber in 1..10)
{
    $strNumber * 100
}

#Demonstrate For loop
For ($i=1; $i -lt 5; $i++)
{
    Write-Host "Loop"$i
}

#Demonstrate While loop
$i = 1
While ($i -lt 5)
{
    Write-Host "While Loop"$i; $i++
}

#Demonstrate Do While loop
$i = 1
do
{
    Write-Host $i; $i++
}
While ($i -lt 5)

#Demonstrate Do Until loop
$i = 1
do
{
    Write-Host $i; $i++
}
Until ($i -gt 5)
