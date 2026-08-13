+++
title = "Les raccourcis, du 3270 à AutoHotKey en passant par Clavier+"
description = "Je travaille depuis plus de vingt ans sur site central (mainframe), et ça fait quasiment autant de temps que ma marotte, c'est me faciliter la vie au travail en automatisant le plus possible les actions répétitives.Vous me direz"
date = "2026-06-28T09:56:01Z"
url = "https://linuxfr.org/news/les-raccourcis-du-3270-a-autohotkey-en-passant-par-clavier"
author = "PhRæD"
text = ""
lastupdated = "2026-07-03T22:38:39.851154564Z"
seen = true
+++

Je travaille depuis plus de vingt ans sur site central ([mainframe](https://fr.wikipedia.org/wiki/Ordinateur_central)), et ça fait quasiment autant de temps que ma marotte, c'est me faciliter la vie au travail en automatisant le plus possible les actions répétitives.

Vous me direz rien de bien nouveau, c'est l'essence même de l'informatique…

Certes, mais je me rends compte qu'il existe tout un univers plutôt confidentiel à mon sens qui gravite autour l'aménagement de ses propres raccourcis clavier.

* lien nᵒ 1 : [Site officiel de Clavier+](https://linuxfr.org/redirect/117760)
* lien nᵒ 2 : [Site officiel de AutoHotKey](https://linuxfr.org/redirect/117761)

Sommaire
----------

* [Un peu d'historique](#toc-un-peu-dhistorique)
  * [Problème de place](#toc-problème-de-place)
  * [Le pad](#toc-le-pad)
  * [Le cas Pacbase](#toc-le-cas-pacbase)
  * [L'invite de commande « universelle »](#toc-linvite-de-commande-universelle)

* [Les logiciels de raccourcis sous Windows](#toc-les-logiciels-de-raccourcis-sous-windows)
  * [Clavier+](#toc-clavier)
  * [AutoHotKey](#toc-autohotkey)
  * [Fonctionnalités communes](#toc-fonctionnalités-communes)
  * [Ce qu'apporte AHK](#toc-ce-quapporte-ahk)

* [En résumé](#toc-en-résumé)
* [PS](#toc-ps)
  * [Quelque raccourcis que j'utilise tout le temps](#toc-quelque-raccourcis-que-jutilise-tout-le-temps)
  * [Tip](#toc-tip)

Un peu d'historique
----------

Comme déjà écrit, je travaille sur site central, et pendant longtemps, ça voulait dire utiliser un émulateur 3270 (même si ça sert encore beaucoup pour les tâches d'administration, Eclipse et VSCode sont de plus en plus présents, notamment pour développer). C'est un logiciel qui simule un terminal passif (qui se contente d'afficher un écran, et de réagir au clavier, point barre - mais qui dispose du 24 touches fonction physiques), et qui dispose de fonctionnalités « modernes », tel le copier-coller (oui, oui, point de copier-coller sur terminal passif).  
 Ce qu'il y a de chouette avec un émulateur, et ça rejoint (enfin) le sujet de cette dépêche, c'est que ça permet de lancer des séquences de frappes de touche.

![Menu principal d'ISPF](https://img.linuxfr.org/img/68747470733a2f2f68756e74657273747261696e696e676173736f6369617465732e636f6d2f696d616765732f69737066315f32352e676966/ispf1_25.gif "Source : https://hunterstrainingassociates.com/images/ispf1_25.gif")

Prenons comme exemple l'affichage d'une table de paramétrage, pour afficher le contenu d'une table il faut :

* Appuyer sur la touche ECHAP (qui efface l'écran)
* Taper X RCD071
* Valider avec Enter
* Saisir le nom de la table de paramétrage
* Interroger son contenu avec PF3

L'émulateur permet de lancer des séquence de touches de plusieurs manières :

* à l'aide d'un raccourci clavier ;
* à l'aide d'un pad, ensemble paramétrables de boutons auxquels on peut associer des actions, dont une séquence de frappes de touche. C'est là que ça commence à devenir intéressant, je vais y revenir.

En reprenant l'exemple du listage d'une table de paramétrage, je peux facilement associer le listage de la table1 à un raccourci, et celui de la table2 à un autre.

### Problème de place ###

Et c'est là qu'on s'aperçoit vite des limites des raccourcis claviers : leur nombre est forcément limité, d'autant plus que bon nombre de combinaisons sont déjà prises : il est illusoire de vouloir se passer de CTRl+C et de CTRL+V par exemple.  
 L'autre problème est celui de la mémoire, pas celle du PC, mais celle de celui ou celle qui est derrière le clavier : pas facile de mémoriser toutes ces combinaisons.

### Le pad ###

J'ai gardé pour maintenant cette histoire de pad : mais qu'est-ce que ça apporte ? Et bien ça « libère » de la mémoire : la vocation du raccourci est disponible sous les yeux, et ça, j'achète !

Moyennant un petit travail de classification en sous-groupes, je retrouve facilement tous mes raccourcis en un clin d'œil.  
 Mais n'avoir à disposition que des boutons, est-ce suffisant ?  
 Pas vraiment, parce que libellé d'un bouton, c'est statique.

### Le cas Pacbase ###

[PACbase](https://fr.slideshare.net/slideshow/pacbase-fundamentals/56314453) est un AGL (NdM: propriétaire) générant du COBOL, intégrant un dictionnaire de données. On y stocke :

* des données ;
* des structures de données ;
* des programmes ;
* des textes pour la documentation ;
* etc.

Ce qui est important pour le sujet que j'évoque que la navigation dans ce référentiel est entièrement textuelle, on accède aux entités au travers d'une ligne de commande :

* j'affiche la donnée toto en tapant E toto ;
* j'affiche la documentation de donnée toto en tapant e toto gc (ou si je suis déjà en train de consulter la donnée toto en tapant -gc) ;
* j'affiche un programme titi en tapant p titi, sa documentation en tapant p titi gc
* etc.

C'est là qu'on s'aperçoit de limite des boutons (même si c'est mieux que les raccourcis) : pas question de créer autant de boutons que d'entités à accéder.

### L'invite de commande « universelle » ###

Il se trouve que l'interface principale du site central (hors applications métiers) qui s'appelle [ISPF](https://fr.wikipedia.org/wiki/Interactive_System_Productivity_Facility) (NdM: propriétaire) est également textuelle est qu'elle possède également une ligne de commande.

J'ai donc cherché à mettre au point une interface dans laquelle je taperai mes commandes, qui seraient mémorisées et qui, à l'instar du comportement d'un terminal, faciliterait le rappel de commandes.

Au passage, j'ai écrit une macro « universelle » qui permet d'interagir de manière scriptée avec l'émulateur, en utilisant un pseudo langage très basique, mais permettant des actions reproductibles : saisie de paramétrage (permettant une « saisie » d'environnement en environnement), réinitialisation de mot de passe avec envoi de courriel avec les mots de passe provisoire, etc.

Je me suis appuyé sur différents modules proposés par l'émulateur 3270, avec comme limites l'univers site central. Or il se trouve que j'avais envie d'automatiser plein d'autres actions sur d'autres logiciels (comme lancer les règles dans Outlook par exemple).

Les logiciels de raccourcis sous Windows
----------

### Clavier+ ###

C'est alors que j'ai découvert :

* [Clavier+](https://gryder.org/software/clavier-plus/?lang=fr) (GPLv3), un logiciel libre qui a la bonne idée de pouvoir être lancé en ligne commande avec une documentation tout en français ;
* les pages HTA, qui sont des fenêtres écrites en HTML / Javascript / CSS.

![Clavier+](https://img.linuxfr.org/img/68747470733a2f2f6772796465722e6f72672f736f6674776172652f636c61766965722d706c75732f73637265656e73686f745f6d61696e5f46522e706e67/screenshot_main_FR.png "Source : https://gryder.org/software/clavier-plus/screenshot_main_FR.png")

J'écris mes pads en HTA, avec des liens qui lancent des actions via Clavier+. Et là, c'est quasi parfait : je paramètre Clavier+ pour lancer une fenêtre HTA quand je tape sur la touche PAUSE (facile d'accès et peu utilisée en standard) qui m'affiche des boutons d'actions et des invites de commandes, fenêtre qui se masque une fois l'action lancée et que je rappelle en rappuyant sur PAUSE. J'ai donc Clavier+ qui lance une fenêtre qui permet de lancer plein d'actions via Clavier+. Pas toujours facile de s'en sortir avec du Javascript pas toujours reconnu dans ses dernières fonctions pourtant bien pratique, et surtout, pas simple de gérer la persistance des données, même si je m'en suis sorti à l'aide de cookies.

### AutoHotKey ###

Je change d'entité dans le groupe qui m'emploie, et patatras, pas de Clavier+ dans le centre logiciel ! Je me lance dans une demande d'intégration de Clavier+, demande qui traîne, et voilà que je découvre que si Clavier+ n'est pas proposé, c'est qu'à sa place figure [AutoHotKey](https://www.autohotkey.com/) (GPLv2)  
![Exemple de GUI AHK](https://img.linuxfr.org/img/68747470733a2f2f692e696d6775722e636f6d2f737542497778682e706e67/suBIwxh.png "Source : https://i.imgur.com/suBIwxh.png")

\\o/ : apothéose : Autohotkey (AHK), c'est clavier+ puissance 1 000 ! Ça gère les raccourcis — heureusement —, mais aussi et surtout les interfaces graphiques, les fichiers, etc. C'est très puissant, mais la documentation — tout en anglais — est parfois un peu absconse (Clavier+ c'est juste génial à ce niveau).

### Fonctionnalités communes ###

* Activation d'une fenêtre par son titre
* Restriction de l'usage d'un raccourci à une fenêtre donnée (via son titre)
* des configurations séparables par fichiers

### Ce qu'apporte AHK ###

* les interfaces graphiques
* interaction avec le système de fichiers
* la superposition des configurations
* et beaucoup plus encore

En résumé
----------

Pour celles et ceux qui souhaitent découvrir comment facilement paramétrer des raccourcis claviers, Clavier+ et fait pour vous. Pour aller (beaucoup beaucoup) plus loin AutoHotKey ouvre tout un univers de possibilités.

PS
----------

### Quelque raccourcis que j'utilise tout le temps ###

* rappel des commandes passées (PACbase et ISPF)
* lancement des règles sous Outlook
* recherche des erreurs de compilation COBOL sous VScode
* configuration et tri des SYSOUT sous SDSF

### Tip ###

Ne pas rager pas si votre tout dernier raccourci ne fonctionne pas avec Clavier+ : vous avez certainement laissé la fenêtre de configuration ouverte…

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/les-raccourcis-du-3270-a-autohotkey-en-passant-par-clavier.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144375/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/les-raccourcis-du-3270-a-autohotkey-en-passant-par-clavier#comments)