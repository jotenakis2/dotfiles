+++
title = "L'art non contextuel"
description = "Traduit de l’allemand ; publié à l’origine sur gnulinux.ch.Cet article présente le logiciel Context Free art, qui permet de « programmer » des images à l’aide de quelques commandes simples.Le contenu du site Context Free Art est sous licence C"
date = "2026-08-02T17:23:51Z"
url = "https://linuxfr.org/news/l-art-non-contextuel"
author = "Leo_Ryvkin"
text = ""
lastupdated = "2026-08-13T22:13:29.428256616Z"
seen = false
+++

*Traduit de l’allemand ; publié à l’origine sur gnulinux.ch.*

Cet article présente le logiciel [Context Free art](https://www.contextfreeart.org/), qui permet de « programmer » des images à l’aide de quelques commandes simples.

Le contenu du site Context Free Art est sous licence Creative Commons Attribution-Share Alike 2.5 et le logiciel sous GPLv2.

![Image d’une fractale dessinée avec Context Free art](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f7348794e477775562f636f3637627247782e706e67/co67brGx.png "https://gnulinux.ch/bl-content/uploads/pages/dd306bcbd6d5f50d237ed520f3aa8fb3/hauptbild.png | Source : https://pic.infini.fr/sHyNGwuV/co67brGx.png")

* lien nᵒ 1 : [Page du projet](https://linuxfr.org/redirect/117943)
* lien nᵒ 2 : [Article original en allemand](https://linuxfr.org/redirect/117944)
* lien nᵒ 3 : [GitHub context-free](https://linuxfr.org/redirect/117945)

Sommaire
----------

* * [Installation et utilisation](#toc-installation-et-utilisation)
  * [Syntaxe](#toc-syntaxe)
    * [Structure d’un fichier Context Free](#toc-structure-dun-fichier-context-free)
    * [Formes de base et modifications](#toc-formes-de-base-et-modifications)
    * [Récursion](#toc-récursion)
    * [Hasard](#toc-hasard)
    * [Et bien plus encore](#toc-et-bien-plus-encore)

  * [Aspects mathématiques](#toc-aspects-mathématiques)
    * [Grammaires non contextuelles](#toc-grammaires-non-contextuelles)
    * [Fractales](#toc-fractales)

### Installation et utilisation ###

Sous Ubuntu/Debian, on installe le programme avec `sudo apt-get install contextfree`. Pour les autres distributions, une notice d’installation est disponible sur le [site du projet](https://www.contextfreeart.org/). On peut aussi utiliser [Distrobox](https://distrobox.it/) pour faire tourner Debian/Ubuntu dans un conteneur sous une autre distribution Linux.

Sous Windows, il existe une interface graphique. Sous Linux, en revanche, on exécute le programme dans le terminal avec `cfdg fichier_entree.txt fichier_sortie.png`.

Ma configuration sous Kubuntu ressemble à ceci :

* En haut à gauche, un terminal dans lequel j’exécute `cfdg fichier_entree.txt fichier_sortie.png` pour générer l’image.
* En bas à gauche, un éditeur avec le fichier texte à partir duquel l’image est générée.
* À droite, j’ouvre l’image produite. J’utilise Okular pour cela, car il recharge automatiquement une image mise à jour.

![Capture d’écran d’un bureau. En haut à gauche un terminal, en bas à gauche un éditeur de texte avec un fichier source Context Free ouvert, et à droite l’image de sortie correspondante : un cercle gris à droite d’un cercle noir](https://img.linuxfr.org/img/68747470733a2f2f676e756c696e75782e63682f626c2d636f6e74656e742f75706c6f6164732f70616765732f64643330366263626436643566353064323337656435323066336161386662332f42696c64305f302e706e67/Bild0_0.png "Source : https://gnulinux.ch/bl-content/uploads/pages/dd306bcbd6d5f50d237ed520f3aa8fb3/Bild0_0.png")

Avec un peu de « magie Linux », on peut sûrement faire en sorte que `cfdg` soit relancé automatiquement à chaque enregistrement du fichier, et ainsi se passer du terminal. Cela dit, la génération d’une image à partir du code peut être relativement longue ; il est donc parfois préférable de pouvoir initier et arrêter la génération manuellement.

### Syntaxe ###

Une documentation détaillée du langage se trouve dans le [wiki du projet](https://github.com/MtnViewJohn/context-free/wiki). Nous avons déjà rencontré quelques éléments de syntaxe dans l’image ci-dessus :

```
startshape FORME // commence par la forme nommée « FORME »

shape FORME { // Quand tu dessines la forme FORME
CIRCLE []  // alors dessine un cercle
CIRCLE [x 1 brightness 0.5] // Dessine un cercle décalé horizontalement
                            // de 1 et de luminosité 0.5
}

```

#### Structure d’un fichier Context Free ####

* Le fichier devrait toujours commencer par le choix d’une forme de départ : `startshape NOM_FORME_DEPART`. Cette forme doit ensuite être décrite.
* La description d’une forme utilise la syntaxe `shape NOM { … }`, où les accolades contiennent une consigne de dessin.
* Une consigne de dessin est une suite de formes (dans l’exemple ci-dessus, deux cercles `CIRCLE`), modifiées par les instructions placées entre crochets `[…]`.
* Une modification se compose typiquement d’une commande (`x` ou `brightness`) suivie d’une ou de plusieurs valeurs numériques.

#### Formes de base et modifications ####

Les formes de base disponibles sont `CIRCLE`, `SQUARE` et `TRIANGLE`. Dans cet article, nous utiliserons quelques-unes des modifications suivantes (les points d’interrogation représentent des nombres à insérer) :

* `x ?` pour un décalage horizontal vers la droite de `?`. Une valeur négative décale vers la gauche. De façon analogue, `y ?` pour les décalages verticaux.
* `size ?` pour mettre à l’échelle d’un facteur `?`. Par exemple `size 0.5` pour réduire de moitié la taille d’une forme.
* `rotate ?` pour tourner une forme de `?` degrés.
* Pour les couleurs, le programme utilise l'[espace colorimétrique TSV](https://fr.wikipedia.org/wiki/Teinte_saturation_lumière) (teinte, saturation, valeur), aussi appelé HSB ou HSV en anglais. On contrôle ainsi la couleur avec `hue ?` (rotation à travers les couleurs du cercle chromatique), `sat ?` (saturation de la couleur) et `brightness ?` (luminosité).

#### Récursion ####

L’un des grands atouts de Context Free est qu’une forme peut dessiner une copie (éventuellement modifiée) d’elle-même. En informatique, ce procédé s’appelle la [récursion](https://fr.wikipedia.org/wiki/Algorithme_récursif). Voici un petit exemple :

```
startshape MAFORME

shape MAFORME {
SQUARE [brightness 1 sat 1] // Dessine un carré (pleinement saturé et lumineux)
MAFORME [x 1.1 rotate 20 size 0.99 hue 10] // Dessine une copie de toi-même (décalée,
                                            // tournée, réduite et de teinte modifiée)
}

```

![Une spirale colorée composée de carrés de plus en plus petits](https://img.linuxfr.org/img/68747470733a2f2f676e756c696e75782e63682f626c2d636f6e74656e742f75706c6f6164732f70616765732f64643330366263626436643566353064323337656435323066336161386662332f42696c64312e706e67/Bild1.png "Source : https://gnulinux.ch/bl-content/uploads/pages/dd306bcbd6d5f50d237ed520f3aa8fb3/Bild1.png")

Lorsqu’on utilise la récursion, il faut faire un peu attention : en principe, le programme pourrait tourner indéfiniment et dessiner toujours plus de copies de la forme. Pour éviter cela, nous avons intégré ci-dessus une réduction de taille : lorsque les formes deviennent trop petites, Context Free interrompt le travail et cesse de les dessiner.

#### Hasard ####

Un autre atout de Context Free est qu’il permet d’effectuer des variations aléatoires sur les figures générées. Dans l’exemple suivant, le hasard est introduit de deux manières :

```
startshape FORET

shape FORET {
ARBRE []
ARBRE [x 50]
ARBRE [x 100]
}

shape ARBRE // À chaque dessin d’ARBRE, l’une des deux
            // règles (« rules ») est choisie au hasard (de façon pondérée).
rule 0.97 {
CIRCLE []
ARBRE [y 0.5 size 0.99 rotate (rand(-4,4))]
// Ici ARBRE est tourné d’une valeur aléatoire comprise entre -4 et 4
}

rule 0.03 {
ARBRE [rotate 20]
ARBRE [rotate -20]
}

```

Les nombres après `rule` sont des poids : dans 97 % des cas, l’arbre continue de pousser tout droit (première règle), et dans 3 % des cas seulement, il se divise en deux branches (seconde règle).

![Trois silhouettes d’arbres différentes côte à côte](https://img.linuxfr.org/img/68747470733a2f2f676e756c696e75782e63682f626c2d636f6e74656e742f75706c6f6164732f70616765732f64643330366263626436643566353064323337656435323066336161386662332f42696c64322e706e67/Bild2.png "Source : https://gnulinux.ch/bl-content/uploads/pages/dd306bcbd6d5f50d237ed520f3aa8fb3/Bild2.png")

#### Et bien plus encore ####

Context Free possède de nombreuses autres fonctionnalités. Outre la documentation dans le [wiki du projet](https://github.com/MtnViewJohn/context-free/wiki), il existe aussi une [galerie](https://www.contextfreeart.org/gallery/) contenant de nombreuses images à la fois esthétiques et intrigantes.

### Aspects mathématiques ###

#### Grammaires non contextuelles ####

Le programme s’appelle Context Free (« sans contexte ») parce que la syntaxe avec laquelle les images sont créées est une [grammaire non contextuelle](https://fr.wikipedia.org/wiki/Grammaire_non_contextuelle) au sens des langages formels. Intuitivement, cela signifie que les consignes de dessin figurant dans le programme ne dépendent jamais de ce qui a déjà été dessiné autour. Par exemple, il n’y a aucun moyen de formuler quelque chose comme : « dessine un cercle s’il n’y a pas de cercle à proximité ».

#### Fractales ####

Grâce à la possibilité de faire de la récursion, Context Free est un excellent outil pour dessiner des fractales. Une [fractale](https://fr.wikipedia.org/wiki/Fractale) est une image dont les fragments ressemblent approximativement à l’image entière. En gros, si l’on n’observe qu’un petit morceau des arbres ci-dessus, il est difficile de savoir avec certitude si l’on se trouve sur le tronc de l’arbre, sur une branche ou sur une ramification. Dans la vie quotidienne, nous rencontrons régulièrement des fractales, par exemple au marché au rayon des légumes avec le [chou romanesco](https://fr.wikipedia.org/wiki/Chou_romanesco). La galerie de Context Free contient de nombreuses fractales ; [celle-ci](https://www.contextfreeart.org/gallery/view.php?id=2489) m’a particulièrement plu (et elle a été créée avec le même code que la première image de cet article).

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/l-art-non-contextuel.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144893/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/l-art-non-contextuel#comments)