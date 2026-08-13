+++
title = "Proxmox : Supprimer un noeud du cluster !"
description = "proxmox_logoIntroduction Quand on rejoint un cluster dans Proxmox, on peut sans soucis le faire via l'interface graphique.   Cependant, pour retirer une machine du cluster on ne peut le faire qu'en li"
date = "2026-08-01T07:46:54Z"
url = "https://www.linuxtricks.fr/wiki/proxmox-supprimer-un-noeud-du-cluster"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.295633223Z"
seen = false
+++

![proxmox_logo](https://www.linuxtricks.fr/upload/proxmox_logo.png "proxmox_logo")

Introduction
----------

 Quand on rejoint un cluster dans Proxmox, on peut sans soucis le faire via l'interface graphique.  
 Cependant, pour retirer une machine du cluster on ne peut le faire qu'en ligne de commande.  

 Nous allons voir ici comment supprimer une machine du cluster.  

Retirer une machine du cluster
----------

 Se positionner sur une machine qui va rester dans le cluster.  

 Lister les noeuds avec :  

Code BASH :

```
pvecm nodes
```

 Ce qui donne :  

Code :

` Membership information  
----------------------  
 Nodeid Votes Name  
 1 1 pve1  
 2 1 pve2  
 3 1 pve241 (local) `

 Le noeud sur lequel on est est précisé avec (local).  

 Pour supprimer le noeud en question, on utilisera à nouveau la commande pvecm. Dans cet exemple, je vais retirer le noeud **pve2** :  

Code BASH :

```
pvecm delnode pve2
```

 On a une confirmation que le noeud est bien retiré :  

Code :

` Killing node 2 `

 Si on relance la commande :  

Code BASH :

```
pvecm nodes
```

 On constate que le noeud a bien été supprimé :  

Code :

` Membership information  
----------------------  
 Nodeid Votes Name  
 1 1 pve1  
 3 1 pve241 (local) `

 Si on veut des détails sur les noeuds, on peut utiliser :  

Code BASH :

```
pvecm status
```

 Ce qui donne une vois mon noeud retiré :  

Code :

` Cluster information  
-------------------  
Name: DCLINUXTRICKS  
Config Version: 4  
Transport: knet  
Secure auth: on  
Quorum information  
------------------  
Date: Wed Apr 30 22:44:55 2025  
Quorum provider: corosync_votequorum  
Nodes: 2  
Node ID: 0x00000003  
Ring ID: 1.4cc  
Quorate: Yes  
Votequorum information  
----------------------  
Expected votes: 2  
Highest expected: 2  
Total votes: 2  
Quorum: 2   
Flags: Quorate   
Membership information  
----------------------  
 Nodeid Votes Name  
0x00000001 1 192.168.21.250  
0x00000003 1 192.168.21.241 (local) `

L'ancien noeud apparait encore dans l'interface graphique
----------

 Lors d'un live, bien que le noeud soit retiré, il apparait encore dans l'interface graphique.  
 L'astuce va consister à vraiment supprimer les métadonnées IRL.  

 On se rend dans **/etc/pve/nodes**  

Code BASH :

```
cd /etc/pve/nodes/
```

 Et on doit trouver 1 dossier par nom de noeud.  
 Supprimer le dossier résiduel via :  

Code BASH :

```
rm pve2
```

 Et on redémarre le service pve-cluster :  

Code BASH :

```
systemctl restart pve-cluster
```