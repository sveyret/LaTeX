Classes pour créer des œuvres littéraires avec LaTeX.

# Language/Langue

These classes are intended to be used to create work of French literature. Therefore, all documents here are in French. If you need some translation, feel free to ask me directly.

Ces classes ont pour but de créer des œuvres littéraires en français. Aussi, tous les documents ici sont en français. N'hésitez pas à me demander si vous avez besoin d'une traduction.

# Licence

Ce programme est un logiciel libre ; vous pouvez le redistribuer ou le modifier suivant les termes de la _GNU General Public License_ telle que publiée par la _Free Software Foundation_ ; soit la version 3 de la licence, soit (à votre gré) toute version ultérieure.

Ce programme est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la _GNU General Public License_ pour plus de détails.

Vous devez avoir reçu une copie de la _GNU General Public License_ en même temps que ce programme ; si ce n'est pas le cas, consultez http://www.gnu.org/licenses.

# Installation

Pour pouvoir utiliser les classes fournies, il suffit de copier l'ensemble des fichiers livrés dans un répertoire quelconque. Par défaut, les exemples fournis considèrent que les fichiers se trouvent dans le sous-répertoire LaTeX de votre répertoire personnel ($HOME/LaTeX), mais cette valeur peut être facilement modifiée dans le fichier _Makefile_ (voir plus bas).

# Création d'un livre littéraire (classe livrelitt)

Cette classe permet de rédiger un livre à publier. Pour débuter un nouveau livre, n'hésitez pas à vous inspirer de l'exemple livré (_modeles/livrelitt_).

Avec cette classe, vous pouvez, à partir d'un fichier .tex et un fichier Scribus (.sla) générer :
* le fichier avec le contenu du livre, au format classique attendu par un imprimeur (*.pdf) ;
* un fichier pour l'impression de la couverture (*.cover.pdf) ;
* un fichier de brouillon, contenant l'ensemble du texte, permettant une impression pour d'éventuelles relectures (*.draft.pdf) ;
* un fichier contenant une version numérique du livre (*.epub).

En plus d'une installation complète de LaTeX (contenant pdflatex, mk4ht, htlatex et latexmk), l'utilisation de cette classe nécessite également :
* perl ;
* Scribus ;
* gimp ;
* pdftoppm ;
* Calibre.

## Rédaction du livre

Le fichier .tex est attendu en UTF-8 et rédigé directement en Français, y compris pour les accents ou les caractères particuliers (guillemets français, par exemple). À cause d'une limitation dans les paquets utilisés, les guillemets français ne doivent toutefois pas être suivis ou précédés d'espaces insécables, mais d'espaces classiques. Il est bien entendu également possible d'utiliser les commandes particulières du LaTeX (tel que \og et \fg si votre clavier ne vous permet pas de faire les guillemets français).

