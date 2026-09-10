+++
title = "Radinus : tenir sa comptabilité personnelle sous Linux"
description = "Radinus écran principalIl existe deux façons de savoir combien il reste sur son compte : "
date = "2026-08-15T07:13:06Z"
url = "https://linuxfr.org/news/radinus-tenir-sa-comptabilite-personnelle-sous-linux"
author = "Fab2bprog"
text = ""
lastupdated = "2026-08-15T16:25:52.277841876Z"
seen = false
+++

![Radinus écran principal](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f71765051463555652f396a574a545134372e77656270/9jWJTQ47.webp "Source : https://pic.infini.fr/qvPQF5Ue/9jWJTQ47.webp")

Il existe deux façons de savoir combien il reste sur son compte : ouvrir vingt-six onglets de son tableur préféré, ou confier ses relevés à une application qui les enverra gentiment sur un serveur inconnu en échange d'un abonnement mensuel. Radinus propose une troisième voie, nettement moins tendance : un logiciel qui tourne sur votre machine, garde vos données sur votre disque, ne parle à personne, et ne vous demande rien. Libre sous GPL v3, écrit en Rust avec [Tauri](https://fr.wikipedia.org/wiki/Tauri_(environnement_de_développement)), disponible pour Linux, et gratuit — les deux à la fois, ce qui mérite qu'on s'y arrête.

**NdM:** il s'agit d'une réécriture d'une [précédente version 1.9.3 en WinDev sous MIT](https://github.com/Fab2bprog/Windev-Radinus/issues). Le README dit « le dépôt est actuellement privé et sous la seule direction de [son](sic) auteur » : on supposera qu'il ne s'agit pas d'accès privé ici sinon on ne verrait pas le code, mais juste du fait que l'auteur souhaite être en charge de tous les commits. Par contre la partie « sole direction of its (sic) author\_ », tout en ayant une traduction en 18 langues, des commits non informatifs du type « maj1 » à « maj9 », etc. il est clair qu'il y a écriture ou assistance par une IA. Ainsi que pour le site du projet. Le projet initial date de juillet 2024 d'après le premier commit, et comme la date d'un commit n'est pas fiable, on peut vérifier le [site du projet à la même époque](https://web.archive.org/web/20240813192437/https://www.radinus.fr/) via Archive.org (et l'[absence du dépôt auparavant](https://web.archive.org/web/20221129195828/https://github.com/Fab2bprog)). Vous pourriez aussi trouver intéressantes les dépêches [Logiciels libres pour la comptabilité d'entreprise](//linuxfr.org/news/logiciels-libres-pour-la-comptabilite-d-entreprise) (2025) et [Logiciels libres de finances personnelles](//linuxfr.org/news/logiciels-libres-de-finances-personnelles) (2023).

* lien nᵒ 1 : [Radinus](https://linuxfr.org/redirect/117983)
* lien nᵒ 2 : [Code source Radinus](https://linuxfr.org/redirect/117984)

**Ce qu'il fait**

Plusieurs comptes bancaires, la saisie des opérations, le pointage et le rapprochement de vos relevés, l'importation des fichiers que votre banque met à disposition (OFX, CSV, tableurs), les chèques, les opérations périodiques, un budget annuel et son contrôle, six statistiques croisées, un tableau de bord et la courbe de vos soldes.

De la comptabilité domestique, faite sérieusement. Son nom vient de « radin » et sa mascotte est un écureuil en costume : le positionnement est assumé.

**Libre et totalement, absolument gratuit !**

Deux mots distincts, et ici les deux sont vrais.

Libre : GPL v3 ou ultérieure, sources publiques. La licence a été choisie pour que personne, pas même l'auteur, ne puisse refermer la porte plus tard.

Gratuit : pas de version amputée, pas de fonction réservée aux donateurs, pas d'abonnement, pas de compte, pas de courriel à laisser.

Et la liste de ce qu'il ne fait pas, qui vaut bien la première : aucune connexion à votre banque, aucune télémétrie, aucune publicité, aucune synchronisation. Le réseau ne sert qu'à une chose, ouvrir le site si vous cliquez dessus. Vos opérations vivent dans un fichier SQLite sur votre disque.

**Sous le capot**

Cœur métier et contrôleur en Rust, interface en HTML/CSS/TypeScript servie par Tauri v2. Tauri s'appuie sur WebKitGTK, le moteur déjà présent sur votre système, au lieu d'embarquer un navigateur complet : un binaire natif, pas de runtime à déployer, pas de Chromium par application.

Stockage SQLite en fichier unique, que vous pouvez copier et lire avec vos propres outils. Sauvegarde en zip avec un JSON par table. Chiffrement de la base par mot de passe si vous le souhaitez.

**Pour Linux**

Ubuntu 22.04, Debian 12, Fedora 36 ou plus récent.   
 Disponible en 18 langues (français, anglais, italien, espagnol, allemand…).

Bonne comptabilité personnelle , et pensez à pointer vos relevés.

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/radinus-tenir-sa-comptabilite-personnelle-sous-linux.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/145142/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/radinus-tenir-sa-comptabilite-personnelle-sous-linux#comments)