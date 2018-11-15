#Comparison operaters and If conditions
#Demonstrate -eq operator
If (1+2 -eq 3)
{
    “one plus two equals three”
}

#Demonstrate -ne operator
If (2 -ne 3)
{
    “two does not equal three”
}

#Demonstrate -lt operator
If (2 -lt 3)
{
    “two is less that three”
}

#Demonstrate -gt operator
If (100 -gt 5)
{
    “one hundred is greater that five”
}

#Demonstrate -ge operator
If (5 -ge 5)
{
    “ten is greater or equal to five”
}

#Demonstrate -le operator
If (1 -le 7)
{
    “one is less or eqal to seven”
}

#Demonstrate -ne operator
If (6 -ne 7)
{
    “six is not eqal to seven”
}

#Demonstrate -like operator
If ( "testosterone" -like "test*" )
{
    "The wildcard string ""test*"" is like testosterone"
}

#Demonstrate -Match operator
$Matches
"Sunday" -Match "sun"
$objDays="Sunday", "Monday"
$objDays.GetType().name
$objDays -Match "sun" 
$objDays -Match "day"

#Demonstrate -NotMatch operator
"Sunday" -NotMatch "day"
$objDays+="Tuesday", "Wednesday"
$objDays -NotMatch "sun" 

#Demonstrate -contains operator
$objTest="this", "is", "a", "test"
$objTest.GetType().Name
If ($objTest -contains "test")
{
    "Object variable contains the string test"
}

#Demonstrate -in operator
"test" -in $objTest

#Demonstrate -replace operator
"Get-Process" -Replace "Get", "Stop"

#Demonstrate -is and -isnot type operaters
$strVariable = "test"
$strVariable -is "String"
$objTest -is [Object]
$strVariable -isnot [Array]

#Demonstrate -as type operaters
$strDateTime = "31-12-14"
$strDateTime -is [DateTime]
$strDateTime -as [DateTime]
1031 -as [System.Globalization.CultureInfo]

#Demonstarte Case In-Sensitivity
"TEST" -eq "test"
"TEST" -ieq "test"

#Demonstarte Case Sensitivity
"TEST" -ceq "test"

#Demonstrate If Not
If (-Not (1 -eq 2))
{
    “Do something”
}
If (!(1 -eq 2))
{
    "Do something awesome"
}

#Demonstarate -And operator
If (!(1 -eq 2) -And (1 -ne 2)) 
{
    “Do something even more awesome"
}

#Demonstarate -Or operator
If ((1 -eq 1) -Or (1 -ne 2)) 
{
    “Do something phenomenal"
}

#Demonstrate Else
If (1 -eq 2)
{
    “True”
}
Else
{
    “False”
}

#Demonstrate ElseIf
If (1 -eq 2)
{
    “one eqals to two”
}
ElseIf (2 -eq 2)
{
    “two equals to two”
}

