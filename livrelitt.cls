%%%%%%%%%%%%
% Classe permettant de générer un livre littéraire (roman)

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{livrelitt}[2017/09/01]

%%%%%%%%%%%%
% Paquets nécessaires

\RequirePackage{textcomp} % Pour les caractères spéciaux
\RequirePackage[utf8]{inputenc} % Format du fichier d'entrée
\RequirePackage[T1]{fontenc} % Format de sortie
\RequirePackage{lmodern} % Police de caractère
\RequirePackage{graphicx} % Insertion d'images
\RequirePackage[french]{babel} % Conventions pour le français
\RequirePackage[autolanguage]{numprint} % Écriture de nombres
\RequirePackage{lettrine} % Lettrines
\RequirePackage{afterpage} % Après la page courante

%%%%%%%%%%%%
% Définir le mode d'exécution (numérique, imprimerie, révision/brouillon)

% Mode (non) brouillon, à redéfinir en amont pour modifier
\providecommand\ModeBrouillon{0}

% Modes : numérique, imprimerie, brouillon
\chardef\GenModeNumerique=0
\chardef\GenModeImprimerie=1
\chardef\GenModeBrouillon=2

% Détecter le mode
\ifdefined\HCode
  \chardef\GenMode=\GenModeNumerique
\else\ifdefined\pdfoutput
  \ifcase\pdfoutput
  \else
    \ifnum\ModeBrouillon=0\relax
      \chardef\GenMode=\GenModeImprimerie
    \else
      \chardef\GenMode=\GenModeBrouillon
    \fi
  \fi
\fi\fi

% Mode indéterminé
\ifdefined\GenMode\else
  \ClassWarning{livrelitt}{Mode indéterminé : cette classe ne peut créer que des fichiers HTML ou PDF}
\fi

%%%%%%%%%%%%
% Conditions et autres valeurs

\newif\ifllt@printfrance\llt@printfrancetrue % Indique si imprimé en France
\newif\ifllt@smallbook\llt@smallbookfalse % Petit livre (faible nombre de pages)
\newif\ifllt@autodropcap\llt@autodropcapfalse % Ajoute des lettrines en début de chapitre
\newlength\llt@temp@length % Une longueur temporaire (utilisée notamment pour le style barré)
\newcount\llt@temp@count % Un compteur temporaire (utilisé notamment en fin de livre et dans les lettrines)

%%%%%%%%%%%%
% Options et classe de base

\DeclareOption{petitlivre}{\llt@smallbooktrue}
\DeclareOption{lettrine}{\llt@autodropcaptrue}
\DeclareOption{@10pt}{\PassOptionsToClass{10pt}{book}}
\DeclareOption{@12pt}{\PassOptionsToClass{12pt}{book}}
\DeclareOption{@a4paper}{\PassOptionsToClass{a4paper}{book}}
\DeclareOption{@a5paper}{\PassOptionsToClass{a5paper}{book}}
\DeclareOption{@openany}{\PassOptionsToClass{openany}{book}}
\DeclareOption*{\ClassWarning{livrelitt}{Option inconnue '\CurrentOption'}}

\ifnum\GenMode=\GenModeBrouillon\relax
  \ExecuteOptions{@12pt,@a4paper,@openany}
\else
  \ifllt@smallbook
    \ExecuteOptions{@12pt,@a5paper}
  \else
    \ExecuteOptions{@10pt,@a5paper}
  \fi
\fi

\ProcessOptions\relax
\LoadClass{book}

%%%%%%%%%%%%
% Francisation

\DeclareUnicodeCharacter{00A0}{~}
\frenchbsetup{AutoSpacePunctuation=false}
\frenchbsetup{og=«,fg=»}
\addto\captionsfrench{\renewcommand{\contentsname}{Sommaire}}

%%%%%%%%%%%%
% Fichiers de métadonnées

\def\llt@disable@utf{%
  \def\UTFviii@two@octets##1##2{\string##1\string##2}%
  \def\UTFviii@three@octets##1##2##3{\string##1\string##2\string##3}%
  \def\UTFviii@four@octets##1##2##3##4{\string##1\string##2\string##3\string##4}%
}
\def\llt@write@meta#1{%
  \protected@write\metadata{\llt@disable@utf}{#1}%
}

