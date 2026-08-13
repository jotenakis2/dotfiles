+++
title = "rsync : Une commande pour synchroniser et sauvegarder des fichiers"
description = "rsync_logoIntroduction Rsync est un programme de synchronisation de fichiers, utilisé aussi bien pour des sauvegardes locales que distantes.   La synchronisation avec rsync est unidirectionnelle : il copi"
date = "2026-06-20T12:09:15Z"
url = "https://www.linuxtricks.fr/wiki/rsync-une-commande-pour-synchroniser-et-sauvegarder-des-fichiers"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.432219808Z"
seen = true
+++

![rsync_logo](https://www.linuxtricks.fr/upload/rsync_logo.jpg "rsync_logo")

Introduction
----------

 Rsync est un programme de synchronisation de fichiers, utilisé aussi bien pour des sauvegardes locales que distantes.  

 La synchronisation avec rsync est unidirectionnelle : il copie les fichiers de la source vers la destination. À chaque exécution, il compare la source et la destination, et ne transfère que ce qui a changé (taille ou date de modification). C'est ce qu'on appelle une sauvegarde incrémentale.  

 Parmi ses avantages :  
 \- il conserve les permissions, propriétaires, groupes, horodatages et liens symboliques.  
 \- il est plus rapide que scp (qui est déprécié) sur les gros volumes, car il ne retransfère que les différences.  
 \- il peut compresser les données pendant le transfert.  
 \- il supporte la reprise d'un transfert interrompu.  
 \- utilisé vers une machine distante, il passe par SSH par défaut : le transfert est chiffré, et on bénéficie de l'authentification par clés si elles sont configurées.  

La commande rsync
----------

 La commande s'utilise de cette manière :  

Code BASH :

```
rsync [options] source/ destination/
```

 Il existe une subtilité importante avec les chemins de dossiers.  
 Ces deux commandes n'ont pas le même comportement :  

Code BASH :

```
rsync -avz source/ destination/
```

 et  

Code BASH :

```
rsync -avz source destination/
```

 Dans le premier cas (slash à la fin de source), le **contenu** de source est copié dans destination.  
 Dans le second cas (pas de slash), c'est le **dossier source lui-même** qui est créé dans destination,  
 ce qui donne **destination/source/**.  

 Pour ne pas s'emmêler les pinceaux, je mets toujours le **/** à la fin des deux chemins, et je crée  
 au besoin l'arborescence de destination à l'avance.  

 Pour une machine distante, la syntaxe est la même, avec user@machine:/chemin/.  

 Pour envoyer, c'est à dire de local vers distant :  

Code BASH :

```
rsync -avz /home/adrien/ adrien@198.51.100.89:/home/sauvegardes/adrien/
```

 Pour récupérer, c'est à dire de distant vers local :  

Code BASH :

```
rsync -avz adrien@198.51.100.89:/home/sauvegardes/adrien/ /home/adrien/
```

 Il est même possible de synchroniser depuis un hôte qui possède un démon rsync dédié :  

Code BASH :

```
rsync rsync://machine:/source/ /home/adrien/
```

Des exemples
----------

### Synchronisation locale ###

 Sauvegarde du home d'adrien vers un disque externe monté sur /media/backup :  

Code BASH :

```
rsync -av /home/adrien/ /media/backup/adrien/
```

 Les options utilisées ici :  
 \- **-a** (archive) : conserve les permissions, propriétaires, groupes, horodatages et liens symboliques.  
 \- **-v** (verbose) : affiche les fichiers traités dans le terminal.  

### Synchronisation vers une machine distante ###

 Sauvegarde de /home/adrien vers la machine distante 198.51.100.89 dans /home/sauvegardes/adrien :  

Code BASH :

```
rsync -avz /home/adrien/ adrien@198.51.100.89:/home/sauvegardes/adrien/
```

 Les options utilisées ici en plus, le **-z** qui compresse les données pendant le transfert. Utile sur le réseau, négligeable en local.  

### Synchronisation avec un port SSH différent ###

 Si le serveur SSH distant n'écoute pas sur le port 22, on le précise avec l'option **-e** :  

Code BASH :

```
rsync -avz -e "ssh -p 222" /home/adrien/ adrien@198.51.100.89:/home/sauvegardes/adrien/
```

### Récupérer des fichiers depuis une machine distante ###

 On peut aussi tirer des fichiers depuis une machine distante vers sa machine locale :  
 C'est typiquement utile pour restaurer une sauvegarde :  

Code BASH :

```
rsync -avz adrien@198.51.100.89:/home/sauvegardes/adrien/ /home/adrien/
```

### Afficher la progression du transfert ###

 L'option -v liste les fichiers traités, mais pour voir la progression et la vitesse en temps réel, on lui préfère **--progress** :  

Code BASH :

```
rsync -az --progress /home/adrien/ adrien@198.51.100.89:/home/sauvegardes/adrien/
```

### Supprimer dans la destination ce qui n'est plus dans la source ###

 Par défaut, rsync ne supprime jamais rien dans la destination. Pour obtenir un vrai miroir et supprimer les fichiers qui ont disparu de la source, on ajoute **--delete** :  

Code BASH :

```
rsync -avz --delete /home/adrien/ /media/backup/adrien/
```

En cas d'erreur pendant le transfert, rsync annule les suppressions par sécurité.  
 Pour forcer la suppression même si des erreurs se produisent, on ajoute **--ignore-errors**.  

### Simulation à blanc avant de synchroniser ###

 Avant de lancer une synchronisation (surtout avec --delete), il est très utile de faire un test à blanc pour voir ce que rsync va faire, sans qu'il touche à quoi que ce soit.  
 On utilise **-n** ou **--dry-run** :  

Code BASH :

```
rsync -avzn --delete /home/adrien/ /media/backup/adrien/
```

 rsync liste tous les fichiers qu'il aurait transférés ou supprimés, sans rien modifier.  
Prendre l'habitude de toujours faire un --dry-run avant d'utiliser --delete.  
 Une erreur de chemin peut vider une destination entière sans avertissement !!  

### Exclure des fichiers ou des dossiers ###

 Pour exclure certains fichiers ou dossiers de la synchronisation, on utilise **--exclude**.  
 On peut le répéter autant de fois que nécessaire :  

Code BASH :

```
rsync -avz --exclude "*.log" --exclude ".cache/" /home/adrien/ /media/backup/adrien/
```

### Exclure depuis un fichier ###

 Plutôt que de multiplier les **--exclude** sur la ligne de commande, on peut lister les exclusions dans un fichier texte et le passer avec **--exclude-from**.  
 C'est beaucoup plus lisible et facile à maintenir :  

Code BASH :

```
rsync -avz --exclude-from="/home/adrien/exclusions.txt" /home/adrien/ /media/backup/adrien/
```

 Exemple de contenu pour exclusions.txt :  

Code BASH :

```
*.tmp
*.cache
*.bak
*.swp
.Trash-*/
 
```

### Limiter la bande passante utilisée ###

 Pour ne pas saturer la connexion pendant un transfert réseau, on peut limiter le débit avec **--bwlimit**. La valeur est en Ko/s. Ici, on limite à 2 Mo/s :  

Code BASH :

```
rsync -avz --bwlimit=2000 /home/adrien/ adrien@198.51.100.89:/home/sauvegardes/adrien/
```

### Sauvegardes incrémentales avec liens physiques ###

 C'est l'utilisation la plus élaborée de rsync, mais aussi la plus efficace pour des sauvegardes planifiées.  

 L'idée : chaque sauvegarde est stockée dans un dossier daté. Les fichiers qui n'ont pas changé depuis la dernière sauvegarde ne sont pas recopiés : rsync crée à la place un lien physique (hardlink) qui pointe vers le fichier de la sauvegarde précédente. Sur le disque, ils ne prennent aucune place supplémentaire. Seuls les fichiers réellement modifiés sont copiés.  

 On utilise **--link-dest** pour indiquer à rsync où se trouve la dernière sauvegarde :  

Code BASH :

```
rsync -avz --link-dest=/media/backup/adrien/2025-01-14/ /home/adrien/ /media/backup/adrien/2025-01-15/
```

 Chaque dossier apparaît comme une sauvegarde complète et indépendante, mais sur le disque, seuls les fichiers vraiment modifiés prennent de la place supplémentaire. On peut supprimer n'importe quel dossier sans affecter les autres. (C'est le but des hard link)