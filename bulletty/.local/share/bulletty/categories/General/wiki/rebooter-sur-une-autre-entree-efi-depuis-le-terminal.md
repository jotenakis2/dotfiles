+++
title = "Rebooter sur une autre entrée EFI depuis le terminal"
description = "Introduction Dans cet article, on va voir comment sous Linux rebooter sur une autre entrée EFI directement depuis la ligne de commande.   En effet, sur ma machine Minisforum MS-R1, j'ai Fedora Linux et Alma Linux en dual boot pour contribuer aux tests sur l'architecture"
date = "2026-06-22T22:53:09Z"
url = "https://www.linuxtricks.fr/wiki/rebooter-sur-une-autre-entree-efi-depuis-le-terminal"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.427466971Z"
seen = true
+++

Introduction
----------

 Dans cet article, on va voir comment sous Linux rebooter sur une autre entrée EFI directement depuis la ligne de commande.  

 En effet, sur ma machine Minisforum MS-R1, j'ai Fedora Linux et Alma Linux en dual boot pour contribuer aux tests sur l'architecture ARM.  
 Je n'ai pas d'écran, clavier et souris de branché et je m'y connecte en ligne de commande ou en bureau distant RDP.  
 Fedora est l'entrée par défaut mais je veux pouvoir rebooter sur Alma Linux.  

 Je vous montre donc les astuces de la commande efibootmgr !  

Prérequis
----------

 Toutes les commandes sevront être saisies en root.  

 Se connecter en tant que superutilisateur :  

Code BASH :

```
su -
```

 Ou avec sudo :  

Code BASH :

```
sudo -i
```

Repérer les ID des entrées EFI
----------

 Avant toute chose, l'UEFI ne cause pas avec des noms mais avec des ID d'entrées.  

 La commande suivante permet de lister les entrées :  

Code BASH :

```
efibootmgr
```

 Sur ma machine, ça donne ceci :  

Code TEXT :

```
BootCurrent: 0004
Timeout: 5 seconds
BootOrder: 0004,0005,0001,0000,0002
Boot0000* UiApp    FvVol(9a15aa37-d555-4a4e-b541-86391ff68164)/FvFile(462caa21-7614-4503-836e-8ab6f4662331)
Boot0001* UEFI KINGSTON OM8TAP41024K1-A00 50026B7383F87542 1    PciRoot(0x1)/Pci(0x0,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-26-B7-38-3F-87-54-25){auto_created_boot_option}
Boot0002  UEFI Shell    FvVol(9a15aa37-d555-4a4e-b541-86391ff68164)/FvFile(7c04a583-9e3e-4f1c-ad65-e05268d0b4d1)
Boot0004* Fedora    HD(1,GPT,37883702-27c0-4312-84be-7460fe4b689c,0x800,0x12c000)/\EFI\fedora\shimaa64.efi
Boot0005* AlmaLinux    HD(1,GPT,37883702-27c0-4312-84be-7460fe4b689c,0x800,0x12c000)/\EFI\almalinux\shimaa64.efi
 
```

 On note que le boot par défaut est l'entrée 0004  
 On note aussi que l'ordre de boot est 0004 0005 0001 0000 0002  

 Et dessous on a les correspondances :  
 \- **Boot0004** correspond à l'entrée "Fedora" et on a le chemin du fichier EFI correspondant  
 \- **Boot0005** correspond à l'entrée "AlmaLinux" et on a le chemin du fichier EFI correspondant  

 Donc par défaut c'est toujours Fedora qui va démarrer  

Rebooter sur une autre entrée
----------

 Depuis Fedora, si je veux rebooter sur AlmaLinux, je vais pouvoir **ponctuellement** indiquer une autre entrée sur laquelle booter la prochaine fois (et seulement la prochaine fois)  

 Si je veux rebooter sur AlmaLinux, j'indique de booter la prochaine fois sur l'ID 0005 :  

Code BASH :

```
efibootmgr --bootnext 0005
```

 La commande génère une sortie, avec une info en plus "BootNext" :  

Code TEXT :

```
BootNext: 0005
BootCurrent: 0004
Timeout: 5 seconds
BootOrder: 0004,0005,0001,0000,0002
Boot0000* UiApp    FvVol(9a15aa37-d555-4a4e-b541-86391ff68164)/FvFile(462caa21-7614-4503-836e-8ab6f4662331)
Boot0001* UEFI KINGSTON OM8TAP41024K1-A00 50026B7383F87542 1    PciRoot(0x1)/Pci(0x0,0x0)/Pci(0x0,0x0)/NVMe(0x1,00-26-B7-38-3F-87-54-25){auto_created_boot_option}
Boot0002  UEFI Shell    FvVol(9a15aa37-d555-4a4e-b541-86391ff68164)/FvFile(7c04a583-9e3e-4f1c-ad65-e05268d0b4d1)
Boot0004* Fedora    HD(1,GPT,37883702-27c0-4312-84be-7460fe4b689c,0x800,0x12c000)/\EFI\fedora\shimaa64.efi
Boot0005* AlmaLinux    HD(1,GPT,37883702-27c0-4312-84be-7460fe4b689c,0x800,0x12c000)/\EFI\almalinux\shimaa64.efi
```

 Il ne me reste plus qu'à faire un reboot :  

Code BASH :

```
reboot
```

Un petit script
----------

 Il ne reste plus qu'à faire un petit script :  

Code BASH :

```
vim /usr/bin/rebootalma
```

 Et y mettre dedans :  

Code BASH :

```
#! /usr/bin/env bash
sudo efibootmgr --bootnext 0005 && sudo reboot
```

 De le rendre exécutable :  

Code BASH :

```
chmod +x /usr/bin/rebootalma
```

 Et voilà !