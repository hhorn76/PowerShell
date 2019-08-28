# Function to read a PLIST file with single entry
function ReadPlist ($xmlPlist) {
    $xmlPlist.plist.dict |       
    foreach {
        $vals = $_.SelectNodes('string'); $_.SelectNodes('key') | 
        Foreach {$ht=@{};$i=0} {$ht[$_.'#text'] = $vals[$i++].'#text'} `
                {new-object psobject -property $ht}
    }
}

# Function to read a PLIST file with single entry using the key values
function ReadPlistKey ($xmlPlist) {
    $xmlPlist.plist.dict | 
    Foreach {
        $_.SelectNodes('key') | 
        Foreach {$ht=@{}} {$ht[$_.'#text'] = $_.NextSibling.'#text'} `
                {new-object psobject -property $ht}
    }
}

# Function to read a PLIST file with array of entries
function ReadPlistArray ($xmlPlist) {
    $xmlPlist.plist.array.dict |       
    foreach {
        $_.SelectNodes('key') | 
        Foreach {$ht=@{}} {$ht[$_.'#text'] = $_.NextSibling.'#text'} `
        {new-object psobject -property $ht}
    }
}

# Parse PLIST with single dictionary values
Write-Host 'Parse PLIST wit single value'
[xml]$xmlPlist = Get-Content ./SAMPLE_DICT.plist
Write-Host "apiToken:  $((ReadPlist $xmlPlist).apiToken) `n"
Write-Host ''

# Parse PLIST with single dictionary values using the key function
Write-Host 'Parse PLIST wit single value'
[xml]$xmlPlist = Get-Content ./SAMPLE_DICT.plist
Write-Host "apiToken:  $((ReadPlist $xmlPlist).apiToken) `n"


Write-Host 'Parse PLIST wit single value'
[xml]$xmlPlist = Get-Content ./SAMPLE_DICT.plist
$arrPlist = ReadPlistKey $xmlPlist
foreach ($item in $arrPlist) {
    Write-Host 'apiToken: ' $item.apiToken
    Write-Host 'username: ' $item.username
    Write-Host 'password: ' $item.password
}
Write-Host ''

# Parse PLIST with multiple dictionary values
Write-Host 'Parse PLIST with multiple values'
[xml]$xmlPlistArray = Get-Content ./SAMPLE_ARRAY.plist
ReadPlistArray $xmlPlistArray