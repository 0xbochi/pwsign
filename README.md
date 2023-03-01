![](./.github/images/banner.png)

Le script pwsign est un script PowerShell qui permet de signer numériquement des fichiers exécutables à l'aide d'un certificat. Il prend en charge la signature numérique de fichiers individuels ainsi que la signature de tous les fichiers d'un dossier et de ses sous-dossiers de manière récursive.
Installation

Pour utiliser le script pwsign, vous devez avoir PowerShell installé sur votre ordinateur. Le script ne nécessite pas d'installation supplémentaire.

## Utilisation

Le script pwsign prend en charge les paramètres suivants :

    -s ou --sign : Spécifie le fichier ou le dossier à signer numériquement.
    -r ou --recursive : Spécifie que la signature numérique doit être appliquée à tous les fichiers d'un dossier et de ses sous-dossiers.
    -c ou --certificat : Spécifie le nom du certificat à utiliser pour signer le fichier ou le dossier. Si ce paramètre n'est pas spécifié, le script utilise le certificat "certificat.pfx" par défaut.
    -d ou --doc : Affiche la documentation du script.
    -v ou --version : Affiche la version du script.
    -g ou --generate : Génère un nouveau certificat.
    -i ou --import : Importe un certificat.
    -p ou --path : Spécifie le chemin d'accès où enregistrer ou importer le certificat.
    -a ou --authority : Spécifie l'autorité de certification à utiliser pour l'importation du certificat. Si ce paramètre n'est pas spécifié, le script utilise l'autorité de certification "Cert:\LocalMachine\Root" par défaut.

## Signature numérique de fichiers

Pour signer numériquement un fichier ou un dossier, utilisez la commande suivante :

```
.\pwsign.ps1 -s <chemin d'accès au fichier ou au dossier> -c <nom du certificat> -r
```

Cela signera numériquement tous les fichiers dans le dossier spécifié et ses sous-dossiers. Si l'argument -r n'est pas spécifié, seul le fichier spécifié sera signé.
Génération de certificats

Pour générer un nouveau certificat, utilisez la commande suivante :

```
.\pwsign.ps1 -g -c <nom du certificat> -p <chemin d'accès>
```

Cela générera un nouveau certificat avec le nom spécifié et l'enregistrera localement sur l'ordinateur.
Importation de certificats

Pour importer un certificat à partir d'un fichier PFX, utilisez la commande suivante :

```
.\pwsign.ps1 -i -a <autorité de certification> -p <chemin d'accès> -c <nom du certificat>
```

Cela importera le certificat dans l'autorité de certification spécifiée.

## Support

Si vous rencontrez des problèmes avec le script pwsign, veuillez créer une issue dans la section Issues de ce repository GitHub. Nous ferons de notre mieux pour vous aider à résoudre votre problème.

## Auteur

Le script pwsign a été écrit par Bochi Si vous avez des questions sur le script, n'hésitez pas à me contacter à bochi#6982.
