# Variables 
# Please change the location to copy the certificate and where to find the certificate 
$strCertLocation = 'cert:\LocalMachine\TrustedPublisher'
$strCertPath = 'C:\Temp\Konica.cer'

# Function to install the certificate
function installCert ( $printCertPath, $strCertLocation ) {
    Write-Host "Certificate does not exist in: $strCertLocation, importing $strCertPath" -ForegroundColor Yellow
    Set-Location C:
    $TrustCert = ( Get-ChildItem -Path $strCertPath )
    $TrustCert | Import-Certificate -CertStoreLocation $strCertLocation
}

# Function to check if certificate is 
function importCertificate ( $strCertPath, $strCertLocation ) {
    # Import the certificat into an object to get the thumbprint
    $objPrintCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $objPrintCert.Import($strCertPath)
    # Import the certificat ino the trusted publishers certificate location if it does not exist
    $trustedCerts = Get-ChildItem -Path $strCertLocation
    if ($trustedCerts) {
        if (!($trustedCerts.Thumbprint.Contains($objPrintCert.Thumbprint))) {
            installCert $printCertPath $strCertLocation 
        } else {
            Write-Host "Certificate: $strCertPath aleady exists in certification store: $strCertLocation." -ForegroundColor Green
        }
    } else {
        installCert $printCertPath $strCertLocation 
    }
}

# Call the functions to import the certificate
importCertificate $strCertPath $strCertLocation