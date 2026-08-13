+++
title = "IA : Installer whisper.cpp pour la reconnaissance vocale (NVidia, AMD, CPU)"
description = "whispercpp-logoIntroduction Whisper.cpp est une implémentation C/C++ haute performance du modèle de reconnaissance vocale Whisper d'OpenAI. Il offre une inférence ultra-rapide pour la transcript"
date = "2026-07-03T06:07:46Z"
url = "https://www.linuxtricks.fr/wiki/ia-installer-whisper-cpp-pour-la-reconnaissance-vocale-nvidia-amd-cpu"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.413525810Z"
seen = true
+++

![whispercpp-logo](https://www.linuxtricks.fr/upload/whispercpp-logo.png "whispercpp-logo")

Introduction
----------

 Whisper.cpp est une implémentation C/C++ haute performance du modèle de reconnaissance vocale Whisper d'OpenAI. Il offre une inférence ultra-rapide pour la transcription et la traduction audio, une compatibilité avec l'API OpenAI, et une gestion optimisée de la mémoire GPU.  

 Whisper.cpp permet de déployer tous les modèles Whisper, du minuscule "tiny" au très performant "large-v3-turbo".  

 Ce tuto a été réalisé sur un serveur Dell Precision 7960 Rack du travail équipé d'AlmaLinux 10.1, (Intel Xeon Gold 6430 3.40 GHz + NVIDIA RTX 6000 Ada Generation.)  

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

 On l'installe avec les outils nécessaires pour la compilation :  

Code BASH :

```
sudo dnf install git cmake gcc gcc-c++ openssl-devel spirv-headers-devel SDL2-devel
```

 Sur Ubuntu / Debian :  

Code BASH :

```
sudo apt install git cmake build-essential libssl-dev spirv-headers libsdl2-dev
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

 Pour une carte NVidia, assurez-vous d'avoir nvcc d'installé :  

Code BASH :

```
sudo dnf install cuda-nvcc-13
```

### Créer un utilisateur dédié ###

 Sur le serveur, on créé un utilisateur dédié pour whispercpp :  

Code BASH :

```
useradd -m whispercpp
```

 On ajoute l'utilisateur au groupe render (et audio pour pouvoir utiliser le micro si besoin) :  

Code BASH :

```
gpasswd -a whispercpp render
gpasswd -a whispercpp audio
```

 On prévoit de suite le répertoire de travail de whispercpp :  

Code BASH :

```
mkdir -p /opt/whispercpp/{bin,models}
chown -R whispercpp /opt/whispercpp
```

 Aussi on prépare la config pour les bibliothèques spécifiques :  

Code BASH :

```
echo "/opt/whispercpp/bin" > /etc/ld.so.conf.d/whispercpp.conf
```

 Et on recharge le cache des bibliothèques dynamiques :  

Code BASH :

```
ldconfig
```

 On se connecte en whispercpp et on va faire toutes les étapes avec cet utilisateur :  

Code BASH :

```
su - whispercpp
```

### Récupération de sources et compilation ###

 On récupère les sources :  

Code BASH :

```
git clone https://github.com/ggerganov/whisper.cpp
```

 On se rend dans le dossier :  

Code BASH :

```
cd whisper.cpp
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
cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_COMPILER=/usr/local/cuda-13.3/bin/nvcc
```

 Si vous n'avez pas de GPU vous pouvez utiliser le CPU, pour de l'audio ça reste tout à fait correct avec les petits modèles :  

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

 Contrairement à llamacpp qui peut télécharger à la volée, il est préférable de télécharger le modèle GGUF en amont.  
 Whisper.cpp fournit un script pour ça. On va utiliser la version **large-v3-turbo** qui offre un excellent ratio vitesse/précision :  

Code BASH :

```
bash ./models/download-ggml-model.sh large-v3-turbo
mv models/ggml-large-v3-turbo.bin /opt/whispercpp/models/
```

Installation de whispercpp
----------

 On va installer les fichiers compilés :  

Code BASH :

```
mv build/bin/* /opt/whispercpp/bin/
```

 On va ajouter dans le PATH le chemin de whispercpp :  

Code BASH :

```
echo "export PATH=$PATH:/opt/whispercpp/bin" >> ~/.bashrc
```

 On recharge l'environnement bash :  

Code BASH :

```
source ~/.bashrc
```

 Avec SELinux, il faut autoriser l'exécution des binaires (à appliquer en root) :  

Code BASH :

```
semanage fcontext -a -t bin_t "/opt/whispercpp/bin(/.*)?"
restorecon -Rv /opt/whispercpp/bin
```

*C'est pour ça qu'on met whispercpp dans /opt, dans /home, on aurait besoin d'encore plus de règles SELinux. En effet /home n'est pas prévu pour le stockage de binaires.*  

Lancer un serveur whispercpp
----------

 Une fois que tout est bon, on va lancer le serveur whispercpp, compatible avec l'API audio d'OpenAI :  

Code BASH :

```
whisper-server -m /opt/whispercpp/models/ggml-large-v3-turbo.bin \
--host 0.0.0.0 \
--port 8081 \
--language fr \
--convert
 
```

 A propos des options :  
**\-m .../ggml-large-v3-turbo.bin** : Chemin absolu vers notre modèle téléchargé  
**\--host 0.0.0.0** : Le serveur web écoute sur toutes les interfaces réseau  
**\--port 8081** : Port d'écoute du serveur API  
**\--language fr** : Force la transcription en français (optionnel, sinon détection auto)  
**\--convert** : Force la conversion en .wav (car seul ce format est supporté)  

Si on veut juste transcrire un fichier audio rapidement en ligne de commande sans lancer le serveur, on peut utiliser :  

Code BASH :

```
whisper-cli -m /opt/whispercpp/models/ggml-large-v3-turbo.bin -f mon-audio.wav
```

 Une fois démarré :  

Code TEXT :

```
ggml_cuda_init: found 1 CUDA devices (Total VRAM: 48537 MiB):
  Device 0: NVIDIA RTX 6000 Ada Generation, compute capability 8.9, VMM: yes, VRAM: 48537 MiB
whisper_init_from_file_with_params_no_state: loading model from '/opt/whispercpp/models/ggml-large-v3-turbo.bin'
whisper_init_with_params_no_state: use gpu    = 1
whisper_init_with_params_no_state: flash attn = 1
whisper_init_with_params_no_state: gpu_device = 0
whisper_init_with_params_no_state: dtw        = 0
whisper_init_with_params_no_state: devices    = 2
whisper_init_with_params_no_state: backends   = 2
whisper_model_load: loading model
whisper_model_load: n_vocab       = 51866
whisper_model_load: n_audio_ctx   = 1500
whisper_model_load: n_audio_state = 1280
whisper_model_load: n_audio_head  = 20
whisper_model_load: n_audio_layer = 32
whisper_model_load: n_text_ctx    = 448
whisper_model_load: n_text_state  = 1280
whisper_model_load: n_text_head   = 20
whisper_model_load: n_text_layer  = 4
whisper_model_load: n_mels        = 128
whisper_model_load: ftype         = 1
whisper_model_load: qntvr         = 0
whisper_model_load: type          = 5 (large v3)
whisper_model_load: adding 1609 extra tokens
whisper_model_load: n_langs       = 100
whisper_model_load:        CUDA0 total size =  1623.92 MB
whisper_model_load: model size    = 1623.92 MB
whisper_backend_init_gpu: device 0: CUDA0 (type: 1)
whisper_backend_init_gpu: found GPU device 0: CUDA0 (type: 1, cnt: 0)
whisper_backend_init_gpu: using CUDA0 backend
whisper_init_state: kv self size  =   10.49 MB
whisper_init_state: kv cross size =   31.46 MB
whisper_init_state: kv pad  size  =    7.86 MB
whisper_init_state: compute buffer (conv)   =   37.69 MB
whisper_init_state: compute buffer (encode) =   55.35 MB
whisper_init_state: compute buffer (cross)  =    9.27 MB
whisper_init_state: compute buffer (decode) =  100.04 MB
whisper server listening at http://0.0.0.0:8081
```

 Si on utilise un pare-feu, on ouvrira le port 8081 :  

Code BASH :

```
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --reload
```

Tester le modèle
----------

 Une fois le serveur démarré, on peut tester depuis l'interface web : [http://0.0.0.0:8081](http://0.0.0.0:8081)  
 L'interface est très basique mais elle permet de faire un upload d'un fichier et de sortir un format.  

 Côté whispercpp, on a des logs de traitement :  

Code TEXT :

```
Received request: test-présentation-linuxtricks.wav
Successfully loaded test-présentation-linuxtricks.wav
system_info: n_threads = 4 / 64 | WHISPER : COREML = 0 | OPENVINO = 0 | CUDA : ARCHS = 890 | PEER_MAX_BATCH_SIZE = 128 | CPU : SSE3 = 1 | SSSE3 = 1 | AVX = 1 | AVX_VNNI = 1 | AVX2 = 1 | F16C = 1 | FMA = 1 | BMI2 = 1 | AVX512 = 1 | AVX512_VBMI = 1 | AVX512_VNNI = 1 | AVX512_BF16 = 1 | AMX_INT8 = 1 | OPENMP = 1 | REPACK = 1 |
operator(): processing 'test-présentation-linuxtricks.wav' (2259951 samples, 141.2 sec), 4 threads, 1 processors, lang = fr, task = transcribe, timestamps = 1 ...
Running whisper.cpp inference on test-présentation-linuxtricks.wav
```

 Si on fait une requête longue, avec nvtop on peut voir la VRAM se remplir de l'état audio et le GPU calculer les tokens.  

![whispercpp-nvtop](https://www.linuxtricks.fr/upload/whispercpp-nvtop.png "whispercpp-nvtop")

Créer un service systemd
----------

 Pour cette partie, on revient en root.  

 Pour que whispercpp démarre automatiquement au boot, on va créer un service systemd :  

Code BASH :

```
vim /etc/systemd/system/whispercpp.service
```

 Voici le contenu du service (adaptez avec le modèle à utiliser) :  

Code BASH :

```
[Unit]
Description=Whisper.cpp API Server
After=network.target
[Service]
User=whispercpp
WorkingDirectory=/opt/whispercpp/bin/
ExecStart=/opt/whispercpp/bin/whisper-server -m /opt/whispercpp/models/ggml-large-v3-turbo.bin --host 0.0.0.0 --port 8081 --language fr
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
systemctl enable --now whispercpp
```

 Et voilà, on peut utiliser notre API de transcription maison via Whisper.cpp. Vous pouvez maintenant brancher n'importe quelle application compatible avec l'API d'OpenAI (en remplaçant l'URL par la vôtre) pour transcrire vos mémos vocaux en texte !