+++
title = "RPM : Utiliser : Installer, Désinstaller, Interroger"
description = "Introduction Qu'est ce que RPM ? RPM (Redhat Package Manager) est un système de gestion de paquets de logiciels utilisé sur certaines distributions GNU/Linux.   RPM s'utilise en ligne de commande ou avec une interface graphique et permet d'installer, de désinstaller, de"
date = "2026-06-23T13:22:02Z"
url = "https://www.linuxtricks.fr/wiki/rpm-utiliser-installer-desinstaller-interroger"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.424640401Z"
seen = true
+++

Introduction
----------

 Qu'est ce que RPM ? RPM (Redhat Package Manager) est un système de gestion de paquets de logiciels utilisé sur certaines distributions GNU/Linux.  

 RPM s'utilise en ligne de commande ou avec une interface graphique et permet d'installer, de désinstaller, de vérifier, d'interroger et de mettre à jour des paquets logiciels. Chaque paquet de logiciels se compose d'une archive de fichiers et d'informations relatives au paquet, tels que sa licence, sa version, sa description, ses dépendances, etc.  

 À noter que RPM ne gère pas le téléchargement et l'installation des dépendances.  

Installer des paquets
----------

 Pour installer des paquets RPM :  

Code BASH :

```
rpm -ivh nom_paquet.rpm
```

 Il est aussi possible de mettre à jour un paquet avec RPM:  

Code BASH :

```
rpm -Uvh nom_paquet.rpm
```

Les commutateurs v et h permettent d'afficher des détails (v) et une barre de progression lors de l'installation (h)  

 On peut aussi forcer l'installation d'un paquet récalcitrant :  

Code BASH :

```
rpm -ivh --nodeps --force paquet
```

Supprimer des paquets
----------

 Pou supprimer un paquet :  

Code BASH :

```
rpm -e nom_paquet
```

 Si ce paquet est une dépendance, il ne sera pas dés-installable. Pour forcer sa désinstallation:  

Code BASH :

```
rpm -e --nodeps nom_paquet
```

Utiliser cette commande avec précaution !!!  

Interroger les paquets
----------

### Lister tous les paquets ###

 La commande la plus connue RPM semble être celle-ci :  

Code BASH :

```
rpm -qa
```

 Elle peut être suivie d'un nom de paquet avec des jockers pour filtrer les résultats :  

Code BASH :

```
rpm -qa systemd\*
```

 A noter : si on veut sélectionner uniquement les paquets installés manuellement (en excluant les dépendances), il faut passer par yum ou dnf :  

Code BASH :

```
dnf repoquery --userinstalled
```

### Lister les paquets installés par date ###

 Pour lister les paquets avec leur date d'installation :  

Code BASH :

```
rpm -qa --last
```

 Ne pas hésiter à piper ou préciser un paquet :  

Code :

` systemd-libs-259.6-1.fc44.i686 lun. 08 juin 2026 18:21:58  
systemd-rpm-macros-259.6-1.fc44.noarch lun. 08 juin 2026 18:21:54  
systemd-resolved-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:21:52  
systemd-pam-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:21:52  
systemd-oomd-defaults-259.6-1.fc44.noarch lun. 08 juin 2026 18:21:52  
systemd-networkd-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:21:52  
systemd-container-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:21:52  
systemd-udev-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:20:16  
systemd-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:20:15  
systemd-sysusers-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:20:10  
systemd-shared-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:20:08  
systemd-libs-259.6-1.fc44.x86_64 lun. 08 juin 2026 18:20:08  
systemd-coffeed-1.0-1.fc44.noarch dim. 12 avril 2026 10:40:30 `

### Demander des détails sur un paquet installé ###

 Pour avoir un maximum d'informations sur un paquet installé, utiliser :  

Code BASH :

```
rpm -qi paquet
```

Code :

` Name : bash  
Version : 5.3.9  
Release : 3.fc44  
Architecture: x86_64  
Install Date: ven. 27 févr. 2026 17:01:20  
Group : Unspecified  
Size : 8873537  
License : GPL-3.0-or-later  
Signature :  
 RSA/SHA256, mar. 20 janv. 2026 09:22:11, Key ID dbfcf71c6d9f90a6  
Source RPM : bash-5.3.9-3.fc44.src.rpm  
Build Date : ven. 16 janv. 2026 10:11:11  
Build Host : buildvm-x86-11.rdu3.fedoraproject.org  
Packager : Fedora Project  
Vendor : Fedora Project  
URL : https://www.gnu.org/software/bash  
Bug URL : https://bugz.fedoraproject.org/bash  
Summary : The GNU Bourne Again shell  
Description :  
The GNU Bourne Again shell (Bash) is a shell or command language  
interpreter that is compatible with the Bourne shell (sh). Bash  
incorporates useful features from the Korn shell (ksh) and the C shell  
(csh). Most sh scripts can be run by bash without modification. `

### Afficher le changelog ###

 Pour afficher le changelog d'un paquet (exemple avec bash), saisir :  

Code BASH :

```
rpm -q bash --changelog
```

 Ce qui donne :  

Code :

` * ven. janv. 16 2026 Fedora Release Engineering  - 5.3.9-3  
- Rebuilt for https://fedoraproject.org/wiki/Fedora_44_Mass_Rebuild  

* ven. janv. 16 2026 Fedora Release Engineering  - 5.3.9-2  
- Rebuilt for https://fedoraproject.org/wiki/Fedora_44_Mass_Rebuild  

* lun. janv. 05 2026 Siteshwar Vashisht  - 5.3.9-1  
- Update to bash-5.3 patchlevel 9  

* mer. juil. 23 2025 Fedora Release Engineering  - 5.3.0-2  
- Rebuilt for https://fedoraproject.org/wiki/Fedora_43_Mass_Rebuild  

* mar. juil. 15 2025 Siteshwar Vashisht  - 5.3.0-1  
- Update to bash-5.3  
 Resolves: #2376213  

* jeu. févr. 13 2025 Siteshwar Vashisht  - 5.2.37-3  
- Fix FTBFS in Fedora rawhide/f42  
 Resolves: #2339923 `

Utilisation avancée
----------

### Utiliser le --queryformat ###

 Il peut être intéressant de lister tous les paquets et afficher quelques éléments. Pour en faire des exports ou autre  
 Utiliser alors l'option queryformat:  

Code BASH :

```
rpm -q --queryformat "CHAINE" paquet
```

 Exemple ci-dessous avec quelques attributs pour le paquet bash :  

Code BASH :

```
rpm -q --queryformat "%{NAME} %{VERSION} %{RELEASE} %{ARCH}\n" bash
```

 Ce qui donne :  

Code TEXT :

```
bash 5.3.9 3.fc44 x86_64
```

 Pour tous les paquets :  

Code BASH :

```
rpm -qa --queryformat "%{NAME} %{VERSION} %{RELEASE} %{ARCH}\n"
```

### Afficher les macros RPM ###

 Si on fait du packaging RPM, on peut avoir besoin de vérifier ce qu'une macro renvoie sur notre système.  
 On utilise alors l'option **-E** :  

Code BASH :

```
rpm -E %{_libdir}
```

 Ce qui donne :  

Code :

` /usr/lib64 `