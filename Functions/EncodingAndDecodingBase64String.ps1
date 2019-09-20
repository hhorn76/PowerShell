#Function to use Base64 to encoding a sring 
Function encodePassword ($strPassword) {
    $strEncoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($strPassword))
    Write-Host $strEncoded -ForegroundColor Yellow
    Return $strEncoded
}


#Base64 deencoding 
Function decodePassword ($strPassword) {
    $strDecoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($strPassword))
    Write-Host $strDecoded -ForegroundColor Yellow
}

#
$strEncoded = encodePassword 'ThisIsMySecrepPassword'
decodePassword $strEncoded