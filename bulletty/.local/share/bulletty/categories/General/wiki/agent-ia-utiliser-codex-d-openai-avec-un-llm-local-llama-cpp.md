+++
title = "Agent IA : Utiliser codex d'OpenAI avec un LLM Local (llama.cpp)"
description = "codex_logoIntroduction Codex est l'agent IA d'OpenAI. Il en existe bien d'autres tels qus Gemmini-cli, ou Claude Code.   Seulement, ces agents fonctionnent avec un abonnement payant aux plateformes associ"
date = "2026-08-01T18:35:39Z"
url = "https://www.linuxtricks.fr/wiki/agent-ia-utiliser-codex-d-openai-avec-un-llm-local-llama-cpp"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.288317807Z"
seen = false
+++

![codex_logo](https://www.linuxtricks.fr/upload/codex_logo.png "codex_logo")

Introduction
----------

 Codex est l'agent IA d'OpenAI. Il en existe bien d'autres tels qus Gemmini-cli, ou Claude Code.  

 Seulement, ces agents fonctionnent avec un abonnement payant aux plateformes associées (OpenAI, ChatGPT pour Codex, Google pour Gemmini-cli et Anthropic, Claude pour Claude Code).  

 Dans ce mémo, on va voir comment installer Codex mais modifier le paramétrage pour le connecter avec un LLM qu'on a auto-hébergé avec llama.cpp !  
 Je vous renvoie sur cet article sur la mise en place de llama.cpp : [https://www.linuxtricks.fr/wiki/ia-installer-llama-cpp-pour-servir-des-llm-nvidia-amd-cpu](https://www.linuxtricks.fr/wiki/ia-installer-llama-cpp-pour-servir-des-llm-nvidia-amd-cpu)  

Je vous conseille d'installer Codex sur une machine spécifique, car elle va pouvoir agir sur votre système et donc c'est potentiellement à rique !  
 Ne laissons pas les LLM faire n'importe quoi sur notre système !  

Installer Codex
----------

 Le projet Codex est sur Github : [https://github.com/openai/codex](https://github.com/openai/codex)  

 Bien qu'il y ait un beau script d'install comme je les aime pas :  

Code BASH :

```
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

 On va récupérer la dernière version via :  

Code BASH :

```
wget https://github.com/openai/codex/releases/latest/download/codex-x86_64-unknown-linux-musl.tar.gz
```

 On extrait :  

Code BASH :

```
tar -xf codex-x86_64-unknown-linux-musl.tar.gz
```

 Et on range :  

Code BASH :

```
mv codex-x86_64-unknown-linux-musl /usr/local/bin/codex
```

 On installera aussi bubblewrap pour le bac à sable !  
 Fedora/Red Hat EL et dérivées :  

Code BASH :

```
dnf install bubblewrap
```

 Debian, Ubuntu et dérivées :  

Code BASH :

```
apt install bubblewrap
```

Configuration
----------

 On va créer le dossier de config pour notre utilisateur :  

Code BASH :

```
mkdir ~/.codex
```

 Et on créé un fichier de config par défaut :  

Code BASH :

```
vi ~/.codex/config.toml
```

 Voici le contenu, où on définit un modèle provider, un nom de modèle (on met ce qu'on veut car llamacpp nous délivre qu'un seul modèle) et on donne l'URL de l'API :  

Code TEXT :

```
model_provider = "llamacpp"
model = "linuxtricks"
 
[model_providers.llamacpp]
name = "llama.cpp"
base_url = "http://fedocloudia.linuxtricks.fr:35515/v1"
wire_api = "responses"
```

*Note : Ne cherchez pas le domaine ici n'est pas publié dans les DNS externes ! Utilisez votre API à llama.cpp*  

Lancer Codex
----------

 Pour lancer codex, avec notre config spécifique :  

Code BASH :

```
codex
```

Ne pas lancer en tant que root codex sauf si vous savez ce que vous faites.  
 Pour le tuto j'ai déployé un conteneur et j'ai tout fait en tant que root mais c'est plus que déconseillé évidemment !!  

 Et Codex se lance et son répertoire de travail est le répertoire dans lequel on était quand on l'a invoqué :  

![codex-lancement](https://www.linuxtricks.fr/upload/codex-lancement.png "codex-lancement")

 Et on peut poser nos questions, l'agent agit :  

![codex-question](https://www.linuxtricks.fr/upload/codex-question.png "codex-question")

 Par défaut, les commandes sensibles demandent une approbation !  

![codex-approuver](https://www.linuxtricks.fr/upload/codex-approuver.png "codex-approuver")

Permissions et autorisations
----------

 On pourra affiner quelques permissions.  

 Modifier l'approbation avec **-a** suivant les valeurs :  
 \- **untrusted** : Seules les commandes "sûres" ne sont pas demandées à approbation (ls, cat sed) - Semble être l'option par défaut  
 \- **on-request** : Le modèle décide de quand demander l'approbation  
 \- **never** : Ne jamais demander l'approbation (DANGEREUX)  

 Par défaut, quand vous lancez codex, il a accès :  
 \- en lecture seule à tout le système de fichiers  
 \- en écriture restreinte uniquement au répertoire de travail actuel et à ses sous-dossiers, ainsi qu'au dossier temporaire /tmp.  

**DANGER DANGER** : Si vous souhaitez quand même changer les permissions de codex en dehors du répertoire de travail, regardez les options de paramétrage de la sandbox avec **-s**. Mais je n'en dis pas plus ici !