<#
.SYNOPSIS
    Digitally signs PS1 files in a folder using a certificate.

.DESCRIPTION
    This script digitally signs all PS1 files in a folder using a certificate. The script can sign all files in the folder recursively. It can also import and export the certificate and change the certificate's password.

.PARAMETER sign
    Specifies the path to the folder containing the PS1 files to sign.

.PARAMETER recursive
    Specifies whether the script should sign all files in the folder recursively.

.PARAMETER certificat
    Specifies the name of the certificate to use for signing the files. Default is "certificat.pfx".

.PARAMETER doc
    Displays detailed documentation for the script.

.PARAMETER help
    Displays help for the script.

.PARAMETER version
    Displays the version of the script.

.PARAMETER output
    Specifies the path to save the signed files.

.PARAMETER password
    Specifies the password for the certificate.

.PARAMETER import
    Specifies the location to import the certificate to. Default is "Cert:\LocalMachine\Root".

.PARAMETER export
    Exports the certificate to a .pfx file.

.EXAMPLE
    pwsign.ps1 -sign C:\Scripts -recursive -certificat MyCert.pfx -output C:\SignedScripts -password MyPassword

    This command signs all PS1 files in the C:\Scripts folder and its subfolders using the MyCert.pfx certificate with the password MyPassword. The signed files are saved in the C:\SignedScripts folder.

.NOTES
    Author: Your Name
    Version: 1.0
#>



param(
    #folder to sign
    [alias("s")]
    [string]$sign,
    
    #sign everything in folder recursively
    [alias("r")]
    [switch]$recursive,

    #Create certificat to sign 
    [alias("c")]
    [string]$certificat = "certificat.pfx",

    #Get documentation about pwsign script 
    [alias("d")]
    [switch]$doc,

    #Get help
    [switch]$help,

    #get script version
    [alias("v")]
    [switch]$version = "Version 0.0.1",

    #output path
    [alias("o")]
    [switch]$output,

    #set certificat password
    [alias("p")]
    [switch]$password,

    #import certificat in local computer
    # here user can define store location
    [alias("i")]
    [string]$import="Cert:\LocalMachine\Root",

    #export certificat
    #user will choose save path
    [alias("e")]
    [switch]$export
)

if ($help) {
    Get-Help pwsign.ps1 -Full
    return
}

if ($doc) {
    Get-Help pwsign.ps1 -Detailed
    return
}

if ($version) {
    Write-Output $version
    return
}

if ($certificat -eq "certificat.pfx" -and !$password) {
    Write-Output "You must specify a password for the certificate."
    return
}

if ($sign) {
    if ($recursive) {
        Sign-FilesRecursively -FolderPath $sign -CertificatPath $certificat
    } else {
        Sign-FilesInFolder -FolderPath $sign -CertificatPath $certificat
    }
}

if ($export) {
    Export-Certificate -CertPath $certificat
}

if ($import) {
    Import-Certificate -CertPath $certificat -StoreLocation $import
}

if ($certificat -ne "certificat.pfx" -and $password) {
    Set-CertificatePassword -CertPath $certificat
}

function Sign-FilesInFolder {
    param(
        [string]$FolderPath,
        [string]$CertificatPath
    )

    # Get a list of all PS1 files in the folder
    $files = Get-ChildItem -Path $FolderPath -Filter "*.ps1"

    # For each PS1 file, sign it with the specified certificate
    foreach ($file in $files) {
        Set-AuthenticodeSignature -FilePath $file.FullName -Certificate (Get-ChildItem -Path cert:\CurrentUser\My\$CertificatPath)
    }
}

function Sign-FilesRecursively {
    param(
        [string]$FolderPath,
        [string]$CertificatPath
    )

    # Get a list of all PS1 files in the folder and its subfolders
    $files = Get-ChildItem -Path $FolderPath -Recurse -Filter "*.ps1"

    # For each PS1 file, sign it with the specified certificate
    foreach ($file in $files) {
        Set-AuthenticodeSignature -FilePath $file.FullName -Certificate (Get-ChildItem -Path cert:\CurrentUser\My\$CertificatPath)
    }
}

function Export-Certificate {
    param(
        [string]$CertPath
    )

    $path = Read-Host "Enter the path to save the certificate"
    $password = Read-Host "Enter the password for the"
    Export-PfxCertificate -Cert cert:\CurrentUser\My\$CertPath -FilePath $path -Password (ConvertTo-SecureString $password -AsPlainText -Force)
}

function Import-Certificate {
    param(
        [string]$CertPath,
        [string]$StoreLocation
    )

    Import-PfxCertificate -FilePath $CertPath -CertStoreLocation $StoreLocation
}

function Set-CertificatePassword {
    param(
        [string]$CertPath
    )

    $password = Read-Host "Enter the new password for the certificate"
    $newCert = Export-PfxCertificate -Cert cert:\CurrentUser\My\$CertPath | Import-PfxCertificate -Password (ConvertTo-SecureString $password -AsPlainText -Force) -CertStoreLocation cert:\CurrentUser\My
    Remove-Item -Path cert:\CurrentUser\My\$CertPath
    $newCertThumbprint = $newCert.Thumbprint
    Write-Output "The password for the certificate has been changed. The new thumbprint is $newCertThumbprint."
}
