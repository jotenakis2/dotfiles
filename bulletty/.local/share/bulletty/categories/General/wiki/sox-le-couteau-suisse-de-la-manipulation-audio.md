+++
title = "sox : Le couteau suisse de la manipulation audio"
description = 'Introduction SoX, ou "Sound eXchange", est le couteau suisse de manipulation audio sous Linux. Il permet de lire, convertir et manipuler des fichiers audio dans divers formats. SoX offre une multitude de fonctionnalités pour répondre à vos besoins.   Il incorpore les co'
date = "2026-06-19T17:10:19Z"
url = "https://www.linuxtricks.fr/wiki/sox-le-couteau-suisse-de-la-manipulation-audio"
author = "Wiki"
text = ""
lastupdated = "2026-07-03T22:25:20.436909455Z"
seen = true
+++

Introduction
----------

 SoX, ou "Sound eXchange", est le couteau suisse de manipulation audio sous Linux. Il permet de lire, convertir et manipuler des fichiers audio dans divers formats. SoX offre une multitude de fonctionnalités pour répondre à vos besoins.  

 Il incorpore les commandes **play** et **rec** qui permettent de lire et enregistrer du contenu audio, ainsi que **sox** pour manipuler les fichiers audio.  

Installation
----------

 SoX n'est souvent pas installé par défaut dans les distributions Linux. Il sera donc nécessaire d'installer le paquet du même nom.  

 Fedora, RHEL et dérivées (EPEL nécessaire) :  

Code BASH :

```
dnf install sox
```

 Debian, Ubuntu et dérivées :  

Code BASH :

```
apt install sox
```

 Gentoo (pensez à activer les USE qui vont bien pour supporter certains formats) :  

Code BASH :

```
emerge -av media-sound/sox
```

play pour lire des fichiers audio
----------

 Pour jouer un fichier audio en console, rien de plus simple:  

Code BASH :

```
play  monfichier.mp3
```

 Pour jouer un répertoire complet de fichiers audio en console:  

Code BASH :

```
play  *.mp3
```

 Il est aussi possible de baisser la voix de l'artiste, pour faire une sorte de karaoké avec l'option oops :  

Code BASH :

```
play monfichier.mp3 oops
```

rec pour enregistrer
----------

 Pour enregistrer de l'audio à partir de votre microphone, on pourra utiliser :  

Code BASH :

```
rec monfichier.wav
```

*L'enregistrement se fait de la validation de la commande à un Ctrl+C*  

 On peut ajouter des effets, par exemple avec une reverb :  

Code BASH :

```
rec monfichier.wav reverb
```

 On peut aussi réduire le volume (gain) lors de l'enregistrement :  

Code BASH :

```
rec monfichier.wav gain -10
```

soxi : Pour avoir des infos
----------

 Pour avoir des infos sur un fichier audio, on utilisera **soxi** :  

Code BASH :

```
soxi monfichier.aiff
```

 Ce qui donne :  

Code :

` Input File : 'monfichier.aiff'  
Channels : 2  
Sample Rate : 44100  
Precision : 16-bit  
Duration : 00:06:33.07 = 17334426 samples = 29480.3 CDDA sectors  
File Size : 69.4M  
Bit Rate : 1.41M  
Sample Encoding: 16-bit Signed Integer PCM  
Comment : 'Processed by SoX `

Manipuler l'audio avec sox
----------

### Convertir des fichiers ###

 On pourra transcoder des fichiers audio, ici vers du MP3 320 :  

Code BASH :

```
sox monfichier.aiff -C 320 monfichier.mp3
```

*Dans le cas du MP3, c'est le bitrate constant qui sera passé à l'option -C*  

 Une option utile est -S pour voir la progression lors du transcodage, ici un exemple en convertissant en OGG avec une haute qualité (10 sur échelle de 1 à 10) :  

Code BASH :

```
sox -S monfichier.aiff -C 10 monfichier.ogg
```

### Ajuster le volume ###

 On pourra ajuster le volume du morceau avec l'effet vol (une valeur négative diminue) :  

Code BASH :

```
sox monfichier.mp3 monfichier_plus_fort.mp3 vol 3dB
```

Si on augmente trop le volume et que sur le fichier le volume est clippé (écrété), on aura un avertissement :  

Code BASH :

```
sox WARN vol: vol clipped 8815536 samples; decrease volume?
```

### Normaliser le volume ###

 On peut aussi normaliser le volume d'un fichier (Augmentation du volume au maximum sans que le fichier soit clippé) :  

Code BASH :

```
sox monfichier.mp3 monfichier_normalise.mp3 norm
```

### Couper des fichiers audio ###

 On pourra aussi couper un fichier audio. Exemple garder 10 secondes à 30 secondes du fichier :  

Code BASH :

```
sox monfichier.mp3 monfichier_coupe.mp3 trim 30 10
```

### Concaténer des fichiers ###

 On pourra aussi concaténer plusieurs fichiers :  

Code BASH :

```
sox fic1.ogg foc2.ogg fichier_concatene.ogg
```

### Générer un spectrogramme audio ###

 sox est aussi capable d'extraire un spectrogramme audio d'un fichier. Il est utile pour analyser la qualité audio.  
 On utilisera la commande suivante :  

Code BASH :

```
sox monfichier.aiff -n spectrogram
```

 Cela génère une image spectrogram.png :  

![sox-spectrogram](https://www.linuxtricks.fr/upload/sox-spectrogram.png "sox-spectrogram")

 On pourra utiliser les options :  
 \-o nomdufichier.png : Pour enegistrer le spectre sous un autre nom  
 \-t Libellé : Pour indiquer un libellé en titre du spectre  
 \-x largeur : Largeur en px du graphe d'une voie  
 \-y hauteur : Hauteur en px du graphe d'une voie  

### Réencoder en supprimant les silences au début et à la fin ###

 On sera obligé de faire un "reverse" car le silence se fait qu'à la fin.  
 Donc on fait le silence à la fin, on reverse le son comme ça le silence du début est à la fin.  
 Et on refait un reverse pour remettre le son comme il faut !  

 Pour du OGG, en gardant la meilleure qualité :  

Code BASH :

```
sox source.ogg -C 10 dest.ogg silence 1 0.1 2% reverse silence 1 0.1 2% reverse
```