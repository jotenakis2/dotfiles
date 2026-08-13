+++
title = "tcpdump : analyser le trafic réseau sous Linux"
description = "tcpdump_headerIntroductiontcpdump est un analyseur de paquets en ligne de commande. Il permet d'obtenir le détail du trafic réseau visible depuis une interface réseau.   Contrairement à des ou"
date = "2026-06-19T17:47:38Z"
url = "https://www.linuxtricks.fr/wiki/tcpdump-analyser-le-trafic-reseau-sous-linux"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.434956619Z"
seen = true
+++

![tcpdump_header](https://www.linuxtricks.fr/upload/tcpdump_header.png "tcpdump_header")

Introduction
----------

**tcpdump** est un analyseur de paquets en ligne de commande. Il permet d'obtenir le détail du trafic réseau visible depuis une interface réseau.  
 Contrairement à des outils graphiques comme Wireshark, tcpdump s'utilise directement dans un terminal, ce qui le rend particulièrement utile sur des serveurs sans interface graphique ou pour scripter des analyses réseau.  
 Il fonctionne en capturant les paquets qui transitent sur une interface réseau et en les affichant selon les filtres qu'on lui applique. On peut capturer en temps réel ou sauvegarder dans un fichier pour analyse ultérieure (notamment avec Wireshark).  
 La syntaxe de la commande est la suivante :  

Code BASH :

```
tcpdump [options] [filtre]
```

**options** : les options de comportement et d'affichage  
**filtre** : l'expression BPF (Berkeley Packet Filter) pour cibler le trafic  

**Note importante** : tcpdump nécessite les droits root (ou la capacité CAP\_NET\_RAW) pour capturer des paquets. Utilisez **sudo** si vous n'êtes pas root.  

Code BASH :

```
sudo tcpdump [options] [filtre]
```

Installation
----------

 Sous Gentoo :  

Code BASH :

```
emerge -av net-analyzer/tcpdump
```

 Fedora, RHEL et clones :  

Code BASH :

```
dnf install tcpdump
```

 Debian et Ubuntu :  

Code BASH :

```
apt install tcpdump
```

Utilisation simple
----------

 Pour analyser le trafic (carte par défaut) :  

Code BASH :

```
tcpdump
```

 Pour lister les interfaces du système que peut analyser tcpdump :  

Code BASH :

```
tcpdump -D
```

 Exemple chez moi :  

Code TEXT :

```
1.ens18 [Up, Running, Connected]
2.any (Pseudo-device that captures on all interfaces) [Up, Running]
3.lo [Up, Running, Loopback]
4.bluetooth-monitor (Bluetooth Linux Monitor) [Wireless]
5.usbmon1 (Raw USB traffic, bus number 1)
6.usbmon0 (Raw USB traffic, all USB buses) [none]
7.nflog (Linux netfilter log (NFLOG) interface) [none]
8.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
```

 Pour filtrer une interface particulière :  

Code BASH :

```
tcpdump -i ens18
```

 Pour filtrer la machine source ou destination :  

Code BASH :

```
tcpdump -i ens18 host 192.168.21.251
```

 Ou par numéro de port :  

Code BASH :

```
tcpdump -i ens18 port 443
```

Options d'affichage
----------

 Par défaut, tcpdump résout les noms d'hôtes et les ports, ce qui peut ralentir la capture et rendre la sortie moins lisible. Voici les options les plus utiles  

 Ne pas résoudre les noms d'hôtes (adresses IP brutes) :  

Code BASH :

```
tcpdump -n -i ens18
```

 Ne pas résoudre les noms d'hôtes ni les noms de ports :  

Code BASH :

```
tcpdump -nn -i ens18
```

 Afficher le contenu des paquets en ASCII (pratique pour voir du trafic HTTP non chiffré) :  

Code BASH :

```
tcpdump -A -i ens18 port 80
```

 Afficher le contenu des paquets en hexadécimal et ASCII :  

Code BASH :

```
tcpdump -XX -i ens18 port 80
```

 Si le timestamp nous gêne, on peut le mettre dans un format plus lisible avec -tttt :  

Code BASH :

```
tcpdump -ttttt -XX -i ens18 port 80
```

 Voici un exemple :  

Code BASH :

```
tcpdump -tttt -nn -A -i ens18 port 80
```

 J'ai requêté un site interne :  

Code TEXT :

```
2026-06-19 19:35:32.337421 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [S], seq 872961048, win 64240, options [mss 1460,sackOK,TS val 880938000 ecr 0,nop,wscale 7], length 0
E..<.e@.@..............P4.T....................
4...........
2026-06-19 19:35:32.337972 IP 192.168.21.251.80 > 192.168.21.21.60124: Flags [S.], seq 123771389, ack 872961049, win 65160, options [mss 1460,sackOK,TS val 1057316569 ecr 880938000,nop,wscale 9], length 0
E..<..@.@..[.........P...`..4.T................
?.^.4......    
2026-06-19 19:35:32.338023 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 880938000 ecr 1057316569], length 0
E..4.f@.@..............P4.T..`.............
4...?.^.
2026-06-19 19:35:32.338079 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [P.], seq 1:79, ack 1, win 502, options [nop,nop,TS val 880938000 ecr 1057316569], length 78: HTTP: GET / HTTP/1.1
E....g@.@..............P4.T..`.............
4...?.^.GET / HTTP/1.1
Host: 192.168.21.251
User-Agent: curl/7.76.1
Accept: */*
2026-06-19 19:35:32.338463 IP 192.168.21.251.80 > 192.168.21.21.60124: Flags [.], ack 79, win 128, options [nop,nop,TS val 1057316569 ecr 880938000], length 0
E..4.U@.@............P...`..4.Tg.....p.....
?.^.4...
2026-06-19 19:35:32.339191 IP 192.168.21.251.80 > 192.168.21.21.60124: Flags [P.], seq 1:307, ack 79, win 128, options [nop,nop,TS val 1057316570 ecr 880938000], length 306: HTTP: HTTP/1.1 200 OK
E..f.V@.@............P...`..4.Tg....sJ.....
?.^.4...HTTP/1.1 200 OK
Date: Fri, 19 Jun 2026 17:35:35 GMT
Server: Apache
Last-Modified: Thu, 16 Sep 2021 05:23:35 GMT
ETag: "5f-5cc160435b5d0"
Accept-Ranges: bytes
Content-Length: 95
Content-Type: text/html

        It works!

2026-06-19 19:35:32.339213 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [.], ack 307, win 501, options [nop,nop,TS val 880938001 ecr 1057316570], length 0
E..4.h@.@..............P4.Tg.`.0...........
4...?.^.
2026-06-19 19:35:32.339382 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [F.], seq 79, ack 307, win 501, options [nop,nop,TS val 880938002 ecr 1057316570], length 0
E..4.i@.@..............P4.Tg.`.0...........
4...?.^.
2026-06-19 19:35:32.339661 IP 192.168.21.251.80 > 192.168.21.21.60124: Flags [F.], seq 307, ack 80, win 128, options [nop,nop,TS val 1057316570 ecr 880938002], length 0
E..4.W@.@............P...`.04.Th.....9.....
?.^.4...
2026-06-19 19:35:32.339670 IP 192.168.21.21.60124 > 192.168.21.251.80: Flags [.], ack 308, win 501, options [nop,nop,TS val 880938002 ecr 1057316570], length 0
E..4.j@.@..............P4.Th.`.1...........
4...?.^.
 
```

Les filtres
----------

 C'est là que tcpdump devient vraiment puissant. On peut cibler précisément le trafic qui nous intéresse.  

**Filtres par hôte**  

 Depuis ou vers un hôte :  

Code BASH :

```
tcpdump -i ens18 host 192.168.21.251
```

 Depuis une source uniquement :  

Code BASH :

```
tcpdump -i ens18 src 192.168.21.251
```

 Vers une destination uniquement :  

Code BASH :

```
tcpdump -i ens18 dst 192.168.21.251
```

**Filtres par réseau**  

 Depuis ou vers un réseau :  

Code BASH :

```
tcpdump -i ens18 net 192.168.21.0/24
```

 Depuis un réseau source :  

Code BASH :

```
tcpdump -i ens18 src net 192.168.21.0/24
```

 Vers un réseau destination :  

Code BASH :

```
tcpdump -i ens18 dst net 192.168.21.0/24
```

**Filtres par port**  

 Depuis ou vers un port :  

Code BASH :

```
tcpdump -i ens18 port 443
```

 Depuis un port source :  

Code BASH :

```
tcpdump -i ens18 src port 22
```

 Vers un port destination :  

Code BASH :

```
tcpdump -i ens18 dst port 80
```

 Filtrer une plage de ports :  

Code BASH :

```
tcpdump -i ens18 portrange 5900-5910
```

**Filtres par protocole**  

 Uniquement le trafic TCP :  

Code BASH :

```
tcpdump -i ens18 tcp
```

 Uniquement le trafic UDP :  

Code BASH :

```
tcpdump -i ens18 udp
```

 Uniquement le trafic ICMP (ping, etc.) :  

Code BASH :

```
tcpdump -i ens18 icmp
```

**Négation d'un filtre**  

 Exclure un port (ici on ignore le SSH pour ne pas se polluer avec sa propre session) :  

Code BASH :

```
tcpdump -i ens18 not port 22
```

 Exclure un hôte :  

Code BASH :

```
tcpdump -i ens18 not host 192.168.21.251
```

Combinaison de filtres
----------

 On peut combiner les filtres avec les opérateurs **and**, **or** et **not**.  
 Pour les expressions complexes, on utilise les parenthèses (à échapper avec \\ ou entre guillemets).  

 Trafic d'un hôte sur un port précis :  

Code BASH :

```
tcpdump -i ens18 host 192.168.21.251 and port 443
```

 Trafic HTTP ou HTTPS :  

Code BASH :

```
tcpdump -i ens18 port 80 or port 443
```

 Trafic d'un réseau vers un port de destination, en excluant le SSH :  

Code BASH :

```
tcpdump -i ens18 src net 192.168.21.0/24 and dst port 443 and not src host 192.168.21.251
```

 Avec des parenthèses pour grouper les conditions :  

Code BASH :

```
tcpdump -i ens18 'host 192.168.21.251 and (port 80 or port 443)'
```

Utilisation avancée de tcpdump
----------

**Sauvegarder et relire une capture**  
 C'est une fonctionnalité que j'utilise souvent : on capture dans un fichier .pcap pour l'analyser ensuite (avec tcpdump lui-même ou Wireshark).  
 Sauvegarder dans un fichier :  

Code BASH :

```
tcpdump -i ens18 -w /tmp/capture.pcap
```

 Sauvegarder avec un filtre et un nombre de paquets limité :  

Code BASH :

```
tcpdump -i ens18 -c 500 port 443 -w /tmp/capture_https.pcap
```

 Relire et afficher le contenu d'un fichier de capture :  

Code BASH :

```
tcpdump -r /tmp/capture.pcap
```

 Relire avec des filtres supplémentaires :  

Code BASH :

```
tcpdump -r /tmp/capture.pcap host 192.168.21.251
```

**Rotation automatique de fichiers**  
 Pour des captures longues durée, on peut faire de la rotation automatique. Ici, un nouveau fichier toutes les 3600 secondes (1h), avec au maximum 24 fichiers :  

Code BASH :

```
tcpdump -i ens18 -G 3600 -W 24 -w /tmp/capture_%Y%m%d_%H%M%S.pcap
```

**Définir la taille des snapshots**  
 Par défaut tcpdump ne capture que les 262144 premiers octets de chaque paquet. Pour capturer les paquets en entier (utile pour voir le contenu applicatif) :  

Code BASH :

```
tcpdump -i ens18 -s 0 port 80 -A
```

**Filtres avancés sur les flags TCP**  
 Capturer uniquement les paquets SYN (nouvelles connexions) :  

Code BASH :

```
tcpdump -i ens18 'tcp[tcpflags] & tcp-syn != 0'
```

 Capturer uniquement les paquets RST (connexions réinitialisées, utile pour détecter des problèmes) :  

Code BASH :

```
tcpdump -i ens18 'tcp[tcpflags] & tcp-rst != 0'
```

Quelques commandes utiles
----------

 Voir les requêtes DNS en temps réel :  

Code BASH :

```
tcpdump -i ens18 -nn port 53
```

 Voir le trafic HTTP (requêtes et réponses en clair) :  

Code BASH :

```
tcpdump -i ens18 -A -nn port 80
```

 Surveiller les tentatives de connexion SSH entrantes :  

Code BASH :

```
tcpdump -i ens18 -nn 'tcp[tcpflags] & tcp-syn != 0 and dst port 22'
```

 Voir tout le trafic sauf SSH et DNS (pour ne pas se noyer) :  

Code BASH :

```
tcpdump -i ens18 -nn not port 22 and not port 53
```