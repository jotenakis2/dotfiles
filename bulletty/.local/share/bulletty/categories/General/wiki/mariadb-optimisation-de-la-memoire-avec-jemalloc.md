+++
title = "MariaDB : Optimisation de la mémoire avec jemalloc"
description = "logo-mariadbIntroduction Dans cet article, on va détaille la procédure pour stabiliser l'utilisation de la mémoire RAM sur un serveur de base de données MariaDB en remplaçant l'allocateur de mémoire p"
date = "2026-06-29T09:27:57Z"
url = "https://www.linuxtricks.fr/wiki/mariadb-optimisation-de-la-memoire-avec-jemalloc"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.415697538Z"
seen = true
+++

![logo-mariadb](https://www.linuxtricks.fr/upload/logo-mariadb.png "logo-mariadb")

Introduction
----------

 Dans cet article, on va détaille la procédure pour stabiliser l'utilisation de la mémoire RAM sur un serveur de base de données MariaDB en remplaçant l'allocateur de mémoire par défaut par **jemalloc**.  
 Cette méthode permet d'éviter la fragmentation de la mémoire en production.  

 Ce tuto a été validé sur une **Red Hat Enterprise Linux release 9.7 (Plow)** avec **MariaDB-server-10.11.17-1.el9.x86\_64** issu des dépôts éditeur de MariaDB. Cela doit fonctionner quelque soit la distribution.  

Optimisation de la RAM avec jemalloc
----------

 Par défaut, MariaDB utilise l'allocateur de mémoire système (glibc).  
 Dans certains contextes de production (grosses requêtes par exemple), cela peut entraîner une augmentation constante de la RAM consommée.  

 Cette RAM n'est jamais libérée et peut causer des crash de MariaDB par l'OOM Killer.  

 Voici ce qui m'est arrivé souvent au travail :  

Code BASH :

```
mai 28 11:32:12 BDDXX.montaf.lan systemd[1]: mariadb.service: A process of this unit has been killed by the OOM killer.
mai 28 11:32:13 BDDXX.montaf.lan systemd[1]: mariadb.service: Main process exited, code=killed, status=9/KILL
mai 28 11:32:13 BDDXX.montaf.lan systemd[1]: mariadb.service: Failed with result 'oom-kill'.
mai 28 11:32:13 BDDXX.montaf.lan systemd[1]: mariadb.service: Consumed 16h 1min 44.925s CPU time, 8.1G memory peak.
```

 L'utilisation de **jemalloc** va permettre de maintenir un niveau de RAM stable.  

Mise en oeuvre de jemalloc
----------

 Dans un premier temps, on installe le paquet jemalloc :  

Code BASH :

```
dnf install jemalloc
```

 On repère le nom de la bibliothèque exacte avec :  

Code BASH :

```
rpm -ql jemalloc
```

 Dans le cas d'EPEL 9 : **/usr/lib64/libjemalloc.so.2**  

 Ensuite, on va créer une configuration spécifique pour le service systemd pour surcharger le service MariaDB :  

Code BASH :

```
mkdir -p /etc/systemd/system/mariadb.service.d/
```

 Via la variable d'environnement **LD\_PRELOAD**, on va charger jemalloc :  

Code BASH :

```
vim /etc/systemd/system/mariadb.service.d/jemalloc.conf
```

 On y met :  

Code :

` [Service]  
Environment="LD_PRELOAD=/usr/lib64/libjemalloc.so.2" `

 On recharge ssystemd :  

Code BASH :

```
systemctl daemon-reload
```

 On applique les modifications en redémarrant le service (attention, cela provoque une indispo le temps du restart) :  

Code BASH :

```
systemctl restart mariadb
```

Constat
----------

 Voici pour info une vue de la mémoire utilisée par MariaDB, la modif ayant été faite au milieu du graphe :  

![mariadb-jemalloc](https://www.linuxtricks.fr/upload/mariadb-jemalloc.png "mariadb-jemalloc")

 Comme on le voit c'est NICKEL !