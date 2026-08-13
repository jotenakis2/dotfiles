+++
title = "Comprendre les notions et terminologies IA (prompt, token, modèle, B, quantization, it, MoE, MTP)"
description = """Introduction Quand on découvre les LLM et qu'on a enfin trouvé un modèle d'IA qui nous plaît, il reste des notions parfois abstraites quand on n'a pas étudié le sujet.   Au moment de télécharger le modèle, on se retrouve face à des dizaines de variantes.   On a des "B" """
date = "2026-08-09T07:14:22Z"
url = "https://www.linuxtricks.fr/wiki/comprendre-les-notions-et-terminologies-ia-prompt-token-modele-b-quantization-it-moe-mtp"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.274084544Z"
seen = false
+++

Introduction
----------

 Quand on découvre les LLM et qu'on a enfin trouvé un modèle d'IA qui nous plaît, il reste des notions parfois abstraites quand on n'a pas étudié le sujet.  

 Au moment de télécharger le modèle, on se retrouve face à des dizaines de variantes.  
 On a des "B" : 4B, 9B, 35B  
 On a des noms barbares comme Q4\_K\_M ou IQ3\_XXS  
 Certains sont bien plus légers que d'autres…  

![huggungface-b-q](https://www.linuxtricks.fr/upload/huggungface-b-q.png "huggungface-b-q")

 Pourtant, choisir la bonne version est important, car c'est ce qui détermine :  
 \- si l'IA sera intelligente  
 \- si elle sera rapide  
 \- si elle pourra démarrer sur notre matériel  

 Voici un petit mémo pour tout comprendre assez simplement. Celui que j'aurais voulu avoir avant de me plonger dans les détails plus techniques.  

Un modèle : le cerveau entraîné
----------

 Un modèle, c'est le résultat d'un entraînement. Pendant des semaines, sur des milliers de GPU, une IA a ingéré des quantités astronomiques de texte : des livres, des articles, du code, des forums, des encyclopédies…  
 À chaque fois qu'elle faisait une prédiction incorrecte sur le mot suivant, ses milliards de paramètres étaient légèrement ajustés pour faire mieux.  
 À la fin de cet entraînement, tous ces ajustements sont "figés" dans les paramètres. Le fichier GGUF (j'en parle plus bas) qu'on télécharge, c'est précisément ça : des milliards de nombres soigneusement ajustés qui encodent, de façon diffuse et mathématique, une représentation du langage et des connaissances du monde.  

 Le modèle ne "sait" pas les choses comme nous. Il n'a pas de mémoire, pas de conscience.  
 À chaque token généré, il calcule : "étant donné tout ce qui précède, quel est le mot le plus probable ?"  

 C'est une machine à complétion statistique, mais tellement bien entraînée qu'elle donne l'impression de comprendre.  
 C'est aussi pourquoi un modèle a une date de coupure : il ne connaît que ce sur quoi il a été entraîné jusqu'à une date spécifique.  
 Tout ce qui s'est passé après, il l'ignore, sauf si on le lui indique, par notre requête ou par l'utilisations d'outils externes.  

La notion de token : l'unité de base du langage
----------

 Un token n'est pas exactement un mot. C'est un morceau de mot, ou parfois plusieurs mots d'un coup. Les modèles ne lisent pas le texte lettre par lettre ni mot par mot : ils le découpent en fragments selon un vocabulaire qui leur est propre.  
 Quelques un exemple concret :  
Les chats sont gourmands et intelligents !  
 "chats" : 1 token  
 "gourmands" : 2 tokens  
 " !" : 1 token  

 En moyenne, on retient qu'1 token est 3/4 de mot en anglais, et un peu moins en français (notre langue est plus "découpée" par les tokenizers, qui sont souvent entraînés majoritairement sur de l'anglais).  

 C'est important car tout se mesure en tokens :  
 \- La vitesse s'exprime en tokens/seconde (t/s). Un bon modèle local tourne entre 10 et 50 t/s selon le matériel. En dessous c'est lent à lire quand le contenu est généré.  
 \- La mémoire de contexte (ce dont l'IA se souvient pendant une conversation) est elle aussi limitée en tokens. On parle de fenêtre de contexte (context window en anglais) : 4K, 8K, 32K, 128K tokens… C'est la quantité maximale de texte que le modèle peut "avoir en tête" en même temps. Ça corerspond aux questions posées, aux réponses fournies et aux instructions de départ.  

 Analogie : c'est comme un bureau de travail. Plus la fenêtre de contexte est grande, plus le bureau est grand, et plus on peut y étaler de documents. Mais un grand bureau demande aussi plus de mémoire pour être maintenu.  

La notion de prompt : ce qu'on dit à l'IA
----------

 Le prompt, c'est le texte qu'on envoie à l'IA. En français on pourrait dire "instruction" ou "requête", mais le terme prompt est universellement utilisé, y compris en français.  
 Il existe en réalité deux types de prompts qui coexistent à chaque échange :  

 Le system prompt : c'est une instruction de fond, invisible pour l'utilisateur final, qui définit le comportement général du modèle. C'est là qu'on lui dit "tu es un assistant spécialisé en cuisine" ou "réponds toujours en français et de façon concise". C'est ce prompt qu'on personnalisera quand on fera des développements internes pour orienter l'objectif du chatbot ou de l'outil développé. On peut y injecter du contexte dans le monde entreprise comme par exemple les infos de l'utilisateur connecté (nom, prénom, email, fonction, ...)  

 Le user prompt : c'est simplement ce qu'on tape dans la boîte de dialogue de l'interface web, ou en ligne de commande. C'est la question, la demande, le texte à corriger…  

 La qualité du prompt influe énormément sur la qualité de la réponse. Un modèle moyen avec un prompt bien formulé donne souvent de meilleurs résultats qu'un grand modèle avec une instruction vague. C'est ce qu'on appelle le prompt engineering, c'est à dire l'art de bien parler à une IA.  

La notion de B : les paramètres
----------

 Le "B" signifie Billion (milliard en français). Quand on dit qu'un modèle fait 8B, cela signifie qu'il possède 8 milliards de paramètres.  

 Un paramètre, c'est un nombre qui représente le poids d'une connexion entre deux neurones artificiels. Lors de son entraînement, l'IA a ajusté des milliards de ces poids pour apprendre les relations entre les mots, les idées, les faits.  

 Concrètement, un paramètre est un nombre qui définit l'importance d'une information par rapport à une autre. Plus il y en a, plus l'IA peut stocker de nuances, de faits historiques, de règles grammaticales complexes ou de concepts de programmation.  

 Il n'est pas toujours nécessaire de prendre le plus gros modèle disponible. En effet, la taille influe directement sur :  
 \- La mémoire : chaque paramètre doit être chargé dans la mémoire vive de la carte graphique (VRAM), ou à défaut dans la RAM, pour que l'IA puisse "réfléchir".  
 \- La vitesse : plus il y a de paramètres, plus le calcul est long pour générer chaque token (j'en parle plus bas).  

La notion de Q : la quantization
----------

 La quantization (ou quantification) consiste à réduire la taille de ces fameux paramètres sans trop "abîmer" l'intelligence du modèle.  

 Par défaut, un paramètre est stocké sous forme de nombre décimal très précis, appelé Floating Point 16 (FP16). Ce nombre occupe 16 bits de mémoire.  

Analogie mathématique : c'est comme avoir une précision à 10 chiffres après la virgule (ex : 0,8574362194). Très précis, mais très lourd.  
 Analogie musicale : c'est comme un fichier audio au format WAV ou AIFF, non compressé. Excellente qualité, mais encombrant.  

 La quantification consiste à réduire cette précision. On passe de 16 bits à 8, 4 ou même 2 bits. En 4-bit (Q4), on n'utilise plus que 4 bits par paramètre. Les valeurs sont "arrondies".  

Analogie mathématique : au lieu d'écrire 0,8574362194, on écrit 0,857.  
 Analogie musicale : au lieu du WAV, on obtient un MP3 à 320 kbps.  

 On gagne donc de la place : un modèle Qwen 3.5 9B en FP16 pèse environ 18 Go. Le même modèle en Q4 ne pèse plus que 5 à 6 Go.  

 Attention cependant : si on prend un modèle trop compressé (2-bit), l'IA perd sa capacité à distinguer les nuances fines. C'est là qu'elle commence à se tromper de mots, à perdre le fil ou à halluciner davantage.  

Analogie mathématique : au lieu d'écrire 0,8574362194, on écrit 0,9. On a perdu l'essentiel.  
 Analogie musicale : au lieu du WAV, on a un MP3 à 96 kbps : le son est dégradé.  

Comprendre les suffixes : Q4\_K\_M et compagnie
----------

 On a encore parfois des suffixes à cette notion de qantization. Un nom comme Q4\_K\_M se décompose ainsi :  
 \- Q4 : quantization en 4 bits (le nombre de bits par paramètre, comme expliqué au-dessus)  
 \- \_K : méthode K-quant : une quantization plus intelligente qui applique des précisions variables selon l'importance des couches du modèle. Résultat : meilleure qualité qu'un Q4 classique à taille équivalente.  
 \- \_M : Medium : indique le niveau de qualité au sein de cette méthode. On trouve aussi \_S (Small, plus léger) et \_L (Large, plus qualitatif).  

 Je trouve que le Q4\_K\_M est un très bon compromis entre compression et efficacité dans mes tests.  

Le suffixe it : quand un modèle apprend à discuter
----------

 Un modèle tout juste sorti de son entraînement initial n'est pas encore prêt à répondre correctement. Il sait "compléter du texte" de façon statistique (deviner la suite la plus probable d'une phrase), mais si on lui pose une question, il peut tout aussi bien continuer par une autre question, partir dans une liste de sujets similaires, ou ignorer complètement ce qu'on attend de lui. C'est ce qu'on appelle un modèle de base (base model).  

 Pour corriger ça, les créateurs du modèle lui font suivre une seconde étape d'entraînement, plus ciblée : on lui montre des milliers d'exemples de "bonnes" conversations, où une question est suivie d'une réponse utile, claire et pertinente. Le modèle apprend alors à se comporter comme un assistant : suivre une consigne, rester dans le sujet, répondre au format attendu (une explication, une liste, un résumé…![;)](https://www.linuxtricks.fr/images/smileys/6.gif ";)"), plutôt que de simplement continuer un texte au hasard.  

 Cette étape s'appelle l'instruction tuning, d'où le suffixe **it** (Instruction Tuned) qu'on retrouve dans un nom comme gemma-4-12b-it. C'est cette version qu'il faut télécharger pour dialoguer avec l'IA, car les réponses seront plus pertinentes.  

 À l'inverse, une version sans ce suffixe (par exemple juste gemma-4-12b) est un modèle de base : intéressant pour des chercheurs ou pour du fine-tuning personnalisé, mais moins bien adapté à un usage direct en conversation, puisqu'il n'a jamais appris à répondre proprement à une question.  

Le format GGUF : le modèle embarqué dans un seul fichier
----------

 Si les "B" représentent la capacité du cerveau et les "Q" la compression, le GGUF est le contenant : un fichier unique qui embarque l'ensemble du modèle, ses poids et ses métadonnées de configuration.  

 C'est le format natif utilisé par des logiciels comme LM Studio ou llama.cpp, les outils les plus populaires pour faire tourner des modèles en local, abordés sur ce site ou sur la chaine Youtube.  

 On le télécharge, on l'ouvre dans l'application, et c'est parti. Pas besoin d'installer quoi que ce soit d'autre.  

 À noter que d'autres formats coexistent, comme le safetensors (utilisé notamment par HuggingFace et des outils comme vLLM), mais ils sont moins adaptés à l'usage local grand public. Le GGUF reste la référence pour tourner un modèle sur sa propre machine.  

La notion de MoE et A3B : tous les experts ne travaillent pas en même temps
----------

 Un modèle classique (dit "dense") utilise absolument tous ses paramètres à chaque calcul, pour chaque token généré. Mais il existe une autre architecture, le MoE (Mixture of Experts, ou "mélange d'experts"), qui fonctionne différemment.  

 Dans un MoE, le modèle est en réalité découpé en plusieurs sous-réseaux spécialisés, appelés "experts". Pour chaque token, un petit routeur interne décide quels experts sont les plus pertinents à consulter, et seuls ceux-là sont activés. Les autres restent au repos.  

 C'est ce que traduit un nom comme 35B-A3B :  
 \- 35B : le nombre total de paramètres présents dans le modèle (tous les experts confondus)  
 \- A3B : "Active 3B", c'est-à-dire que seulement 3 milliards de paramètres sont réellement utilisés à chaque calcul  

Analogie : imaginons un cabinet médical avec 35 médecins spécialistes sous le même toit. Quand on arrive avec un problème, on ne consulte pas les 35 d'un coup : le secrétariat nous oriente vers les 2-3 spécialistes concernés. Le cabinet est grand (35B), mais la consultation ne mobilise que 3 médecins (A3B).  

 L'intérêt : on profite de la richesse de connaissances d'un gros modèle, avec la vitesse de calcul d'un petit. Le revers de la médaille, c'est que tous les experts doivent quand même être chargés en mémoire (RAM/VRAM), même ceux qui ne travaillent pas sur le moment. Un MoE demande donc autant de mémoire qu'un modèle dense de taille équivalente au total, mais calcule beaucoup plus vite.  

La notion de MTP : prédire plusieurs mots d'un coup
----------

 Normalement, un modèle génère ses tokens un par un : il calcule le suivant, l'écrit dans la réponse, puis reprend tout le calcul depuis le début pour deviner celui d'après, et ainsi de suite. C'est ce qui rend la génération parfois lente : chaque mot demande un aller-retour complet dans le modèle.  

 Le MTP (Multi-Token Prediction) vient accélérer ce processus. Le modèle a été entraîné pour proposer d'un coup plusieurs tokens suivants, pas un seul, en une seule passe de calcul. Un second mécanisme (léger et rapide) vérifie ensuite si ces tokens proposés sont corrects. Ceux qui sont validés sont gardés tels quels, ceux qui ne collent pas sont recalculés normalement. Comme la plupart des tokens proposés sont bons, on économise un grand nombre de passes de calcul, donc du temps, sans que la qualité du texte final ne change.  

Analogie : c'est la différence entre écrire une phrase mot par mot en relisant à chaque fois depuis le début, et écrire un brouillon de plusieurs mots d'un coup, qu'on valide ensuite en bloc. Le résultat final est identique, mais on va plus vite.  

 Concrètement, ça se traduit par des gains de vitesse de génération de l'ordre de 1,4x à 2x, sans perte de qualité, à condition d'avoir un peu de mémoire supplémentaire disponible (comptez 2 Go de plus). C'est pour ça qu'on trouve parfois deux versions du même modèle : une classique, et une avec le suffixe -MTP, à télécharger spécifiquement si on veut profiter de cette accélération.