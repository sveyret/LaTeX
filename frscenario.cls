%%%%%%%%%%%%
% Classe permettant de générer un scénario (français)

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{frscenario}[2017/12/01]

%%%%%%%%%%%%
% Paquets nécessaires

\RequirePackage{textcomp} % Pour les caractères spéciaux
\RequirePackage[utf8]{inputenc} % Format du fichier d'entrée
\RequirePackage[T1]{fontenc} % Format de sortie
\RequirePackage{courier} % Police de caractère
\RequirePackage[french]{babel} % Conventions pour le français
\RequirePackage[autolanguage]{numprint} % Écriture de nombres

%%%%%%%%%%%%
% Options et classe de base

\DeclareOption*{\ClassWarning{frscenario}{Option inconnue '\CurrentOption'}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper]{article}

%%%%%%%%%%%%
% Francisation

\DeclareUnicodeCharacter{00A0}{~}
\frenchbsetup{AutoSpacePunctuation=false}
\frenchbsetup{og=«,fg=»}

%%%%%%%%%%%%
% Informations sur le scénario

\def\@title{}
\def\@author{}
\def\fsc@contact{}

% Définir le titre
\newcommand*\Titre[1]{%
  \def\@title{#1}%
}

% Définir le ou les auteurs
\newcommand*\Auteur[1]{%
  \fsc@author@split 0#1 \et {} \et%
}
\def\fsc@author@split#1#2 \et{%
  \let\fsc@z@next=\relax%
  \def\fsc@z@next@split{\fsc@author@split {1}}%
  \def\fsc@z@temp{#2}%
  \ifx\fsc@z@temp\@empty\else%
    \ifnum#1=0\relax%
      \def\@author{#2}%
    \else%
      \expandafter\def\expandafter\@author\expandafter{\@author, #2}%
    \fi%
    \let\fsc@z@next=\fsc@z@next@split%
  \fi%
  \fsc@z@next%
}

% Définir les coordonnées des auteurs
\newcommand\Contact[1]{%
  \def\fsc@contact{#1}%
}

%%%%%%%%%%%%
% Mise en page

\newlength{\fsc@textheight}
\newlength{\fsc@textwidth}
\newlength{\fsc@contactwidth}
\newlength{\fsc@dialogwidth}
\newlength{\fsc@headheight}
\newlength{\fsc@marginwidth}
\newlength{\fsc@contactspace}
\newlength{\fsc@dialogspace}
\newlength{\fsc@marginspace}

\setlength{\fsc@textheight}{240mm} % Hauteur du texte principal
\setlength{\fsc@textwidth}{155mm} % Largeur du texte normal
\setlength{\fsc@contactwidth}{50mm} % Largeur du texte contact
\setlength{\fsc@dialogwidth}{82mm} % Largeur des dialogues
\setlength{\fsc@headheight}{16pt} % Hauteur des en-têtes et pieds de page
\setlength{\fsc@marginwidth}{50pt} % Largeur des marges (pour notes en marge)

\setlength{\pdfpageheight}{\paperheight}
\setlength{\pdfpagewidth}{\paperwidth}

\setlength{\hoffset}{-1in}
\setlength{\voffset}{-1in}

\setlength{\textheight}{\fsc@textheight}
\setlength{\headheight}{\fsc@headheight}
\setlength{\fsc@marginspace}{0.5\paperheight}
\addtolength{\fsc@marginspace}{-0.5\fsc@textheight}
\setlength{\topmargin}{0.5\fsc@marginspace}
\addtolength{\topmargin}{-0.5\fsc@headheight}
\setlength{\headsep}{0.5\fsc@marginspace}
\addtolength{\headsep}{-0.5\fsc@headheight}
\setlength{\footskip}{0.5\fsc@marginspace}
\addtolength{\footskip}{-0.5\fsc@headheight}

\setlength{\textwidth}{\fsc@textwidth}
\setlength{\fsc@marginspace}{0.5\paperwidth}
\addtolength{\fsc@marginspace}{-0.5\fsc@textwidth}
\setlength{\oddsidemargin}{\fsc@marginspace}
\setlength{\marginparwidth}{\fsc@marginwidth}

\setlength{\fsc@contactspace}{\fsc@textwidth}
\addtolength{\fsc@contactspace}{-\fsc@contactwidth}

\setlength{\fsc@dialogspace}{0.5\fsc@textwidth}
\addtolength{\fsc@dialogspace}{-0.5\fsc@dialogwidth}

\renewcommand*{\baselinestretch}{0.8}
\setlength{\baselineskip}{12pt plus 0pt minus 0pt}
\setlength{\parskip}{\baselineskip}
\setlength{\parindent}{0in}
\renewcommand*{\textfraction}{1}
\renewcommand*{\topfraction}{0}
\renewcommand*{\bottomfraction}{0}

%%%%%%%%%%%%
% En-têtes et pieds de page

\def\ps@open{%
  \def\@oddhead{\makebox[0.3\textwidth][l]{\@author}\hfill\makebox[0.3\textwidth][r]{\topmark}}%
  \def\@oddfoot{\hfill-- \thepage --\hfill}%
}
\def\ps@plain{%
  \def\@oddhead{\makebox[0.3\textwidth][l]{\@author}\hfill\@title\hfill\makebox[0.3\textwidth][r]{\topmark}}%
  \def\@oddfoot{\hfill-- \thepage --\hfill}%
}
\mark{Ouverture}

% Supprimer la gestion des marques par défaut
\def\markright#1{\relax}
\def\markboth#1#2{\relax}
\let\leftmark\relax
\let\rightmark\relax

%%%%%%%%%%%%
% Gestion des scènes

% Compteur de scène
\newcounter{fsc@scenecount}
\setcounter{fsc@scenecount}{0}

% Nouvelle scène
\newcommand*{\fsc@scene}[3]{%
  \stepcounter{fsc@scenecount}%
  \mark{Scène \thefsc@scenecount}
  \vspace{\parskip}%
  \begin{bfseries}%
    \hspace{-3em}\makebox[3em][l]{\thefsc@scenecount}%
    \MakeUppercase{#1.~#2\hspace{2em plus 0em minus 0em}#3}\hfill\thefsc@scenecount%
  \end{bfseries}%
  \nopagebreak\par%
}

% Types de scènes
\newcommand*{\SceneInt}[2]{\fsc@scene{INT}{#2}{#1}}
\newcommand*{\SceneExt}[2]{\fsc@scene{EXT}{#2}{#1}}
\newcommand*{\SceneIntExt}[2]{\fsc@scene{INT./EXT}{#2}{#1}}
\newcommand*{\SceneExtInt}[2]{\fsc@scene{EXT./INT}{#2}{#1}}
\newcommand*{\Generique}{\fsc@scene{GÉNÉRIQUE}{}{}}
\newcommand*{\transition}[1]{\hfill\mbox{\MakeUppercase{#1}}\par}

%%%%%%%%%%%%
% Dialogues et didascalies

\newenvironment{fsc@dialogue}[1]{%
  \def\—##1\par{\end{fsc@dialogue}\begin{fsc@dialogue}{##1}}
  \def\dial##1\par{\end{fsc@dialogue}\begin{fsc@dialogue}{##1}}
  \newcommand*{\did}[1]{%
    \par\hspace*{1.5em}(\emph{##1})\par%
  }
  \newcommand*{\coupe}{%
    \hfill\did{…}%
    \end{fsc@dialogue}%
    \newpage%
    \begin{fsc@dialogue}{#1}%
    \did{SUITE}%
  }
%
  \begin{minipage}{\textwidth}%
  \hspace*{\fsc@dialogspace}\hspace*{3em}\hbox{\MakeUppercase{#1}}\\*%
  \hspace*{\fsc@dialogspace}\begin{minipage}{\fsc@dialogwidth}%
  \vspace{0.5\baselineskip}%
  \raggedright%
  \begin{tt}%
}{%
  \end{tt}%
  \end{minipage}%
  \end{minipage}%
  \par%
}
\long\def\—#1\par#2\——{\begin{fsc@dialogue}{\ignorespaces#1\ignorespaces}#2\end{fsc@dialogue}}
\long\def\dial#1\par#2\fin{\begin{fsc@dialogue}{\ignorespaces#1\ignorespaces}#2\end{fsc@dialogue}}

%%%%%%%%%%%%
% Invalidation des commandes

\def\fsc@invalidate#1{%
  \fsc@invalidate@cmd #1,,%
}
\def\fsc@invalidate@cmd#1,{%
  \def\fsc@z@temp{#1}%
  \ifx\fsc@z@temp\@empty\else%
    \expandafter\gdef\csname #1\endcsname{\ClassError{frscenario}{La commande #1 n'est utilisable que dans le préambule}}%
    \expandafter\fsc@invalidate@cmd%
  \fi%
}

%%%%%%%%%%%%
% Début du document

\AtBeginDocument{%
  % Mettre des valeurs par défaut et invalider les commandes
  \ifx\@title\@empty \Titre{?Titre?}\fi%
  \ifx\@author\@empty \Auteur{?Auteur?}\fi%
  \fsc@invalidate{Titre,Auteur,Contact}%
%
  % Style des pages
  \pagestyle{plain}%
%
  % Couverture
  \thispagestyle{empty}%
  \vspace*{\stretch{1}}%
  \begin{center}%
    {\Huge \MakeUppercase{\@title}}\\%
    \vspace{\parskip}%
    par\\%
    \vspace{\parskip}%
    \@author%
  \end{center}%
  \vspace*{\stretch{1}}%
  \hspace{\fsc@contactspace}\parbox[t]{\fsc@contactwidth}{\@author\\\fsc@contact}%
%
  % Première page
  \newpage%
  \thispagestyle{open}%
  \setcounter{page}{1}%
  \begin{center}%
    {\Huge \MakeUppercase{\@title}}\\%
  \end{center}%
  \transition{Fondu à l'ouverture :}%
}

%%%%%%%%%%%%
% Fin du document

\AtEndDocument{%
  \begin{center}%
    \vspace{\parskip}%
    --~FIN~--%
  \end{center}%
}
