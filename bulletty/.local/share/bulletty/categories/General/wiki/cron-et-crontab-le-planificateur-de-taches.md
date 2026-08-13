+++
title = "Cron et crontab : le planificateur de tâches !"
description = "crontabIntroduction Crontab est un outil qui permet de lancer des tâches de façon régulière sur les systèmes Linux.   On pourra donc programmer l'exécution de scripts ou de commandes ce qui est pratique pour un"
date = "2026-06-29T06:10:10Z"
url = "https://www.linuxtricks.fr/wiki/cron-et-crontab-le-planificateur-de-taches"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.420168794Z"
seen = true
+++

![crontab](https://www.linuxtricks.fr/upload/crontab.png "crontab")

Introduction
----------

 Crontab est un outil qui permet de lancer des tâches de façon régulière sur les systèmes Linux.  
 On pourra donc programmer l'exécution de scripts ou de commandes ce qui est pratique pour un serveur pour y lancer des scripts de sauvegardes, ou d'autres automatismes par exemple.  

A propos de cron et crontab
----------

 Cron est le démon (service) qui va se charger d'exécuter les planifications. Ces planifications sont saisies dans un fichier de configuration.  

 Crontab est ce fameux fichier de configuration. Il est propre à chaque utilisateur.  
 Le super utilisateur root possède un crontab mais n'importe quel utilisateur du système également. Évidemment, par défaut, les commandes lancées dans le crontab d'un utilisateur se lancent avec les droits de celui-ci.  

L'installation
----------

 Bien que par défaut, le service est souvent installé, voici les commandes pour l'installer sur les différentes distributions Linux.  

 Debian et Ubuntu :  

Code BASH :

```
sudo apt install cron
```

 Fedora, RHEL (et dérivées) :  

Code BASH :

```
sudo dnf install cronie
```

 Gentoo :  

Code BASH :

```
sudo emerge -av sys-process/cronie
```

La configuration
----------

 Les fichiers **/etc/cron.allow** et **/etc/cron.deny** permettent de définir les droits d'utilisation sur crontab.  

 Si le fichier **/etc/cron.deny** existe, alors vous ne devez pas être mentionné dans le fichier **/etc/cron.deny** afin de pouvoir utiliser cette commande.  
 Si le fichier **/etc/cron.allow** existe, alors vous devez être présent dans ce fichier pour être autorisé à utiliser cette commande.  
 Si aucun fichier n'existe, seul **root** peut planifier des tâches et dans tous les cas root peut planifier des tâches.  

 Je conseille de ne créer qu'un seul des deux fichiers et ensuite placer le nom des utilisateurs auxquels vous voulez donner/refuser l'accès à la commande **crontab**. Généralement, c'est le fichier **cron.deny** qui est présent par défaut.  

Les fichiers **/etc/cron.allow** et **/etc/cron.deny** gèrent l'accès à la commande **crontab**. Cela signifie que si un utilisateur possède un crontab et qu'ensuite on le supprime de liste de **/etc/cron.allow**, les tâches seront quand même effectuées.  

 Vous devez supprimer le crontab de cet utilisateur situé dans **/var/spool/cron/crontabs**  

Utiliser la commande crontab
----------

 Pour afficher le contenu du fichier **crontab** :  

Code BASH :

```
crontab -l
```

 Pour supprimer toutes les actions du fichier **crontab** :  

Code BASH :

```
crontab -r
```

 Pour éditer les actions du fichier **crontab** :  

Code BASH :

```
crontab -e
```

 Le crontab s'ouvre avec un éditeur par défaut. Sous Fedora, c'est **vi**. Si on veut utiliser **nano** :  

Code BASH :

```
export EDITOR=nano
crontab -e
```

Guide de survie de crontab : les syntaxes
----------

 La syntaxe à utiliser est précise.  

 Voici de manière schématique la syntaxe à respecter d'un **crontab**:  

Code :

` # Example of job definition:  
# .---------------- minute (0 - 59)  
# | .------------- hour (0 - 23)  
# | | .---------- day of month (1 - 31)  
# | | | .------- month (1 - 12) OR jan,feb,mar,apr ...  
# | | | | .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat  
# | | | | |  
# * * * * * user command to be executed  
`

 Le fichier de configuration est constitué des différentes lignes. Chaque ligne correspond à une action.  

 Prenons l'exemple suivant :  

Code BASH :

```
mm hh jj MMM JJJ tâche > log
```

* **mm** : minutes (00-59).
* **hh** : heures (00-23) .
* **jj** : jour du mois (01-31).
* **MMM** : mois (01-12 ou abréviation anglaise sur trois lettres : jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec).
* **JJJ** : jour de la semaine (1-7 ou abréviation anglaise sur trois lettres : mon, tue, wed, thu, fri, sat, sun).
* **tâche** : commande à exécuter.
* **\> log** (facultatif) : redirection de la sortie vers un fichier de log. Si un fichier de log n'est pas spécifié, un mail sera envoyé à l'utilisateur local.  

 Pour chaque unité, on peut utiliser les notations suivantes :  

* **1-5** : les unités de temps de 1 à 5.
* **\*/6** : toutes les 6 unités de temps (toutes les 6 heures par exemple).
* **2,7** : les unités de temps 2 et 7.  

 Bonus, on a des alias rapides tels que @reboot qui vont nous permettre de lancer une commande au boot de la machine. La syntaxe sera la suivante :  

Code BASH :

```
@reboot tâche > log
```

Exemples
----------

 Exécution tous les jours à 22h00 d'une commande et rediriger les infos dans sauvegarde.log :  

Code BASH :

```
00 22 * * * /root/scripts/sauvegarde.sh >> sauvegarde.log
```

 Exécution d'une commande toutes les 6 heures :  

Code BASH :

```
00 */6 * * * /root/scripts/synchronisation-ftp.sh
```

 Exécution d'une commande tous les premier du mois à minuit :  

Code BASH :

```
00 00 1 * * /server/lets-encrypt.sh
```

 Exécution d'une commande une fois par an à une heure précise (ici le 25 décembre à 00h15) :  

Code BASH :

```
15 00 25 12 * echo "Le père Noël est passé !"
```

 Un étudiant m'a posé une question une fois lors d'une formation à propos de la définition de jj et JJJ définis en même temps comme dans cet exemple :  

Code BASH :

```
0 0 15 * 1 echo "une tache avec les 15 et les lundi"
```

 A cette question, la réponse peut paraitre complexe car on demande de le faire tous les lundis et on définit en plus le 15 du mois.  
 Dans ce cas là, que se passe-t-il ?  
 Et bien la tâche se déroule tous les lundis **et en plus** le 15 du mois !  

Répertoires /etc/cron.X
----------

 Sur le système il existe dans /etc des dossiers cron.hourly, cron.daily, cron.weekly, cron.monthly  

 On pourra y placer des scripts dedans qui s'exécuteront à intervalle régulier.  
 cron.hourly s'exécute chaque heure à minute 0 ! (0h, 1h, 2h ...)  
 Pour cron.daily cron.weekly et cron.monthly, contrairement à ce qu'on pourrait croire ça ne s'exécute pas à minuit.  
 L'heure est définie dans **/etc/anacrontab**  

 Sur mon système, voici la configuration :  

Code TEXT :

```
SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
RANDOM_DELAY=45
# the jobs will be started during the following hours only
START_HOURS_RANGE=3-22
 
#period in days   delay in minutes   job-identifier   command
1    5    cron.daily        nice run-parts /etc/cron.daily
7    25    cron.weekly        nice run-parts /etc/cron.weekly
@monthly 45    cron.monthly        nice run-parts /etc/cron.monthly
 
```

 Vous pouvez voir que le cron.daily s'exécute, lorsque le système est allumé à 3h du matin avec une marge aléatoire de 45 minutes.  
 On peut le vérifier avec un :  

Code BASH :

```
journalctl -u crond --grep cron.daily
```

Code TEXT :

```
juin 27 03:01:00 superlinux anacron[477612]: Will run job `cron.daily' in 43 min.
juin 27 03:44:00 superlinux anacron[477612]: Job `cron.daily' started
juin 27 03:44:00 superlinux anacron[477612]: Job `cron.daily' terminated
juin 28 03:01:00 superlinux anacron[586135]: Will run job `cron.daily' in 37 min.
juin 28 03:38:00 superlinux anacron[586135]: Job `cron.daily' started
juin 28 03:38:00 superlinux anacron[586135]: Job `cron.daily' terminated
-- Boot 1a1df73277034f89a596593feecc61b1 --
juin 29 08:01:00 superlinux anacron[49972]: Will run job `cron.daily' in 17 min.
```

 A noter : les tâches journalières, si elles ont été "ratées" se déroulent dès que le système s'allume (avec cette même durée aléatoire).  

Changement d'heure et tâches loupées
----------

 Lors des changements d’heure, cron peut avoir un comportement “surprenant” autour des heures qui sont modifiées.  

 Au printemps, lors du passage de 2h à 3h (heure qui avance), les tâches prévues pour une heure qui “n’existe pas” (par exemple 2h30) ne sont tout simplement pas exécutées.  
 À l’inverse, à l'automne, lors du passage de 3h à 2h (heure qui recule), les heures “reviennent”, si bien qu’une tâche planifiée pour 2h30 sera exécutée deux fois, une fois pour chaque occurrence de cette heure.  

 A noter que contrairement aux cron.daily vus précédemment, si la machine est éteinte au moment où une exécution planifiée devrait se produire, cron ne “rattrape” pas automatiquement : la tâche n’est pas exécutée.  

Envoi de mail
----------

 Par défaut, cron envoie un message à l'utilisateur qui a planifié sa tâche.  

 Pour ne pas envoyer de façon automatique ce message à l'utilisateur (ou [utilisateur@domaine.ext](mailto:utilisateur@domaine.ext) si un agent tel que postfix a été configuré) il faut indiquer sur la première ligne du **crontab -e**  

Code BASH :

```
MAILTO=""
```