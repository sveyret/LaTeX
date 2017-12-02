Classes et outils pour créer des œuvres littéraires avec LaTeX.

# Language/Langue

These classes are intended to be used to create work of French literature. Therefore, all documents here are in French. If you need some translation, feel free to ask me directly.

Ces classes ont pour but de créer des œuvres littéraires en français. Aussi, tous les documents ici sont en français. N'hésitez pas à me demander si vous avez besoin d'une traduction.

# Licence

Copyright © 2017 Stéphane Veyret stephane_DOT_veyret_AT_neptura_DOT_org

:us: :gb:

This program is free software: you can redistribute it and/or modify it under the terms of the _GNU General Public License_ as published by the _Free Software Foundation_, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the _GNU General Public License_ for more details.

You should have received a copy of the _GNU General Public License_ along with this program. If not, see http://www.gnu.org/licenses/.

:fr:

Ce programme est un logiciel libre ; vous pouvez le redistribuer ou le modifier suivant les termes de la _GNU General Public License_ telle que publiée par la _Free Software Foundation_ ; soit la version 3 de la licence, soit (à votre gré) toute version ultérieure.

Ce programme est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la _GNU General Public License_ pour plus de détails.

Vous devez avoir reçu une copie de la _GNU General Public License_ en même temps que ce programme ; si ce n'est pas le cas, consultez http://www.gnu.org/licenses.

# Installation

Pour pouvoir utiliser les classes fournies, il suffit de copier l'ensemble des fichiers livrés dans un répertoire quelconque. Pour ce faire, vous pouvez soit utiliser `git clone` suivie de l'adresse du dépôt, soit télécharger une version archivée du répertoire.

Par défaut, les exemples fournis considèrent que les fichiers se trouvent dans le sous-répertoire LaTeX de votre répertoire personnel ($HOME/LaTeX), mais cette valeur peut être facilement modifiée dans les fichiers _Makefile_ (voir la documentation).

# Classes fournies

## Création d'un livre littéraire

La classe _livrelitt_ permet de rédiger un livre littéraire (Roman).

Avec cette classe, vous pouvez, à partir d'un fichier .tex et un fichier Scribus (.sla) générer :
* le fichier avec le contenu du livre, au format classique attendu par un imprimeur (*.pdf) ;
* un fichier pour l'impression de la couverture (*.cover.pdf) ;
* un fichier de brouillon, contenant l'ensemble du texte, permettant une impression pour d'éventuelles relectures (*.draft.pdf) ;
* un fichier contenant une version numérique du livre (*.epub).

Documentation et exemples se trouvent dans le [répertoire adéquat](doc/livrelitt).

# Création d'un scénario en langue française

La classe _frscenario_ permet de rédiger un scénario en langue française.

Cette classe permet de générer automatiquement le scénario, avec couverture, numérotation des scènes, gestion des transitions, gestion des dialogues, etc.

Documentation et exemples se trouvent dans le [répertoire adéquat](doc/frscenario).

