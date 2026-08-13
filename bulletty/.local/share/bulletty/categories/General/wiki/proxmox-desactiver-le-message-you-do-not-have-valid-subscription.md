+++
title = "PROXMOX : Désactiver le message You do not have valid subscription"
description = """proxmox_logoIntroduction Proxmox Virtual Environment (PVE) est une solution de virtualisation libre basée sur l'hyperviseur Linux KVM, et offre aussi une solution de containers avec LXC.   La popup "N"""
date = "2026-08-01T08:05:34Z"
url = "https://www.linuxtricks.fr/wiki/proxmox-desactiver-le-message-you-do-not-have-valid-subscription"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.291971653Z"
seen = false
+++

![proxmox_logo](https://www.linuxtricks.fr/upload/proxmox_logo.png "proxmox_logo")

Introduction
----------

 Proxmox Virtual Environment (PVE) est une solution de virtualisation libre basée sur l'hyperviseur Linux KVM, et offre aussi une solution de containers avec LXC.  

 La popup "No Valid Subscription" est une notification qui s'affiche si vous n'avez pas de souscription valide (Enterprise) pour Proxmox.  

![subscription_proxmox](https://www.linuxtricks.fr/upload/subscription_proxmox.png "subscription_proxmox")

 Nous allons voir dans cet article comment désactiver cette popup.  
 Cette astuce fonctionne pour Proxmox Virtual Environment (PVE) ET Proxmox Backup Server (PBS).  

Les modifications sont à refaire à chaque mise à jour.  
 En effet, le fichier que nous allons modifier sera écrasé par celui présent dans le paquet proxmox-widget-toolkit.  

Testé avec succès pour les éditions suivantes : PVE 7.3 - PVE 7.4 - PVE 8 - PVE9  

Désactiver la popup
----------

 Cette pop-up est générée par du Javascript via le fichier : **/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js**  
 Ce fichier est utilisé par Proxmox Virtual Environment (PVE) et Proxmox Backup Server (PBS).  

 Avant de modifier ce fichier, on en réalise une copie de sauvegarde :  

Code BASH :

```
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
```

 Il suffit d'éditer ce fichier :  

Code BASH :

```
vim /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```

 Chercher la ligne contenant ceci (environ à la ligne 520 sur Proxmox 7.3) :  

Code JAVASCRIPT :

```
.data.status.toLowerCase() !== 'active'
```

 On va modifier cette ligne pour inverser la condition :  

Code JAVASCRIPT :

```
.data.status.toLowerCase() === 'active'
```

 Déconnectez-vous, et relancez pve-proxy (pour Proxmox Virtual Environment) et/ou proxmox-backup-proxy (pour Proxmox Backup Server) :  

Code BASH :

```
systemctl restart pveproxy.service
```

Code BASH :

```
systemctl restart proxmox-backup-proxy.service
```

 Rafraîchissez la page via Ctrl+F5 pour ignorer le cache du navigateur.  
 Reconnectez-vous et constatez que le message a disparu.  

BONUS : Script à lancer à chaque mise à jour
----------

 Pour éviter de faire la manip manuellement, je vous propose un petit script à lancer manuellement.  

Code BASH :

```
vi /root/remove-popup.sh
```

 On y place le contenu suivant :  

Code BASH :

```
#! /bin/bash
# Patch du fichier JS
sed -i.bak "s/.data.status.toLowerCase() !== 'active'/.data.status.toLowerCase() === 'active'/" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
# Restart PVE Web
if [[ $(systemctl is-active pveproxy.service) = 'active' ]]
then
    systemctl restart pveproxy.service
fi
# Restart PBS Web
if [[ $(systemctl is-active proxmox-backup-proxy.service) = 'active' ]]
then
    systemctl restart proxmox-backup-proxy.service
fi
 
```

 Rendez le script exécutable :  

Code BASH :

```
chmod +x /root/remove-popup.sh
```

 Et voilà, à la prochaine mise à jour, vous naurez qu'à exécuter le script :  

Code BASH :

```
/root/remove-popup.sh
```

BONUS 2 : Lancer automatiquement le script lors de la mise à jour
----------

 Ce qui est encore mieux c'est d'automatiser le lancement du script lorsque le paquet qui contient ce fichier est mis à jour !  

 Pour cela, on va faire un petit hook "apt".  
 Créer le fichier de hook :  

Code BASH :

```
nano /etc/apt/apt.conf.d/99removesub.sh
```

 Et on y met ceci dedans :  

Code :

` DPkg::Post-Invoke { "/root/removesub.sh"; }; `

 On rend le script exécutable et roulez !  

Code BASH :

```
chmod +x /etc/apt/apt.conf.d/99removesub.sh
```

Retour arrière en cas de problème
----------

 Si la page est blanche vous pouvez revenir en arrière via :  

Code BASH :

```
apt reinstall proxmox-widget-toolkit
```

![:magic:](https://www.linuxtricks.fr/images/smileys/64.gif ":magic:")