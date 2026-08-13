+++
title = "Mageia 10 : le manchot sort du chaudron !"
description = "La nouvelle mouture de la distribution Linux communautaire Mageia est disponible : la version 10 fait sortir le manchot du chaudron ! Les personnes connaissant la distribution comprendront l’allusion ;-) Cauldron — le chaudron — étant la "
date = "2026-07-01T16:13:10Z"
url = "https://linuxfr.org/news/mageia-10-le-manchot-sort-du-chaudron"
author = "BAud"
text = ""
lastupdated = "2026-07-03T22:38:39.843557904Z"
seen = true
+++

La nouvelle mouture de la distribution Linux communautaire Mageia est disponible : la version 10 fait sortir le manchot du chaudron ! Les personnes connaissant la distribution comprendront l’allusion ;-) [Cauldron](https://wiki.mageia.org/en/Cauldron-fr) — le chaudron — étant la version de développement, il est naturel d’en obtenir une version installable stabilisée périodiquement.

À vos téléchargements pour utiliser cette nouvelle mouture.

* lien nᵒ 1 : [Site web officiel de Mageia](https://linuxfr.org/redirect/117442)
* lien nᵒ 2 : [Télécharger Mageia 10](https://linuxfr.org/redirect/117443)
* lien nᵒ 3 : [Notes de version de Mageia 10](https://linuxfr.org/redirect/117444)
* lien nᵒ 4 : [Soutien de nos amis de MageiaLinux-online](https://linuxfr.org/redirect/117445)
* lien nᵒ 5 : [Annonce de la sortie de Mageia 10](https://linuxfr.org/redirect/117788)

Cette version 10 de Mageia marque les 16 ans du lancement de la distribution (septembre 2010), elle s’inscrit dans la continuité de Mageia 9 qui nous a accompagnés et a évolué depuis plus de 2 ans et ½ ;-)

Versions disponibles
----------

Mageia 10 est classiquement proposée à l’installation avec différents choix :

* image *ISO Live* avec Plasma/KDE, GNOME seulement en x86\_64, XFCE en x86\_64 et i686 ;
* image de DVD/clé USB d’installation (plus) complète en x86\_64 et i686 avec choix du bureau ou serveur ;
* image d’installation réseau en x86\_64 et i686, permettant une installation minimaliste ou plus complète avec les méta-paquets `task-` (plasma, gnome, lxqt, lamp-php, edu, astronomy…).

Nouveautés
----------

Mises à jour des environnements de bureau

* Plasma KDE 6.5.5
* GNOME 49
* XFCE 4.20
* ainsi que Cinnamon, Enlightenment, LXDE, LxQt, MATE et quelques *window managers* FVWM (2 & 3), swm, twm, WindowMaker, xfwm… ainsi que quelques compositeurs Wayland comme hyprland, sway…

Au niveau des logiciels, GIMP 3.2.4 (GIMP 2.10 n’est plus disponible, mais à qui va-t-il manquer ?), FreeCAD 1.1.1, Inkscape 1.4.4, Mathmod 13.0…

![Nouvelle apparence pour Mageia 10](https://img.linuxfr.org/img/68747470733a2f2f626c6f672e6d61676569612e6f72672f66722f77702d636f6e74656e742f75706c6f6164732f323032362f30362f696d6167652d322e706e67/image-2.png "Source : https://blog.mageia.org/fr/wp-content/uploads/2026/06/image-2.png")

Points marquants
----------

Mageia 10 est sans doute la dernière version à proposer Plasma 6.5.5 et GNOME 49 pour X11. En effet, la version suivante GNOME 50 sortie récemment commence les travaux de suppression de la prise en charge de X.org : c’est Wayland qui est désormais standard. Ceci explique certainement le fait que Mageia fait le choix de ne pas passer vers Gnome 50.

Concernant l’architecture 32 bits, ses jours^W mois sont sans doute comptés aussi : c’est i686 qui est encore proposé à l’installation (et non plus i586). Dommage pour les EeePC avec les processeurs Intel Atom N270 (déjà que la résolution d’écran de 1024x600 n’aidait pas trop :/). Pour les jeux, Wine 11.0 est fourni avec Wine-Wow64, permettant de bénéficier de meilleures performances et de faire fonctionner des applications et jeux 32 bits sans paquets dédiés 32 bits, ce qui évite d’avoir à activer les dépôts 32 bits sur une distribution x86\_64.

Lors du cycle de publication de Mageia 10, des failles critiques du noyau Linux ont été prises en compte : CopyFail (CVE-2026-31431) par fourniture du noyau 6.18.22 et suivants incluant les correctifs, puis DirtyFrag (CVE-2026-46300, mise à jour noyau), puis Fragnesia (CVE-2026-46300), puis vulnérabilité dans *ptrace* (CVE-2026-46333, mise à jour noyau 6.18.30 avec patch pour *get\_dumpable* dans *ptrace*, le noyau 6.18.31 incluant déjà le patch). Les mises à jour correspondantes pour le noyau 6.6.x LTS de Mageia 9 ont aussi été proposées, elles sont [tracées dans les *advisories* Mageia MGASA-](https://advisories.mageia.org/) lorsque suivies par l’équipe sécurité et dans le *changelog* du noyau (`urpmq - i --changelog kernel-desktop-latest`) lorsqu’un patch est spécifiquement appliqué (sinon voir le changelog de la version officielle du noyau).

Montées de versions successives de Firefox 140.6 à 140.11 LTS : consommation mémoire améliorée ?

Le paquet [chromium-browser-stable 136](https://madb.mageialinux-online.org/show?rpm=chromium-browser-stable&distribution=9&architecture=x86_64) a été le dernier fourni en Mageia 9 et a dû être abandonné par manque de mainteneur pour Mageia 10 : l’installation peut être effectuée via flatpak ou [passer au paquet RPM de Chrome disponible chez Google](https://wiki.mageia.org/en/Installing_Google_Chrome_in_Mageia). Si un nouveau mainteneur se manifeste, il pourrait redevenir disponible pour Mageia 10 via les *updates*, [avis aux personnes motivées à devenir empaqueteur](https://wiki.mageia.org/en/Packagers_Team_portal) \_o/ (même si ce n’est clairement pas le paquet le plus simple pour commencer).

En contrepartie, des navigateurs pour le [protocole Gemini](https://fr.wikipedia.org/wiki/Gemini_(protocole)) ont été ajoutés : Lagrange (SDL), Kristall (Qt), Offpunk (CLI).

Jeux et autres logiciels (liste non exhaustive)
----------

[0ad 0.28](https://play0ad.com/new-release-0-a-d-release-28-boiorix/) a été actualisé à la version « Bolorix ».

[Flightgear en version 2024.1.5](https://www.mageialinux-online.org/forum/topic-18336-586-flightgear-sous-linux-mageia.php) un simulateur de vol ayant ses fans sur MLO (plus de 586 pages dans le fil du forum jeux).

[Rocks 'n Diamonds](https://www.artsoft.org/rocksndiamonds/) est en version 4.4.1.2 (et a plus de 30 ans !)

[Audacity](https://www.audacityteam.org) en version 3.7.7 — la 3.7.8 étant sortie après la rc1, à voir si elle fera son chemin dans les *updates* — pour profiter des greffons Tempo tracks, [LADSPA](https://fr.wikipedia.org/wiki/LADSPA), et analyseur Vamp tant qu’ils sont encore disponibles.

[FreeCAD 1.1.1](https://wiki.freecad.org/Release_notes_1.1) pour la modélisation 3D en [fablab](//linuxfr.org/wiki/fablab) intégré lors du cycle de bêta de Mageia 10 (Mars 2026) sera la dernière suivant cette numérotation, [le choix du passage à CalVer étant entériné](https://github.com/FreeCAD/FreeCAD-Enhancement-Proposals/blob/master/FEPs/FEP-0003-release-schedule/README.md)

Inkscape 1.4.4 pour avoir une version de maintenance de la branche 1.4.x à jour apportant moins de plantages et plus de performances.

[LibreOffice 26.2.3.2](https://wiki.documentfoundation.org/ReleaseNotes/26.2/fr) la suite de bureau, à voir si la prochaine version à venir [26.8](https://wiki.documentfoundation.org/ReleaseNotes/26.8/fr) sera ajoutée dans les *updates* pour la rentrée des classes ;-)

Les paquets pour le serveur et le client [Nextcloud en version 32](https://madb.mageialinux-online.org/show?distribution=cauldron&architecture=x86_64&rpm=nextcloud&repo=&group=&page=) font leur retour avec Mageia 10.

Communauté et contributions
----------

Présent avec un stand à Capitole du libre en novembre 2025, au PSL XXL et visite à l’OSXP en décembre 2025, JDLL fin mai 2026.

Nos amis de [MageiaLinux-Online (MLO)](https://www.mageialinux-online.org/) sont toujours de la partie \_o/ Tutoriels et forums en français vous accueillent. Rendez-vous à la rentrée pour install'parties et événements du Libre ;-)

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/mageia-10-le-manchot-sort-du-chaudron.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/143124/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/mageia-10-le-manchot-sort-du-chaudron#comments)