# Function to generate a password using the System.web.dll (int length, int numberOfNonAlphanumericCharacters)
# Does not work in Powershell Core 6 or Powershell Core 7
# Import the System.web dll
Add-Type -AssemblyName System.web
function generateWebPassword {
    [System.Web.Security.Membership]::GeneratePassword(10,0)
}

# Create 10 random password susing the System.web.dll
function generateRandomPasswords ([int]$int) {
    1..$int | % { [System.Web.Security.Membership]::GeneratePassword(8,3) }
}

# Create password using ascii characters
Function createAsciiPassword {
    $Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | Sort-Object {Get-Random})[0..8] -join ''
    return $Password
}

# Function to Validate Password
Function validatePassword {
    param(
        [string]$strPwd=$(throw "Please specify password"),
        [int]$minLength=8,
        [int]$numUpper=1,
        [int]$numLower=1,
        [int]$numNumbers=1, 
        [int]$numSpecial=0
    )
    $upper=[regex]"[A-Z]"
    $lower=[regex]"[a-z]"
    $number=[regex]"[0-9]"
    #Special is "none of the above"
    $special=[regex]"[^a-zA-Z0-9]"

    # Check the length.
    IF($strPwd.length -lt $minLength) {$false; return}

    # Check for minimum number of occurrences.
    IF($upper.Matches($strPwd).Count -lt $numUpper ) {$false; return}
    IF($lower.Matches($strPwd).Count -lt $numLower ) {$false; return}
    IF($number.Matches($strPwd).Count -lt $numNumbers ) {$false; return}
    IF($special.Matches($strPwd).Count -lt $numSpecial ) {$false; return}

    # Passed all checks.
    $true
}

# Function to generate random Password
Function createPassword() {
    $upper=[regex]"[A-Z]"
    $lower=[regex]"[a-z]"
    $number=[regex]"[0-9]"
    #Special is "none of the above"
    $special=[regex]"[^a-zA-Z0-9]"
    $ascii=$NULL
    $b=48..57
    $b+=64..90
    $b+=97..122
    #b+=33..47
    $b+=35..38
    
    Foreach($a in $b){$ascii+=,[char][byte]$a }
    For ($loop=1; $loop –le 8; $loop++) {
        $TempPassword+=($ascii | GET-RANDOM)
    }
    $aU=$NULL;For ($a=65;$a –le 90;$a++) {$aU+=,[char][byte]$a }
    $aL=$NULL;For ($a=97;$a –le 122;$a++) {$aL+=,[char][byte]$a }
    $aI=$NULL;For ($a=48;$a –le 57;$a++) {$aI+=,[char][byte]$a }
    $aS=$NULL;For ($a=33;$a –le 47;$a++) {$aS+=,[char][byte]$a }
    IF(!$upper.Matches($TempPassword).Count){$TempPassword+=($aU | GET-RANDOM)}
    IF(!$lower.Matches($TempPassword).Count){$TempPassword+=($aL | GET-RANDOM)}
    IF(!$number.Matches($TempPassword).Count){$TempPassword+=($aI | GET-RANDOM)}
    IF(!$special.Matches($TempPassword).Count){$TempPassword+=($aS | GET-RANDOM)}
    return $TempPassword
}


# Function to randomise password according to parameters
function generatePassword {
    param(
        [int]$numLength=8,
        [int]$numUpper=1,
        [int]$numLower=1,
        [int]$numNumbers=1, 
        [int]$numSpecial=0,
        [int]$i=1
    )
    $charNumbers = 0..9 # or [char[]]([char]48..[char]57)
    $charUpper = [char[]]([char]65..[char]90)
    $charLower = [char[]]([char]97..[char]122)
    $charSpecial = [char[]]([char]33..[char]47) + [char[]]([char]58..[char]64)
    $random = $null
    if ($numUpper -gt 0) {$random += $charUpper}
    if ($numLower -gt 0) {$random += $charLower}
    if ($numNumbers -gt 0) {$random += $charNumbers}
    if ($numSpecial -gt 0) {$random += $charSpecial}
    $Password = ($random | Sort-Object {Get-Random})[1..($numLength)] -join ''
    # Check if parameters are less than number of characters
    if ( ($numNumbers + $numUpper + $numLower + $numSpecial) -le $numLength ) {
        # Check to make sure that all parameters specified are met, if not rerun the rpassword generator
        if ( (([regex]"[A-Z]").Matches($Password).Count -lt $numUpper) `
            -or (([regex]"[a-z]").Matches($Password).Count -lt $numLower) `
            -or (([regex]"[0-9]").Matches($Password).Count -lt $numNumbers) `
            -or (([regex]"[^a-zA-Z0-9]").Matches($Password).Count -lt $numSpecial) ) {
                Write-Host "Password does not meet paremeters that were set, recreating password... ($i)" -ForegroundColor DarkYellow
                $i++; generatePassword $numLength $numUpper $numLower $numNumbers $numSpecial $i
            } else {
            return $Password 
        } 
    } else {
        Write-Host 'The number of parameters that are passed to the funtion are greater that the number of characters specified...' -ForegroundColor Red
    }
}

# Using the function generateWebPassword, this creates a random password which does not always comply with a complex password policy 
$strPassword = generateWebPassword
$strPassword
validatePassword $strPassword 8 1 1 1 1

# Using the function generateRandomPasswords to generate a certain number of passwods
# enerateRandomPasswords [[-int] <int>]
generateRandomPasswords 

# Usnig the function createAsciiPassword, this creates a random password which does not always comply with a complex password policy 
createAsciiPassword
$strPassword
validatePassword $strPassword 8 1 1 1 1

# Usnig the function createPassword, this will always comply with a complex password policy
$strPassword = createPassword
$strPassword
validatePassword $strPassword 8 1 1 1 1

# Usnig the function generatePassword, this will always comply with a complex password policy
# generatePassword [[-numLength] <int>] [[-numUpper] <int>] [[-numLower] <int>] [[-numNumbers] <int>] [[-numSpecial] <int>] [[-i] <int>] 
$strPassword = generatePassword 8 1 1 1 1
$strPassword
validatePassword $strPassword 8 1 1 1 1

# Usnig the function generatePassword to create a really comlex password, the function will try to recreate a password until all parameters are met.
# generatePassword [[-numLength] <int>] [[-numUpper] <int>] [[-numLower] <int>] [[-numNumbers] <int>] [[-numSpecial] <int>] [[-i] <int>] 
generatePassword 18 5 5 4 4 