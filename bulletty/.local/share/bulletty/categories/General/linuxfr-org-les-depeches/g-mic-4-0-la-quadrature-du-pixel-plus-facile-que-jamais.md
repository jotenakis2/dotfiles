+++
title = "G’MIC 4.0 : La quadrature du pixel, plus facile que jamais !"
description = "Dix-huit ans après ses débuts, G’MIC, cadriciel libre pour le traitement des images numériques, franchit une étape importante avec la sortie d'une nouvelle version majeure, numérotée 4.0, la version de "
date = "2026-07-29T07:25:41Z"
url = "https://linuxfr.org/news/g-mic-4-0-la-quadrature-du-pixel-plus-facile-que-jamais"
author = "David Tschumperlé"
text = ""
lastupdated = "2026-08-13T22:13:29.436083935Z"
seen = false
+++

Dix-huit ans après ses débuts, [*G’MIC*](https://gmic.eu), cadriciel libre pour [le traitement des images numériques](https://fr.wikipedia.org/wiki/Traitement_d'images), franchit une étape importante avec la sortie d'une nouvelle version majeure, numérotée **4.0**, la version de la maturité !

L'occasion, comme chaque année, de faire le point sur les évolutions récentes de ce projet, depuis notre [dernière dépêche](//linuxfr.org/news/g-mic-3-6-l-art-de-soigner-ses-images) publiée en août 2025.

[![G´MIC 4.0 Teaser](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f7465617365725f736d616c6c2e706e67/teaser_small.png "Source : https://gmic.eu/gmic40/thumbs/teaser_small.png")](https://gmic.eu/gmic40/img/teaser_small.jpg)

*N. D. A. : Cliquez sur les images pour en obtenir une version en pleine résolution, ou une vidéo correspondante lorsque les images contiennent l’icône ![Icône 'Play Video'](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f69636f6e5f706c61795f766964656f2e706e67/icon_play_video.png "Source : https://gmic.eu/gmic40/thumbs/icon_play_video.png")*

* lien nᵒ 1 : [Le projet G'MIC](https://linuxfr.org/redirect/117928)
* lien nᵒ 2 : [Fil Mastodon du projet](https://linuxfr.org/redirect/117929)
* lien nᵒ 3 : [Série d’articles G’MIC sur LinuxFr.org](https://linuxfr.org/redirect/117930)

Sommaire
----------

* [1. *G’MIC* : Un cadriciel libre pour l'image numérique](#toc-1-gmic-un-cadriciel-libre-pour-limage-numérique)
* [2. Nouveaux filtres du greffon *G'MIC-Qt*](#toc-2-nouveaux-filtres-du-greffon-gmic-qt)
  * [2.1. Filtre « *Rendering / Pixel Stretch* »](#toc-21-filtre-rendering--pixel-stretch)
  * [2.2. Filtre « *Rendering / Gradients [Poles]* »](#toc-22-filtre-rendering--gradients-poles)
  * [2.3. Filtre « *Artistic / Marker Drawing* »](#toc-23-filtre-artistic--marker-drawing)
  * [2.4. Filtre « *Deformations / Heightfield Warp* »](#toc-24-filtre-deformations--heightfield-warp)
  * [2.5. Filtre « *Degradations / Offset Stripes* »](#toc-25-filtre-degradations--offset-stripes)
  * [2.6. Filtre « *Colors / Transfer Colors [Multi]* »](#toc-26-filtre-colors--transfer-colors-multi)

* [3. Nouveautés et améliorations du cœur du logiciel et de sa bibliothèque standard](#toc-3-nouveautés-et-améliorations-du-cœur-du-logiciel-et-de-sa-bibliothèque-standard)
* [4. Nouveau dépôt de codes sources: `gmic-interactive-demos`](#toc-4-nouveau-dépôt-de-codes-sources-gmic-interactive-demos)
  * [4.1. *The SteamFace Machine*](#toc-41-the-steamface-machine)
  * [4.2. *Virtual Artist*](#toc-42-virtual-artist)
  * [4.3. *GREYC Warp*](#toc-43-greyc-warp)

* [5 G'MIC et le code créatif](#toc-5-gmic-et-le-code-créatif)
  * [5.1. Codes créatifs courts](#toc-51-codes-créatifs-courts)
  * [5.2. Continuation de la série « *G'MIC Adventures* »](#toc-52-continuation-de-la-série-gmic-adventures)

* [6. Autres nouvelles liées au projet](#toc-6-autres-nouvelles-liées-au-projet)
* [7. Conclusion](#toc-7-conclusion)

1. *G’MIC* : Un cadriciel libre pour l'image numérique
----------

Le projet [*G'MIC*](https://gmic.eu) (*GREYC's Magic for Image Computing*) est né en juillet 2008, et a grandi au sein de l'équipe [*IMAGE*](https://www.greyc.fr/equipes/image/) du laboratoire [*GREYC*](https://www.greyc.fr/) de Caen (Unité Mixte de Recherche placée sous la triple tutelle du [*CNRS*](https://www.cnrs.fr/fr), de l'[*ENSICAEN*](https://www.ensicaen.fr/) et de l'[Université de Caen](https://www.unicaen.fr/)).

Sa vocation : offrir un cadriciel libre, ouvert et extensible pour la manipulation, le traitement et la création d'[images numériques](https://fr.wikipedia.org/wiki/Image_numérique). Pour ce faire, il s'appuie sur les fonctionnalités de la bibliothèque libre C++ de traitement d'images [CImg](https://cimg.eu), développée depuis 1999 d'abord au sein de l'[INRIA](https://www.inria.fr/fr), puis de l'équipe [*IMAGE*](https://www.greyc.fr/equipes/image/) du [*GREYC*](https://www.greyc.fr/) (également par votre serviteur).

Au cœur du projet se trouve un interpréteur de langage de script dédié, le [« langage *G'MIC* »](https://gmic.eu/reference/overall_context.html), spécialement conçu pour prototyper rapidement de nouveaux algorithmes de traitement d'images, et les enchaîner au sein de *pipelines* (ou filtres) personnalisés. Autour de ce noyau viennent se greffer plusieurs interfaces, donnant à l'utilisateur accès à des centaines d'opérateurs de traitement d'images prédéfinis, comme par exemple l'outil en ligne de commande [`gmic`](https://gmic.eu/reference/) ; le service Web [*G'MIC Online*](https://gmicol.greyc.fr/) ; et le greffon [*G'MIC-Qt*](https://github.com/c-koi/gmic-qt), qu'il est possible d'intégrer dans plusieurs logiciels de création et d'édition d'images, tels que [GIMP](https://www.gimp.org), [Krita](https://www.krita.org), [digiKam](https://www.digikam.org), [Paint.net](https://www.getpaint.net), [Adobe Photoshop](https://fr.wikipedia.org/wiki/Adobe_Photoshop) ou [Affinity Photo](https://fr.wikipedia.org/wiki/Affinity_Photo). C'est aujourd'hui ce greffon qui est l'interface du projet la plus utilisée, avec plus de 1200 téléchargements quotidiens, en progression depuis un an. Il propose plus de **640 filtres** variés pour triturer vos images et enrichir les possibilités des logiciels de retouche, et semble particulièrement apprécié des artistes numériques.

Cette version majeure **4.0** marque un tournant dans la vie du projet : la syntaxe du langage *G'MIC*, le code de l'interpréteur et des algorithmes de traitement d'images associés sont maintenant éprouvés. Nous souhaitons donc ralentir un peu le rythme des nouvelles *releases* et de l'ajout de nouvelles fonctionnalités, pour nous concentrer sur la stabilité, la robustesse, et les performances du cadriciel.

[![Aperçu du greffon G'MIC-Qt](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f75692e706e67/gmic_ui.png "Source : https://gmic.eu/gmic40/thumbs/gmic_ui.png")](https://gmic.eu/gmic40/img/gmic_ui.jpg) *Fig. 1.1. Aperçu de quelques-unes des interfaces proposées par le projet G'MIC : Greffon G'MIC-Qt pour GIMP (en haut à gauche), Outil CLI `gmic` (en haut à droite), Service web G'MIC Online (en bas).*

2. Nouveaux filtres du greffon *G'MIC-Qt*
----------

Côté greffon *G'MIC-Qt*, l'essentiel des nouveautés se concentre sur l'apparition de nouveaux filtres de traitement d'images. La version 4.0 porte leur nombre à **644**, tous accessibles directement depuis l'interface graphique. Je liste ci-dessous les derniers filtres ajoutés.

### 2.1. Filtre « *Rendering / Pixel Stretch* » ###

Le filtre « **Rendering / Pixel Stretch** » permet de sélectionner une « bande de pixels », et la duplique dans l'image en lui faisant suivre une trajectoire personnalisable, définie par deux courbes splines (une pour chaque bord de la bande).

[![Filtre 'Rendering/Pixel Stretch' (G'MIC-Qt)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f706978656c5f73747265746368302e706e67/gmic_pixel_stretch0.png "Source : https://gmic.eu/gmic40/thumbs/gmic_pixel_stretch0.png")](https://gmic.eu/gmic40/img/gmic_pixel_stretch0.jpg) *Fig. 2.1.1. Le filtre « Rendering / Pixel Stretch » tel qu'il apparait dans le greffon G'MIC-Qt.*

[![Filtre 'Rendering/Pixel Stretch' (rendu 1)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f706978656c5f73747265746368312e706e67/gmic_pixel_stretch1.png "Source : https://gmic.eu/gmic40/thumbs/gmic_pixel_stretch1.png")](https://gmic.eu/gmic40/img/gmic_pixel_stretch1.jpg) *Fig. 2.1.2. Exemple de rendu du filtre « Rendering / Pixel Stretch », ici avec deux traînées de pixels ajoutées par le filtre.*

Cet effet donne l'impression que l'image a été étirée localement, un peu comme une pâte élastique. Il peut servir à suggèrer ou styliser un mouvement dans une image, comme sur l'exemple ci-dessous (extrait de la [vidéo tutorielle](https://youtu.be/2WWBALrbWz4?si=NF1tQCzyNUeNgV_F) que [Miguel Pineau](https://www.youtube.com/@MiguelPineau) a spécialement dédiée à ce filtre).  
 On peut également imaginer son utilisation pour du [Glitch art](https://fr.wikipedia.org/wiki/Glitch_art) ou de la création de textures abstraites.

[![Filtre 'Rendering/Pixel Stretch' (rendu 2)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f706978656c5f73747265746368322e706e67/gmic_pixel_stretch2.png "Source : https://gmic.eu/gmic40/thumbs/gmic_pixel_stretch2.png")](https://gmic.eu/gmic40/img/gmic_pixel_stretch2.jpg) *Fig. 2.1.3. Le filtre « Rendering / Pixel Stretch » appliqué pour styliser le mouvement d'une danseuse (Crédits : Miguel Pineau).*

### 2.2. Filtre « *Rendering / Gradients [Poles]* » ###

Toujours dans cette section « **Rendering** », notons l'arrivée de « **Rendering / Gradients [Poles]** », un filtre générant des dégradés de couleurs en interpolant spatialement des points-clés colorés, dont les positions et les couleurs sont laissées au choix de l'utilisateur. Ici, l'interpolation fait usage des [fonctions de base radiale](https://fr.wikipedia.org/wiki/Fonction_de_base_radiale) qui produisent des dégradés de couleurs lisses et harmonieux. L'utilisateur a également le choix de l'espace de couleurs dans lequel l'interpolation s'effectue. L'animation ci-dessous illustre le fonctionnement de ce filtre au sein du greffon.

[![Filtre 'Rendering/Gradient (Poles)' (G'MIC-Qt)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f6772616469656e745f706f6c65732e706e67/gmic_gradient_poles.png "Source : https://gmic.eu/gmic40/thumbs/gmic_gradient_poles.png")](https://gmic.eu/gmic40/img/gmic_gradient_poles.mp4) *Fig. 2.2.1. Le filtre « Rendering / Gradient [Poles] » crée des gradients spatiaux de couleurs possiblement complexes, à partir de quelques points de contrôle.*

### 2.3. Filtre « *Artistic / Marker Drawing* » ###

Passons maintenant au filtre « **Artistic / Marker Drawing** », qui comme son nom l'indique, essaye de redessiner une image d'entrée sous la forme de traits de stylos feutres colorés. L'algorithme sous-jacent trace effectivement des splines colorées aléatoires sur une feuille blanche, le long des contours des structures géométriques présentes dans l'image à reproduire.

[![Filtre 'Artistic/Marker Drawing' (G'MIC-Qt)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f676d69635f6d61726b65725f64726177696e672e676966/gmic_marker_drawing.gif "Source : https://gmic.eu/gmic40/img/gmic_marker_drawing.gif")](https://gmic.eu/gmic40/img/gmic_marker_drawing.gif) *Fig. 2.3.1. Le filtre « Artistic / Marker Drawing » redessine une image en simulant l'utilisation de stylos feutres colorés.*

Les nombreux paramètres réglables de ce filtre permettent d'obtenir des rendus potentiellement variés, plus ou moins abstraits, comme l'illustre la figure comparative suivante :

[![Filtre 'Artistic/Marker Drawing' (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f626561725f6d645f616c6c2e706e67/bear_md_all.png "Source : https://gmic.eu/gmic40/thumbs/bear_md_all.png")](https://gmic.eu/gmic40/img/bear_md_all.jpg) *Fig. 2.3.2. Trois types de rendus du filtre « Artistic / Marker Drawing », utilisant trois jeux de paramètres différents.*

### 2.4. Filtre « *Deformations / Heightfield Warp* » ###

Changeons maintenant de thématique avec le filtre « **Deformations / Heightfield Warp** » qui crée un effet 3D, en déformant une image d'entrée comme si elle était plaquée sur une carte d'élévation (définie de manière paramétrique). Un effet d'éclairage additionnel, de type [ombrage de Phong](https://fr.wikipedia.org/wiki/Ombrage_de_Phong), peut être activé pour accentuer davantage l'effet de volume 3D produit par ce filtre.

[![Filtre 'Deformations/Heightfield Warp (G'MIC-Qt)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f6865696768746669656c645f776172702e706e67/gmic_heightfield_warp.png "Source : https://gmic.eu/gmic40/thumbs/gmic_heightfield_warp.png")](https://gmic.eu/gmic40/img/gmic_heightfield_warp.jpg) *Fig. 2.4.1. Le filtre « Deformations / Heightfield Warp », tel qu'il apparait dans le greffon G'MIC-Qt, ici avec une élévation correspondant à une demi-sphère bombée vers la caméra.*

Ce filtre est particulièrement flexible : il laisse la possibilité à l'utilisateur de définir explicitement des formules mathématiques personnalisées pour les cartes d'élévations. Les mathématiciens en herbe peuvent ainsi laisser libre cours à leur imagination pour déformer leurs images !

[![Filtre 'Deformations/Heightfield Warp (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f6865696768746669656c645f776172705f616c6c2e706e67/gmic_heightfield_warp_all.png "Source : https://gmic.eu/gmic40/thumbs/gmic_heightfield_warp_all.png")](https://gmic.eu/gmic40/img/gmic_heightfield_warp_all.jpg) *Fig. 2.4.2. Application de trois formules personnalisés de cartes d'élévations 3D, avec le filtre « Deformations / Heightfield Warp ».*

### 2.5. Filtre « *Degradations / Offset Stripes* » ###

Les amateurs de [Glitch art](https://fr.wikipedia.org/wiki/Glitch_art) pourront être séduits par le nouveau filtre « **Degradations / Offset Stripes** », qui crée un effet de décalage de bandes d'images, horizontales et/ou verticales, avec des amplitudes de décalage aléatoires.

[![Filtre 'Degradations/Offset Stripes (G'MIC-Qt)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f676d69635f6f66667365745f737472697065732e676966/gmic_offset_stripes.gif "Source : https://gmic.eu/gmic40/img/gmic_offset_stripes.gif")](https://gmic.eu/gmic40/img/gmic_offset_stripes.gif) *Fig. 2.5.1. Le filtre « Degradations / Offset Stripes » applique des décalages aléatoires sur des bandes d'images horizontales et/ou verticales.*

Ce principe de base est tout simple, mais là encore, les nombreux paramètres du filtre donnent accès à des décalages décorrélés sur chaque canal, pour des espaces couleurs variés, en pouvant itérer ces décalages aléatoires, et autorisent ainsi une grande variété de dégradations d'images de type « *Glitch* », comme illustré sur la figure ci-dessous.

[![Filtre 'Degradations/Offset Stripes (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f6f66667365745f737472697065735f616c6c2e706e67/gmic_offset_stripes_all.png "Source : https://gmic.eu/gmic40/thumbs/gmic_offset_stripes_all.png")](https://gmic.eu/gmic40/img/gmic_offset_stripes_all.jpg) *Fig. 2.5.2. Résultats de différents jeux de paramètres du filtre « Degradations / Offset Stripes », appliqués sur une même image de portrait.*

### 2.6. Filtre « *Colors / Transfer Colors [Multi]* » ###

Et pour terminer ce résumé des nouveaux filtres du greffon *G'MIC-Qt*, j'ai gardé le plus intéressant pour la fin : le filtre « **Colors / Transfer Colors [Multi]** » est un nouveau filtre de transfert de couleurs entre deux images.

Le transfert de couleur consiste à appliquer une transformation couleur à une image « *Source* », en prenant comme référence une deuxième image (image dite de « *Style* ») dont on veut reproduire le style ou l'ambiance colorimétrique, et ceci bien sûr en préservant autant que possible les structures importantes (contours, objets, contenu sémantique) présentes dans l'image « *Source* » d'origine.

[![Principe du transfert couleur entre images](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f636f6c6f725f7472616e736665722e706e67/color_transfer.png "Source : https://gmic.eu/gmic40/thumbs/color_transfer.png")](https://gmic.eu/gmic40/img/color_transfer.jpg) *Fig. 2.6.1. Principe du transfert de couleur entre images: une image « \_Source* » (à gauche) est modifiée (à droite) de telle façon qu'elle « emprunte » les couleurs d'une image de « *Style* » (au centre).\_

D'un point de vue algorithmique, il y a de nombreuses façons d'aborder ce type de transfert. Le filtre « **Colors / Transfer Colors [Multi]** », comme son nom le suggère, implémente trois méthodes différentes pour ce faire : une méthode [ACP](https://fr.wikipedia.org/wiki/Analyse_en_composantes_principales) ; une méthode de transfert d'[histogrammes](https://fr.wikipedia.org/wiki/Histogramme_(imagerie_numérique)) ; et enfin une [méthode variationnelle](https://fr.wikipedia.org/wiki/Calcul_des_variations). Pour utiliser ce filtre dans le greffon *G'MIC-Qt*, il suffit de l'appeler sur une image contenant deux calques superposés : un calque contenant l'image « *Source* » à modifier, et un calque avec l'image « *Style* » contenant les couleurs de référence à transférer.

[![Filtre 'Colors/Transfer Colors (Multi)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f7472616e736665725f636f6c6f72735f6d756c74692e706e67/gmic_transfer_colors_multi.png "Source : https://gmic.eu/gmic40/thumbs/gmic_transfer_colors_multi.png")](https://gmic.eu/gmic40/img/gmic_transfer_colors_multi.jpg) *Fig. 2.6.2. Le filtre « Colors / Transfer Colors [Multi] » tel qu'il se présente dans le greffon G'MIC-Qt.*

L'algorithme variationnel de transfert de couleur implémenté dans ce filtre est une production totalement originale : il est le fruit d'une collaboration de recherche entre deux membres de l'équipe [IMAGE](https://www.greyc.fr/equipes/image/) du laboratoire [*GREYC*](https://www.greyc.fr/) de Caen ([D. Tschumperlé](https://tschumperle.users.greyc.fr/) et [J. Rabin](https://sites.google.com/site/rabinjulien/)), et d'une professeure du laboratoire de mathématiques [*LMI*](http://lmi.insa-rouen.fr/) de l'[*INSA* de Rouen](https://www.insa-rouen.fr/) ([C. Le Guyader](http://lmi.insa-rouen.fr/mam/9-membres/professeurs/28-le-guyader-carole.html)).

Bref, un algorithme **100 % normand**, qui fonctionne forcément « *vachement* 🐄 bien » 😉, et que vous ne trouverez nulle part ailleurs !  
 On remercie chaleureusement la Fédération Normande de Recherche en Sciences et Technologies de l’Information et de la Communication ([*NormaSTIC*](https://www.normastic.fr/)) pour son aide financière qui a accéléré la mise en contact et le démarrage de cette collaboration fructueuse !

Notre méthode a plusieurs caractéristiques propres permettant de calculer des transferts de couleurs souvent pertinents, et de bonne qualité comparativement à ses concurrentes, et ce, de manière rapide et complètement automatique. La figure ci-dessous illustre des exemples de transferts de couleurs qu'il est possible d'obtenir pour une même image « *Source* », en choisissant des images de « *Style* » différentes (et en laissant les paramètres par défaut du filtre).

[![Filtre 'Colors/Transfer Colors (Multi) (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f6272696467655f616c6c2e706e67/bridge_all.png "Source : https://gmic.eu/gmic40/thumbs/bridge_all.png")](https://gmic.eu/gmic40/img/bridge_all.jpg) *Fig. 2.6.3. Exemples de transferts de couleurs réalisés par le filtre « Colors / Transfer Colors [Multi] » sur une même image « Source », avec plusieurs images « Style » différentes.*

La technique que nous proposons autorise également un mode « semi-supervisé » qui permet à l'utilisateur de forcer certaines correspondances de couleurs, et donc de « guider » l'algorithme pour calculer une solution de transfert plus contrainte et personnalisée.  
 Les deux exemples ci-dessous illustrent ce mode de contrôle de manière assez parlante :

[![Filtre 'Colors/Transfer Colors (Multi) (rendu guidé 1)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f636f6c6f725f7472616e736665725f677569646564302e706e67/gmic_color_transfer_guided0.png "Source : https://gmic.eu/gmic40/thumbs/gmic_color_transfer_guided0.png")](https://gmic.eu/gmic40/img/gmic_color_transfer_guided0.jpg) *Fig. 2.6.4. Guidage de l'algorithme de transfert de couleurs par mise en correspondance forcée de couleurs (Perruche → Mésange).*

Ici, les plumes vertes du corps de la perruche (*a*) sont perceptuellement plus proches de la couleur jaune du corps de la mésange (*b*), et c'est donc cette mise en correspondance qui est réalisée par défaut par l'algorithme de transfert (résultat (*c*)). En explicitant des correspondances de couleurs souhaitées (liens symbolisés entre les images (*a*) et (*b*)), on peut modifier ce comportement et contraindre le transfert à assigner la couleur bleue de la mésange aux plumes de la perruche (résultat (*d*)).

[![Filtre 'Colors/Transfer Colors (Multi) (rendu guidé 2)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f636f6c6f725f7472616e736665725f677569646564312e706e67/gmic_color_transfer_guided1.png "Source : https://gmic.eu/gmic40/thumbs/gmic_color_transfer_guided1.png")](https://gmic.eu/gmic40/img/gmic_color_transfer_guided1.jpg) *Fig. 2.6.5. Guidage de l'algorithme de transfert de couleurs par mise en correspondance forcée de couleurs (Coccinelle → Formule 1).*

Dans ce deuxième exemple, on note que la couleur rouge de la Coccinelle (*a*) se retrouve ailleurs dans l'image « *Style* » de la Formule 1 (*b*) : au bord de la route, sur les coquelicots… L'algorithme décide donc naturellement de conserver cette couleur quasiment telle quelle lors du transfert automatique (résultat (*c*)). Forcer des correspondances de couleurs explicites permet de guider l'algorithme pour lui faire changer la couleur de la Coccinelle en vert (résultat (*d*)).

Vous l'aurez compris, ce filtre représente l'aboutissement d'un travail de recherche de longue haleine en algorithmique du traitement d'images. Pour des chercheurs comme nous, il est réjouissant d'être arrivé au bout du processus complet : élaborer un nouvel algorithme complexe sur un bout de papier, le développer, l'implémenter, le peaufiner, en obtenir des résultats encourageants, le peaufiner encore et encore, en écrire une description détaillée dans un article scientifique (en cours de finalisation), l'intégrer proprement et le rendre utilisable par tout un chacun dans un logiciel libre, en sachant qu'il pourra être testé et utilisé potentiellement des milliers de fois !

Notons que ce n'est pas la première fois qu'une méthode de traitement d'images développée au sein de notre laboratoire de recherche se retrouve valorisée dans *G'MIC*. [Cette page](https://gmic.eu/reference/scientific_publications.html) recense plusieurs publications scientifiques décrivant des algorithmes élaborés au sein de l'équipe *IMAGE* du *GREYC*, et qui sont accessibles comme filtres du greffon *G'MIC-Qt*.

3. Nouveautés et améliorations du cœur du logiciel et de sa bibliothèque standard
----------

Comme évoqué précédemment, le terme *G'MIC* peut faire référence au langage de script du même nom. Ce langage est doté de son propre interpréteur et de sa bibliothèque standard de fonctions. Il est utilisé pour implémenter tous les filtres et opérateurs de traitement d'images mis à disposition des utilisateurs des différentes interfaces du projet.

Durant l'année écoulée, un grand nombre de petites améliorations ont été implémentées conjointement sur ce langage et sa bibliothèque standard.  
 En réalité, l'ensemble de ces contributions représente même la majorité du travail de développement réalisé, et en même temps ce sont des choses qu'il est difficile de valoriser dans une dépêche grand public : elles concernent principalement des points très précis et techniques du projet, comme par exemple des optimisations du *parsing* ou des algorithmes, du nettoyage de code, de nouvelles fonctions ou options pour l'évaluateur d'expressions mathématiques, etc.  
 Ce sont bien sûr des ajouts utiles pour les développeurs de nouveaux filtres dans ce langage, mais il est difficile de les mettre en valeur de manière réellement plaisante.

J'ai donc pris le parti de lister ci-dessous uniquement les quelques nouveautés facilement « illustrables » :

* La nouvelle commande [`random_patches`](https://gmic.eu/reference/random_patches) réalise un rendu procédural d'images carrées contenant des formes géométriques et des textures synthétiques aléatoires. À quoi cela peut-il bien servir, me direz-vous ? Eh bien par exemple, à générer des ensembles d'images pour l'entrainement de réseaux de neurones convolutionnels, pour des tâches de débruitage et de super-résolution (ces réseaux sont ceux utilisés par les commandes [`denoise_cnn`](https://gmic.eu/reference/denoise_cnn) et [`scale2x_cnn`](https://gmic.eu/reference/scale2x_cnn)).

[![Commande 'random_patches' (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f72616e646f6d5f706174636865732e706e67/gmic_random_patches.png "Source : https://gmic.eu/gmic40/thumbs/gmic_random_patches.png")](https://gmic.eu/gmic40/img/gmic_random_patches.jpg) *Fig. 3.1. La commande `random_patches` synthétise des images carrées contenant des formes géométriques et des textures aléatoires.*

Ces images sont en réalité suffisamment complexes pour qu'un réseau de neurones puisse apprendre des filtres convolutionnels pertinents pour l'analyse semi-locale de la géométrie des structures présentes dans des images plus naturelles. Ces filtres appris peuvent ensuite être utilisés dans des tâches de débruitage ou de super-résolution, qui sont des problèmes très géométriques et qui ne nécessitent pas vraiment une analyse sémantique du contenu des images. Utiliser ces données synthétiques pour entrainer des réseaux simples est donc largement suffisant pour ce type d'applications. D'une part, cela évite de stocker de grandes bases d'images volumineuses lors de l'entrainement (les images synthétiques étant générées à la volée). Et d'autre part, on évite automatiquement d'enfreindre le *copyright* éventuel des images présentes dans les ensembles d'apprentissage prédéfinis (dont la provenance n'est pas toujours clairement citée, avouons-le).

* La nouvelle commande [`shape_hilbert`](https://gmic.eu/reference/shape_hilbert) génère, comme son nom l'indique, une image de la [courbe de Hilbert](https://fr.wikipedia.org/wiki/Courbe_de_Hilbert) (en 2D).

[![Commande 'shape_hilbert (rendus)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f73686170655f68696c626572742e706e67/gmic_shape_hilbert.png "Source : https://gmic.eu/gmic40/thumbs/gmic_shape_hilbert.png")](https://gmic.eu/gmic40/img/gmic_shape_hilbert.jpg) *Fig. 3.2. La commande `shape_hilbert` trace une courbe de Hilbert dans une image, commande illustrée ici avec des niveaux croissants de récursions.*

* La nouvelle commande [`pca`](https://gmic.eu/reference/pca) calcule une [analyse en composantes principales](https://fr.wikipedia.org/wiki/Analyse_en_composantes_principales) (ACP) d'un ensemble de vecteurs. Ce type d'analyse permet à la fois de déterminer la dimensionnalité représentative de données vectorielles, ainsi que leurs orientations principales dans l'espace. L'ACP a de nombreuses applications en traitement d'images et plus généralement en analyse de données : débruitage, compression, reconnaissance de visages, analyse de textures, recalage géométrique, etc. L'exemple ci-dessous illustre son utilisation pour déterminer l'orientation des axes principaux (dessinés en pointillés) d'une silhouette de libellule.

[![Commande 'pca')](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f7063612e706e67/gmic_pca.png "Source : https://gmic.eu/gmic40/thumbs/gmic_pca.png")](https://gmic.eu/gmic40/img/gmic_pca.jpg) *Fig. 3.3. La commande `pca` est utilisée ici pour calculer les orientations des axes principaux d'une silhouette binaire 2D.*

* Les nouvelles commandes [`depthmap3d`](https://gmic.eu/reference/depthmap3d) et [`normalmap3d`](https://gmic.eu/reference/normalmap3d) viennent enrichir les possibilités de rendus d'objets 3D maillés de *G'MIC*, en synthésisant des rendus d'un objet respectivement sous la forme de cartes de profondeurs et de normales 3D.

[![Commandes 'depthmap3d' et 'normalmap3d')](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f6c7569676933642e706e67/gmic_luigi3d.png "Source : https://gmic.eu/gmic40/thumbs/gmic_luigi3d.png")](https://gmic.eu/gmic40/img/gmic_luigi3d.mp4) *Fig. 3.4. Les commandes `depthmap3d` et `normalmap3d` appliquées sur un modèle 3D en rotation.*

* Mentionnons enfin le travail d'amélioration général ciblé sur les algorithmes d'opérations matricielles présents dans *G'MIC* : arrivée de la [décomposition QR](https://fr.wikipedia.org/wiki/Décomposition_QR) (avec pivot), amélioration de la précision de calcul pour l'[inversion de matrices](https://fr.wikipedia.org/wiki/Matrice_inversible) et la [résolution de systèmes linéaires](https://fr.wikipedia.org/wiki/Système_d'équations_linéaires)… Et même s'il est difficile de rendre ça visuel, je vous propose cette petite ligne de commande qui crée une matrice carrée 40×40 aléatoire, qui l'inverse et qui calcule le produit des deux pour vérifier que l'on retrouve bien la matrice identité.

```
$ gmic 40,40 rand -1,1 +invert +mmul name A,invA,'A*invA'
```

[![Commande 'invert')](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f696e766572745f6d61747269782e706e67/gmic_invert_matrix.png "Source : https://gmic.eu/gmic40/thumbs/gmic_invert_matrix.png")](https://gmic.eu/gmic40/img/gmic_invert_matrix.jpg) *Fig. 3.5. Exemple de l'utilisation de `gmic` en ligne de commande pour l'inversion d'une matrice aléatoire.*

Tout ceci n'est bien sûr qu'un aperçu succinct de ce qui a été réalisé sur le cœur de *G'MIC* cette année. Pour plus de détails techniques, la consultation des [Changelog](https://discuss.pixls.us/tag/changelog) est recommandée.

4. Nouveau dépôt de codes sources: `gmic-interactive-demos`
----------

En tant que membre d'un laboratoire public de recherche, j'ai l'occasion de participer ponctuellement à des évènements de vulgarisation scientifique (tels que la [Fête de la science](https://fr.wikipedia.org/wiki/Fête_de_la_science), le [FÉNO](https://feno.normandie.fr/), etc.), où l'on présente certaines de nos activités de recherche au grand public (en algorithmique du traitement d'images en ce qui me concerne). Pour rendre ces présentations plus attractives et ludiques, j'ai élaboré au fil des ans, différents programmes et bornes de démonstration interactifs, en me reposant sur les possibilités offertes par le langage *G'MIC*.

Ces applications libres (sous licence CeCILL) sont maintenant accessibles sur ce dépôt logiciel : [`github.com/GreycLab/gmic-interactive-demos`](https://github.com/GreycLab/gmic-interactive-demos)

Elles pourront intéresser des enseignants et/ou chercheurs souhaitant illustrer différents concepts du traitement d'images à des publics de néophytes. Ces codes illustrent aussi les capacités du langage *G'MIC* pour la création de programmes interactifs, et ceci indépendamment du greffon *G'MIC-Qt*.

Pour le moment, trois démonstrateurs sont présents dans ce dépôt logiciel. Ils sont détaillés ci-dessous.

### 4.1. *The SteamFace Machine*  ###

« *The SteamFace Machine* » est le démonstrateur le plus récent. Il montre le fonctionnement des réseaux de neurones convolutionnels pour la détection d'un visage dans une image, et l'analyse de caractéristiques propres à ce visage, le tout enrobé dans un style [*SteamPunk*](https://fr.wikipedia.org/wiki/Steampunk) du plus bel effet !

[![The SteamFace Machine (intro)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f737465616d66616365302e706e67/gmic_steamface0.png "Source : https://gmic.eu/gmic40/thumbs/gmic_steamface0.png")](https://gmic.eu/gmic40/img/gmic_steamface0.jpg) *Fig. 4.1.1. Écran de lancement du démonstrateur « The SteamFace Machine ».*

Le flux vidéo capturé par la *webcam* s'affiche à l'écran, et lorsqu'un visage est placé au centre de l'image, la jauge de détection faciale s'active. En bas à droite, on peut apercevoir la sortie de différentes couches intermédiaires du réseau de neurones réalisant la détection (classifieur binaire avec une architecture de type [LeNet-5](https://en.wikipedia.org/wiki/LeNet)).

[![The SteamFace Machine (main)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f676d69635f737465616d666163655f616e696d2e676966/gmic_steamface_anim.gif "Source : https://gmic.eu/gmic40/img/gmic_steamface_anim.gif")](https://gmic.eu/gmic40/img/gmic_steamface_anim.gif) *Fig. 4.1.2. Détection du visage par un réseau de neurones convolutionnel dans le démonstrateur « \_The SteamFace Machine* ».\_

Une fois la détection opérée, un deuxième réseau est inféré pour en extraire différentes caractéristiques faciales : genre, âge, type de cheveux, port de lunettes ou de chapeau, taille du nez…

[![The SteamFace Machine (caractéristiques)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f737465616d66616365322e706e67/gmic_steamface2.png "Source : https://gmic.eu/gmic40/thumbs/gmic_steamface2.png")](https://gmic.eu/gmic40/img/gmic_steamface2.jpg) *Fig. 4.1.3. Analyse de quelques caractéristiques liées au visage détecté.*

C'est une manière visuellement amusante de présenter le fonctionnement de classifieurs neuronaux au grand public, leurs capacités mais aussi leurs limites et les biais inhérents aux bases d'apprentissage utilisées pour les entrainer (dans le cas de ce démonstrateur, la base [CelebA](https://mmlab.ie.cuhk.edu.hk/projects/CelebA.html), qui contient des images assez éloignées de celles que l'on acquiert via la *webcam* dans un environnement non-contrôlé tel qu'un parc des expositions).

Mentionnons également la belle contribution de notre cher collègue Philippe Bernard, du service [Administration système et réseaux](https://www.greyc.fr/laboratoire/asr/) du [*GREYC*](https://www.greyc.fr/), qui a réalisé une borne physique de démonstration intégrant « *The SteamFace Machine* », facilement transportable à des évènements de médiation scientifique !

[![The SteamFace Machine (borne)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f737465616d666163655f626f726e655f7468756d622e706e67/gmic_steamface_borne_thumb.png "Source : https://gmic.eu/gmic40/thumbs/gmic_steamface_borne_thumb.png")](https://gmic.eu/gmic40/img/gmic_steamface_borne.mp4) *Fig. 4.1.4. Vidéo de démonstration de la borne « The SteamFace Machine » quand elle était en cours d'élaboration.*

### 4.2. *Virtual Artist*  ###

« *Virtual Artist* » est un deuxième démonstrateur interactif, qui cherche à illustrer le principe du « [transfert de style](https://en.wikipedia.org/wiki/Neural_style_transfer) » entre deux images.  
 Nous avons précédemment évoqué le transfert de couleurs (en section 2.6). Le transfert de style en est une extension naturelle : au lieu de transférer uniquement les couleurs, on cherche à transférer tout le style graphique d'une image « *Style* » vers l'image « *Source* ».  
 C'est bien sûr un problème autrement plus complexe, et les méthodes les plus performantes du domaine utilisent généralement de gros réseaux de neurones.

« *Virtual Artist* » n'a pas la prétention d'être à la pointe de l'état de l'art : c'est avant tout un démonstrateur pédagogique pour expliquer le principe général du transfert de style en traitement d'images. L'utilisateur peut jouer avec différentes images de « *Source* » et de « *Style* » prédéfinies. La figure ci-dessous illustre quelques-uns des écrans principaux de l'application.

[![Virtual Artist](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f676d69635f7669727475616c5f6172746973745f616c6c2e706e67/gmic_virtual_artist_all.png "Source : https://gmic.eu/gmic40/thumbs/gmic_virtual_artist_all.png")](https://gmic.eu/gmic40/img/gmic_virtual_artist_all.jpg) *Fig. 4.2.1. L'application « Virtual Artist » illustre le principe du transfert de style entre deux images.*

Ce démonstrateur a été utilisé de nombreuses fois sur une grande table tactile, dans des évènements grand public, et fait toujours son petit effet !

[![Virtual Artist (FÉNO)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f66656e6f323032312e706e67/feno2021.png "Source : https://gmic.eu/gmic40/thumbs/feno2021.png")](https://gmic.eu/gmic40/img/feno2021.jpg) *Fig. 4.2.2. L'application « Virtual Artist » utilisée comme démonstrateur, ici au Festival de l'Excellence Normande (FÉNO) en 2021.*

### 4.3. *GREYC Warp*  ###

« *GREYC Warp* », le dernier démonstrateur de ce nouveau dépôt logiciel, implémente un [miroir déformant](https://fr.wikipedia.org/wiki/Miroir_déformant) interactif. L'utilisateur voit en direct le flux de la *webcam* et peut créer, déplacer ou supprimer des points clés qui définissent une déformation appliquée en temps réel. Une dizaine de transformations pré-définies sont également proposées.

[![GREYC Warp](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f67726579635f776172705f616c6c2e706e67/greyc_warp_all.png "Source : https://gmic.eu/gmic40/thumbs/greyc_warp_all.png")](https://gmic.eu/gmic40/img/greyc_warp_all.jpg) *Fig. 4.3.1. L'application « GREYC Warp » vous laisse déformer le flux vidéo de votre webcam, de manière interactive, et non sans humour !*

Pour avoir testé ce démonstrateur en situation réelle lors d'expositions, ça fait beaucoup rire les enfants (mais pas les plus jeunes qui pensent que ça reflète vraiment l'apparence de leur tête et qui peuvent se mettre à pleurer). Une application toute simple mais néanmoins amusante !

5 G'MIC et le code créatif
----------

Ces quelques démonstrateurs esquissent déjà l'image d'un langage *G'MIC* adapté au [code créatif](https://fr.wikipedia.org/wiki/Code_créatif), qui consiste, selon *Wikipedia,* à *« utiliser la programmation informatique comme un moyen d'expression artistique (visuel, musical, littéraire, interactif, performatif…) à part entière »*.

### 5.1. Codes créatifs courts ###

En tant qu'ancien [*demomaker*](https://fr.wikipedia.org/wiki/Demomaking), le code créatif est forcément un domaine qui me tient à cœur, et j'écris et partage régulièrement des scripts courts sur [le forum de *G'MIC*](https://discuss.pixls.us/c/software/gmic/) pour expérimenter de nouvelles idées d'effets graphiques, ou en reproduire certains sur lesquels je suis tombé et que je trouve captivants.  
 Quelques-uns de ces effets récents sont décrits ci-dessous, avec à chaque fois, un accès vers le code source correspondant (script `.gmic`).

* **Agrégation limitée par diffusion tournoyante** : Cet effet est une variante de l'[agrégation limitée par diffusion](https://fr.wikipedia.org/wiki/Agrégation_limitée_par_diffusion), implémentant un système de particules en mouvement qui sont stoppées dès lors qu'elles rencontrent une masse d'éléments plus anciens, déjà immobiles. On ajoute à tout ça une rotation, un zoom inverse, une palette de couleurs, et le tour est joué ! Le [code source](https://pastebin.com/HFkeVxMK) de cet effet atteint difficilement les 36 lignes, commentaires inclus !

[![Diffusion-Limited-Aggregation (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f63635f646c612e706e67/cc_dla.png "Source : https://gmic.eu/gmic40/thumbs/cc_dla.png")](https://gmic.eu/gmic40/img/cc_dla.mp4) *Fig. 5.1.1. L'effet animé « Agrégation limitée par diffusion tournoyante », rendu par G'MIC.*

* **Courbe de Hilbert néon** : Cette animation stylise le dessin d'une [courbe de Hilbert](https://fr.wikipedia.org/wiki/Courbe_de_Hilbert) par un tracé incrémental faisant songer à un néon. Ici, le [code source](https://pastebin.com/5ceJLvWT) est beaucoup plus conséquent (52 lignes 😉).

[![Hilbert-Curve (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f63635f68696c626572742e706e67/cc_hilbert.png "Source : https://gmic.eu/gmic40/thumbs/cc_hilbert.png")](https://gmic.eu/gmic40/img/cc_hilbert.mp4) *Fig. 5.1.2. L'effet animé « Courbe de Hilbert néon », rendu par G'MIC.*

* ***Morphing* de formes** : Ici, deux silhouettes se transforment l'une vers l'autre via un *morphing* continu. On utilise des [edgels](https://gmic.eu/reference/edgels.html) pour l'extraction et la paramétrisation du contour des deux silhouettes à transformer. Le [code source](https://pastebin.com/CULjvHnB) de cet effet revient à un nombre de lignes de code quand même plus raisonnable que précédemment (36 lignes).

[![Morph Shape (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f63635f6d6f72706873686170652e676966/cc_morphshape.gif "Source : https://gmic.eu/gmic40/img/cc_morphshape.gif")](https://gmic.eu/gmic40/img/cc_morphshape.gif) *Fig. 5.1.3. L'effet animé « Morphing de formes », rendu par G'MIC.*

* **Tunnel 3D** : Celui-ci est l'un de mes préférés. C'est certes un effet ultra-classique dans le monde de la scène démo, mais le rendu est sympa. Et avec ses 68 lignes, le [code source](https://pastebin.com/BuVziqhc) pour générer cette animation de 256 *frames* (qui cyclent parfaitement) reste dans les limites du raisonnable !

[![Tunnel 3D (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f63635f74756e6e656c33642e676966/cc_tunnel3d.gif "Source : https://gmic.eu/gmic40/img/cc_tunnel3d.gif")](https://gmic.eu/gmic40/img/cc_tunnel3d.gif) *Fig. 5.1.4. L'effet animé « Tunnel 3D », rendu par G'MIC.*

* **One-liner géométrique** : Le langage *G'MIC*, grâce à sa syntaxe délibérément concise, est un candidat idéal pour la création de [*one-liners*](https://fr.wikipedia.org/wiki/Uniligne). Une section entière de la [documentation de référence](https://gmic.eu/reference/funny_oneliners.html) est d'ailleurs dédiée à quelques *one-liners* amusants. Étant tombé par hasard sur [cette belle image](https://www.geogebra.org/m/vjxe7vzq) créée avec [GeoGebra](https://www.geogebra.org/?lang=fr) par [Georg Wengler](https://www.geogebra.org/u/gwengler), j'ai souhaité la retranscrire en langage *G'MIC* sous la forme d'une unique ligne de commande affichant une animation, et voici le résultat (et heureusement qu'une ligne de code ne se limite pas à 80 caractères !)

```
$ gmic 12,12,256,2,"a = 1 + x; b = 1 + y; t = lerp(0,2*pi*b,z/d); cos(a/b*t)*cexp([0,t])" 12,12,1,2,"S = crop(#-1,x,y,0,c,1,1,d#0,1); S = round(45*(S - avg(S)) + 50); draw(#-1,S,x,y,0,c,1,1,d#0,1)" rm. 1200,1200,1,3,255 repeat 256 { 12,12,1,1,"repeat (16,l, X = 100*[x,y] + round(I(#0,x,y,$> + l/16,2,2)); ellipse(#-1,X,1,1,0,1,0))" rm. +rs. 600 w. rm. wait 20 } rm
```

[![cos(ab) (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f696d672f63635f636f7361622e676966/cc_cosab.gif "Source : https://gmic.eu/gmic40/img/cc_cosab.gif")](https://gmic.eu/gmic40/img/cc_cosab.gif) *Fig. 5.1.5. L'effet animé « cos(ab) », rendu par G'MIC.*

L'ensemble de ces nouvelles animations se retrouve dans la section [*Gallery*](https://gmic.eu/gallery/codesamples.html) du site web de *G'MIC*.

### 5.2. Continuation de la série « *G'MIC Adventures* » ###

De temps en temps, j'essaie aussi de partager l'ensemble du processus permettant d'arriver (en partant de zéro) à un résultat de code créatif.  
 Et cela, rédigé sous la forme d'un petit article partagé sur le forum de *G'MIC*. Cette série d'articles est nommée « *[G'MIC Adventures](https://discuss.pixls.us/tag/gmic-adventures)* ». Je l'avais évoquée dans notre dernière dépêche. Deux nouveaux épisodes de cette série sont parus depuis :

* **Apprentissage d'un perceptron multi-couches pour la reproduction d'une image couleur** (*[G'MIC Adventure #5](https://discuss.pixls.us/t/g-mic-adventures-5-multi-layer-perceptron-tries-to-reproduce-an-image)*) :

Dans ce [cinquième épisode](https://discuss.pixls.us/t/g-mic-adventures-5-multi-layer-perceptron-tries-to-reproduce-an-image), on cherche à entrainer un réseau de neurones simple (un [perceptron](https://fr.wikipedia.org/wiki/Perceptron) multi-couches) capable d'apprendre une fonction image entière ![(x,y)\to(R,G,B)](data:image/svg+xml;base64,PHN2ZyB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGlu%0AayIgdmlld0JveD0iMCAtNzA1LjI3NzQ4OTAwMjU0MSA2OTYzLjU1NTU1NTU1%0ANTU1NyA5NDAuNTU0OTc4MDA1MDgxOCIgc3R5bGU9IndpZHRoOiAxNi4xNDVl%0AeDsgaGVpZ2h0OiAyLjE2OWV4OyB2ZXJ0aWNhbC1hbGlnbjogLTAuNjAyZXg7%0AIG1hcmdpbjogMXB4IDBweDsgcG9zaXRpb246IHN0YXRpYzsiIHhtbG5zPSJo%0AdHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnMgaWQ9Ik1hdGhKYXhf%0AU1ZHX2dseXBocyI+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTI4IiBzdHJva2Ut%0Ad2lkdGg9IjEwIiBkPSJNMzA0IC0xNjFsLTEyIC0xNmMtMTU4IDkwIC0yNDQg%0AMjU5IC0yNDQgNDI5YzAgMTg1IDg3IDMyOSAyNDcgNDI0bDkgLTE2Yy0xMzkg%0ALTExOSAtMTcwIC0yMTIgLTE3MCAtNDA1YzAgLTE4NiAzMCAtMjk5IDE3MCAt%0ANDE2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTkktNzgiIHN0cm9r%0AZS13aWR0aD0iMTAiIGQ9Ik0yNDMgMzU1bDEyIC01N2M3MCAxMDcgMTA3IDE0%0AMyAxNTEgMTQzYzI0IDAgNDEgLTE1IDQxIC0zN2MwIC0yMSAtMTQgLTM2IC0z%0ANCAtMzZjLTE5IDAgLTI4IDE3IC01MiAxN2MtMTggMCAtNTQgLTQ0IC05OCAt%0AMTIxYzAgLTcgMiAtMjEgOCAtNDVsMzIgLTEzNGM3IC0yOCAxNiAtNDEgMzAg%0ALTQxYzEzIDAgMjQgMTAgNDcgNDBjOSAxMiAxMyAxOCAyMSAyOGwxNSAtOWMt%0ANTggLTkwIC04NCAtMTE0IC0xMjIgLTExNCBjLTMyIDAgLTQ3IDE4IC01OSA2%0AOGwtMjkgMTE5bC04OCAtMTE5Yy00NCAtNTkgLTY0IC02OCAtOTUgLTY4cy01%0AMCAxNiAtNTAgNDJjMCAyMCAxNCAzNiAzNCAzNmM5IDAgMTkgLTQgMzIgLTEx%0AYzEwIC02IDIwIC05IDI2IC05YzExIDAgMzAgMTkgNTEgNDlsODIgMTE2bC0y%0AOCAxMjRjLTE0IDYwIC0yMSA2OCAtNDYgNjhjLTggMCAtMjAgLTIgLTM5IC03%0AbC0xOCAtNWwtMyAxNmwxMSA0YzYxIDIyIDk0IDI5IDExNyAyOSBjMjUgMCAz%0ANyAtMTggNTEgLTg2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTi0y%0AQyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0iTTgzIC0xNDFsLTEwIDE5YzU1IDM3%0AIDgzIDc0IDgzIDEwN2MwIDcgLTYgMTMgLTE0IDEzcy0xOCAtNCAtMjkgLTRj%0ALTM3IDAgLTU4IDE3IC01OCA1MXMyNCA1NyA2MCA1N2M0NSAwIDgwIC0zNSA4%0AMCAtODdjMCAtNjAgLTQzIC0xMjMgLTExMiAtMTU2WiI+PC9wYXRoPjxwYXRo%0AIGlkPSJTVElYV0VCTUFJTkktNzkiIHN0cm9rZS13aWR0aD0iMTAiIGQ9Ik0y%0ANDMgMTg2bDIxIC0xMTBjODUgMTQxIDEyMiAyMTMgMTIyIDI1N2MwIDE0IC03%0AIDIwIC0yNiAzMmMtMjAgMTMgLTI2IDIzIC0yNiAzOWMwIDIyIDE3IDM3IDQw%0AIDM3YzMwIDAgNTIgLTI1IDUyIC01NWMwIC01NyAtNDggLTE2NyAtMTMxIC0z%0AMDVjLTEwNCAtMTcyIC0yMTEgLTI4NyAtMjY4IC0yODdjLTMwIDAgLTUxIDE3%0AIC01MSA0M2MwIDIyIDE3IDQwIDM5IDQwYzM1IDAgMzUgLTI4IDYxIC0yOGMx%0AMyAwIDI1IDggNDggMzMgYzE4IDE5IDYzIDc4IDcxIDkxYzYgMTIgMTAgMjQg%0AMTAgMzVjMCA0MCAtNTUgMjY0IC04MiAzMzJjLTE5IDQ5IC0zNyA2NCAtNzcg%0ANjRjLTExIDAgLTIwIC0xIC0zMSAtNHYxN2MxMSAyIDIyIDQgMzIgNmMyMCA0%0AIDUzIDEwIDEwNyAxOGg0YzE1IDAgNjggLTE2NiA4NSAtMjU1WiI+PC9wYXRo%0APjxwYXRoIGlkPSJTVElYV0VCTUFJTi0yOSIgc3Ryb2tlLXdpZHRoPSIxMCIg%0AZD0iTTI5IDY2MGwxMiAxNmMxNTMgLTkyIDI0NCAtMjU5IDI0NCAtNDI5YzAg%0ALTE4NSAtODggLTMyNyAtMjQ3IC00MjRsLTkgMTZjMTQyIDExNyAxNzAgMjEx%0AIDE3MCA0MDVjMCAxODcgLTI1IDMwMiAtMTcwIDQxNloiPjwvcGF0aD48cGF0%0AaCBpZD0iU1RJWFdFQk1BSU4tMjE5MiIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0i%0ATTg1NiAyNTh2LTEwYy05NiAtNDEgLTE3MiAtMTE1IC0yMzggLTE5MWwtMjAg%0AMTljMjMgMzMgNTIgNjUgODIgOTZjOSA5IDE0IDIwIDE0IDI4YzAgMTAgLTgg%0AMjAgLTI2IDIwaC01OTh2NjZoNTk5YzEwIDAgMjYgMTIgMjYgMjJjMCA5IC00%0AIDE1IC0xNCAyNWMtMjkgMjggLTYwIDYzIC04MiA5NmwyMCAxOWM2NSAtNzUg%0AMTQxIC0xNTAgMjM3IC0xOTBaIj48L3BhdGg+PHBhdGggaWQ9IlNUSVhXRUJN%0AQUlOLTI4IiBzdHJva2Utd2lkdGg9IjEwIiBkPSJNMzA0IC0xNjFsLTEyIC0x%0ANmMtMTU4IDkwIC0yNDQgMjU5IC0yNDQgNDI5YzAgMTg1IDg3IDMyOSAyNDcg%0ANDI0bDkgLTE2Yy0xMzkgLTExOSAtMTcwIC0yMTIgLTE3MCAtNDA1YzAgLTE4%0ANiAzMCAtMjk5IDE3MCAtNDE2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VC%0ATUFJTkktNTIiIHN0cm9rZS13aWR0aD0iMTAiIGQ9Ik0xMzIgNjUzaDI1MmMx%0AMzIgMCAyMDQgLTU2IDIwNCAtMTQxYzAgLTQ4IC0yNSAtOTcgLTY2IC0xMjhj%0ALTMxIC0yNCAtNjQgLTM2IC0xMzEgLTUxbDg5IC0yMzVjMjIgLTU5IDQyIC04%0AMiA4NyAtODJ2LTE2aC0xNDdsLTEyMyAzMjRsLTY2IDVsLTU1IC0yMDNjLTEx%0AIC0zOSAtMTMgLTUzIC0xMyAtNjNjMCAtMzAgMTAgLTQxIDY3IC00N3YtMTZo%0ALTI0M3YxNmM1NSA3IDY5IDI2IDg1IDg1bDExOSA0MzFjNyAyNyAxMiA0NiAx%0AMiA2MyBjMCAxMSAtNyAyMyAtMTQgMjhjLTExIDcgLTE1IDggLTU3IDE0djE2%0Aek0zMDYgNTkzbC02MyAtMjI3YzI1IC00IDMzIC01IDUxIC01YzExOSAwIDE4%0AOSA1NyAxODkgMTUwYzAgNjkgLTQyIDExMiAtMTIwIDExMmMtMzEgMCAtNTIg%0ALTExIC01NyAtMzBaIj48L3BhdGg+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTJD%0AIiBzdHJva2Utd2lkdGg9IjEwIiBkPSJNODMgLTE0MWwtMTAgMTljNTUgMzcg%0AODMgNzQgODMgMTA3YzAgNyAtNiAxMyAtMTQgMTNzLTE4IC00IC0yOSAtNGMt%0AMzcgMCAtNTggMTcgLTU4IDUxczI0IDU3IDYwIDU3YzQ1IDAgODAgLTM1IDgw%0AIC04N2MwIC02MCAtNDMgLTEyMyAtMTEyIC0xNTZaIj48L3BhdGg+PHBhdGgg%0AaWQ9IlNUSVhXRUJNQUlOSS00NyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0iTTcy%0AMiAzMTl2LTE2Yy02NSAtNCAtODIgLTE1IC05NyAtNzJsLTQ5IC0xODdjLTc3%0AIC00MyAtMTQ5IC02MiAtMjM3IC02MmMtODcgMCAtMTYyIDI1IC0yMTMgNzZj%0ALTQ3IDQ4IC03NCAxMjUgLTc0IDE5M2MwIDE0MSA3NSAyNjggMTgzIDM0M2M2%0ANSA0NSAxNDEgNzIgMjIwIDcyYzQxIDAgOTAgLTcgMTM0IC0yNGMyMyAtOSAz%0AMyAtMTAgNDQgLTEwYzI2IDAgNDMgMTAgNjAgMzRsMTUgLTVsLTQ5IC0xOTds%0ALTE4IDMgYy0yIDQzIC0xNSA3OSAtMzcgMTA2Yy0zMSAzOCAtNzkgNTkgLTE0%0AMSA1OWMtNzkgMCAtMTQ3IC0zOCAtMTk1IC05OWMtNjUgLTgzIC0xMDYgLTE5%0ANCAtMTA2IC0zMDVjMCAtMTMxIDczIC0yMDkgMjAyIC0yMDljNDUgMCA4MyAx%0AMiAxMDUgMzRjMTIgMTIgMTcgMjQgMzkgMTAxYzIwIDY3IDI2IDkxIDI2IDEx%0AM2MwIDE4IC0xNCAzMCAtNDcgMzNsLTMyIDN2MTZoMjY3WiI+PC9wYXRoPjxw%0AYXRoIGlkPSJTVElYV0VCTUFJTi0yQyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0i%0ATTgzIC0xNDFsLTEwIDE5YzU1IDM3IDgzIDc0IDgzIDEwN2MwIDcgLTYgMTMg%0ALTE0IDEzcy0xOCAtNCAtMjkgLTRjLTM3IDAgLTU4IDE3IC01OCA1MXMyNCA1%0ANyA2MCA1N2M0NSAwIDgwIC0zNSA4MCAtODdjMCAtNjAgLTQzIC0xMjMgLTEx%0AMiAtMTU2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTkktNDIiIHN0%0Acm9rZS13aWR0aD0iMTAiIGQ9Ik0xMzAgNjUzaDI1MGMxMzkgMCAyMDggLTUx%0AIDIwOCAtMTUwYzAgLTU0IC0yOCAtODkgLTY0IC0xMTNjLTMxIC0yMSAtNjgg%0ALTMwIC0xMTEgLTM5di0xYzg2IC0yNiAxMjYgLTc5IDEyNiAtMTUwYzAgLTEz%0ANCAtMTEzIC0yMDAgLTI3NSAtMjAwaC0yNzJ2MTZjNTUgOCA2NiAxOCA4MyA4%0AMGwxMjEgNDM2YzcgMjUgMTEgNDkgMTEgNjRjMCAyOSAtMTQgMzYgLTc3IDQx%0AdjE2ek0yNDggMzYzaDM4YzEzMSAwIDIwMSA1MyAyMDEgMTUyIGMwIDc0IC0z%0ANiAxMDggLTExNyAxMDhjLTM5IDAgLTQ5IDAgLTU5IC0zNnpNMjM4IDMzMWwt%0AMzIgLTExOWMtMjAgLTc2IC0zNSAtMTI3IC0zNSAtMTQwYzAgLTI4IDI1IC00%0AMiA2NyAtNDJjMTE1IDAgMTkzIDU5IDE5MyAxNzBjMCA2MiAtMjkgMTA2IC02%0ANyAxMTljLTIwIDcgLTYzIDEyIC0xMjYgMTJaIj48L3BhdGg+PHBhdGggaWQ9%0AIlNUSVhXRUJNQUlOLTI5IiBzdHJva2Utd2lkdGg9IjEwIiBkPSJNMjkgNjYw%0AbDEyIDE2YzE1MyAtOTIgMjQ0IC0yNTkgMjQ0IC00MjljMCAtMTg1IC04OCAt%0AMzI3IC0yNDcgLTQyNGwtOSAxNmMxNDIgMTE3IDE3MCAyMTEgMTcwIDQwNWMw%0AIDE4NyAtMjUgMzAyIC0xNzAgNDE2WiI+PC9wYXRoPjwvZGVmcz48ZyBzdHJv%0Aa2U9ImJsYWNrIiBmaWxsPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIwIiB0cmFu%0Ac2Zvcm09Im1hdHJpeCgxIDAgMCAtMSAwIDApIj48dXNlIHhsaW5rOmhyZWY9%0AIiNTVElYV0VCTUFJTi0yOCI+PC91c2U+PHVzZSB4bGluazpocmVmPSIjU1RJ%0AWFdFQk1BSU5JLTc4IiB4PSIzMzgiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6%0AaHJlZj0iI1NUSVhXRUJNQUlOLTJDIiB4PSI3OTAiIHk9IjAiPjwvdXNlPjx1%0Ac2UgeGxpbms6aHJlZj0iI1NUSVhXRUJNQUlOSS03OSIgeD0iMTIxMSIgeT0i%0AMCI+PC91c2U+PHVzZSB4bGluazpocmVmPSIjU1RJWFdFQk1BSU4tMjkiIHg9%0AIjE2NjAiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJN%0AQUlOLTIxOTIiIHg9IjIyNzYiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJl%0AZj0iI1NUSVhXRUJNQUlOLTI4IiB4PSIzNDg1IiB5PSIwIj48L3VzZT48dXNl%0AIHhsaW5rOmhyZWY9IiNTVElYV0VCTUFJTkktNTIiIHg9IjM4MjMiIHk9IjAi%0APjwvdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJNQUlOLTJDIiB4PSI0%0ANDM5IiB5PSIwIj48L3VzZT48dXNlIHhsaW5rOmhyZWY9IiNTVElYV0VCTUFJ%0ATkktNDciIHg9IjQ4NjAiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJlZj0i%0AI1NUSVhXRUJNQUlOLTJDIiB4PSI1NTg3IiB5PSIwIj48L3VzZT48dXNlIHhs%0AaW5rOmhyZWY9IiNTVElYV0VCTUFJTkktNDIiIHg9IjYwMDkiIHk9IjAiPjwv%0AdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJNQUlOLTI5IiB4PSI2NjI1%0AIiB5PSIwIj48L3VzZT48L2c+PC9zdmc+%0A), c'est-à-dire un réseau capable de prédire une couleur ![(R,G,B)](data:image/svg+xml;base64,PHN2ZyB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGlu%0AayIgdmlld0JveD0iMCAtNzA1LjI3NzQ4OTAwMjU0MSAzNDc4LjMzMzMzMzMz%0AMzMzMzUgOTExLjU1NDk3ODAwNTA4MTgiIHN0eWxlPSJ3aWR0aDogOC4wNzJl%0AeDsgaGVpZ2h0OiAyLjE2OWV4OyB2ZXJ0aWNhbC1hbGlnbjogLTAuNjAyZXg7%0AIG1hcmdpbjogMXB4IDBweDsgcG9zaXRpb246IHN0YXRpYzsiIHhtbG5zPSJo%0AdHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnMgaWQ9Ik1hdGhKYXhf%0AU1ZHX2dseXBocyI+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTI4IiBzdHJva2Ut%0Ad2lkdGg9IjEwIiBkPSJNMzA0IC0xNjFsLTEyIC0xNmMtMTU4IDkwIC0yNDQg%0AMjU5IC0yNDQgNDI5YzAgMTg1IDg3IDMyOSAyNDcgNDI0bDkgLTE2Yy0xMzkg%0ALTExOSAtMTcwIC0yMTIgLTE3MCAtNDA1YzAgLTE4NiAzMCAtMjk5IDE3MCAt%0ANDE2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTkktNTIiIHN0cm9r%0AZS13aWR0aD0iMTAiIGQ9Ik0xMzIgNjUzaDI1MmMxMzIgMCAyMDQgLTU2IDIw%0ANCAtMTQxYzAgLTQ4IC0yNSAtOTcgLTY2IC0xMjhjLTMxIC0yNCAtNjQgLTM2%0AIC0xMzEgLTUxbDg5IC0yMzVjMjIgLTU5IDQyIC04MiA4NyAtODJ2LTE2aC0x%0ANDdsLTEyMyAzMjRsLTY2IDVsLTU1IC0yMDNjLTExIC0zOSAtMTMgLTUzIC0x%0AMyAtNjNjMCAtMzAgMTAgLTQxIDY3IC00N3YtMTZoLTI0M3YxNmM1NSA3IDY5%0AIDI2IDg1IDg1bDExOSA0MzFjNyAyNyAxMiA0NiAxMiA2MyBjMCAxMSAtNyAy%0AMyAtMTQgMjhjLTExIDcgLTE1IDggLTU3IDE0djE2ek0zMDYgNTkzbC02MyAt%0AMjI3YzI1IC00IDMzIC01IDUxIC01YzExOSAwIDE4OSA1NyAxODkgMTUwYzAg%0ANjkgLTQyIDExMiAtMTIwIDExMmMtMzEgMCAtNTIgLTExIC01NyAtMzBaIj48%0AL3BhdGg+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTJDIiBzdHJva2Utd2lkdGg9%0AIjEwIiBkPSJNODMgLTE0MWwtMTAgMTljNTUgMzcgODMgNzQgODMgMTA3YzAg%0ANyAtNiAxMyAtMTQgMTNzLTE4IC00IC0yOSAtNGMtMzcgMCAtNTggMTcgLTU4%0AIDUxczI0IDU3IDYwIDU3YzQ1IDAgODAgLTM1IDgwIC04N2MwIC02MCAtNDMg%0ALTEyMyAtMTEyIC0xNTZaIj48L3BhdGg+PHBhdGggaWQ9IlNUSVhXRUJNQUlO%0ASS00NyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0iTTcyMiAzMTl2LTE2Yy02NSAt%0ANCAtODIgLTE1IC05NyAtNzJsLTQ5IC0xODdjLTc3IC00MyAtMTQ5IC02MiAt%0AMjM3IC02MmMtODcgMCAtMTYyIDI1IC0yMTMgNzZjLTQ3IDQ4IC03NCAxMjUg%0ALTc0IDE5M2MwIDE0MSA3NSAyNjggMTgzIDM0M2M2NSA0NSAxNDEgNzIgMjIw%0AIDcyYzQxIDAgOTAgLTcgMTM0IC0yNGMyMyAtOSAzMyAtMTAgNDQgLTEwYzI2%0AIDAgNDMgMTAgNjAgMzRsMTUgLTVsLTQ5IC0xOTdsLTE4IDMgYy0yIDQzIC0x%0ANSA3OSAtMzcgMTA2Yy0zMSAzOCAtNzkgNTkgLTE0MSA1OWMtNzkgMCAtMTQ3%0AIC0zOCAtMTk1IC05OWMtNjUgLTgzIC0xMDYgLTE5NCAtMTA2IC0zMDVjMCAt%0AMTMxIDczIC0yMDkgMjAyIC0yMDljNDUgMCA4MyAxMiAxMDUgMzRjMTIgMTIg%0AMTcgMjQgMzkgMTAxYzIwIDY3IDI2IDkxIDI2IDExM2MwIDE4IC0xNCAzMCAt%0ANDcgMzNsLTMyIDN2MTZoMjY3WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VC%0ATUFJTi0yQyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0iTTgzIC0xNDFsLTEwIDE5%0AYzU1IDM3IDgzIDc0IDgzIDEwN2MwIDcgLTYgMTMgLTE0IDEzcy0xOCAtNCAt%0AMjkgLTRjLTM3IDAgLTU4IDE3IC01OCA1MXMyNCA1NyA2MCA1N2M0NSAwIDgw%0AIC0zNSA4MCAtODdjMCAtNjAgLTQzIC0xMjMgLTExMiAtMTU2WiI+PC9wYXRo%0APjxwYXRoIGlkPSJTVElYV0VCTUFJTkktNDIiIHN0cm9rZS13aWR0aD0iMTAi%0AIGQ9Ik0xMzAgNjUzaDI1MGMxMzkgMCAyMDggLTUxIDIwOCAtMTUwYzAgLTU0%0AIC0yOCAtODkgLTY0IC0xMTNjLTMxIC0yMSAtNjggLTMwIC0xMTEgLTM5di0x%0AYzg2IC0yNiAxMjYgLTc5IDEyNiAtMTUwYzAgLTEzNCAtMTEzIC0yMDAgLTI3%0ANSAtMjAwaC0yNzJ2MTZjNTUgOCA2NiAxOCA4MyA4MGwxMjEgNDM2YzcgMjUg%0AMTEgNDkgMTEgNjRjMCAyOSAtMTQgMzYgLTc3IDQxdjE2ek0yNDggMzYzaDM4%0AYzEzMSAwIDIwMSA1MyAyMDEgMTUyIGMwIDc0IC0zNiAxMDggLTExNyAxMDhj%0ALTM5IDAgLTQ5IDAgLTU5IC0zNnpNMjM4IDMzMWwtMzIgLTExOWMtMjAgLTc2%0AIC0zNSAtMTI3IC0zNSAtMTQwYzAgLTI4IDI1IC00MiA2NyAtNDJjMTE1IDAg%0AMTkzIDU5IDE5MyAxNzBjMCA2MiAtMjkgMTA2IC02NyAxMTljLTIwIDcgLTYz%0AIDEyIC0xMjYgMTJaIj48L3BhdGg+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTI5%0AIiBzdHJva2Utd2lkdGg9IjEwIiBkPSJNMjkgNjYwbDEyIDE2YzE1MyAtOTIg%0AMjQ0IC0yNTkgMjQ0IC00MjljMCAtMTg1IC04OCAtMzI3IC0yNDcgLTQyNGwt%0AOSAxNmMxNDIgMTE3IDE3MCAyMTEgMTcwIDQwNWMwIDE4NyAtMjUgMzAyIC0x%0ANzAgNDE2WiI+PC9wYXRoPjwvZGVmcz48ZyBzdHJva2U9ImJsYWNrIiBmaWxs%0APSJibGFjayIgc3Ryb2tlLXdpZHRoPSIwIiB0cmFuc2Zvcm09Im1hdHJpeCgx%0AIDAgMCAtMSAwIDApIj48dXNlIHhsaW5rOmhyZWY9IiNTVElYV0VCTUFJTi0y%0AOCI+PC91c2U+PHVzZSB4bGluazpocmVmPSIjU1RJWFdFQk1BSU5JLTUyIiB4%0APSIzMzgiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJN%0AQUlOLTJDIiB4PSI5NTQiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJlZj0i%0AI1NUSVhXRUJNQUlOSS00NyIgeD0iMTM3NSIgeT0iMCI+PC91c2U+PHVzZSB4%0AbGluazpocmVmPSIjU1RJWFdFQk1BSU4tMkMiIHg9IjIxMDIiIHk9IjAiPjwv%0AdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJNQUlOSS00MiIgeD0iMjUy%0ANCIgeT0iMCI+PC91c2U+PHVzZSB4bGluazpocmVmPSIjU1RJWFdFQk1BSU4t%0AMjkiIHg9IjMxNDAiIHk9IjAiPjwvdXNlPjwvZz48L3N2Zz4=%0A) correcte à partir d'un vecteur de coordonnées ![(x,y)](data:image/svg+xml;base64,PHN2ZyB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGlu%0AayIgdmlld0JveD0iMCAtNzA1LjI3NzQ4OTAwMjU0MSAxOTk4LjY2NjY2NjY2%0ANjY2NjcgOTQwLjU1NDk3ODAwNTA4MTgiIHN0eWxlPSJ3aWR0aDogNC42OTll%0AeDsgaGVpZ2h0OiAyLjE2OWV4OyB2ZXJ0aWNhbC1hbGlnbjogLTAuNjAyZXg7%0AIG1hcmdpbjogMXB4IDBweDsgcG9zaXRpb246IHN0YXRpYzsiIHhtbG5zPSJo%0AdHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnMgaWQ9Ik1hdGhKYXhf%0AU1ZHX2dseXBocyI+PHBhdGggaWQ9IlNUSVhXRUJNQUlOLTI4IiBzdHJva2Ut%0Ad2lkdGg9IjEwIiBkPSJNMzA0IC0xNjFsLTEyIC0xNmMtMTU4IDkwIC0yNDQg%0AMjU5IC0yNDQgNDI5YzAgMTg1IDg3IDMyOSAyNDcgNDI0bDkgLTE2Yy0xMzkg%0ALTExOSAtMTcwIC0yMTIgLTE3MCAtNDA1YzAgLTE4NiAzMCAtMjk5IDE3MCAt%0ANDE2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTkktNzgiIHN0cm9r%0AZS13aWR0aD0iMTAiIGQ9Ik0yNDMgMzU1bDEyIC01N2M3MCAxMDcgMTA3IDE0%0AMyAxNTEgMTQzYzI0IDAgNDEgLTE1IDQxIC0zN2MwIC0yMSAtMTQgLTM2IC0z%0ANCAtMzZjLTE5IDAgLTI4IDE3IC01MiAxN2MtMTggMCAtNTQgLTQ0IC05OCAt%0AMTIxYzAgLTcgMiAtMjEgOCAtNDVsMzIgLTEzNGM3IC0yOCAxNiAtNDEgMzAg%0ALTQxYzEzIDAgMjQgMTAgNDcgNDBjOSAxMiAxMyAxOCAyMSAyOGwxNSAtOWMt%0ANTggLTkwIC04NCAtMTE0IC0xMjIgLTExNCBjLTMyIDAgLTQ3IDE4IC01OSA2%0AOGwtMjkgMTE5bC04OCAtMTE5Yy00NCAtNTkgLTY0IC02OCAtOTUgLTY4cy01%0AMCAxNiAtNTAgNDJjMCAyMCAxNCAzNiAzNCAzNmM5IDAgMTkgLTQgMzIgLTEx%0AYzEwIC02IDIwIC05IDI2IC05YzExIDAgMzAgMTkgNTEgNDlsODIgMTE2bC0y%0AOCAxMjRjLTE0IDYwIC0yMSA2OCAtNDYgNjhjLTggMCAtMjAgLTIgLTM5IC03%0AbC0xOCAtNWwtMyAxNmwxMSA0YzYxIDIyIDk0IDI5IDExNyAyOSBjMjUgMCAz%0ANyAtMTggNTEgLTg2WiI+PC9wYXRoPjxwYXRoIGlkPSJTVElYV0VCTUFJTi0y%0AQyIgc3Ryb2tlLXdpZHRoPSIxMCIgZD0iTTgzIC0xNDFsLTEwIDE5YzU1IDM3%0AIDgzIDc0IDgzIDEwN2MwIDcgLTYgMTMgLTE0IDEzcy0xOCAtNCAtMjkgLTRj%0ALTM3IDAgLTU4IDE3IC01OCA1MXMyNCA1NyA2MCA1N2M0NSAwIDgwIC0zNSA4%0AMCAtODdjMCAtNjAgLTQzIC0xMjMgLTExMiAtMTU2WiI+PC9wYXRoPjxwYXRo%0AIGlkPSJTVElYV0VCTUFJTkktNzkiIHN0cm9rZS13aWR0aD0iMTAiIGQ9Ik0y%0ANDMgMTg2bDIxIC0xMTBjODUgMTQxIDEyMiAyMTMgMTIyIDI1N2MwIDE0IC03%0AIDIwIC0yNiAzMmMtMjAgMTMgLTI2IDIzIC0yNiAzOWMwIDIyIDE3IDM3IDQw%0AIDM3YzMwIDAgNTIgLTI1IDUyIC01NWMwIC01NyAtNDggLTE2NyAtMTMxIC0z%0AMDVjLTEwNCAtMTcyIC0yMTEgLTI4NyAtMjY4IC0yODdjLTMwIDAgLTUxIDE3%0AIC01MSA0M2MwIDIyIDE3IDQwIDM5IDQwYzM1IDAgMzUgLTI4IDYxIC0yOGMx%0AMyAwIDI1IDggNDggMzMgYzE4IDE5IDYzIDc4IDcxIDkxYzYgMTIgMTAgMjQg%0AMTAgMzVjMCA0MCAtNTUgMjY0IC04MiAzMzJjLTE5IDQ5IC0zNyA2NCAtNzcg%0ANjRjLTExIDAgLTIwIC0xIC0zMSAtNHYxN2MxMSAyIDIyIDQgMzIgNmMyMCA0%0AIDUzIDEwIDEwNyAxOGg0YzE1IDAgNjggLTE2NiA4NSAtMjU1WiI+PC9wYXRo%0APjxwYXRoIGlkPSJTVElYV0VCTUFJTi0yOSIgc3Ryb2tlLXdpZHRoPSIxMCIg%0AZD0iTTI5IDY2MGwxMiAxNmMxNTMgLTkyIDI0NCAtMjU5IDI0NCAtNDI5YzAg%0ALTE4NSAtODggLTMyNyAtMjQ3IC00MjRsLTkgMTZjMTQyIDExNyAxNzAgMjEx%0AIDE3MCA0MDVjMCAxODcgLTI1IDMwMiAtMTcwIDQxNloiPjwvcGF0aD48L2Rl%0AZnM+PGcgc3Ryb2tlPSJibGFjayIgZmlsbD0iYmxhY2siIHN0cm9rZS13aWR0%0AaD0iMCIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgLTEgMCAwKSI+PHVzZSB4%0AbGluazpocmVmPSIjU1RJWFdFQk1BSU4tMjgiPjwvdXNlPjx1c2UgeGxpbms6%0AaHJlZj0iI1NUSVhXRUJNQUlOSS03OCIgeD0iMzM4IiB5PSIwIj48L3VzZT48%0AdXNlIHhsaW5rOmhyZWY9IiNTVElYV0VCTUFJTi0yQyIgeD0iNzkwIiB5PSIw%0AIj48L3VzZT48dXNlIHhsaW5rOmhyZWY9IiNTVElYV0VCTUFJTkktNzkiIHg9%0AIjEyMTEiIHk9IjAiPjwvdXNlPjx1c2UgeGxpbms6aHJlZj0iI1NUSVhXRUJN%0AQUlOLTI5IiB4PSIxNjYwIiB5PSIwIj48L3VzZT48L2c+PC9zdmc+%0A) donné en entrée. Il est particulièrement intéressant de visualiser l'image couleur que le réseau est capable de reproduire à chaque itération de son apprentissage (figure ci-dessous), et ce, jusqu'à convergence.

[![MLP (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f63635f6d6c702e706e67/cc_mlp.png "Source : https://gmic.eu/gmic40/thumbs/cc_mlp.png")](https://gmic.eu/gmic40/img/cc_mlp.mp4) *Fig. 5.2.1. Reconstruction itérative d'une image couleur obtenue par l'apprentissage d'un perceptron multi-couches.*

* **S'amuser avec l'équation d'ondes** (*[G'MIC Adventure #6](https://discuss.pixls.us/t/gmic-adventure-6-playing-with-the-wave-equation)*) :

Dans ce [sixième épisode](https://discuss.pixls.us/t/gmic-adventure-6-playing-with-the-wave-equation), on s'intéresse à l'implémentation en *G'MIC* de l'[équation d'ondes](https://fr.wikipedia.org/wiki/Équation_des_ondes) et ses possibilités pour appliquer des effets de déformations amusants sur des images, comme l'illustre la figure suivante qui correspond au résultat obtenu à la toute fin de l'article.

[![Wave equation (animation)](https://img.linuxfr.org/img/68747470733a2f2f676d69632e65752f676d696334302f7468756d62732f63635f77617665732e706e67/cc_waves.png "Source : https://gmic.eu/gmic40/thumbs/cc_waves.png")](https://gmic.eu/gmic40/img/cc_waves.mp4) *Fig. 5.2.2. Application d'une équation d'ondes anisotrope pour la déformation d'une image le long de ses contours.*

Les exemples présentés dans cette section montrent que *G'MIC* a du potentiel pour le code créatif, notamment pour l'expérimentation rapide de codes d'effets graphiques. Le fait qu'il soit utilisable en ligne de commande (via la commande [`gmic`](https://gmic.eu/reference/)) en fait un allié précieux pour générer des animations ou pour modifier des lots d'images de manière automatisée.

6. Autres nouvelles liées au projet
----------

Pour finir cette longue dépêche, voici en vrac quelques autres nouvelles notables liées au projet :

* **Diffusion de *G'MIC*** : Avec le temps, la diffusion de *G'MIC* s'accélère et son installation se simplifie. Notons tout d'abord que *G'MIC-Qt* a été parmi les premiers greffons disponibles lors de la sortie de la version majeure **3.2** de *GIMP*. L'installation de ce greffon est maintenant aussi largement simplifiée pour les utilisateurs de *macOS*, grâce au travail remarquable des empaqueteurs de *MacPorts*, qui en proposent [une version toujours très à jour](https://ports.macports.org/port/gmic-gimp/).

Nous avons également appris que *G'MIC* suscite l'intérêt des projets suivants :

1. Le projet [G'MIC-GEGL](https://discuss.pixls.us/t/gmic-gegl-release-0-1-0) a pour objectif d'exposer les différents filtres du greffon *G'MIC-Qt* directement sous forme de nœuds [GEGL](https://fr.wikipedia.org/wiki/GEGL), qui est la bibliothèque de traitement utilisée en interne dans *GIMP*. Cela voudrait dire que les effets de *G'MIC-Qt* pourraient à terme être utilisés dans des calques d'effets non-destructifs de *GIMP*.
2. Le projet [PhotoFlare](https://photoflare.io/) est un nouvel éditeur d'images numériques multi-plateformes, et son développeur a annoncé [y avoir intégré le greffon *G'MIC-Qt*](https://photoflare.io/what-gmic-adds-to-photoflare/) afin de profiter de ses centaines de filtres proposés.
3. Le projet [`gmic-affinity`](https://github.com/dstrupl/gmic-affinity) se propose de développer un greffon en *Rust* pour *Affinity Photo*, pour exposer le greffon *G'MIC-Qt* aux utilisateurs. Ce dernier est normalement déjà fonctionnel pour ce logiciel, via l'API *8bf* (comme le montre [cette vidéo](https://www.youtube.com/watch?v=iD_lD_azvFA)), mais malheureusement pas encore pour les utilisateurs de *macOS*.
4. Enfin, notons l'arrivée de *G'MIC-Qt* sur le [Snap Store](https://snapcraft.io/gimp-plugins-gmic), proposant ainsi une façon alternative d'installer notre greffon pour *GIMP*.

* **Exposé** : Début mai 2026, j'ai eu l'occasion de faire un bref passage au laboratoire [*LRDE de l'EPITA*](https://www.lre.epita.fr/lrde), sympathiquement invité par [Marc Espie](https://www.lre.epita.fr/members/marc-espie/) (enseignant et l'un des développeurs du projet [OpenBSD](https://www.openbsd.org/)), où j'ai donné une présentation intitulée « *25 ans de développement libre pour le traitement des images numériques* ». Une vidéo de cette présentation a été captée et [mise sur YouTube](https://www.youtube.com/watch?v=tLWUgxRPYbw).

7. Conclusion
----------

Cette version **4.0** marque un jalon important pour *G'MIC* : dix-huit ans après la première ligne de code, le projet a montré qu'un logiciel *open-source* né au sein d'un laboratoire de recherche public, et aux ressources modestes, peut s'installer durablement dans le paysage du graphisme numérique libre, et continuer à innover grâce à son écosystème ouvert et extensible.

Cette dépêche a cherché a montrer la maturité et la polyvalence de *G'MIC*. C'est un cadriciel multi-usages dont les interfaces variées peuvent toucher des publics différents, de l'artiste numérique au bidouilleur de la ligne de commande, en passant par le chercheur en traitement d'images, à partir du moment où une image numérique entre en jeu !

C'est aussi l'occasion de rappeler que rien de tout cela n'aurait été possible sans l'écosystème bienveillant qui gravite autour du projet. Nous tenons à remercier chaleureusement nos partenaires académiques (le *CNRS*, l'*ENSICAEN*, l'Université de Caen, la direction du *GREYC*), ainsi que l'ensemble de la communauté (testeurs, empaqueteurs, vidéastes et utilisateurs du quotidien). Votre soutien est très apprécié.

Les idées fourmillent, l'envie de triturer des pixels est toujours aussi présente, et on espère donc pouvoir continuer à développer et valoriser ce cadriciel libre comme il se doit dans le futur.

Y aura-t-il une nouvelle dépêche l'année prochaine ? L'avenir nous le dira !

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/g-mic-4-0-la-quadrature-du-pixel-plus-facile-que-jamais.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144862/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/g-mic-4-0-la-quadrature-du-pixel-plus-facile-que-jamais#comments)