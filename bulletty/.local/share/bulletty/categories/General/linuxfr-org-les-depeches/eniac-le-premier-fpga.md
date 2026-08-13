+++
title = "ENIAC, le premier FPGA ?"
description = "Les employés de chez Xilinx aiment à raconter qu'ils sont les inventeurs du FPGA. Avec leurs glorieux XC2064 ils auraient été les inventeurs du concept "
date = "2026-07-30T16:51:12Z"
url = "https://linuxfr.org/news/eniac-le-premier-fpga"
author = "martoni"
text = ""
lastupdated = "2026-08-13T22:13:29.430831191Z"
seen = false
+++

Les employés de chez Xilinx aiment à raconter qu'ils sont les inventeurs du [FPGA](https://fr.wikipedia.org/wiki/Circuit_logique_programmable). Avec leurs glorieux [XC2064](https://spectrum.ieee.org/chip-hall-of-fame-xilinx-xc2064-fpga) ils auraient été les inventeurs du concept et les premiers à en commercialiser.

![Blueprint du XC2064](https://img.linuxfr.org/img/68747470733a2f2f7777772e616d642e636f6d2f636f6e74656e742f64616d2f616d642f656e2f696d616765732f626c6f67732f64657369676e732f70726f6a656374732f70722d626c6f672d6173736574732f616d645f626c6f675f696d6167655f667067615f343074685f616e6e69766572736172795f312e706e67/amd_blog_image_fpga_40th_anniversary_1.png "Source : https://www.amd.com/content/dam/amd/en/images/blogs/designs/projects/pr-blog-assets/amd_blog_image_fpga_40th_anniversary_1.png")  
*[Deux ingénieurs de xilinx](https://spectrum.ieee.org/chip-hall-of-fame-xilinx-xc2064-fpga) en plein placement-routage du XC2064 ?*

En est-on si sûr ?

Tout d’abord revenons à la définition d’un FPGA :

**F**ield **P**rogrammable **G**ate **A**rray

Littéralement: Grille de portes programmable sur le champ.

Les FPGA sont des composants munis d’éléments logiques plus ou moins complexes dont les connexions ne sont pas figées. Les connexions peuvent être re-programmées pour modifier l’architecture électronique du système en fonction du besoin sans avoir à démonter l’appareil à chaque fois.

L’aspect *programmable* ne doit pas être vu dans le sens d’un programme que l’on télécharge dans une mémoire pour qu’il soit exécuté par un processeur. Non, le bon mot serait plutôt *configurable* ou re-câblable (quel beau mot) au besoin.

Dans un FPGA moderne, les blocs que l’on peut connecter sont des éléments logiques (LUT), des multiplexeurs, des multiplieurs, des additionneurs, les sérialiseurs/dé-sérialiseur (serdes) sans oublier les blocs de mémoires ram (BRAM). Des [PLL](https://fr.wikipedia.org/wiki/Boucle_à_phase_asservie) viennent en renfort pour générer des horloges pour cadencer tout ce bazar.

![Mapping du Gatemate A1](https://img.linuxfr.org/img/68747470733a2f2f636f6c6f676e65636869702e636f6d2f77702d636f6e74656e742f75706c6f6164732f63686970766965772e706e67/chipview.png "Source : https://colognechip.com/wp-content/uploads/chipview.png")  
*Plan du [Gatemate A1](https://colognechip.com/programmable-logic/gatemate/) de Colognechip, les entrées sorties sont à la périphérie et les blocs logique au centre*

Le « re-câblage » (on parle plutôt de configuration) est effectué en téléchargeant un fichier appelé *bitstream* dans la mémoire RAM ou flash du FPGA.

Mais alors revenons à l'[ENIAC](https://fr.wikipedia.org/wiki/ENIAC). Cette machine est considérée comme le premier ordinateur électronique. Quand on pense ordinateur vient tout de suite l’idée d’un processeur qui exécute des instructions enregistrées dans une mémoire.

Ça n’est pourtant pas le cas des débuts de l’ENIAC qui est conçu pour faire des calculs très rapidement, notamment pour calculer des tables de tir de missiles (pour tuer des gens). Et à chaque nouveau calcul il faut le re-câbler.

Les blocs que l’on peut connecter sont des multiplieurs, des additionneurs, des tables de fonctions ([à roulettes](https://fr.wikipedia.org/wiki/Fichier:Classic_shot_of_the_ENIAC.jpg)) ainsi que des imprimantes et des lecteurs de cartes perforées pour les entrées/sorties.

![Plan «mapping» de l’ENIAC](https://img.linuxfr.org/img/68747470733a2f2f686973746f72796f66696e666f726d6174696f6e2e636f6d2f696d616765732f53637265656e5f53686f745f323032302d30392d30365f61745f382e35352e31335f414d5f6269672e706e67/Screen_Shot_2020-09-06_at_8.55.13_AM_big.png "Source : https://historyofinformation.com/images/Screen_Shot_2020-09-06_at_8.55.13_AM_big.png")  
*Plan de l’ENIAC, il y quelques similitudes avec un FPGA. Cependant les blocs sont à l’extérieur et le multiplexage et les entrées sorties se font au centre. (sources [https://historyofinformation.com](https://historyofinformation.com))*

Pour re-câbler l’ENIAC point de *bitstream* mais des équipes de câbleuses qui reconfigurent la machine pour lancer un nouveau calcul histoire de faire péter une bombe plus fort (nucléaire) ou de bien atteindre la cible avec un canon.

![Câbleuse en action](https://img.linuxfr.org/img/68747470733a2f2f7777772e736967617263682e6f72672f77702d636f6e74656e742f75706c6f6164732f323032312f30322f526570726f6772616d6d696e675f454e4941432d393830783633382e706e67/Reprogramming_ENIAC-980x638.png "Source : https://www.sigarch.org/wp-content/uploads/2021/02/Reprogramming_ENIAC-980x638.png")  
*Câbleuses en pleine action, maintenant on télécharge un bitstream (source [sigarch](https://www.sigarch.org/eniac-day/))*

Mais, attendez, cette description ressemble furieusement à la description d’un FPGA non ?

Et oui, Xilinx n’a qu’à bien se tenir, le premier ordinateur électronique était également le premier FPGA de l’histoire. [D’autres ont fait le lien également](https://www.sigarch.org/eniac-day/).

Peut-être pourrait-on l’inclure dans les outils de synthèse libre comme [Yosys](https://github.com/yosyshq/yosys) ?

Pas sûr.

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/eniac-le-premier-fpga.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144880/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/eniac-le-premier-fpga#comments)