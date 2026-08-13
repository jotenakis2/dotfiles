+++
title = "python : Créer et utiliser un environnement virtuel Python (venv)"
description = "python_logoIntroduction Lorsqu'on développe ou qu'on teste des applications Python, il est recommandé d'isoler les dépendances de chaque projet.   Un environnement virtuel (venv) permet de créer un bac "
date = "2026-07-31T18:38:17Z"
url = "https://www.linuxtricks.fr/wiki/python-creer-et-utiliser-un-environnement-virtuel-python-venv"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.298857540Z"
seen = false
+++

![python_logo](https://www.linuxtricks.fr/upload/python_logo.png "python_logo")

Introduction
----------

 Lorsqu'on développe ou qu'on teste des applications Python, il est recommandé d'isoler les dépendances de chaque projet.  
 Un environnement virtuel (venv) permet de créer un bac à sable contenant son propre interpréteur Python et sa propre copie de pip, évitant ainsi les conflits de versions avec les paquets du système d'exploitation.  

Prérequis
----------

 On commence par vérifier que la version de Python 3 est bien présente et que le module venv est disponible :  

Code BASH :

```
python -V
```

 Sous RHEL, Fedora (et ses dérivées), Python 3 est inclus nativement et l'outil venv est fourni par le module officiel et ne nécessite pas d'installation tierce.  
 On aura besoin de Python PIP :  

Code BASH :

```
dnf install python3-pip
```

 Sur Debian/Ubuntu, il faut installer des trucs en plus :  

Code BASH :

```
apt install python3-pip python3-venv
```

Création de l'environnement
----------

 On se place dans le répertoire de son projet, puis on génère l'environnement virtuel :  

Code BASH :

```
python3 -m venv venv
```

 Cela crée un dossier venv/ contenant un interpréteur Python isolé.  

 Note : On peut nommer ce dossier comme on veut (.venv, env, etc.), venv est juste une convention courante.  

Activation de l'environnement
----------

 On active ensuite l'environnement pour commencer à travailler :  

Code BASH :

```
source venv/bin/activate
```

 Une fois activé, l'invite de commande affiche généralement le nom de l'environnement entre parenthèses, par exemple :  

Code BASH :

```
(venv) [adrien@spaciba hermes]$
```

 À partir de ce moment, les commandes python et pip pointent vers l'interpréteur du venv, et non vers celui du système.  

Installation des dépendances
----------

 On met pip à jour :  

Code BASH :

```
pip install --upgrade pip
```

 Puis on installe les modules nécessaires au projet :  

Code BASH :

```
pip install nom_du_module
```

 Si le projet utilise un fichier de dépendances standard :  

Code BASH :

```
pip install -r requirements.txt
```

Exécution et désactivation
----------

 Avec le venv activé, on lance le script, le programme ou le module qu'on veut utiliser :  

Code BASH :

```
python mon_script.py
```

 Pour quitter l'environnement virtuel et revenir à l'interpréteur système, on utilise :  

Code BASH :

```
deactivate
```

Astuce pratique pour activer le venv et lancer le programme
----------

 On peut créer un petit script run.sh pour lancer le projet plus tard sans réactiver manuellement l'environnement à chaque fois :  

Code BASH :

```
#!/bin/bash
source venv/bin/activate
python mon_script.py
deactivate
```

 On le rend exécutable avec :  

Code BASH :

```
chmod +x run.sh
```

 Puis on le lance via :  

Code BASH :

```
./run.sh
```