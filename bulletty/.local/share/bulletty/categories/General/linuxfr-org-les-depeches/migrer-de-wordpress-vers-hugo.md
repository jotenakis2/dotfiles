+++
title = "Migrer de WordPress vers Hugo"
description = "Passer du système de gestion de contenu WordPress au générateur de sites statiques Hugo c’est changer de paradigme, il faut savoir ce que l’on va gagner et ce que l’on va perdre et il faut retrousser ses manches, un jour viendra où cela se fera en un clic, mais ce n’est pas aujou"
date = "2026-06-23T05:12:48Z"
url = "https://linuxfr.org/news/migrer-de-wordpress-vers-hugo"
author = "philippe lhardy"
text = ""
lastupdated = "2026-07-03T22:38:39.865973447Z"
seen = true
+++

Passer du système de gestion de contenu WordPress au générateur de sites statiques Hugo c’est changer de paradigme, il faut savoir ce que l’on va gagner et ce que l’on va perdre et il faut retrousser ses manches, un jour viendra où cela se fera en un clic, mais ce n’est pas aujourd’hui !

* lien nᵒ 1 : [l'original (ou le clone ?) de ce billet](https://linuxfr.org/redirect/117707)

Sommaire
----------

* [Avant même de se poser la question comment, on peut se poser la question : pourquoi ?](#toc-avant-même-de-se-poser-la-question-comment-on-peut-se-poser-la-question--pourquoi)
  * [Mais pourquoi Hugo et pas une autre solution, par exemple Jekyll ?](#toc-mais-pourquoi-hugo-et-pas-une-autre-solution-par-exemple-jekyll)

* [Ma vie, mon œuvre](#toc-ma-vie-mon-œuvre)
* [WordPress via le navigateur, Hugo via le terminal](#toc-wordpress-via-le-navigateur-hugo-via-le-terminal)
* [On installe le plugin, clic ! On importe le résultat et c’est fini !](#toc-on-installe-le-plugin-clic-on-importe-le-résultat-et-cest-fini)
* [Exportez votre site WordPress et appliquez un outil magique !](#toc-exportez-votre-site-wordpress-et-appliquez-un-outil-magique)
* [La vérité est ailleurs ?](#toc-la-vérité-est-ailleurs)
* [On installe Hugo](#toc-on-installe-hugo)
* [C’est pas beau hein ?](#toc-cest-pas-beau-hein)
  * [Les blocs réutilisables de WordPress](#toc-les-blocs-réutilisables-de-wordpress)
  * [Les `<figure>`](#toc-les-figure)
  * [URL permanentes](#toc-url-permanentes)
  * [URL relatives](#toc-url-relatives)
  * [Le menu](#toc-le-menu)

* [Un site WordPress c’est un site web comme un autre](#toc-un-site-wordpress-cest-un-site-web-comme-un-autre)
* [On repart de zéro et on mélange tout](#toc-on-repart-de-zéro-et-on-mélange-tout)
  * [Variations mais pas sur le même thème](#toc-variations-mais-pas-sur-le-même-thème)

Avant même de se poser la question comment, on peut se poser la question : pourquoi ?
----------

Avec [WordPress](https://wordpress.org/about/) chaque page repose sur du [PHP](https://www.php.net/), un programme est exécuté qui peut faire de nombreuses actions, il y a une base de données. WordPress est un des classiques LAMP (Linux, Apache, MySql, PHP) et consorts, il nécessite l’installation de multiples composants. Quand le contenu à délivrer doit s’adapter au contexte utilisateur et à d’autres facteurs, c’est approprié, pour un site de commerce ça l’est, s’il s’agit d’une vitrine statique, ça ne l’est pas. Entre les deux on trouve le blog, qui peut se balancer d’un côté ou de l’autre si l’on souhaite gérer des accès utilisateurs, suivre les pages ou ajouter des interactions.

Avec [Hugo](https://gohugo.io/), le site est généré une seule fois puis les pages sont délivrées, à l’ancienne dirait-on. À la grande époque où l’on éditait le HTML à la main et on publiait son site via FTP. Sauf qu’avec Hugo on manipule du Markdown plutôt que du HTML. Le Markdown est pratique, c’est l’héritage pragmatique d’Aaron Schwartz dont on peut encore trouver la trace dans le code PHP de génération. Le Markdown lui-même porte une étincelle de liberté, il est désormais normalisé dans la [RFC 7763](https://datatracker.ietf.org/doc/html/rfc7763). Et on utilise le programme Hugo qui est un binaire fourni, ou bien compilé depuis du code Go, pour générer des pages HTML. Le site généré peut être délivré en http par Hugo ou bien par n’importe quel serveur web. Hugo repose aussi sur des en-têtes front-matter dans les fichiers Markdown qui est une extension plus récente.

Sortir de WordPress c’est sortir d’une zone de confort et ce sera nécessairement perdre des fonctionnalités, comme l’édition en ligne directe intégrée par exemple, le suivi de vues et les formulaires.

C’est aussi faire un choix simplificateur, économe et efficace. Beaucoup moins énergivore il est aussi beaucoup plus efficace et rapide. Il est aussi beaucoup plus facile à déployer qu’un WordPress puisqu’en définitive ce n’est qu’un binaire et un thème.  
 Une autre bonne raison de migrer est la sécurité, comme a pu le faire le projet Xubuntu à la fin de l’année dernière suite à la [compromission de leur site de téléchargement sous WordPress](https://xubuntu.org/news/2025/2025-11-20-public-postmortem-of-the-website-download-compromise/)

### Mais pourquoi Hugo et pas une autre solution, par exemple Jekyll ? ###

Hugo est la version la plus efficace, écrit en Go et compilé, les performances se rapprochent sans les égaler de celles de Rust ou de C. Et il est maintenu, dispose d’une communauté qui maintient des thèmes permettant de facilement avoir un rendu à la mode. Jekyll est en Ruby qui n’est pas le plus performant des langages mais est très versatile. Jekyll est apparu avant Hugo ce qui explique sa notoriété.

Ces deux logiciels ont popularisé la génération de sites statiques, mais ce ne sont pas les seuls, [eleventry par exemple a déjà été couvert par un journal sur LinuxFr.org](//linuxfr.org/users/outs/journaux/eleventy-presentation-et-mini-tutoriel).

Ma vie, mon œuvre
----------

Dans mon cas je ne me suis pas posé la question puisque je réponds à une demande d’une personne qui a déjà fait son choix, il faut migrer !

Avant de me lancer dans l’aventure j’ai dû me renseigner, parce que j’opère bien un site statique qui me sert de vitrine et celui-ci est en Markdown sous Git, mais tout est fait à la main et je ne connais pas Hugo. Je ne suis pas non plus un grand utilisateur de WordPress, que j’ai toujours trouvé lourd, et d’ailleurs j’ai toujours eu un faible pour les challengers, et je m’étais penché sur Joomla qui a les mêmes défauts. Utiliser ces CMS c’est déjà avoir appris une façon de penser, avec les pages et les posts, cela ne m’a jamais paru intuitif.

Donc j’étais absolument et résolument prêt pour cette migration !

Vous pouvez à ce moment me demander pourquoi donc l’ai-je fait ?

Parce qu’un ami me l’a demandé, parce qu’il rémunère pour cela et parce que je trouve que cela va dans le bon sens. Celui de l’éco-responsabilité, une sobriété qui ne transige pas avec la qualité et un mouvement vers plus d’indépendance.

Donc je me renseigne.

WordPress via le navigateur, Hugo via le terminal
----------

Si vous ne souhaitez pas utiliser de terminal et des scripts shells, alors je serais d’avis de vous déconseiller fortement de vous lancer dans l’aventure Hugo.  
 Parce qu’Hugo c’est du Web as code, très exactement l’inverse du [WYSIWYG](https://fr.wikipedia.org/wiki/What_you_see_is_what_you_get) le PETALE Pris à l’écrit tel à l’écran. Tout se fait en Markdown dans votre éditeur favori.  
 Cela s’opère souvent via Git et le fait de pousser le commit git vers le serveur régénère le contenu du site.  
 S’il est possible de le faire via un VSCodium, je reste sur mon Emacs favori, mais évidemment ceci un choix très personnel.  
 Un bon éditeur de texte capable de te laisser saisir des codes Markdown est absolument nécessaire, un éditeur de texte dans ce cas ce n’est pas un traitement de texte, Libreoffice par exemple ne m’apparait pas comme l’outil adapté, mais je vous laisse juge.

On installe le plugin, clic ! On importe le résultat et c’est fini !
----------

C’est assez évident en fait il suffit de suivre ce que propose le projet Hugo en matière de [migration vers Hugo](https://gohugo.io/tools/migrations/).

Ça c’est ce que l’on souhaite et j’y ai presque cru.

Il n’y a pas de plugin WordPress officiel pour exporter vers Hugo, mais il y en a pour exporter en Jekyll. Sachant que Hugo sait importer du Jekyll, cela semble évident.

Tout d’abord il faut importer le plugin sous WordPress.  
 Si cela semble évident quand le plugin est disponible dans le magasin des plugins WordPress, cela ne l’est plus quand il faut l’installer à la main.

Dans mon cas, et peut être dans le vôtre aussi vous n’avez pas installé le WordPress, il vous a été fourni en tant que service hébergé, et c’est pourquoi vous êtes limités aux plugins officiels, quand encore, on vous y autorise.

Donc en suivant le lien de [migration depuis WordPress](https://gohugo.io/tools/migrations/#wordpress) je lis (en anglais, mais je vous offre gratuitement la traduction) :

[wordpress-to-hugo-exporter](https://github.com/SchumacherFM/wordpress-to-hugo-exporter)

Un plugin en un clic qui convertit tous les posts, pages, taxonomies, metadata, et settings en Markdown et YAML et déposable dans Hugo. (Note: Si vous avez des difficultés avec ce plugin, vous pouvez exporter le site pour Jekyll et utiliser le convertisseur intégré à Hugo listé ci-dessus)

Oui mais non, je n’ai pas accès au backend.

Et pourquoi ne pas juste installer un plugin officiel comme celui dont wordpress-to-hugo-exporter dérive ? Le [jekyll-exporter](https://wordpress.org/plugins/jekyll-exporter/)

Ce n’est pas un échec, mais ça n’a pas marché.

Après l’installation du plugin et l’utilisation de l’export le site me réponds avec aplomb : 500 Internal ERROR.

Plutôt que d’abandonner, je cherche sur le projet source s’il y a un bug en cours et effectivement : [Issue #400 sur wordpress-static-site-exporter](https://github.com/benbalter/wordpress-static-site-exporter/issues/400). Sur ce, je rajoute mes informations sur le bug et j’attends une réponse.

Donc le ça fonctionne en un clic n’aura pas tenu bien longtemps, en attendant un correctif je me penche sur une alternative. Mais ne vous inquiétez pas, nous y reviendrons, si vous avez suivi le lien de l’issue vous le savez déjà !

Exportez votre site WordPress et appliquez un outil magique !
----------

Ce n’est pas bien grave, il y a d’autres outils…

[blog2md](https://github.com/palaniraja/blog2md)  
 Fonctionne sur l’XML exporté depuis le site gratuit votre VOTRE-DOMAIN.wordpress.com. Cela sauve aussi les commentaires approuvés sous forme YOUR-POST-NAME-comments.md à côté des posts.

Ce projet n’a pas évolué depuis quatre ans, je ne vais pas choisir cette option.

[wordhugopress](https://github.com/nantipov/wordhugopress)  
 Un petit utilitaire écrit en Java qui exporte le site WordPress depuis la base de donnée et les resources (c’est-à-dire par exemple les images) stockées localement ou à distance. Ainsi la migration depuis des backups est possible. Support de multiples sites vers un seul site Hugo.

Je n’ai pas accès à la base de données où à l’export des backups, je ne vais pas choisir cette option non plus.

[wp2hugo](https://github.com/ashishb/wp2hugo)

Celui-ci est un très bon candidat, sauf que je vends mon travail et la licence de cet outil est Attribution-NonCommercial-ShareAlike 4.0 International, donc je ne vais pas choisir cette option. Si mon budget avait été très important j’aurais envisagé de contacter l’auteur pour négocier, mais ce n’est pas le cas.

Donc aucun de ces autres outils ne répond à mes besoins.

La vérité est ailleurs ?
----------

Oui, mais il n’y a pas que site Hugo de référence non plus.

Les forums et en particulier [https://discourse.gohugo.io/t/wordpress-migration-url-rewriting/3827](https://discourse.gohugo.io/t/wordpress-migration-url-rewriting/3827), mais il a été écrit il y a presque dix ans…  
 Et dans mes pérégrinations hors des sentiers battus des scripts Python émergent [https://www.infinitescript.com/2024/01/migrate-from-wordpress-to-hugo/](https://www.infinitescript.com/2024/01/migrate-from-wordpress-to-hugo/).  
 Ce guide aussi m’a inspiré [https://fr.benchwiseunderflow.in/blog/guide-complet-migration-wordpress-hugo/](https://fr.benchwiseunderflow.in/blog/guide-complet-migration-wordpress-hugo/) ceci dit fournir les scripts Python dans son blog sans l’indentation, ce n’est pas ce qui se fait de mieux.

Voici la liste des projets que j’ai regardés, je n’en ai testé qu’une sous partie entre ceux utilisant de l’IA ou pour lesquelles mon utilisation ne respecterait pas la licence et celles dont le contenu semble trop vieux…

|                                                                             Site                                                                             |                                                                                                                          Commentaire                                                                                                                           |      langage       |                         html -\> markdown                          |                license                 |                            testé                             |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|--------------------------------------------------------------------|----------------------------------------|--------------------------------------------------------------|
|                    [https://github.com/benbalter/wordpress-to-jekyll-exporter](https://github.com/benbalter/wordpress-to-jekyll-exporter)                    |                                                                                             plugin officiel nécessite une migration supplémentaire jekyll -\> hugo                                                                                             |php wordpress plugin|                            Markdownify                             |                GPL-3.0                 |                              ✅                               |
|                   [https://github.com/SchumacherFM/wordpress-to-hugo-exporter](https://github.com/SchumacherFM/wordpress-to-hugo-exporter)                   |                                                                     basée sur une version du projet ci-dessus mais datant de 2014, a dérivé depuis. Ce n’est hélas pas un plugin officiel                                                                      |php wordpress plugin|                            Markdownify                             |            GPL-3.0-or-later            |                              ✅                               |
|                   [https://github.com/lonekorean/wordpress-export-to-markdown](https://github.com/lonekorean/wordpress-export-to-markdown)                   |                                                                                                 travailler sur l’export en XML it won’t migrate GUID correctly                                                                                                 | nodeJs javascript  |                              turndown                              |                   \-                   |                              ✅                               |
|                                       [https://github.com/bradfeld/wp-to-hugo](https://github.com/bradfeld/wp-to-hugo)                                       |                                                                                  plus complet mais : IA generated Claude / typescript via API strip WordPress block comments                                                                                   | nodeJs typescript  |                              turndown                              |          MIT License (& IA ?)          |                           Non : IA                           |
|                                           [https://github.com/ashishb/wp2hugo](https://github.com/ashishb/wp2hugo)                                           |                                                                                                    attachment page post wp\_navigation wp comments footnote                                                                                                    |         go         |[[site\_scrapping\_vers\_Hugo#johanneskaufmann\_html\_to\_markdown]]|Attribution-NonCommercial-ShareAlike 4.0|Non, licence non commerciale et c’est un travail commercialisé|
|[https://github.com/helgeklein/WordPress-Hugo-Migration-Scripts-HTML-Markdown/](https://github.com/helgeklein/WordPress-Hugo-Migration-Scripts-HTML-Markdown/)|                [https://helgeklein.com/blog/scripted-wordpress-html-to-hugo-markdown-migration/](https://helgeklein.com/blog/scripted-wordpress-html-to-hugo-markdown-migration/) post\_type in (“post”, “page”)… donc pas de gestion des blocks               |       python       |                           BeautifulSoup                            |                  MIT                   |                                                              |
|                                      [https://github.com/some-programs/exitwp](https://github.com/some-programs/exitwp)                                      | [https://web.archive.org/web/20221120194327/https://www.justindunham.net/migrating-from-wordpress-to-hugo/](https://web.archive.org/web/20221120194327/https://www.justindunham.net/migrating-from-wordpress-to-hugo/) 2019 ? page et post + item\_type\_filter|       python       |                      beautifulsoup html2text                       |              \~ GNU GPL 3              |                                                              |
|                                          [https://github.com/dreikanter/wp2md](https://github.com/dreikanter/wp2md)                                          |                                                                                issues [https://github.com/dreikanter/wp2md/issues](https://github.com/dreikanter/wp2md/issues)                                                                                 |       python       |                             html2text                              |                                        |                                                              |
|[https://fr.benchwiseunderflow.in/blog/guide-complet-migration-wordpress-hugo/](https://fr.benchwiseunderflow.in/blog/guide-complet-migration-wordpress-hugo/)|                                                                                status “publish” post\_type “post”, “page” le code fourni est à copier coller et non fonctionnel                                                                                |       python       |                               pandoc                               |                                        |                                                              |
|       [https://www.infinitescript.com/2024/01/migrate-from-wordpress-to-hugo/](https://www.infinitescript.com/2024/01/migrate-from-wordpress-to-hugo/)       |                                                                                                         post de blog contenant le code python utilisé                                                                                                          |       python       |                   re (regular expression python)                   |                                        |                                                              |
|                                        [https://github.com/palaniraja/blog2md](https://github.com/palaniraja/blog2md)                                        |                                                                                                    Le projet a 4 ans et part de blogger et non de WordPress                                                                                                    |     javascript     |                                 ?                                  |           absence de licence           |                          non testé                           |

C’est [wordpress-export-to-markdown](https://github.com/lonekorean/wordpress-export-to-markdown) qui a remporté une partie du travail. Cela a nécessité l’installation de node puisque le code est en javascript.

J’exporte donc le site via la fonction standard d’export de site WordPpress qui fourni un fichier XML.

Cet export contient tout sauf les images et les autres ressources, donc il faudra que l’outil puisse les rechercher, et donc que le site WordPress soit toujours activé. Ceci ne peut donc pas se faire sur un site indisponible ou bien même déjà arrêté.

On installe Hugo
----------

Et il faut un serveur, une vraie machine avec une adresse IP publique, un serveur web.  
 Là où pour du WordPress un hébergeur fournit la solution, en Hugo le plus classique est tout de même de mettre en place son propre serveur. Avec tout ce qui va bien, et le certificat pour HTTPS.

Mais avant de faire le pas, cela s'[installe](https://gohugo.io/installation/) en local sur une machine de développement avec docker, podman, inclus ou bien même directement puisque ce n’est qu’un exécutable.

sur une machine Linux :

```
sudo apt install hugo

```

ou

```
snap install hugo

```

Il suffit de lancer `hugo server` dans le répertoire du projet hugo et se connecter sur `localhost` avec l’URL qui a été fournie dans le terminal.

Dans le cas d’une migration vous aurez forcément à modifier de nombreuses pages de votre site qui comportent des problèmes de code markdown mal converti depuis le HTML.

Et il vous faudra utiliser des scripts, dans votre langage préféré, mais dans tous les cas l’utilisation d’expressions régulières sera nécessaire. C’est-à-dire : il faut connaître un minimum de programmation.

Voici le genre de commande qui recherche tous les fichiers avec l’extension.md et supprime le 'Proudly powered by WordPress' dedans :

```
text='Proudly powered by <a href="https://wordpress.org" rel="nofollow">WordPress</a>'
find content -name '*.md' -print0 | xargs -0 sed -i 's|'"$text"'||g'

```

Attention cette commande fonctionne, car le texte $text est compatible avec la syntaxe de commande sed en particulier utiliser un '|' dans la variable text serait problématique.

En suivant la procédure d’installation rapide [https://gohugo.io/getting-started/quick-start/](https://gohugo.io/getting-started/quick-start/) on va créer un dépôt git. Si par la suite on souhaite le répliquer pour le tester ailleurs alors il ne faudra pas oublier les submodules pour le thème, sinon la génération du site rendra un site vide.

```
git clone user@server:quickstart --recurse-submodules mon_site
cd mon_site
hugo server

```

On termine avec un `firefox http://localhost:1313` par exemple pour voir en local.

on pourra alors éditer le contenu sous content avec notre éditeur préféré et créer un commit git quand nous sommes contents de notre résultat local.

```
git add content
git commit -m 'édition numero xx du site'
git push

```

Cela doit pousser sur le git parent le contenu. Si le git parent est attaché à la production alors la production est mise à jour ainsi.

C’est pas beau hein ?
----------

Le contenu généré par l’outil de migration ayant été copié dans le répertoire `content` du projet Hugo, il suffit de lancer le serveur Hugo pour qu’il soit délivré sur le port indiqué en console. En se connectant avec un navigateur `firefox https://localhost:1313`, le contenu apparait…

Ah j’oubliais, en Hugo toute la présentation est contrôlée par le thème, ici le thème choisi est ananke, c’est celui proposé dans la [documentation de démarrage rapide de Hugo](https://gohugo.io/getting-started/quick-start/)

Il y a du contenu, certes mais quand même il y a eu des dégâts collatéraux.

Cliquez sur l’image pour voir la vidéo.

[![vue comparée du site avant et pendant migration](https://img.linuxfr.org/img/68747470733a2f2f6172746973616e2e6c30672e65752f626c6f672f696d616765732f726f6f74636f6d6d69745f6176616e745f70656e64616e742e706e67/rootcommit_avant_pendant.png "Source : https://artisan.l0g.eu/blog/images/rootcommit_avant_pendant.png")](https://pire.artisanlogiciel.net/w/uu3VRFjoh73BPcc85D89Kj)

### Les blocs réutilisables de WordPress ###

Il s’agit d’une fonctionnalité ajoutée dans l’éditeur de WordPress Gutemberg, la possibilité de créer des [blocs réutilisables](https://wordpress.org/documentation/article/wordpress-block-editor/) qui seront référencés dans d’autres pages ou bien même dans d’autres blocs

Pratiquement tous les outils d’export ne conservent pas les items qui ne sont ni de type page ni de type post et quand ils conservent les autres type, ils ne gèrent pas les blocs réutilisables.

Dans le fichier d’export.xml de WordPress on les retrouve ainsi :

```
<item>
…
<wp:post_id>610</wp:post_id>
…
</item>

```

et sont utilisés par référence :

```
<!-- wp:block {"ref":610} /-->

```

Dans mon cas pour l’outil wordpress-export-to-markdown, j’ai créé une [demande de fonctionnalité pour le support des blocs réutilisables]().

En pratique les outils perdent complètement le contenu de ces blocs.

Une façon de résoudre le problème est d’utiliser la source HTML générée par WordPress directement et de la convertir en Markdown.

### Les `<figure>`  ###

Hugo ne gère pas le tag `<figure>`, il faut supprimer ces tags, sinon les images qu’ils contiennent n’apparaissent juste pas. Or WordPress génère souvent des blocks HTML avec des tags figure.

Voici un script bash qui supprime le tag figure partout dans tous les fichiers.md de content.

```
find_files=(find content -name '*.md' -print0)
command2=(xargs -0 sed -i 's|</\?figure[^>]*[>]||g;')
"${find_files[@]}" | "${command2[@]}"

```

### URL permanentes ###

Il est crucial que les pages migrées se retrouvent au même endroit après migration. C’est crucial car cela fait partie du SEO, votre référencement, si vos pages changent de place, les moteurs de recherche vont vous perdre, tout comme les références depuis tout autre site.

En Hugo c’est le champ `url`dans l’entête [front-matter](https://gohugo.io/content-management/urls/#front-matter) du fichier markdown qui sert à indiquer où la page destinée à être délivrée.  
 Cette URL peut être totalement différente du répertoire dans lequel le fichier se trouve, même s’il est conseillé de conserver la mẽme hiérarchie, c’est une solution pratique.

### URL relatives ###

WordPress délivre toutes ses pages avec des URL absolues dans le corps c’est-à-dire avec le nom du site intégré dans l’URL, ceci est un souci quand on souhaite déplacer le site, ou bien avec un site réplica lui aussi accessible en ligne mais sous une autre URL.

Les expressions régulières sont là pour ça, il faut supprimer `http://monsite` du début des toutes les URL. Pour rappel, à l’intérieur d’une page HTML un lien `href='/article/linuxfr.html'` est une référence relative dans le site courant, si l’URL du site est `https://example.com` alors le lien avec l’URL absolue est au lien ``href='https://example.com/article/linuxfr.html'`.

Si vous ne faites pas vous pourriez avoir la surprise lors de l’arrêt du site WordPress de ne plus avoir les images et autres ressources, car elles étaient sur le site original et non sur le nouveau site migré !

voici un exemple en bash

```
find_files=(find content -name '*.md' -print0)
command2=(xargs -0 sed -i "s|https://${site_domain}||g")
"${find_files[@]}" | "${command2[@]}"

```

### Le menu ###

Le menu a été perdu, c’est ballot !  
 Via l’export Hugo il n’y a pas de menu du tout, il est perdu.  
 Dans WordPress le menu est supporté par du CSS les classes wp-block-navigation…  
 En Hugo c’est le thème qui le gère, ici avec ananke il faut rajouter des entrées de menu avec `menu.main`, dans mon cas j’ai rajouté le menu globalement dans le fichier de configuration Hugo, mais il y a [plusieurs façons de définir les menus en Hugo](https://gohugo.io/configuration/menus/).

Un site WordPress c’est un site web comme un autre
----------

Une autre approche est de considérer qu’un site WordPress c’est un site web comme un autre.  
 Un navigateur n’a pas de code particulier pour visualiser un site WordPress, donc un site WordPress est juste un site web, certes avec beaucoup de JavaScript et CSS, mais un site web.  
 Et un site web, ça se siphonne, et c’est facile, il suffit de regarder le projet internet archive, par exemple le [site de LinuxFr.org le 2 avril 2018](https://web.archive.org/web/20180402090712/http://linuxfr.org/) pour s’en convaincre, il est très facile de récupérer le contenu visible d’un site web, à condition de connaître tous les points d’entrée et en pratique il suffit de partir de la page principale.  
 Puisque vous migrez un site que vous possédez, il n’y a pas de souci à utiliser un [aspirateur de site](https://fr.wikipedia.org/wiki/Aspirateur_de_site_web).

Une fois le site récupéré, il y a des convertisseurs Markdown.

En particulier j’ai employé le [convertisseur de HTML vers Markdown de Johannes Kaufmann](https://github.com/JohannesKaufmann/html-to-markdown), qui est aussi une base pour d’autres projets de conversion pour des applications particulières dont WordPress.

Et le tour est joué ! Ou presque…

On repart de zéro et on mélange tout
----------

Si aucune des solutions ne fonctionne, chacune permet de créer une partie du site. En utilisant toutes les générations on peut récupérer les meilleurs pages.

Dans mon cas le plugin officiel de migration de jekyll vers hugo a été corrigé et j’ai donc pu l’utiliser.

En utilisant aussi des parties générées depuis le site statique, j’ai obtenu un résultat acceptable, mais cela ne s’est pas fait sans une série de petits scripts en bash à base de find et de sed et donc d’expression régulières, les fameuses regex.

### Variations mais pas sur le même thème ###

Une fois le contenu cohérent, il est temps de tester d’autres thèmes Hugo pour donner au site une apparence différente.  
 Ces thèmes aussi peuvent être personnalisés. La notion de thème existe déjà dans WordPress, donc vous ne devez pas être surpris, mais les thèmes de WordPress ne peuvent pas être transposés tels quels dans Hugo, par exemple le thème twentytwo désormais classique ne se résout pas en la copie de son continu sur Hugo.  
 Mais passer à Hugo c’est aussi l’opportunité de se démarquer.

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/migrer-de-wordpress-vers-hugo.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144129/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/migrer-de-wordpress-vers-hugo#comments)