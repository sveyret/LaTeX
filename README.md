Classes pour créer des œuvres littéraires avec LaTeX.

# Language/Langue

These classes are intended to be used to create work of French literature. Therefore, all documents here are in French. If you need some translation, feel free to ask me directly.

Ces classes ont pour but de créer des œuvres littéraires en français. Aussi, tous les documents ici sont en français. N'hésitez pas à me demander si vous avez besoin d'une traduction.

# Création d'un livre (classe publivre)

Cette classe permet de rédiger un livre à publier. Cette classe s'utilise avec le modèle de Makefile (Makefile.publivre) fourni.

Avec cette classe, vous pouvez, à partir d'un fichier .tex et un fichier Scribus (.sla) générer :
* le fichier avec le contenu du livre, au format classique attendu par un imprimeur (*.pdf) ;
* un fichier pour l'impression de la couverture (*.cover.pdf) ;
* un fichier de brouillon, contenant l'ensemble du texte, permettant une impression pour d'éventuelles relectures (*.draft.pdf) ;
* un fichier contenant une version numérique du livre (*.epub).

En plus d'une installation complète de LaTeX (contenant pdflatex, mk4ht et htlatex), l'utilisation de cette classe nécessite également :
* Scribus ;
* gimp ;
* pdftoppm ;
* Calibre.

## Rédaction du livre

Le fichier .tex est attendu en UTF-8 et rédigé directement en Français, y compris pour les accents ou les caractères particuliers (guillemets français, par exemple). À cause d'une limitation dans les paquets utilisés, les guillemets français ne doivent toutefois pas être suivis ou précédés d'espaces insécables, mais d'espaces classiques. Il est bien entendu également possible d'utiliser les commandes particulières du LaTeX (tel que \og et \fg si votre clavier ne vous permet pas de faire les guillemets français).

### Paramètres de la classe

La classe accepte les paramètres suivants :
* _petitlivre_, peut être utilisé avec un livre ayant peu de contenu, afin de « gonfler » artificiellement le nombre de pages ;
* _sanschapnum_ permet de supprimer les numéros des chapitres ; cette option est incompatible avec _chapnumsimple_ ;
* _chapnumsimple_ permet de ne mettre que le numéro des chapitres, sans l'indication « Chapitre » avant le numéro ; cette option n'est pas compatible avec _sanschapnum_.

### Paramètres du préambule

Différentes commandes, utilisables dans le préambule du document, permettent de fixer les paramètres du livre :
* \Titre{_titre du livre_} permet d'indiquer le titre du livre. Si vous ne précisez pas ce paramètre, le titre sera « ?Titre? ».
* \Auteur{_Nom_}{_Prénom_} peut être appelé plusieurs fois, une fois pour chaque auteur du livre. Si aucun auteur n'est spécifié, « ?Auteur? » apparaitra.
* \AuteurSecondaire{_Nom_}{_Prénom_}{_code rôle_}{_Rôle_} peut être utilisé pour indiquer un contributeur supplémentaire, tel qu'un illustrateur, un photographe, etc. Le _Rôle_ est le nom du rôle en clair (par exemple _Illustratrice_ ou _Illustrations_) tandis que _code rôle_ est l'un des codes spécifiés par la [norme OPF](http://www.idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#Section2.2.6) (par exemple _ill_). Cette commande est facultative. Elle peut être appelée plusieurs fois pour indiquer plusieurs contributeurs ou rôles.
* \CouvResume{_Résumé_} permet de rédiger le résumé (quatrième de couverture) du livre. Ce résumé apparaitra sur la couverture et sur la version brouillon du livre. Le résumé doit uniquement contenir du texte et pas de commande LaTeX. Il peut toutefois faire plusieurs paragraphes. Si le résumé n'est pas spécifié, « ?Résumé? » apparaitra.
* \Categorie{_Catégorie_} fixe la catégorie du livre (Policier, Science fiction, ou tout simplement Roman). Sans cette commande, la catégorie indiquée est « ?Roman? ».
* \Editeur{_Éditeur_} vous permet d'indiquer l'éditeur du  livre. Si vous n'utilisez pas cette commande, la valeur sera « ?Auteur-Éditeur? ».
* \Licence{_Licence_} peut être utilisée pour fixer la licence du livre. C'est une commande facultative mais recommandée. Si elle n'est pas spécifiée, aucune licence ne sera indiquée dans le livre numérique, tandis que la mention « © » suivie de la date sera insérée dans la version papier du livre.
* \Isbn{_Version numérique_}{_Version papier_} est une commande pour indiquer le numéro ISBN du livre. En principe, un même livre sous deux formats différents devrait avoir deux numéros d'ISBN différents. Le premier numéro est utilisé pour la version numérique du livre, tandis que le deuxième est utilisé dans la version papier. La version brouillon n'utilise pas de numéro ISBN. Chacun des numéros est facultatif, la commande elle-même n'est pas nécessaire.
* \DepotLegal{_Date_} vous permet de spécifier la date du dépôt légal du livre. En principe, on ne spécifie que le mois et l'année (par exemple _juin 2017_). La commande est facultative.
* \PresseEtrangere peut être utilisé pour ne pas afficher « imprimé en France » dans la version papier du livre. C'est une commande facultative.
* \DuMemeAuteur{_Autres publications_} est une commande facultative qui permet d'afficher les autres livres écrits par le même auteur. Le paramètre fourni peut contenir plusieurs paragraphes ainsi que des commandes LaTeX.

### Mise en forme

Cette classe hérite de la classe standard « book ». Vous pouvez donc utiliser toutes les commandes de mise en forme de cette classe. Vous pouvez également utiliser les commandes spécifiques :
* \sommaire qui affiche une table des matières ;
* \sout{_texte_} pour afficher un texte barré ;
* \etranger{_texte_} pour du texte en langue étrangère ;
* \separateurpar qui ajoute un [astérisme](https://fr.wikipedia.org/wiki/Ast%C3%A9risme_(typographie)) afin de séparer deux paragraphes logiques.

Deux environnements supplémentaires peuvent également être utilisés :
* \begin{dedicace} permet de démarrer la dédicace du livre. Cette dédicace s'affiche sur une page vide, les paragraphes alignés à droite.
* \begin{manuscrit} peut être utilisée au début d'une zone écrite avec une police de caractères imitant l'écriture manuscrite.

### Couverture

(à compléter)

# Création d'un scénario (classe filmscenario)

(à compléter)
