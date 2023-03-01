![](./.github/images/banner.png)

The pwsign script is a PowerShell script for digitally signing executable files using a certificate. It supports digital signing of individual files as well as signing all files in a folder and its subfolders recursively. Installation

To use the pwsign script, you must have PowerShell installed on your computer. The script does not require any additional installation.

## Usage

##### The pwsign script supports the following parameters:

    -s or --sign: Specifies the file or folder to digitally sign.
    -r or --recursive: Specifies that the digital signature should be applied to all files in a folder and its subfolders.
    -c or --certificate: Specifies the name of the certificate to use to sign the file or folder. If this parameter is not specified, the script uses the default certificate "certificate.pfx".
    -d or --doc: Displays the script documentation.
    -v or --version : Displays the version of the script.
    -g or --generate : Generate a new certificate.
    -i or --import: Imports a certificate.
    -p or --path: Specifies the path to save or import the certificate.
    -a or --authority: Specifies the certificate authority to use for importing the certificate. If this parameter is not specified, the script uses the "Cert:\LocalMachine\Root" certificate authority by default.



#### Digital signature of files

To digitally sign a file or folder, use the following command:
```
.\pwsign.ps1 -s <path to file or folder> -c <name of certificate> -r <for recursive mode>
```
This will digitally sign all files in the specified folder and its subfolders. If the -r argument is not specified, only the specified file will be signed.


#### Generating certificates

To generate a new certificate, use the following command:
```
.\pwsign.ps1 -g -c <name of certificate> -p <path to file or folder to store> 
```
It will generate a new certificate with the specified name and save it locally on the computer.


#### Importing certificates

To import a certificate from a PFX file, use the following command:
```
.\pwsign.ps1 -i -a <certification authority> -p <path> -c <certificate name>
```
This will import the certificate into the specified certificate authority.


## Support

If you are having problems with the pwsign script, please create an issue in the Issues section of this GitHub repository. We will do our best to help you resolve your issue.

## Author

The pwsign script was written by Bochi If you have any questions about the script, feel free to contact me at bochi#6982.
