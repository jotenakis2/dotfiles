+++
title = "IA : Installer stablediffusion.cpp pour la génération d'image (NVidia, AMD, CPU)"
description = "stablediffusionccpp_logoIntroduction Stable-diffusion.cpp est une implémentation C/C++ haute performance des modèles de génération d'images par diffusion (Stable Diffusion, SDX"
date = "2026-08-08T07:26:00Z"
url = "https://www.linuxtricks.fr/wiki/ia-installer-stablediffusion-cpp-pour-la-generation-d-image-nvidia-amd-cpu"
author = "Wiki"
text = ""
lastupdated = "2026-08-13T22:13:29.279728194Z"
seen = false
+++

![stablediffusionccpp_logo](https://www.linuxtricks.fr/upload/stablediffusionccpp_logo.png "stablediffusionccpp_logo")

Introduction
----------

 Stable-diffusion.cpp est une implémentation C/C++ haute performance des modèles de génération d'images par diffusion (Stable Diffusion, SDXL, SD3/3.5, Flux, Qwen Image, Z-Image, Wan pour la vidéo, etc.).  
 A l'image de whisper.cpp ou llama.cpp, le projet s'appuie sur la bibliothèque **ggml** et propose une inférence légère, sans dépendances lourdes type PyTorch, avec un support GPU optimisé (CUDA, Vulkan, Metal, SYCL) ainsi qu'une compatibilité avec l'API images d'OpenAI et l'API webui d'AUTOMATIC1111.  

 Ce tuto a été réalisé sur une machine disposant d'une carte NVidia RTX 5090.  

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

 Pour de meilleures performances, dans ce tuto je vais le compiler.  

 On installe les outils nécessaires à la compilation :  

Code BASH :

```
sudo dnf install git cmake gcc gcc-c++
```

 Sur Ubuntu / Debian :  

Code BASH :

```
sudo apt install git cmake build-essential
```

 Ayant une carte AMD, je vais compiler la version avec le support de Vulkan :  

Code BASH :

```
sudo dnf install glslc vulkan-devel spirv-headers-devel
```

 Sur Ubuntu / Debian :  

Code BASH :

```
sudo apt install glslc libvulkan-dev spirv-headers
```

 Pour une carte NVidia, assurez-vous d'avoir nvcc d'installé :  

Code BASH :

```
sudo dnf install cuda-nvcc-13
```

### Créer un utilisateur dédié ###

 Sur le serveur, on créé un utilisateur dédié pour sdcpp :  

Code BASH :

```
useradd -m sdcpp
```

 On ajoute l'utilisateur au groupe render pour l'accès au GPU :  

Code BASH :

```
gpasswd -a sdcpp render
```

 On prévoit de suite le répertoire de travail de sdcpp :  

Code BASH :

```
mkdir -p /opt/sdcpp/{bin,models}
chown -R sdcpp /opt/sdcpp
```

 On se connecte en sdcpp et on va faire toutes les étapes avec cet utilisateur :  

Code BASH :

```
su - sdcpp
```

### Récupération de sources et compilation ###

 On récupère les sources.  
 Contrairement à whisper.cpp ou llama.cpp, il faut penser au **--recursive** pour récupérer les sous-modules (ggml, libwebp, etc.) :  

Code BASH :

```
git clone --recursive https://github.com/leejet/stable-diffusion.cpp
```

 On se rend dans le dossier :  

Code BASH :

```
cd stable-diffusion.cpp
```

 Et on prépare à la compilation.  

 Cas carte AMD :  

Code BASH :

```
cmake -B build -DSD_VULKAN=ON
```

 Cas carte NVidia :  

Code BASH :

```
cmake -B build -DSD_CUDA=ON -DCMAKE_CUDA_COMPILER=/usr/local/cuda-13.3/bin/nvcc
```

Si GCC est trop récent, on pourra outrepasser les vérifs en ajoutant **-DCMAKE\_CUDA\_FLAGS="-allow-unsupported-compiler"**  

 Si vous n'avez pas de GPU vous pouvez utiliser le CPU, cependant la génération d'image est très gourmande, à réserver aux petits modèles ou aux tests.  

Code BASH :

```
cmake -B build
```

 Et on compile (le nproc c'est pour compiler avec tous les CPU dispo sur la machine) :  

Code BASH :

```
cmake --build build --config Release -j $(nproc)
```

Téléchargement d'un modèle
----------

 Contrairement à whisper.cpp, il n'y a pas de script de téléchargement fourni : on récupère directement les modèles depuis Huggingface.  
 On peut utiliser des fichiers au format **.safetensors** (poids d'origine) ou au format **.gguf** (versions quantifiées, plus légères en VRAM).  

 Je trouve très intéressant les modèles d'Offgrid AI : [https://huggingface.co/offgrid-ai/](https://huggingface.co/offgrid-ai/)  
 Cs modèles tournent avec pas trop de VRAM pour une résolution de 1024x1024  

 On va utiliser **realvisxl-v5.0-lightning-Q4\_K.gguf** qui offre un bon compromis qualité/poids et qui reste un standard éprouvé :  

Code BASH :

```
wget https://huggingface.co/offgrid-ai/realvisxl-v5.0-lightning-GGUF/resolve/main/realvisxl-v5.0-lightning-Q4_K.gguf
mv realvisxl-v5.0-lightning-Q4_K.gguf /opt/sdcpp/models/
```

Certains modèles plus récents (Flux, SD3.5, Qwen Image...) nécessitent en plus du modèle de diffusion des fichiers séparés pour l'encodeur de texte (clip-l, t5xxl...) et le VAE. Chaque famille de modèle a sa propre doc dans le dossier *docs/* du dépôt (flux.md, sd3.md, qwen\_image.md...) : [https://github.com/leejet/stable-diffusion.cpp/tree/master/docs](https://github.com/leejet/stable-diffusion.cpp/tree/master/docs)  

Installation de stable-diffusion.cpp
----------

 On va installer les fichiers compilés :  

Code BASH :

```
mv build/bin/* /opt/sdcpp/bin/
```

 On va ajouter dans le PATH le chemin de sdcpp :  

Code BASH :

```
echo "export PATH=$PATH:/opt/sdcpp/bin" >> ~/.bashrc
```

 Pour aller chercher les bibliothèques partagées dans le bon dossier, on ajoute ceci dans notre .bashrc :  

Code BASH :

```
echo "export LD_LIBRARY_PATH=/opt/sdcpp/bin" >> ~/.bashrc
```

 On recharge l'environnement bash :  

Code BASH :

```
source ~/.bashrc
```

 Avec SELinux, il faut autoriser l'exécution des binaires (à appliquer en root) :  

Code BASH :

```
semanage fcontext -a -t bin_t "/opt/sdcpp/bin(/.*)?"
restorecon -Rv /opt/sdcpp/bin
```

*Comme pour whisper.cpp, c'est pour ça qu'on met sdcpp dans /opt : dans /home, on aurait besoin d'encore plus de règles SELinux, ce dossier n'étant pas prévu pour le stockage de binaires.*  

Lancer un serveur stable-diffusion.cpp
----------

 Une fois que tout est bon, on va lancer **sd-server** :  

Code BASH :

```
sd-server -m /opt/sdcpp/models/realvisxl-v5.0-lightning-Q4_K.gguf --listen-ip 0.0.0.0 --listen-port 8082
```

 A propos des options :  
**\-m .../realvisxl-v5.0-lightning-Q4\_K.gguf** : Chemin absolu vers notre modèle téléchargé  
**\--listen-ip 0.0.0.0** : Le serveur web écoute sur toutes les interfaces réseau  
**\--listen-port 8082** : Port d'écoute du serveur API  
**\--vae-on-cpu** : Optionnel : garde le VAE sur CPU, pratique pour économiser de la VRAM sur les cartes justes (optionnel)  

 Stable diffusion n'a pas de serveur web embarqué pour faire de la génération d'image depuis une interface web. Seule l'API est lancée en http.  

Si on veut juste générer une image rapidement en ligne de commande sans lancer le serveur, on peut utiliser :  

Code BASH :

```
sd-cli -m /opt/sdcpp/models/realvisxl-v5.0-lightning-Q4_K.gguf -p "un beau pingouin linux" -o ~/test.png
```

 Une fois démarré, on doit voir dans les logs le chargement du backend GPU puis du modèle :  

Code TEXT :

```
ggml_cuda_init: found 1 CUDA devices (Total VRAM: 32149 MiB):
  Device 0: NVIDIA GeForce RTX 5090, compute capability 12.0, VMM: yes, VRAM: 32149 MiB
[INFO ] stable-diffusion.cpp:710  - loading model from '/opt/sdcpp/models/realvisxl-v5.0-lightning-Q4_K.gguf'
[INFO ] model_loader.cpp:236  - load /opt/sdcpp/models/realvisxl-v5.0-lightning-Q4_K.gguf using gguf format
[INFO ] stable-diffusion.cpp:905  - Version: SDXL
[INFO ] stable-diffusion.cpp:956  - Weight type stat:                      f16: 1292 |    q4_K: 1222
[INFO ] stable-diffusion.cpp:957  - Conditioner weight type stat:          f16: 262  |    q4_K: 323  
[INFO ] stable-diffusion.cpp:958  - Diffusion model weight type stat:      f16: 822  |    q4_K: 858  
[INFO ] stable-diffusion.cpp:959  - VAE weight type stat:                  f16: 207  |    q4_K: 41   
  |##################################################| 1/1 - 0.16MB/s
[INFO ] model_loader.cpp:1304 - loading tensors completed, taking 0.01s (read: 0.00s, memcpy: 0.00s, convert: 0.00s, copy_to_backend: 0.00s)
[INFO ] stable-diffusion.cpp:1494 - using VAE for encoding / decoding
[INFO ] auto_encoder_kl.hpp:527  - vae decoder: ch = 128
[WARN ] stable-diffusion.cpp:1462 - No valid VAE specified with --vae or --force-sdxl-vae-conv-scale flag set, using Conv2D scale 0.031
[INFO ] stable-diffusion.cpp:1727 - total params memory size = 2678.64MB (VRAM 2678.64MB, RAM 0.00MB): text_encoders 585.42MB(VRAM), diffusion_model 1933.54MB(VRAM), vae 159.68MB(VRAM), controlnet 0.00MB(N/A), extensions 0.00MB(N/A)
[INFO ] stable-diffusion.cpp:1831 - running in eps-prediction mode
[INFO ] main.cpp:148  - listening on: http://0.0.0.0:8082
```

 Si on utilise un pare-feu et que notre API est accédée depuis une autre machine, on ouvrira le port 8082 :  

Code BASH :

```
firewall-cmd --permanent --add-port=8082/tcp
firewall-cmd --reload
```

Tester le modèle
----------

 Une fois le serveur démarré, on peut tester en faisant une requête curl.  

 L'API étant aussi compatible avec le format d'OpenAI, on peut interroger directement le serveur en ligne de commande :  

Code BASH :

```
curl http://0.0.0.0:8082/v1/images/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "un beau pingouin linux",
    "n": 1,
    "size": "512x512"
  }'
```

 L'image étant encodée en base64, on pourra générer le PNG direct avec les commandes jq et base64 :  

Code BASH :

```
curl -s http://0.0.0.0:8082/v1/images/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "un beau pingouin linux",
    "n": 1,
    "size": "512x512"
  }' | jq -r '.data[0].b64_json' | base64 -d > pingouin.png
```

 Avec nvtop on peut voir la VRAM se remplir de l'état audio et le GPU calculer les tokens.  

![sdcpp-nvtop](https://www.linuxtricks.fr/upload/sdcpp-nvtop.png "sdcpp-nvtop")

 Pour info, l'image réalisée dans ce tuto est la suivante (avec le modèle **realvisxl-v5.0-lightning-Q4\_K.gguf**) :  

![sdcpp-pingouin](https://www.linuxtricks.fr/upload/sdcpp-pingouin.png "sdcpp-pingouin")

 Si nécessaire, je vous partage un script python permettant de faire des requêtes de façon un peu plus sympa :  
[https://github.com/aaaaadrien/miscripts/tree/main/ia/image-generation](https://github.com/aaaaadrien/miscripts/tree/main/ia/image-generation)  

Créer un service systemd
----------

 Pour cette partie, on revient en root.  

 Pour que sdcpp démarre automatiquement au boot, on va créer un service systemd :  

Code BASH :

```
vim /etc/systemd/system/sdcpp.service
```

 Voici le contenu du service (adaptez avec le modèle à utiliser) :  

Code BASH :

```
[Unit]
Description=stable-diffusion.cpp API Server
After=network.target
[Service]
User=sdcpp
WorkingDirectory=/opt/sdcpp/bin/
Environment=LD_LIBRARY_PATH=/opt/sdcpp/bin
ExecStart=/opt/sdcpp/bin/sd-server --listen-ip 0.0.0.0 --listen-port 8082 -m /opt/sdcpp/models/realvisxl-v5.0-lightning-Q4_K.gguf
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
systemctl enable --now sdcpp
```

 Et voilà, on peut utiliser notre API de génération d'images maison via stable-diffusion.cpp.  

 On pourra maintenant brancher n'importe quelle application compatible avec l'API images d'OpenAI !