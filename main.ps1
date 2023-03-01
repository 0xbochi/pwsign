
param(
    #folder to sign
    [alias("s")]
    [switch]$sign,
    
    #sign everything in folder recursively
    [alias("r")]
    [switch]$recursive,

    #Create certificat to sign 
    [alias("c")]
    [string]$certificat,

    #Get documentation about pwsign script 
    [alias("d")]
    [switch]$doc,

    #Get help
    [switch]$help,

    #get script version
    [alias("v")]
    [switch]$version,

    #output path
    [alias("o")]
    [string]$output,

    #output path
    [alias("g")]
    [switch]$generate,

    [alias("i")]
    [switch]$import,

    #user will choose save path
    [alias("p")]
    [string]$path,

    [alias("a")]
    [string]$authority
    

)

#Condition pour le paramètre -c
if([string]::IsNullOrEmpty($certificat)) {
    $certificat = "certificat.pfx"
}

# Condition pour le paramètre -d
if(!$doc) {
    $doc = $false
}

# Condition pour le paramètre -v
if(!$version) {
    $version = $false
}

# Condition pour le paramètre -g
if(!$generate) {
    $generate = $false
}

if(!$import) {
    $import = $false
}

if(!$sign) {
    $sign = $false
}



#function to recursively sign every file in folder
function signRecursively {
    param(
        [string]$certificat,
        [string]$path,
        [string]$authority
    )
    if (!$authority) {
        $authority = "Cert:\LocalMachine\My"
    }
    if(!$certificat) {
        $certificat = "certificat.pfx"
    }

    # Spécifiez le chemin d'accès au dossier contenant les fichiers PS1 à signer
    $folderPath = "$path"

    #sign with the recursive way
    if($recursive){
    Write-Host "wrong way"
        # Récupérer la liste de tous les fichiers PS1 dans le dossier et ses sous-dossiers
        $files = Get-ChildItem -Path $folderPath -Recurse -Filter "*.ps1"

        # Pour chaque fichier PS1, signer numériquement le script avec le certificat spécifié
        foreach ($file in $files) {
            Set-AuthenticodeSignature -FilePath $file.FullName -Certificate (Get-ChildItem -Path "$authority" | Where-Object {$_.Subject -eq "CN=$certificat"})
        }


    }else{
        #sign single way
        write-host "here we are "
        write-host $path
        write-host $certificat
        write-host $recursive
        Set-AuthenticodeSignature -FilePath $path -Certificate (Get-ChildItem -Path "$authority" | Where-Object {$_.Subject -eq "CN=$certificat"})
    }
    
}


function certifGenerate {
    param(
        [string]$certificat,
        [string]$path
    )
    if(!$path) {
        $path = "C:"
    }
    if(!$certificat) {
        $certificat = "certificat.pfx"
    }


    $cert = New-SelfSignedCertificate -Type CodeSigningCert -DnsName "$certificat" -CertStoreLocation Cert:\LocalMachine\My -NotAfter (Get-Date).AddYears(1)
    Export-Certificate -Cert $cert -FilePath "$path\$certificat"

    write-host "Certificat $certificat généré dans $path avec succès"
    
    
    return $cert


}


function certifImport {
    param(
        [string]$authority,
        [string]$path,
        [string]$certificat
    )
    if (!$authority) {
        $authority = "Cert:\LocalMachine\Root"
    }
    if (!$path) {
        $path = "C:"
    }
    if (!$certificat) {
        $certificat = "certificat.pfx"
    }

    Import-Certificate -FilePath "$path\$certificat" -CertStoreLocation "$authority"

    Write-Host "Certificat $certificat situé dans $path importé avec succès dans $authority"


}


if($help) {
    # Appeler la fonction qui affiche l'aide
    Write-Host "Affichage de l'aide"
}
elseif($doc) {
    # Appeler la fonction qui affiche la documentation
    Write-Host "Affichage de la documentation"
}
elseif($version) {
    # Afficher la version du script
    Write-Host "Version du script: $version"
}
elseif($generate) {
    Write-Host "Generation de certificat"
    # Appeler la fonction de génération de certificat si l'argument -c est fourni
    certifGenerate $certificat $path
}
elseif($import) {
    Write-Host "Import du certificat"
    # Appeler la fonction de génération de certificat si l'argument -c est fourni
    certifImport -authority $authority -path $path -certificat $certificat
}


elseif($sign) {
    Write-Host "Signature en cours..."
    # Appeler la fonction de génération de certificat si l'argument -c est fourni
    signRecursively -certificat $certificat -path $path -authority $authority
}

else {
    # Afficher un message d'erreur si aucun argument n'est fourni
    Write-Host "Aucun argument fourni. Utilisez -help pour afficher l'aide."
}