Afin de détecter quelques fautes qui ne sont normalement pas visibles, la génération n'aura pas lieue si, dans le corps du document .tex (après le préambule) :
* des guillemets ouvrants sont suivis d'une espace insécable ; pour passer outre le contrôle, utiliser «~ ;
* des guillemets fermants sont précédés d'une espace insécable ; pour passer outre le contrôle, utiliser ~» ;
* des tirets quadratins en début de ligne (donc, en principe, lors d'une ouverture de dialogue) sont suivis d'une espace simple ; pour passer outre ce contrôle, utiliser —\space.

### Paramètres de la classe

La classe accepte les paramètres suivants :
* _petitlivre_, peut être utilisé avec un livre ayant peu de contenu, afin de « gonfler » artificiellement le nombre de pages ;
* _lettrine_ ajoute une lettrine au début de chaque chapitre classique (pas pour les chapitres définis avec *).

### Paramètres du préambule

Différentes commandes, utilisables uniquement dans le préambule du document, permettent de fixer les paramètres du livre :
* \Titre{_titre du livre_} permet d'indiquer le titre du livre. Si vous ne précisez pas ce paramètre, le titre sera « ?Titre? ».
* \Auteur{_Nom_, _Prénom_ \et _AutreNom_} défini le ou les auteurs du livre. La partie fournie avant la virgule est celle sur laquelle le tri doit s'effectuer, il s'agit en général du nom ; la partie après la virgule se présente, au naturel, avant la partie qui précède. Il s'agit en général du prénom. La virgule n'est pas obligatoire (cas d'un pseudonyme, par exemple), et doit être suivie d'une espace si elle est présente. Le \et permet de définir plusieurs auteurs au livre. Il est suivi et précédé d'une espace. Si aucun auteur n'est spécifié, « ?Auteur? » apparaitra.
* \Contributeur{[_code rôle_/_Rôle_] _Nom_, _Prénom_ \et …} peut être utilisé pour indiquer un ou plusieurs contributeurs supplémentaires, tel qu'un illustrateur, un photographe, etc. Le _Rôle_ est le nom du rôle en clair (par exemple _Illustratrice_ ou _Illustrations_) tandis que _code rôle_ est l'un des codes spécifiés par la [norme OPF](http://www.idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#Section2.2.6) (par exemple _ill_). Les rôle et code rôle sont encadrés de crochets et séparés par une barre oblique. Une espace doit séparer le crochet final du nom de l'auteur. Excepté pour le rôle, la syntaxe est la même que pour l'auteur. L'utilisation de cette commande est facultative.
* \Resume{_Résumé_} permet de rédiger le résumé (quatrième de couverture) du livre. Ce résumé apparaitra sur la couverture et sur la version brouillon du livre. Le résumé doit uniquement contenir du texte et pas de commande LaTeX. Il peut toutefois faire plusieurs paragraphes. Si le résumé n'est pas spécifié, il sera identique au titre.
* \Categorie{_Catégorie_} fixe la catégorie du livre (Policier, Science fiction, ou tout simplement Roman). Sans cette commande, la catégorie indiquée est « Roman ».
* \Editeur{_Éditeur_} vous permet d'indiquer l'éditeur du  livre. Si vous n'utilisez pas cette commande, la valeur sera « Auteur-Éditeur ».
* \DroitsDAuteur{_Licence_} peut être utilisée pour donner la licence du livre. C'est une commande facultative mais recommandée. Si elle n'est pas spécifiée, la mention « © » suivie de la date sera insérée.
* \Isbn{_Version papier_}{_Version numérique_} est une commande pour indiquer le numéro ISBN du livre. En principe, un même livre sous deux formats différents devrait avoir deux numéros d'ISBN différents. Le premier numéro est utilisé pour la version papier du livre, tandis que le deuxième est utilisé dans la version numérique. La version brouillon n'utilise pas de numéro ISBN. Chacun des numéros est facultatif, la commande elle-même n'est pas nécessaire.
* \InfoImpression{_Détails_} peut être utilisée pour ajouter des détails sur l'imprimeur (par exemple, nom de l'imprimeur, date de l'impression). La commande est facultative.
* \DepotLegal{_Date_} vous permet de spécifier la date du dépôt légal du livre. En principe, on ne spécifie que le mois et l'année (par exemple _juin 2017_). La commande est facultative.
* \PresseEtrangere peut être utilisé pour ne pas afficher « imprimé en France » dans la version papier du livre. C'est une commande facultative.
* \DuMemeAuteur{_Autres publications_} est une commande facultative qui permet d'afficher les autres livres écrits par le même auteur. Le paramètre fourni peut contenir plusieurs paragraphes ainsi que des commandes LaTeX.

### Mise en forme

Cette classe hérite de la classe standard « book ». Vous pouvez donc utiliser toutes les commandes de mise en forme de cette classe. Vous pouvez également utiliser les commandes spécifiques :
* \barre{_texte_} pour afficher un texte barré ;
* \etranger{_texte_} pour du texte en langue étrangère ;
* \separateurpar qui ajoute un [astérisme](https://fr.wikipedia.org/wiki/Ast%C3%A9risme_(typographie)) afin de séparer deux paragraphes logiques ;
* \pageillustr{_image_} pour ajouter une illustration pleine page (l'illustration sera placée sur l'intégralité de la prochaine page) ; pour plus d'informations sur les formats d'image, voir [ci-dessous](https://github.com/sveyret/LaTeX#images).

Des environnements supplémentaires peuvent également être utilisés :
* \begin{dedicace}…\end{dedicace} permet de délimiter la dédicace du livre ; cette dédicace s'affiche sur une page vide, les paragraphes alignés à droite ;
* \begin{narrateur}…\end{narrateur} permet d'encadrer une zone dans lequel le narrateur n'est pas l'un des personnage du livre ; ces zones ont une mise en forme différente ;
* \begin{manuscrit}…\end{manuscrit} peut être utilisée pour identifier une zone écrite avec une police de caractères imitant l'écriture manuscrite.

Par défaut, l'en-tête du livre contiendra le nom de l'auteur sur les pages de gauche et le titre du livre sur les pages de droite. Les pieds de page contiennent le numéro de la page. Notez que, conformément aux normes esthétiques dans l'industrie du livre, en-têtes et pieds de page ne s'affichent qu'au « milieu » d'un chapitre en cours.

Les valeurs par défaut peuvent être modifiées par les commandes, utilisables uniquement dans le préambule :
* \Entete[_position_]{_valeur_} pour positionner les en-têtes ;
* \PiedPage[_position_]{_valeur_} pour indiquer les pieds de page.

Ces commandes acceptent en premier paramètre, optionnel, entre crochets, un lettre pour indiquer si l'on souhaite modifier les pages de droite (avec un D) ou les pages de gauche (avec un G). Si cette valeur n'est pas indiquée, ou est différente de D ou G (en lettres capitales), les deux côtés sont modifiés. Les définitions suivantes peuvent être utiles pour ces commandes :
* \LeTitre, qui sera remplacé par le titre du livre ;
* \LAuteur, qui sera remplacé par l'auteur du livre ;
* \LaPartie{_marque_} pour extraire le nom de la partie en cours ;
* \LeChapitre{_marque_} pour extraire le nom du chapitre en cours.

Pour ces deux dernières commandes, il faut spécifier la marque à utiliser, parmi _\topmark_, _\botmark_ et _\firstmark_ pour respectivement le dernier élément de la page précédente, le dernier élément de la page en cours ou le premier élément de la page en cours (cf. manuel d'utilisation de TeX).

### Images

Les images à insérer dans le livre doivent se trouver dans le même répertoire que le document LaTeX. Ces images doivent être au format PNG ou JPEG et avoir respectivement l'extension _.png_ ou _.jpg_.

Les images peuvent être en couleur et doivent avoir la meilleure résolution possible. Pour une image à utiliser en pleine page (avec \pageillustr), la taille doit être de 600×800 ou proportionnelle.

Les images sont automatiquement modifiées comme suit :
* pour la version numérique du livre, les images sont rabaissées à une résolution maximale de 600×800 ;
* pour la version imprimable du livre, les images sont converties en niveaux de gris.

**Important !** Des répertoires _images_ et _pictures_ sont automatiquement créés par le processus automatique pour gérer les images utilisées dans le livre électronique et dans la version imprimable. Ne créez surtout pas de tels répertoires vous-même, car ils **seront supprimés** dès l'exécution d'un _make clean_.

## Création de la couverture

La couverture doit être créée avec Scribus. Il est conseillé de faire déborder vos images, couleurs, etc. de quelques millimètres et définir un « fond perdu ». Il est également possible d'indiquer des traits de coupe. La taille du fond perdu et la longueur des traits de coupe peuvent se régler dans le menu _Fichier_/_Réglage du document_, onglet _Export PDF_. Demandez à votre imprimeur les paramètres dont il a besoin.

Votre document doit obligatoirement contenir des champs ayant les noms suivants. Vous pouvez toutefois jouer sur la position, la taille et la couleur de ces champs afin qu'ils ne soient pas visibles :
* _Auteur_ pour le nom de l'auteur (ou des auteurs) sur la première de couverture ;
* _AuteurDos_ qui contiendra également le nom de l'auteur, est prévu pour le dos du livre ;
* _AuteurTranche_, toujours pour le nom de l'auteur, est prévu pour la tranche du livre ;
* _Titre_ avec le titre du livre sur l'avant du livre ;
* _TitreDos_, également pour le titre, mais sur le dos du livre ;
* _TitreTranche_, encore pour le titre, prévu pour la tranche du livre ;
* _Contributeur_ contiendra le nom des éventuels contributeurs ;
* _Éditeur_, pour la face avant du livre, contiendra la nom de l'éditeur ;
* _ÉditeurDos_ est également pour le nom de l'éditeur, mais prévu pour le dos du livre ;
* _Résumé_, prévu pour le résumé de quatrième de couverture ;
* _ISBN_ qui contient le code à barre du livre lié à son numéro ISBN.

À chaque fois que la couverture est générée, le contenu de ces champs est modifié dans le fichier .sla en fonction des données fournies dans le fichier .tex.

## Génération

Un fichier _Makefile_ est fourni à titre de modèle pour votre projet de livre. Il se trouve, avec un exemple, dans le répertoire _modele/livrelitt_. Ce fichier doit être copié dans le répertoire contenant les sources du projet, puis adapté en modifiant les variables qui se trouvent au début du fichier :
* _BASENAME_ doit contenir la « racine » du nom du projet ; c'est le nom, hors extension, de tous les fichiers concernant le projet (fichier .tex et .sla, ainsi que fichiers générés) ;
* _LATEXFILES_ contient le chemin vers le répertoire contenant les fichiers de _livrelitt_ ;
* _COVERRES_ doit contenir, en points par pouce, la résolution de l'image qui sera extraite de la couverture papier pour être insérée dans le livre numérique ;
* _COVERCUT_ contient la taille, en millimètres, de la partie de couverture qui doit être coupée (fond perdu, traits de coupe, etc.)

Il est également possible de spécifier des polices de caractères qui seront intégrées dans le livre électronique. Ces polices doivent être installées sur l'ordinateur servant à générer le livre.

* _FONT_SERIF_ est la police de caractères utilisée par défaut ;
* _FONT_CURSIVE_ est la police de caractères utilisée pour l'écriture cursive.

Les valeurs fournies ici seront directement utilisées dans le fichier _.css_ généré. Il est donc également possible d'y indiquer une taille. Exemple :

    FONT_CURSIVE=My Own Handwriting; font-size: 120%

Lorsque le fichier _Makefile_ est prêt, vous pouvez utiliser, si l'outil _Make_ est installé sur votre poste (c'est le cas sur la plupart des distribution Linux) :
* _make_ sans argument, qui exécutera par défaut la cible _all_ et générera la couverture et l'intérieur du livre papier, la version brouillon et la version numérique du livre ;
* _make draft_ pour générer la version brouillon (mode révision) du livre ;
* _make print_ pour générer la couverture et l'intérieur du livre papier ;
* _make ebook_ pour générer le livre numérique ;
* _make clean_ pour supprimer les fichiers intermédiaires ;
* _make mrproper_ pour faire le ménage et supprimer tous les fichiers générés.

Bien sûr, vous pouvez également appeler _make_ pour générer n'importe quel fichier, définitif ou intermédiaire, selon votre désir…

## À faire

* Générer automatiquement le code barre pour la couverture.
* Gérer les guillemets en les rendant actifs pour autoriser les espaces insécables.

# Création d'un scénario (classe filmscenario)

## À faire

* Compléter ce mode d'emploi ;
* Permettre la coupure automatique de dialogue multi-page.

