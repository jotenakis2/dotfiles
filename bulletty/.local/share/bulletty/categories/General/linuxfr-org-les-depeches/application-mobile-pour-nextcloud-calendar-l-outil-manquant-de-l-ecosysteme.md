+++
title = "Application mobile pour Nextcloud Calendar, l'outil manquant de l'écosystème"
description = "Ceux qui recherchent une alternative européenne et auto-hébergeable aux deux leaders mondiaux des suites bureautiques, Google Workspace et Microsoft 365, connaissent très certainement Nextcloud.![Illustration de Nextcloud Calendar](https://img.linuxfr.org/img/68747470733a2f2f706c"
date = "2026-08-05T16:51:24Z"
url = "https://linuxfr.org/news/application-mobile-pour-nextcloud-calendar-l-outil-manquant-de-l-ecosysteme"
author = "killian.larcher"
text = ""
lastupdated = "2026-08-13T22:13:29.415924370Z"
seen = false
+++

Ceux qui recherchent une alternative européenne et auto-hébergeable aux deux leaders mondiaux des suites bureautiques, Google Workspace et Microsoft 365, connaissent très certainement Nextcloud.

![Illustration de Nextcloud Calendar](https://img.linuxfr.org/img/68747470733a2f2f706c61792d6c682e676f6f676c6575736572636f6e74656e742e636f6d2f56697352735431794c504276636755584171482d316a674259384341474f314c5556394b76436970303865332d5653632d764c574d563665336e6a79505f6f5831786a7762724958656d3462796643374e4673753d773833322d683437302d7277/VisRsT1yLPBvcgUXAqH-1jgBY8CAGO1LUV9KvCip08e3-VSc-vLWMV6e3njyP_oX1xjwbrIXem4byfC7NFsu=w832-h470-rw "Source : https://play-lh.googleusercontent.com/VisRsT1yLPBvcgUXAqH-1jgBY8CAGO1LUV9KvCip08e3-VSc-vLWMV6e3njyP_oX1xjwbrIXem4byfC7NFsu=w832-h470-rw")

* lien nᵒ 1 : [App Store](https://linuxfr.org/redirect/117914)
* lien nᵒ 2 : [Play Store](https://linuxfr.org/redirect/117915)
* lien nᵒ 3 : [Dépôt GitHub](https://linuxfr.org/redirect/117916)

Sommaire
----------

* [Qu’est-ce que Nextcloud ?](#toc-quest-ce-que-nextcloud)
* [Pourquoi une application de calendrier ?](#toc-pourquoi-une-application-de-calendrier)
* [La création d’une première version en quelques semaines](#toc-la-création-dune-première-version-en-quelques-semaines)
* [Un succès inattendu](#toc-un-succès-inattendu)
* [Et maintenant ?](#toc-et-maintenant)

Qu’est-ce que Nextcloud ?
----------

Nextcloud est un dérivé d'ownCloud, lancé en 2016 par l'Allemand Frank Karlitschek, lui-même créateur d'ownCloud. D'abord centré sur la gestion de documents, l'écosystème s'est peu à peu étendu pour intégrer tous les modules bureautiques : e-mail, visioconférence, messagerie instantanée, etc.

Dix ans plus tard, **Nextcloud est l'un des leaders open source des suites bureautiques**, collabore avec d'autres acteurs majeurs européens comme IONOS Cloud ou OpenProject, et s'engage à investir 250 millions d'euros d'ici 2030 dans la souveraineté numérique.

Un beau parcours qui a commencé, comme beaucoup, par un simple commit.

Nextcloud doit donc fournir des alternatives crédibles à des outils comme Google Drive, Microsoft Teams, Google Meet ou SharePoint. Pour cela, il lui faut un écosystème extrêmement complet, doublé d'une expérience d'usage très qualitative, afin de faciliter et d'accélérer l'adoption auprès des publics non techniques, qui constituent en réalité la majorité du public visé.

Pourquoi une application de calendrier ?
----------

Contrairement à Google avec Google Agenda ou à Microsoft avec Outlook et Teams, Nextcloud ne propose pas d'application mobile dédiée à son calendrier.

Vous me direz d'abord : « C'est inutile, il suffit d'utiliser la web app. » Oui, mais non.

Imaginez un commercial en déplacement : il doit consulter son agenda, créer un rendez-vous avec un prospect et envoyer une invitation, parfois avec une connexion réseau très limitée. Dans cette situation, une application mobile, accessible en un clic et capable de fonctionner hors ligne, fait la différence.

Vous me direz ensuite : « C'est inutile, il suffit de connecter son calendrier à une application existante avec un lien CalDAV. » Encore une fois, oui, mais non.

Une application générique peut synchroniser les événements, mais elle ne sait pas créer un lien de visioconférence Nextcloud Talk, ni intégrer les fonctionnalités spécifiques de la plateforme (comme la récupération des contacts par exemple). C’est exactement ce qui fait la force des applications de Google et Microsoft : chaque brique est conçue pour fonctionner avec les autres.

Et c’est ce manque que nous avons voulu combler.

La création d’une première version en quelques semaines
----------

Sur un coup de tête et un peu au hasard, nous avons réalisé un premier prototype.

La **technologie multiplateforme React Native** a été choisie dans cette optique : aller vite pour tester la faisabilité. Si l'application n'avait jamais été créée auparavant, c'était peut-être qu'il existait un verrou technique que nous n'avions pas identifié.

Nous avons créé une première version fonctionnelle et très basique en quelques jours en nous appuyant sur l'API de Nextcloud, puis nous avons amélioré l'expérience et ajouté quelques fonctionnalités (afficher ou masquer un agenda, créer un nouvel événement, ajouter des participants).

Après des tests rapides en cas réel sur Android et iOS, nous avons créé les fiches App Store et Play Store, puis publié. Trois jours plus tard, les applications étaient disponibles pour le grand public.

Un succès inattendu
----------

L'application a été **publiée sur les magasins d'applications (App Store et Play Store) en avril 2026**.

Trois semaines plus tard, avec un article Reddit comme seul moyen de communication, l’application avait déjà atteint 3.500 téléchargements.

Une heureuse surprise, mais qui allait demander du travail !

L'application était avant tout destinée aux besoins internes de notre entreprise et n'avait pas été pensée pour une telle adoption.

Il a fallu transformer ce prototype réalisé rapidement en un produit capable de répondre aux besoins de milliers de personnes tout en respectant les standards de l'open source :

* structurer une vision moyen-terme et créer une feuille de route publique
* récolter et répondre aux retours des utilisateurs (GitHub, App Store, Play Store)
* publier un APK à chaque version pour ceux qui n’ont pas accès au Play Store
* renforcer les performances et l’expérience utilisateur sur tous supports (notamment sur la navigation dans le calendrier et la gestion des données)

Et maintenant ?
----------

Avec environ **15.000 téléchargements à fin juillet 2026**, l'application est utilisée au quotidien par des milliers d'utilisateurs et dispose déjà des fonctionnalités principales :

* Visualisation des agendas personnels et partagés dans différentes vues (jour, semaine, mois, etc.)
* Édition des événements avec ajout d’un lien de visioconférence, d’un lieu et de participants
* Notifications configurables pour les rappels avant un événement
* Traductions en 8 langues : français, anglais, allemand, espagnol, italien, portugais, néerlandais et russe
* Support de plusieurs comptes connectés simultanément (par exemple, pour les ceux utilisant Nextcloud à titre pro et perso)
* Widgets (iOS et Android) pour visualiser rapidement les événements à venir

Nous avons pu échanger récemment avec les équipes techniques de Nextcloud afin de confronter notre produit à leur expérience de l'écosystème, aux bonnes pratiques et aux attentes des utilisateurs.

Leurs retours nous ont permis de repenser notre feuille de route, qui sera mise à jour en conséquence dans les semaines à venir.

En attendant, pour celles et ceux qui disposent d'une instance Nextcloud et qui souhaitent télécharger l'application :

* App Store : [https://apps.apple.com/fr/app/nextcloud-calendar/id6766678698](https://apps.apple.com/fr/app/nextcloud-calendar/id6766678698)
* Play Store : [https://play.google.com/store/apps/details?id=com.soluce.nextcloudcalendar](https://play.google.com/store/apps/details?id=com.soluce.nextcloudcalendar)
* F-Droid : à venir très prochainement

Et pour les plus motivés qui voudraient contribuer (ou simplement étudier le code source), voici le lien du dépôt GitHub :  
[https://github.com/SoluceTechnologies/nextcloud-calendar-mobile](https://github.com/SoluceTechnologies/nextcloud-calendar-mobile)

N. D. M. : GPLv3

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/application-mobile-pour-nextcloud-calendar-l-outil-manquant-de-l-ecosysteme.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144833/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/application-mobile-pour-nextcloud-calendar-l-outil-manquant-de-l-ecosysteme#comments)