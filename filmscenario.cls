\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{filmscenario}[2017/05/01]

% Options
\DeclareOption*{\PackageError{filmscenario}{Option inconnue '\CurrentOption'}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper]{article}[2004/02/16]

% Paquets necessaires
\RequirePackage{ifthen,textcomp,eurosym,ucs,fancyhdr}
\RequirePackage[utf8x]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[francais]{babel}
\RequirePackage[autolanguage]{numprint}
\RequirePackage{courier}

% Informations sur le film
\def\@titre{?Titre?}
\def\@auteur{?Auteur?}
\def\@contact{?Adresse?}

\newcommand\Titre[1]{%
  \def\@titre{#1}%
}
\newcommand\Auteur[1]{%
  \def\@auteur{#1}%
}
\newcommand\Contact[1]{%
  \def\@contact{#1}%
}

% Reglages des longueurs
\newlength{\@hauteurtexte}
\newlength{\@largeurtexte}
\newlength{\@largeurcontact}
\newlength{\@espacecontact}
\newlength{\@largeurdialogue}
\newlength{\@espacedialogue}
\newlength{\@tempmarge}

\setlength{\@hauteurtexte}{240mm}
\setlength{\@largeurtexte}{155mm}
\setlength{\@largeurcontact}{50mm}
\setlength{\@largeurdialogue}{82mm}

\setlength{\pdfpageheight}{\paperheight}
\setlength{\pdfpagewidth}{\paperwidth}

\setlength{\headheight}{16pt}
\setlength{\@tempmarge}{0.5\paperheight}
\addtolength{\@tempmarge}{-0.5\@hauteurtexte}
\setlength{\voffset}{-1in}
\addtolength{\voffset}{0.5\@tempmarge}
\addtolength{\voffset}{-0.5\headheight}
\addtolength{\voffset}{-5mm}
\setlength{\topmargin}{5mm}
\setlength{\headsep}{0.5\@tempmarge}
\addtolength{\headsep}{-0.5\headheight}
\setlength{\textheight}{\@hauteurtexte}
\setlength{\footskip}{0.5\@tempmarge}
\addtolength{\footskip}{-0.5\headheight}

\setlength{\@tempmarge}{0.5\paperwidth}
\addtolength{\@tempmarge}{-0.5\@largeurtexte}
\setlength{\hoffset}{-1in}
\addtolength{\hoffset}{\@tempmarge}
\addtolength{\hoffset}{-5mm}
\setlength{\oddsidemargin}{5mm}
\setlength{\marginparwidth}{50pt}
\setlength{\textwidth}{\@largeurtexte}

\setlength{\@espacecontact}{\@largeurtexte}
\addtolength{\@espacecontact}{-\@largeurcontact}

\setlength{\@espacedialogue}{0.5\@largeurtexte}
\addtolength{\@espacedialogue}{-0.5\@largeurdialogue}

\renewcommand*{\baselinestretch}{0.8}
\setlength{\baselineskip}{12pt plus 0pt minus 0pt}
\setlength{\parskip}{\baselineskip}
\setlength{\parindent}{0in}
\renewcommand*{\textfraction}{1}
\renewcommand*{\topfraction}{0}
\renewcommand*{\bottomfraction}{0}

% Gestion des scènes
\newcounter{scenecount}
\newcounter{lastscenecount}
\setcounter{scenecount}{0}
\newcommand*{\scene}[3]{%
  \stepcounter{scenecount}%

  \vspace{\parskip}%
  \begin{bfseries}%
    \hspace{-3em}\makebox[3em][l]{\thescenecount}%
    \MakeUppercase{#1.~#2\hspace{2em plus 0em minus 0em}#3}\hspace{\fill}%
  \end{bfseries}%
  \nopagebreak%
}
\newcommand*{\sint}[2]{\scene{INT}{#2}{#1}}
\newcommand*{\sext}[2]{\scene{EXT}{#2}{#1}}
\newcommand*{\sintext}[2]{\scene{INT./EXT}{#2}{#1}}
\newcommand*{\sextint}[2]{\scene{EXT./INT}{#2}{#1}}
\newcommand*{\generique}{\scene{GÉNÉRIQUE}{}{}}
\newcommand*{\transition}[1]{\hspace*{\stretch{1}}\mbox{\MakeUppercase{#1}}}

% Dialogues et didascalies
\newenvironment{dialogue}[1]{%
\newcommand*{\did}[1]{%

\hspace*{1.5em}(\emph{##1})%

}
\renewcommand*{\dit}[1]{\end{dialogue}\begin{dialogue}{##1}}
\newcommand*{\coupe}{%
  \hspace*{\stretch{1}}\did{…}%
  \end{dialogue}%
  \newpage%
  \begin{dialogue}{#1}%
  \didasc{SUITE}%
}

  \begin{minipage}{\textwidth}%
  \hspace*{\@espacedialogue}\hspace*{3em}\hbox{\MakeUppercase{#1}}\\*%
  \hspace*{\@espacedialogue}\begin{minipage}{\@largeurdialogue}%
  \vspace{0.5\baselineskip}%
  \raggedright%
  \begin{tt}%
}{%
  \end{tt}%
  \end{minipage}%
  \end{minipage}%

}
\newcommand{\dit}[2]{\begin{dialogue}{#1}#2\end{dialogue}}

% En-tête et pieds de page
\fancypagestyle{plain}{%
  \fancyhf[FL,FR]{}%
  \lhead{\@auteur}%
  \chead{\setcounter{lastscenecount}{\thescenecount}}%
  \rhead{Ouverture}%
  \cfoot{-- \thepage --}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{fancy}
\fancyhf[FL,FR]{}
\lhead{\@auteur}
\chead{\@titre}
\rhead{Scène \thelastscenecount%
  \setcounter{lastscenecount}{\thescenecount}%
}
\cfoot{-- \thepage --}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Francisation
\frenchbsetup{AutoSpacePunctuation=false}
\frenchbsetup{og=«,fg=»}

% Page de couverture et première page
\AtBeginDocument{%
  \thispagestyle{empty}%
  \vspace*{\stretch{1}}%
  \begin{center}%
    {\Huge \MakeUppercase{\@titre}}\\%
    \vspace{\parskip}%
    par\\%
    \vspace{\parskip}%
    \@auteur%
  \end{center}%
  \vspace*{\stretch{1}}%
  \hspace{\@espacecontact}\parbox[t]{\@largeurcontact}{\@auteur\\\@contact}%
  \newpage%
  \setcounter{page}{1}%
  \thispagestyle{plain}%
  \begin{center}%
    {\Huge \MakeUppercase{\@titre}}\\%
  \end{center}%
  \transition{Fondu à l'ouverture :}
}

% Fin
\AtEndDocument{%
  \begin{center}%
    \vspace{\parskip}%
    --~FIN~--%
  \end{center}%
}
