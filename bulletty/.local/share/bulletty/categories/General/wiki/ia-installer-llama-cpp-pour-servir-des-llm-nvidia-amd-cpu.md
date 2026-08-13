+++
title = "IA : Installer llama.cpp pour servir des LLM (NVidia, AMD, CPU)"
description = "llamacpp-logoIntroduction Llama.cpp est un moteur d'inférence haute performance pour les modèles de langage (LLM). Il offre des fonctionnalités avancées ainsi qu'une compatibilité avec l'API OpenAI,"
date = "2026-08-10T14:09:53Z"
url = "https://www.linuxtricks.fr/wiki/ia-installer-llama-cpp-pour-servir-des-llm-nvidia-amd-cpu"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.266679530Z"
seen = false
+++

![llamacpp-logo](https://www.linuxtricks.fr/upload/llamacpp-logo.png "llamacpp-logo")

Introduction
----------

 Llama.cpp est un moteur d'inférence haute performance pour les modèles de langage (LLM). Il offre des fonctionnalités avancées ainsi qu'une compatibilité avec l'API OpenAI, et une gestion optimisée de la mémoire GPU.  
 Llama.cpp permet de déployer toutes sortes de modèles comme qwen3.5, gemma3, llama, mistral etc.  

 Dans ce tutoriel, on va installer Llama.cpp sur Fedora Linux 44.  

 Ce tuto a été réalisé sur mon PC Fixe, équipé de Fedora Linux 44, d'un CPU AMD Ryzen 5 2600X et d'un GPU AMD Radeon RX 7600 !  

 J'ai vérifié aussi l'installation sur :  
 \- Une machine cloud disposant d'une carte NVidia RTX 5090 sous Fedora Linux 44  
 \- Dell Precision 7960 Rack du travail équipé d'AlmaLinux 10.1, (Intel Xeon Gold 6430 3.40 GHz + NVIDIA RTX 6000 Ada Generation.)  
 \- ARM64 sur MINIFORUMS MS-R1 (CPU CIX CP8180)  

Prérequis à vérifier
----------

 Evidemment, les drivers NVidia et la pile CUDA doivent être installés et fonctionnels.  
 La carte NVidia doit être suffisamment récente !  

 On pourra vérifier avec :  

Code BASH :

```
nvidia-smi
```

![nvidia-smi](https://www.linuxtricks.fr/upload/nvidia-smi.png "nvidia-smi")

 Pour une carte AMD, tout est inclus dans l'install avec Vulkan.  

Préparation
----------

### Installer les outils de développement et les dépendances ###

 llama.cpp peut être décompressé depuis l'archive disponible ou compilé. Pour de meilleures performances, dans ce tuto je vais le compiler.  

 On l'installe avec les outils nécessaires pour la compilation :  

Code BASH :

```
sudo dnf install git cmake gcc gcc-c++ openssl-devel spirv-headers-devel
```

 Sur Ubuntu / Debian :  

Code BASH :

```
sudo apt install git cmake build-essential libssl-dev spirv-headers
```

 Ayant une carte AMD, je vais compiler la version avec le support de Vulkan :  

Code BASH :

```
sudo dnf install glslc vulkan-devel
```

 Sur Ubuntu / Debian :  

Code BASH :

```
sudo apt install glslc libvulkan-dev
```

 Pour une carte NVidia, assurez-vous d'avoir cuda d'installé :  

Code BASH :

```
sudo dnf install cuda-toolkit cuda-nvcc-13
```

### Créer un utilisateur dédié ###

 Sur le serveur, on créé un utilisateur dédié pour llamacpp :  

Code BASH :

```
useradd -m llamacpp
```

 On ajoute l'utilisateur au groupe render :  

Code BASH :

```
gpasswd -a llamacpp render
```

 On prévoit de suite le répertoire de travail de llamacpp :  

Code BASH :

```
mkdir -p /opt/llamacpp/{bin,models}
chown -R llamacpp /opt/llamacpp
```

 On se connecte en llamacpp et on va faire toutes les étapes avec cet utilisateur :  

Code BASH :

```
su - llamacpp
```

### Récupération de sources et compilation ###

 On récupère les sources :  

Code BASH :

```
git clone https://github.com/ggml-org/llama.cpp
```

 On se rend dans le dossier :  

Code BASH :

```
cd llama.cpp
```

 Et on prépare à la compilation.  

 Cas carte AMD :  

Code BASH :

```
cmake -B build -DGGML_VULKAN=1
```

 Cas carte NVidia :  

Code BASH :

```
cmake -B build -DGGML_CUDA=ON  -DCMAKE_CUDA_COMPILER=/usr/local/cuda-13.3/bin/nvcc
```

Si GCC est trop récent, on pourra outrepasser les vérifs en ajoutant **-DCMAKE\_CUDA\_FLAGS="-allow-unsupported-compiler"**  

 Si vous n'avez pas de GPU vous pouvez utiliser le CPU, ça ne sera pas très performant mais vous pourrez quand même manipuler :  

Code BASH :

```
cmake -B build
```

 Et on compile (le nproc c'est pour compiler avec tous les CPU dispo sur la machine) :  

Code BASH :

```
cmake --build build --config Release -j $(nproc)
```

Installation de llamacpp
----------

 On va installer les fichiers compilés :  

Code BASH :

```
mv build/bin/* /opt/llamacpp/bin/
```

 On va ajouter dans le PATH le chemin de llamacpp :  

Code BASH :

```
echo "export PATH=$PATH:/opt/llamacpp/bin" >> ~/.bashrc
```

 Pour aller chercher les bibliothèques partagées dans le bon dossier, on ajoute ceci dans notre .bashrc :  

Code BASH :

```
echo "export LD_LIBRARY_PATH=/opt/llamacpp/bin" >> ~/.bashrc
```

 Les modèles sont stockés par défaut dans **/home/llamacpp/.cache/llama.cpp/**.  
 Si on veut les stocker ailleurs comme dans le dossier models précédemment créé, on pourra exporter 2 variables en plus :  

Code BASH :

```
echo "export LLAMA_CACHE=/opt/llamacpp/models/"  >> ~/.bashrc
echo "export HF_HUB_CACHE=/opt/llamacpp/models/"  >> ~/.bashrc
```

 On recharge l'environnement bash :  

Code BASH :

```
source ~/.bashrc
```

 Avec SELinux, il faut autoriser l'exécution des binaires (à appliquer en root) :  

Code BASH :

```
semanage fcontext -a -t bin_t "/opt/llamacpp/bin(/.*)?"
restorecon -Rv /opt/llamacpp/bin
```

*C'est pour ça qu'on met llamacpp dans /opt, dans /home, on aurait besoin d'encore plus de règles SELinux. En effet /home n'est pas prévu pour le stockage de binaires.*  

Lancer un serveur llamacpp
----------

 Une fois que tout est bon, on va lancer le serveur llamacpp, et je prends le modèle **unsloth/gemma-4-12b-it-GGUF:Q4\_K\_M** dans ce tuto.  

Si vous voulez un modèle relativement léger et qui peut tenir dans 3Gb de VRAM, prenez **unsloth/Qwen3.5-4B-GGUF:Q4\_K\_M**. J'aime bien les modèles de chez Unsloth, modifiés et tunés, au format GGUF évidemment : [https://huggingface.co/unsloth](https://huggingface.co/unsloth) Adaptez avec le modèle que vous voulez.  

Code BASH :

```
llama-server -hf unsloth/gemma-4-12b-it-GGUF:Q4_K_M \
   --ctx-size 16384 \
   --temp 1.0 \
   --top-p 0.95 \
   --top-k 20 \
   --min-p 0.00 \
   --host 0.0.0.0 \
   --port 8080
 
```

 A propos des options :  
**\-hf unsloth/gemma-4-12b-it-GGUF:Q4\_K\_M** : On charge le modèle depuis Hugging Face  
**\--ctx-size 16384** : Fenêtre de contexte de 32k tokens  
**\--temp 1.0** : Température de 1 (pas trop créatif)  
**\--top-p 0.95** : Nucleus Sampling. Le modèle ne choisit que parmi les mots dont la probabilité cumulée atteint 95%.  
**\--top-k 20** : Limite le choix aux 20 mots les plus probables uniquement. (meilleure cohérence)  
**\--host 0.0.0.0** : Le serveur web écoute sur toutes les interfaces réseau  
**\--port 8000** : Port d'écoute du serveur API  

 Si on veut, pour les modèles ayant le mode raisonnement le désactiver, je vous propose 3 options à ajouter (comme çà, ça fonctionne sur Qwen et Gemma) :  

Code TEXT :

```
--reasoning off --reasoning-budget 0
```

 Le premier lancement téléchargera le modèle depuis Hugging Face, ce qui peut prendre du temps selon la connexion internet et la taille du modèle !  

Si on a déjà les modèles en GGUF, on pourra en lieu et place de l'option -hf utiliser l'option -m avec le chemin du modèle.  

 Une fois démarré :  

Code TEXT :

```
Downloading mmproj-BF16.gguf ─────────────────────────────────────── 100%
Downloading gemma-4-12b-it-Q4_K_M.gguf ───────────────────────────── 100%
3.21.916.602 I srv    load_model: loading model 'unsloth/gemma-4-12b-it-GGUF:Q4_K_M'
3.24.758.466 I srv    load_model: loaded multimodal model, '/opt/llamacpp/models/models--unsloth--gemma-4-12b-it-GGUF/snapshots/fc034cfff751157913579611efad8462ac1be606/mmproj-BF16.gguf'
3.24.769.972 I srv    load_model: initializing, n_slots = 4, n_ctx_slot = 16384, kv_unified = 'true'
3.24.777.681 I srv  llama_server: model loaded
3.24.777.694 I srv  llama_server: listening on http://0.0.0.0:8080
```

 Si on utilise un pare-feu, on ouvrira le port 8080 :  

Code BASH :

```
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
```

Tester le modèle
----------

 Une fois le serveur démarré, on peut tester depuis l'interface web : [http://0.0.0.0:8080](http://0.0.0.0:8080)  

 Si on fait une requête longue, pour que ça prenne du temps à traiter, on peut voir avec nvtop par exemple que le GPU est bien sollicité :  

![llamacpp-nvtop](https://www.linuxtricks.fr/upload/llamacpp-nvtop.png "llamacpp-nvtop")

Script python chatbot
----------

 Je vous propose un petit script python pour tester ce modèle en mode chatbot sur mon github : [https://github.com/aaaaadrien/miscripts/tree/main/ia/chat-llm](https://github.com/aaaaadrien/miscripts/tree/main/ia/chat-llm)  

Créer un service systemd
----------

 Pour cette partie, on revient en root.  

 Pour que llamacpp démarre automatiquement au boot, on va créer un service systemd :  

Code BASH :

```
vim /etc/systemd/system/llamacpp.service
```

 Voici le contenu du service (adaptez avec le modèle et les options à utiliser) :  

Code BASH :

```
[Unit]
Description=Llamacpp Server
After=network.target
[Service]
User=llamacpp
WorkingDirectory=/opt/llamacpp/bin/
Environment=LD_LIBRARY_PATH=/opt/llamacpp/bin
Environment=LLAMA_CACHE=/opt/llamacpp/models/
Environment=HF_HUB_CACHE=/opt/llamacpp/models/
ExecStart=/opt/llamacpp/bin/llama-server -hf unsloth/gemma-4-12b-it-GGUF:Q4_K_M --ctx-size 256000 --temp 0.4 --top-p 0.95 --top-k 20 --min-p 0.00 --host 0.0.0.0 --port 8080
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
```

 On recharge systemd :  

Code BASH :

```
systemctl daemon-reload
```

 On active et démarre le service :  

Code BASH :

```
systemctl enable --now llamacpp
```

 Et voilà, on peut utiliser notre modèle via Llamacpp.  
 Contrairement à Ollama, ici, seul 1 modèle est mis à disposition.