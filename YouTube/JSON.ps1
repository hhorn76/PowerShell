#Demonstrate ConvertTo-Json
Get-Date "2000-01-01" | Select-Object -Property * | ConvertTo-Json

$objDate=(Get-Date "2000-01-01") | Select-Object -Property *
$jsonDate=ConvertTo-Json -InputObject $objDate

ConvertTo-Json -InputObject (Get-Date "2000-01-01" | Select-Object -Property *)

#Demonstrate ConvertFrom-Json with Web Request
$jsonRequest=Invoke-WebRequest -Uri http://date.jsontest.com
$jsonRequest.Content
$objJson=$jsonRequest | ConvertFrom-Json
$objJson.date
$objJson.time

#Demonstrate ConvertFrom-Json with InputObject
ConvertFrom-Json -InputObject $jsonDate

#Demonstrate ConvertFrom-Json with JSON File and Pipeline
$objJson=Get-Content C:\test\json\Test.JSON | ConvertFrom-Json

#Demonstrate Pair
$objJson.firstName
$objJson.lastName
$objJson.age

#Demonstrate Pairs
$objJson.gender.type

$objJson.address.streetAddress
$objJson.address.city
$objJson.address.state
$objJson.address.postalCode

#Demonstrate Array
$objJson.phoneNumber.Count
ForEach($strPhone in $objJson.phoneNumber) {
    Write-Host "$($strPhone.type): $($strPhone.number)"
}

$i=1
ForEach($emojii in $objJson.emojii) {
    Write-Host "Emojii$($i): $($emojii.type)"
    $i++
}
