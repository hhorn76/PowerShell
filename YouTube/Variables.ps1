#Declare String
$strMyVariable = "test"ù
#Overwrite String
$strMyVariable = "This is a test!"ù
#Nest/Insert Strings
$strNew ="new"ù
$strMyVariable = "This is a "+$strNew+"ù test!"ù

#Declare Integers
$intMyVariable = 1
#Add to integer
$intMyVariable + 1
#Add integer to itself
$intMyVariable +=1
$intMyVariable = $intMyVariable+1

#Arrays
#Add string values to an array:
$arrVariable = @("String1", "String2", "String3")
#Get specific value from array:
$arrVariable[0]
#Change value in array:
$arrVariable[2] = "String4"ù

$y=1,2,3,4,5
$y=@(1,2,3,4)
$y=[array]1,2,3,4,5
$y[3]

#Declare Hash Table
$hashVariable = @{"String1" = 100; "String2" = 101; "String3" = 102}
#Read Names and Values in variable
$hashVariable
#Get specific values:
$hashVariable["String1"]
#Add a new record:
$hashVariable["String4"] = 111
$hashVariable.Add("String5",222)
#Delete a record:
$hashVariable.Remove("String2")
#Remove all records from hash table:
$hashVariable.Clear

#Set DateTime to variable
$objVariable = Get-Date

#Read DateTime property from variable
$objVariable.Year

#Demonstate default Variables
$true
$false
$null
$pwd

$Host
$ShellID

#Fixed Datatype variables
[int32]$intMyVariable="5"