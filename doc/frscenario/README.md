La classe _frscenario_ permet de rédiger un scénario en langue française.

Cette classe permet de générer automatiquement le scénario, avec couverture, numérotation des scènes, gestion des transitions, gestion des dialogues, etc.

Pour débuter un nouveau scénario, n'hésitez pas à vous inspirer de [l'exemple livré](exemple).

# Pré-requis

L'utilisation de cette classe nécessite une installation complète de LaTeX (contenant pdflatex, mk4ht, htlatex et latexmk).

# Rédaction du scénario

Le fichier .tex est attendu en UTF-8 et rédigé directement en français, y compris pour les accents ou les caractères particuliers (guillemets français, par exemple). À cause d'une limitation dans les paquets utilisés, les guillemets français ne doivent toutefois pas être suivis ou précédés d'espaces insécables, mais d'espaces classiques. Il est bien entendu également possible d'utiliser les commandes particulières du LaTeX (tel que \og et \fg si votre clavier ne vous permet pas de faire les guillemets français).

Afin de détecter quelques fautes qui ne sont normalement pas visibles, la génération n'aura pas lieu si, dans le corps du document .tex (après le préambule) :
* des guillemets ouvrants sont suivis d'une espace insécable ; pour passer outre le contrôle, utiliser «~ ;
* des guillemets fermants sont précédés d'une espace insécable ; pour passer outre le contrôle, utiliser ~».

## Paramètres de la classe

La classe n'accepte aucun paramètre.

## Paramètres du préambule

Différentes commandes, utilisables uniquement dans le préambule du document, permettent de fixer les paramètres du scenario :
* \Titre{_titre du scénario_} permet d'indiquer le titre du scénario. Si vous ne précisez pas ce paramètre, le titre sera « ?Titre? ».
* \Auteur{_Nom_ \et _AutreNom_} défini le ou les auteurs du scénario. Le \et permet de définir plusieurs auteurs au livre. Il est suivi et précédé d'une espace. Son utilisation n'est pas obligatoire.
* \Contact{_informations_} permet de donner les informations de contact. Ces informations peuvent prendre plusieurs lignes. Elles seront affichées sur la page de couverture.

## Mise en forme

Cette classe hérite de la classe standard « article ». Vous pouvez donc utiliser toutes les commandes de mise en forme de cette classe.

## Gestion des scènes

Pour démarrer une scène, il faut utiliser l'une des options suivantes :
* \SceneInt{_temps_}{_lieu_} pour débuter une scène se déroulant en intérieur ;
* \SceneExt{_temps_}{_lieu_} pour débuter une scène se déroulant en extérieur ;
* \SceneIntExt{_temps_}{_lieu_} pour débuter une scène se déroulant à la fois en intérieur et extérieur, et débutant en intérieur ;
* \SceneExtInt{_temps_}{_lieu_} pour débuter une scène se déroulant à la fois en intérieur et extérieur, et débutant en extérieur ;
* \Generique pour indiquer un générique.

Excepté pour les génériques, chaque type de scène prend un paramètre pour indiquer le _temps_ (en général « jour » ou « nuit ») et un paramètre pour décrire le _lieu_. Il est également possible de préciser les transitions avec la commande \transition{_type_} qui prend en paramètre le type de la transition. Notez que la transition d'ouverture (fondu à l'ouverture) est ajoutée automatiquement.

Les scènes sont numérotées automatiquement. Les numéros ne doivent donc pas être indiqués dans la description.

## Gestion des dialogues

Pour débuter un dialogue, changer de locuteur et terminer un dialogue, il faut utiliser respectivement les commandes :
* \— _nom du locuteur_ (c'est un tiret quadratin, et non un signe moins), suivie d'une fin de paragraphe (une ligne vide) ;
* \— _nom du nouveau locuteur_ (c'est un tiret quadratin, et non un signe moins), suivie d'une fin de paragraphe (une ligne vide) ;
* \—— (ce sont deux tirets quadratins accolés).

Cela permet de faire rapidement des dialogues faciles à distinguer, y compris dans le document source. Si vous n'avez pas de possibilité pour faire simplement un tiret quadratin avec votre clavier, vous pouvez également utiliser :
* \dial pour démarrer ou changer de locuteur à la place de \— ;
* \fin pour terminer le dialogue à la place de \——.

Notez que vous ne devez pas mélanger les deux styles de dialogues (démarrer avec \diag et terminer avec \—— n'est, par exemple, pas permis).

Lorsque vous êtes à l'intérieur d'un dialogue, vous pouvez utiliser :
* \did{_description_} pour ajouter une didascalie ;
* \coupe pour couper le dialogue et le poursuivre sur la page suivante (l'utilisation de cette option n'est pas recommandée).

# Génération

Un fichier _Makefile_ est fourni à titre de modèle pour votre projet de scénario. Il se trouve, avec un exemple, dans le répertoire [exemple](exemple). Ce fichier doit être copié dans le répertoire contenant les sources du projet, puis adapté en modifiant les variables qui se trouvent au début du fichier :
* _BASENAME_ doit contenir la « racine » du nom du projet ; c'est le nom, hors extension, de tous les fichiers concernant le projet (fichier .tex ainsi que fichiers générés) ;
* _LATEXFILES_ contient le chemin vers le répertoire contenant les fichiers de _frscenario_.

Lorsque le fichier _Makefile_ est prêt, vous pouvez utiliser, si l'outil _Make_ est installé sur votre poste (c'est le cas sur la plupart des distributions Linux) :
* _make_ sans argument, qui exécutera par défaut la cible _print_ et générera une version imprimable du scénario ;
* _make web_ pour générer une version électronique du scénario (cela peut être utile pour publier le scénario sur un site Internet ou pour le charger dans un autre éditeur) ;
* _make clean_ pour supprimer les fichiers intermédiaires ;
* _make mrproper_ pour faire le ménage et supprimer tous les fichiers générés.

# À faire

- [ ] Donner la possibilité d'utiliser et modifier les numéros de scène (pour créer une « 12A » par exemple).
- [ ] Permettre la coupure automatique de dialogue multi-page.