% Créer et préparer le fichier
\immediate\newwrite\metadata
\ifcase\GenMode\relax
  % Numérique
  \immediate\openout\metadata=\jobname.opf
  \llt@write@meta{<?xml version='1.0' encoding='utf-8'?>}
  \llt@write@meta{<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="calibre_id" version="2.0">}
  \llt@write@meta{<metadata xmlns:calibre="http://calibre.kovidgoyal.net/2009/metadata" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">}
\or
  % Imprimerie
  \immediate\openout\metadata=\jobname.data
\fi

%%%%%%%%%%%%
% Informations sur le livre

\def\@title{}
\def\@author{}
\def\llt@contributor@v{}
\def\llt@contributor@h{}
\def\llt@summary{}
\def\llt@subject{}
\def\llt@publisher{}
\def\llt@copyrights{}
\def\llt@isbn@print{}
\def\llt@isbn@digital{}
\def\llt@printinfo{}
\def\llt@legaldeposit{}
\def\llt@sameauthor{}

% Définir le titre
\newcommand*\Titre[1]{%
  \def\@title{#1}%
  \ifnum\GenMode=\GenModeNumerique\relax\llt@write@meta{<dc:title opf:type="main">#1</dc:title>}\fi%
}

% Définir le ou les auteurs
\newcommand*\Auteur[1]{%
  \llt@author@split 0{\llt@author@set}#1 \et {} \et%
}
\def\llt@author@set#1#2#3#4#5{%
  \ifnum#1=0\relax%
    \def\@author{#2}%
  \else%
    \expandafter\def\expandafter\@author\expandafter{\@author, #2}%
  \fi%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \llt@write@meta{<dc:creator opf:file-as="#3" opf:role="aut">#2</dc:creator>}%
  \fi%
}

% Définir le ou les contributeurs
\newcommand*\Contributeur[1]{%
  \llt@author@split 0{\llt@contributor@set}#1 \et {} \et%
}
\def\llt@contributor@set#1#2#3#4#5{%
  \ifnum#1=0\relax%
    \def\llt@contributor@v{#5 : #2}%
    \def\llt@contributor@h{#5 : #2}%
  \else%
    \expandafter\def\expandafter\llt@contributor@v\expandafter{\llt@contributor@v\par#5 : #2}%
    \expandafter\def\expandafter\llt@contributor@h\expandafter{\llt@contributor@h\space— #5 : #2}%
  \fi%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \ifnum\GenMode=\GenModeNumerique\relax\llt@write@meta{<dc:contributor opf:file-as="#3" opf:role="#4">#2</dc:contributor>}\fi%
  \fi%
}

% Extraction des noms d'auteurs
\def\llt@author@split#1#2{%
  \@ifnextchar[ {\llt@@author@split {#1}{#2}}{\llt@@author@split {#1}{#2}[/] }%
}
\def\llt@@author@split#1#2[#3/#4] #5 \et{%
  \let\llt@z@next=\relax%
  \def\llt@z@next@split{\llt@author@split {1}{#2}}%
  \def\llt@z@temp{#5}%
  \ifx\llt@z@temp\@empty\else%
    \llt@author@extractname {#1}{#2}[#3/#4]#5, , \stop%
    \let\llt@z@next=\llt@z@next@split%
  \fi%
  \llt@z@next%
}
\def\llt@author@extractname#1#2[#3/#4]#5, #6, #7\stop{%
  \def\llt@z@temp{#6}%
  \ifx\llt@z@temp\@empty%
    #2 {#1}{#5}{#5}{#3}{#4}
  \else%
    #2 {#1}{#6 #5}{#5, #6}{#3}{#4}
  \fi%
}

% Définir le résumé (4e de couverture)
\ifnum\GenMode=\GenModeNumerique\relax
  \newcommand*\Resume{\begingroup\obeylines\llt@@summary}
  \begingroup\obeylines%
  \gdef\llt@@summary#1{%
    \gdef\llt@summary{#1}%
    \obeylines%
    \def^^M^^M{^^J}%
    \llt@write@meta{<dc:description>#1</dc:description>}%
    \endgroup%
  }%
  \endgroup
\else
  \newcommand\Resume[1]{%
    \def\llt@summary{#1}%
  }
\fi

% Définir la catégorie
\newcommand*\Categorie[1]{%
  \def\llt@subject{#1}%
  \ifnum\GenMode=\GenModeNumerique\relax\llt@write@meta{<dc:subject>#1</dc:subject>}\fi%
}

% Définir l'éditeur
\newcommand*\Editeur[1]{%
  \def\llt@publisher{#1}%
  \ifnum\GenMode=\GenModeNumerique\relax\llt@write@meta{<dc:publisher>#1</dc:publisher>}\fi%
}

% Définir les droits d'auteur
\newcommand*\DroitsDAuteur[1]{%
  \def\llt@copyrights{#1}%
  \ifnum\GenMode=\GenModeNumerique\relax\llt@write@meta{<dc:rights>#1</dc:rights>}\fi%
}

% Définir les numéros ISBN
\newcommand*\Isbn[2]{%
  \def\llt@isbn@print{#1}%
  \def\llt@isbn@digital{#2}%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \ifx\llt@isbn@digital\@empty\else%
      \llt@write@meta{<dc:identifier opf:scheme="ISBN">#1</dc:identifier>}
    \fi%
  \fi%
}

% Définir les informations d'impression
\newcommand*\InfoImpression[1]{%
  \def\llt@printinfo{#1}%
}

% Définir la date de dépôt légal
\newcommand*\DepotLegal[1]{%
  \def\llt@legaldeposit{Dépôt légal : #1}%
}

% Définir une impression hors France
\newcommand*\PresseEtrangere{%
  \llt@printfrancefalse%
}

% Définir les autres œuvres de l'auteur
\newcommand\DuMemeAuteur[1]{%
  \def\llt@sameauthor{\begin{center}DU MÊME AUTEUR\par\end{center}\par#1}%
}

%%%%%%%%%%%%
% Mise en page

\newlength{\llt@sidemargin}
\newlength{\llt@bindingmargin}
\newlength{\llt@topmargin}
\newlength{\llt@topmarginsep}
\newlength{\llt@botmargin}
\newlength{\llt@botmarginsep}

\ifcase\GenMode\relax
  % Numérique (pas de marge fixe)
  \setlength{\llt@topmargin}{0mm}
  \setlength{\llt@topmarginsep}{0mm}
  \setlength{\llt@botmargin}{0mm}
  \setlength{\llt@botmarginsep}{0mm}
  \setlength{\llt@bindingmargin}{0mm}
  \setlength{\llt@sidemargin}{0mm}
\or
  % Imprimerie
  \setlength{\llt@topmargin}{18mm}
  \setlength{\llt@topmarginsep}{10mm}
  \setlength{\llt@botmargin}{22mm}
  \setlength{\llt@botmarginsep}{10mm}
  \ifllt@smallbook\setlength{\llt@bindingmargin}{2mm}\else\setlength{\llt@bindingmargin}{1mm}\fi
  \setlength{\llt@sidemargin}{25mm}
\or
  % Brouillon
  \setlength{\llt@topmargin}{15mm}
  \setlength{\llt@topmarginsep}{8mm}
  \setlength{\llt@botmargin}{15mm}
  \setlength{\llt@botmarginsep}{8mm}
  \setlength{\llt@bindingmargin}{5mm}
  \setlength{\llt@sidemargin}{20mm}
\fi

\setlength{\pdfpageheight}{\paperheight}
\setlength{\pdfpagewidth}{\paperwidth}

\setlength{\topmargin}{-1in}
\setlength{\textheight}{\paperheight}
\addtolength{\textheight}{-\llt@topmargin}
\addtolength{\textheight}{-\llt@topmarginsep}
\addtolength{\textheight}{-\llt@botmargin}
\addtolength{\textheight}{-\llt@botmarginsep}
\addtolength{\topmargin}{\llt@topmargin}
\setlength{\headheight}{\baselineskip}
\addtolength{\topmargin}{-\headheight}
\setlength{\headsep}{\llt@topmarginsep}
\setlength{\footskip}{\llt@botmarginsep}
\addtolength{\footskip}{\baselineskip}

\setlength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{-1in}
\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-2\llt@sidemargin}
\addtolength{\textwidth}{-\llt@bindingmargin}
\addtolength{\oddsidemargin}{\llt@sidemargin}
\addtolength{\oddsidemargin}{\llt@bindingmargin}
\addtolength{\evensidemargin}{\llt@sidemargin}

\ifnum\GenMode=\GenModeBrouillon\relax
  \renewcommand{\baselinestretch}{1.5}
\else\ifllt@smallbook
  \renewcommand{\baselinestretch}{1.2}
\fi\fi
\setlength{\parskip}{4pt plus 4pt minus 2pt}

\tolerance=500
\emergencystretch=3em

%%%%%%%%%%%%
% Gestion des lettrines

\long\def\llt@ltn@capture@par#1 \par{%
  \def\llt@z@temp{#1}%
  \ifx\llt@z@temp\@empty%
    \let\llt@z@next=\llt@ltn@capture@par%
  \else%
    \prevgraf0%
    \llt@ltn@capture #1 \par%
    {%
      \llt@temp@count=\numexpr2-\prevgraf\relax%
      \ifnum\llt@temp@count>0%
        \vspace{\llt@temp@count\baselineskip}%
      \fi%
    }%
    \let\llt@z@next=\relax%
  \fi%
  \llt@z@next%
}
\long\def\llt@ltn@capture{%
  \@ifnextchar[ \llt@@ltn@capture{\llt@@ltn@capture[]}%
}
\long\def\llt@@ltn@capture[#1]#2#3 {%
  \llt@ltn@analyze[#1]#2#3{}{}{}{}{}\relax%
}
\long\def\llt@ltn@analyze[#1]#2#3#4#5#6\relax{%
  \def\llt@z@next@capture{\llt@ltn@capture[#1]}%
  \def\llt@z@next@analyze{\llt@ltn@analyze[#1]#3#4#5#6{}{}{}{}{}\relax}%
  \let\llt@z@next=\relax%
  \def\llt@z@temp{#2}%
  \ifx\llt@z@temp\@empty%
    \let\llt@z@next=\llt@z@next@capture%
  \else\ifx#2\par%
    \let\llt@z@next=\llt@z@next@analyze%
  \else%
    \ifnum`#2>239\relax%
      \def\llt@z@next@exec{\llt@ltn@exec[#1]{#2#3#4#5}{#6}}%
      \let\llt@z@next=\llt@z@next@exec%
    \else\ifnum`#2>223\relax%
      \def\llt@z@next@exec{\llt@ltn@exec[#1]{#2#3#4}{#5#6}}%
      \let\llt@z@next=\llt@z@next@exec%
    \else\ifnum`#2>127\relax%
      \def\llt@z@next@exec{\llt@ltn@exec[#1]{#2#3}{#4#5#6}}%
      \let\llt@z@next=\llt@z@next@exec%
    \else%
      \def\llt@z@next@exec{\llt@ltn@exec[#1]{#2}{#3#4#5#6}}%
      \let\llt@z@next=\llt@z@next@exec%
    \fi\fi\fi%
  \fi\fi%
  \llt@z@next%
}
\def\llt@ltn@exec[#1]#2#3{%
  \def\llt@z@done{0}%
  \def\llt@z@temp{#1}%
  \ifx\llt@z@temp\@empty%
    \def\llt@z@ante{}%
  \else%
    \def\llt@z@ante{[ante=#1]}%
  \fi%
  \def\llt@z@temp{#2}%
  \def\llt@z@guill{«}%
  \def\llt@z@dash{—}%
  \def\llt@z@nbsp{~}%
  \ifx\llt@z@guill\llt@z@temp%
    \def\llt@z@temp{\guillemotleft}%
  \else\ifx\llt@z@dash\llt@z@temp%
    \def\llt@z@temp{---}%
  \else\ifx\llt@z@nbsp\llt@z@temp%
    \def\llt@z@temp{}%
  \else%
    \def\llt@z@done{1}%
    \expandafter\lettrine\llt@z@ante{#2}{#3}%
    \space%
  \fi\fi\fi%
  \let\llt@z@next=\relax%
  \ifnum\llt@z@done=0\relax%
    \ifx\llt@z@ante\@empty%
      \edef\llt@z@ante{\llt@z@temp}%
    \else%
      \def\llt@z@ante{#1}%
    \fi%
    \edef\llt@z@next@capture{\noexpand\llt@ltn@capture[\llt@z@ante]}%
    \edef\llt@z@next@analyze{\noexpand\llt@ltn@analyze[\llt@z@ante]\noexpand#3\noexpand{}\noexpand{}\noexpand{}\noexpand{}\noexpand\relax}%
    \def\llt@z@temp{#3}%
    \ifx\llt@z@temp\@empty%
      \let\llt@z@next=\llt@z@next@capture%
    \else%
      \let\llt@z@next=\llt@z@next@analyze%
    \fi%
  \fi%
  \llt@z@next%
}

%%%%%%%%%%%%
% Parties et chapitres

\def\PartieActuelle{}
\def\ChapitreActuel{}
\def\llt@inside@chapter{0}
\def\llt@end@part{%
  \def\PartieActuelle{}%
  \def\ChapitreActuel{}%
  \def\llt@inside@chapter{0}%
  \llt@mark%
}
\def\llt@end@chapter{%
  \def\ChapitreActuel{}%
  \def\llt@inside@chapter{0}%
  \llt@mark%
}
\def\llt@mark{%
  \mark{\PartieActuelle \noexpand\or \ChapitreActuel \noexpand\or \llt@inside@chapter}%
}
\llt@mark

% Sauver et modifier le comportement par défaut
\let\llt@sav@clearpage=\clearpage
\let\llt@sav@newpage=\newpage
\let\llt@sav@part=\part
\let\llt@sav@chapter=\chapter
\let\llt@sav@tableofcontents=\tableofcontents

% Supprimer la gestion des marques par défaut
\def\markright#1{\relax}
\def\markboth#1#2{\relax}
\let\leftmark\relax
\let\rightmark\relax

% Désactivation et réactivation des sauts de page
\def\llt@pagebreak@disable{%
  \ifnum\GenMode=\GenModeBrouillon\relax%
    \let\clearpage=\par%
    \let\newpage=\par%
  \fi%
}
\def\llt@pagebreak@enable{%
  \ifnum\GenMode=\GenModeBrouillon\relax%
    \let\clearpage=\llt@sav@clearpage%
    \let\newpage=\llt@sav@newpage%
  \fi%
}

% Modification de la définition d'une partie
\renewcommand\part{%
  \llt@end@part%
  \secdef\llt@part\llt@spart%
}
\def\llt@part[#1]#2{%
  \llt@pagebreak@disable%
  \llt@sav@part[#1]{#2}%
  \llt@pagebreak@enable%
  \def\PartieActuelle{#1}%
  \llt@mark%
}
\def\llt@spart#1{%
  \llt@pagebreak@disable%
  \llt@sav@part*{#1}%
  \llt@pagebreak@enable%
  \def\PartieActuelle{#1}%
  \llt@mark%
}

% Modification de la définition d'un chapitre
\renewcommand\chapter{%
  \llt@end@chapter%
  \secdef\llt@chapter\llt@schapter%
}
\def\llt@chapter[#1]#2{%
  \llt@pagebreak@disable%
  \llt@sav@chapter[#1]{#2}%
  \llt@pagebreak@enable%
  \def\ChapitreActuel{#1}%
  \def\llt@inside@chapter{1}%
  \llt@mark%
  \ifllt@autodropcap\expandafter\llt@ltn@capture@par\fi%
}
\def\llt@schapter#1{%
  \llt@pagebreak@disable%
  \llt@sav@chapter*{#1}%
  \llt@pagebreak@enable%
  \def\ChapitreActuel{#1}%
  \def\llt@inside@chapter{1}%
  \llt@mark%
}

%%%%%%%%%%%%
% En-têtes et pieds de page

\def\llt@if@ongoing@chapter#1#2{%
  \edef\llt@z@val{\ifcase2\expandafter\relax #1\fi}%
  \ifnum\llt@z@val=1\relax#2\fi%
}
\def\llt@header@defined{0}
\def\llt@header@left{}
\def\llt@header@right{}
\def\llt@footer@defined{0}
\def\llt@footer@left{}
\def\llt@footer@right{}
\def\ps@plain{%
  \ifcase\GenMode\relax
    % Numérique
    \def\@evenhead{}%
    \def\@oddhead{}%
    \def\@evenfoot{}%
    \def\@oddfoot{}%
  \or
    % Imprimerie
    \def\@evenhead{\llt@if@ongoing@chapter\topmark\llt@header@left}%
    \def\@oddhead{\llt@if@ongoing@chapter\topmark\llt@header@right}%
    \def\@evenfoot{\llt@if@ongoing@chapter\botmark\llt@footer@left}%
    \def\@oddfoot{\llt@if@ongoing@chapter\botmark\llt@footer@right}%
  \or
    % Brouillon
    \def\@evenhead{\textit{\@title}\hfill Version du \today}%
    \def\@oddhead{\textit{\@title}\hfill Version du \today}%
    \def\@evenfoot{\hfill\thepage\hfill}%
    \def\@oddfoot{\hfill\thepage\hfill}%
\fi
}

% Commandes
\newcommand\Entete[2][]{%
  \def\llt@header@defined{1}%
  \ifx#1G\relax%
    \def\llt@header@left{#2}%
  \else\ifx#1D\relax%
    \def\llt@header@right{#2}%
  \else%
    \def\llt@header@left{#2}%
    \def\llt@header@right{#2}%
  \fi\fi%
}
\newcommand\PiedPage[2][]{%
  \def\llt@footer@defined{1}%
  \ifx#1G\relax%
    \def\llt@footer@left{#2}%
  \else\ifx#1D\relax%
    \def\llt@footer@right{#2}%
  \else%
    \def\llt@footer@left{#2}%
    \def\llt@footer@right{#2}%
  \fi\fi%
}

% Éléments utilisables dans les en-têtes
\newcommand\LeTitre{\@title}
\newcommand\LAuteur{\@author}
\newcommand*\LaPartie[1]{%
  \ifcase0\expandafter\relax #1\fi%
}
\newcommand*\LeChapitre[1]{%
  \ifcase1\expandafter\relax #1\fi%
}

%%%%%%%%%%%%
% Définitions spécifiques

\ifcase\GenMode\relax
  % Numérique
  \def\cl@chapter{\@elt{section}\@elt{equation}\@elt{figure}\@elt{table}}% Ne pas réinitialiser les notes de bas de page
  \def\llt@digital@nopar{\ifvmode\IgnorePar\fi\EndP}
  \def\llt@digital@pagebreak{\llt@digital@nopar\HCode{<div class="newpage"></div>}}
  \def\clearpage{\llt@sav@clearpage\llt@digital@pagebreak}
  \let\cleardoublepage=\clearpage % Inutile de sauter 2 pages sur un livre numérique
  \def\FB@og{\HCode{&laquo;&nbsp;}\ignorespaces}
  \def\FB@fg{\unskip\HCode{&nbsp;&raquo;}}
  \def\null{\HCode{&nbsp;}}
\or
  % Imprimerie
\or
  % Brouillon
  \let\cleardoublepage=\clearpage % On ne saute pas 2 pages en mode brouillon
  \def\tableofcontents{\llt@sav@clearpage\llt@sav@tableofcontents}
\fi

%%%%%%%%%%%%
% Invalidation des commandes

\def\llt@invalidate#1{%
  \llt@invalidate@cmd #1,,%
}
\def\llt@invalidate@cmd#1,{%
  \def\llt@z@temp{#1}%
  \ifx\llt@z@temp\@empty\else%
    \expandafter\gdef\csname #1\endcsname{\ClassError{livrelitt}{La commande #1 n'est utilisable que dans le préambule}}%
    \expandafter\llt@invalidate@cmd%
  \fi%
}

%%%%%%%%%%%%
% Début du document

\AtBeginDocument{%
  % Mettre des valeurs par défaut
  \ifx\@title\@empty \Titre{?Titre?}\fi%
  \ifx\@author\@empty \Auteur{?Auteur?}\fi%
  \ifx\llt@summary\@empty \expandafter\Resume\expandafter{\@title}\fi%
  \ifx\llt@subject\@empty \Categorie{Roman}\fi%
  \ifx\llt@publisher\@empty \Editeur{Auteur-Éditeur}\fi%
  \ifx\llt@copyrights\@empty \Licence{© \today\relax}\fi%
  \ifnum\llt@header@defined=0\relax%
    \Entete[G]{\hfill\small{\LAuteur}\hfill}%
    \Entete[D]{\hfill\textit{\LeTitre}\hfill}%
  \fi%
  \ifnum\llt@footer@defined=0\relax%
    \PiedPage{\hfill\thepage\hfill}%
  \fi%
%
  % Invalider les commandes
  \llt@invalidate{Titre,Auteur,Contributeur,Resume,Categorie,Editeur,%
    DroitsDAuteur,Isbn,InfoImpression,DepotLegal,PresseEtrangere,DuMemeAuteur,%
    Entete,PiedPage}%
%
  % Terminer le fichier de métadonnées
  \ifcase\GenMode\relax%
    % Numérique
    \llt@write@meta{<dc:language>fr</dc:language>}%
    \llt@write@meta{</metadata>}%
    \llt@write@meta{<manifest/>}%
    \llt@write@meta{<spine/>}%
    \llt@write@meta{<guide/>}%
    \llt@write@meta{</package>}%
    \closeout\metadata%
  \or%
    % Imprimerie
    \llt@write@meta{\@title}%
    \llt@write@meta{\@author}%
    \llt@write@meta{\llt@contributor@h}%
    \llt@write@meta{\llt@publisher}%
    \llt@write@meta{\llt@isbn@print}%
    \llt@write@meta{\llt@summary}%
    \closeout\metadata%
  \or%
    % Brouillon
  \fi%
%
  % Premières pages
  \pagestyle{empty}%
  \ifcase\GenMode\relax%
    % Numérique
    \Css{p.indent{text-indent: 1.5em;}}%i
    \Css{.newpage{page-break-before: always;}}%
    \Css{.tpauthor{height: 30\%; text-align: center;}}%
    \Css{.tptitle{height: 50\%; text-align: center;}}%
    \Css{.tptitle p{text-indent: 0; margin-top: 1em;}}%
    \Css{.tppublisher{text-align: center;}}%
    \Css{.fplegal{margin-top: 50\%; text-align: center;}}%
    \Css{.fplegal p{text-indent: 0;}}%
    \Css{.handwriting{font-family: cursive;}}%
    \Css{.pageillustr{width: 100\%; text-indent: 0; text-align: center; page-break-inside: avoid; page-break-before: auto; page-break-after: auto;}}%
    \Css{.pageillustr svg{display: inline-block; width: 100\%; margin: 0 auto;}}%
    \Tag{TITLE+}{\@title}%
    \Configure{newpage}{\llt@digital@pagebreak}%
    \Configure{@BODY}{%
      \llt@digital@nopar%
      \HCode{<div class="tpauthor">}{\Large\@author}\HCode{</div>}%
      \HCode{<div class="tptitle">}{\Huge\@title}\HCode{<br />}\textsc{\llt@subject}\HCode{</div>}%
      \HCode{<div class="tppublisher">}{\bfseries\llt@publisher}\HCode{</div>}%
      \newpage%
    }%
    \ifllt@autodropcap\else\Configure{chapter}{}{}%
      {\IgnorePar\EndP\HCode{<h2 class="chapterHead"\csname a:LRdir\endcsname>}%
      \TitleMark{\HCode{<br />}}}%
      {\HCode{</h2>}\par}%
    \fi%
    \Configure{likechapter}{}{}%
      {\IgnorePar\EndP\HCode{<h2 class="likechapterHead"\csname a:LRdir\endcsname>}}%
      {\HCode{</h2>}\par}%
    \Configure{graphics*}{png}{%
      \Picture[pict]{\csname Gin@base\endcsname .png%
      \space width="\expandafter\the\csname Gin@req@width\endcsname"%
    }}%
  \or%
    % Imprimerie
    \null\newpage%
    \null\newpage%
    \begin{center}%
      \vspace*{\stretch{1}}\@title\vspace*{\stretch{2}}%
    \end{center}%
    \newpage%
    \llt@sameauthor\par\vspace*{\stretch{1}}{\small\llt@contributor@v}%
    \newpage%
    \begin{center}%
      {\Large\@author\par}%
      \vspace*{\stretch{1}}%
      {\Huge\@title\par}\vspace{\baselineskip}\textsc{\llt@subject}\par%
      \vspace*{\stretch{2}}%
      {\bfseries\llt@publisher}%
    \end{center}%
    \newpage%
    \vspace*{\fill}%
    \begin{center}%
      \llt@copyrights\par%
      \null\par%
      \ifx\llt@isbn@print\@empty\else N° ISBN : \llt@isbn@print \fi%
    \end{center}%
    \newpage%
  \or%
    % Brouillon
    \begin{center}%
      {\Large\textsc{Confidentiel — Merci de ne pas diffuser}\par}%
      {\Large\@author\par}%
      {\Huge\@title\par}\vspace{\baselineskip}\textsc{\llt@subject}\par%
      (mode révision)\par%
    \end{center}%
    {\small\emph{N'hésitez pas à annoter le texte directement, si possible au stylo rouge. %
    Des marques dans la marge pour repérer plus facilement les annotations seront appréciées.}}\par%
    Résumé :\par\llt@summary\par%
    \vspace*{\stretch{1}}{\small\llt@sameauthor\par\hrulefill\par\llt@contributor@v}%
    \begin{center}%
      {\Large\par\textsc{Confidentiel — Merci de ne pas diffuser}}%
    \end{center}%
    \newpage%
  \fi%
  \pagestyle{plain}%
}

%%%%%%%%%%%%
% Fin du document

\AtEndDocument{%
  % Terminer le livre
  \llt@end@part%
  \clearpage%
  \pagestyle{empty}%
%
  % Dernières pages
  \ifcase\GenMode\relax%
    % Numérique
    \llt@sameauthor%
    \llt@digital@pagebreak%
    \llt@digital@nopar\HCode{<div class="fplegal">}\par\ShowPar%
    \llt@copyrights\par%
    \llt@contributor@v\par%
    \ifx\llt@isbn@digital\@empty\else N° ISBN : \llt@isbn@digital\par \fi%
    \llt@legaldeposit%
    \llt@digital@nopar\HCode{</div>}%
    \llt@digital@pagebreak%
  \or%
    % Imprimerie
    \llt@temp@count=\thepage%
    \divide\llt@temp@count by 4% Il faut un multiple de 4 pages
    \llt@temp@count=\numexpr\thepage-\llt@temp@count*4\relax%
    \ifnum\llt@temp@count=0\relax\null\newpage\fi%
    \ifnum\llt@temp@count<3\relax\null\cleardoublepage\fi%
    \vspace*{\fill}%
    \begin{center}%
      \ifllt@printfrance\emph{Imprimé en France}\par\fi%
      \llt@printinfo\par\null\par\llt@legaldeposit%
    \end{center}%
    \newpage\null%
  \or%
    % Brouillon
  \fi%
}

%%%%%%%%%%%%
% Commandes spécifiques

% Style barré
\newcommand\barre[1]{%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \HCode{<s>}#1\HCode{</s>}%
  \else%
    \settowidth{\llt@temp@length}{#1}%
    \makebox[0cm][l]{#1}%
    \rule[0.5ex]{\llt@temp@length}{0.2pt}%
  \fi%
}

% Langue étrangère
\newcommand\etranger[1]{%
  \emph{#1}%
}

% Séparateur de paragraphes
\newcommand\separateurpar{%
  \par%
  \begin{center}%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \HCode{&\#x2042;}%
  \else%
    \mbox{%
      \makebox[1.5em][c]{*}\hspace{-1.5em}%
      \raisebox{-1em}{\makebox[1.5em][c]{*\hfill{}*}}%
    }%
  \fi%
  \end{center}%
  \par%
}

% Illustration pleine page
\newcommand\pageillustr[1]{%
  \ifcase\GenMode\relax%
    % Numérique
    \llt@digital@nopar%
    \HCode{<div class="pageillustr">}%
    \HCode{<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="100\%" height="100\%" viewBox="0 0 600 800" preserveAspectRatio="xMidYMid meet">}%
    \HCode{<image width="600" height="800" xlink:href="#1"/>}%
    \HCode{</svg>}%
    \HCode{</div>}%
  \or%
    % Imprimerie
    \afterpage{%
      \vspace*{\stretch{1}}%
      \noindent\includegraphics[width=\textwidth]{#1}%
      \vspace*{\stretch{1}}%
      \thispagestyle{empty}%
      \newpage%
    }%
  \or%
    % Brouillon
    \par\begin{center}{\Large[Emplacement pour une image]}\end{center}\par%
  \fi%
}

%%%%%%%%%%%%
% Environnements spécifiques

% Dédicace
\newenvironment{dedicace}{%
  \ifnum\GenMode=\GenModeBrouillon\relax%
    \par%
  \else%
    \cleardoublepage\thispagestyle{empty}\vspace*{\fill}%
  \fi%
  \begin{flushright}\slshape%
}{%
  \upshape\end{flushright}%
  \ifnum\GenMode=\GenModeBrouillon\relax%
    \par%
  \else%
    \vspace*{\fill}\cleardoublepage%
  \fi%
}

% Narrateur
\newenvironment{narrateur}{%
  \slshape%
}{%
  \upshape%
}

% Manuscrit
\newenvironment{manuscrit}{%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \llt@digital@nopar\HCode{<div class="handwriting">}\par\ShowPar%
  \else%
    \fontfamily{pzc}\selectfont%
  \fi%
}{%
  \ifnum\GenMode=\GenModeNumerique\relax%
    \llt@digital@nopar\HCode{</div>}%
  \else%
    \null%
  \fi%
}

%%%%%%%%%%%%
% Fin du fichier

\endinput

