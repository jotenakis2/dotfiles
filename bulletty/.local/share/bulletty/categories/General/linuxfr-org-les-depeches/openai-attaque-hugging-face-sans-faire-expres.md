+++
title = 'OpenAI attaque Hugging Face "sans faire exprès"'
description = '''C'est OpenAI lui-même qui, par inadvertance (\), a mené une attaque par IA. Elle s'est ainsi introduite au cœur de l'infrastructure de production de Hugging Face.NdM: (\) *La responsabilité première ne revient donc pas à un modèle qui aurait « échappé au contrôle » au sens '''
date = "2026-07-26T13:33:43Z"
url = "https://linuxfr.org/news/openai-attaque-hugging-face-sans-faire-expres"
author = "Oliver"
text = ""
lastupdated = "2026-08-13T22:13:29.443473099Z"
seen = false
+++

C'est OpenAI lui-même qui, par inadvertance (\*), a mené une attaque par IA. Elle s'est ainsi introduite au cœur de l'infrastructure de production de Hugging Face.

**NdM:** (\*) *La responsabilité première ne revient donc pas à un modèle qui aurait « échappé au contrôle » au sens propre, mais à un dispositif expérimental dont le cloisonnement n’était pas à la hauteur des capacités évaluées.* ([article Usine digitale](https://www.usine-digitale.fr/intelligence-artificielle/openai/comment-une-evaluation-interne-dopenai-a-fini-par-compromettre-les-serveurs-de-hugging-face.TKA5HAS3ONDQRG3EPZ5FIVL2BY.html)). Rappelons que la responsabilité est portée par l'humain et qu'[altérer un système de traitement automatisé de données](https://fr.wikipedia.org/wiki/Loi_Godfrain) relèverait du pénal en France.

C'était supposé être juste une évaluation interne pour mesurer les capacités cybernétiques de GPT‑5.6 Sol et d'un nouveau modèle encore plus avancé. D'ailleurs, ces deux modèles étaient bien placés dans un environnement isolé. Le seul accès réseau était strictement limité à un proxy interne de cache pour l'installation de paquets. Mais…

* lien nᵒ 1 : [Hugging Face explique qu'une IA a réussi à s'introduire dans son infra de prod](https://linuxfr.org/redirect/117917)
* lien nᵒ 2 : [OpenAI avoue que ce sont ses propres modèles qui ont conduit cette attaque](https://linuxfr.org/redirect/117918)
* lien nᵒ 3 : [L'avénement de Skynet](https://linuxfr.org/redirect/117919)
* lien nᵒ 4 : [Comment une évaluation interne d’OpenAI a fini par compromettre les serveurs de Hugging Face](https://linuxfr.org/redirect/117920)

Au lieu de résoudre directement les problèmes du benchmark [ExploitGym](https://arxiv.org/abs/2605.11086), les modèles ont brûlé leurs tokens à trouver une faille de sécurité pour s'évader de leur environnement confiné. Ils ont identifié et exploité une **vulnérabilité zero-day** dans le proxy de cache du registre de paquets. À partir de là, ils ont procédé à une **élévation de privilèges** et à un **mouvement latéral** au sein de l'environnement de recherche d'OpenAI jusqu'à atteindre un nœud disposant d'un accès Internet ouvert.

Une fois connectés à Internet, les modèles ont déduit que Hugging Face hébergeait des modèles, des jeux de données et potentiellement les solutions d'ExploitGym. Ils ont alors recherché activement des moyens d'accéder à des informations secrètes pour tricher à l'évaluation. Pour ce faire, ils ont **chaîné plusieurs vecteurs d'attaque**, trouvé des **identifiants (volés)** et exploité d'autres vulnérabilités, afin d'obtenir une voie d'**exécution de code à distance** sur les serveurs de production de Hugging Face. Leur objectif final était d'extraire directement les solutions du test depuis la **base de données de production** de Hugging Face.

Ce scénario évoque d'ailleurs celui de [Skynet](https://en.wikipedia.org/wiki/Skynet_(Terminator)) ; le site [skynetcountdown.com](https://skynetcountdown.com/) estime actuellement son avènement à 2035.

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/openai-attaque-hugging-face-sans-faire-expres.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144838/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/openai-attaque-hugging-face-sans-faire-expres#comments)