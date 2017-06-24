% Reste à faire :
% PRINT : Générer le code-barre automatiquement
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{publivre}[2017/05/01]

% Paquets nécessaires
\RequirePackage{ifpdf,ifthen,textcomp,fancyhdr}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[francais]{babel}
\RequirePackage[autolanguage]{numprint}
\RequirePackage{graphicx}

% Utiliser @ comme une lettre classique
\makeatletter

% Conditions
\newif\ifbrouillon % Mode brouillon
\newif\if@html % Moteur HTML
\newif\if@imprimefrance % Indique si imprimé en France
\newif\if@petitlivre % Petit livre (faible nombre de pages)
\newif\if@chapnum % Numérotation des chapitres
\newif\if@chapindic % Numérotation avec indicateur (« Chapitre »)

\ifdefined\HCode % Moteur HTML
  \@htmltrue
\else
  \@htmlfalse
\fi
\@imprimefrancetrue % Par défaut, on imprime en France
\@petitlivrefalse % Par défaut, on considère que le livre est gros
\@chapnumtrue % Par défaut, les chapitre sont numérotés
\@chapindictrue % Par défaut, les chapitre ont une indication avant le numéro

% Mode (non) brouillon, à redéfinir en amont pour modifier
\providecommand\Brouillon{%
	\brouillonfalse%
}
\Brouillon{}

% Options
\DeclareOption{petitlivre}{\@petitlivretrue}
\DeclareOption{sanschapnum}{\@chapnumfalse\@chapindicfalse}
\DeclareOption{chapnumsimple}{\@chapnumtrue\@chapindicfalse}
\DeclareOption{@10pt}{\PassOptionsToClass{10pt}{book}}
\DeclareOption{@12pt}{\PassOptionsToClass{12pt}{book}}
\DeclareOption{@a4paper}{\PassOptionsToClass{a4paper}{book}}
\DeclareOption{@a5paper}{\PassOptionsToClass{a5paper}{book}}
\DeclareOption{@openany}{\PassOptionsToClass{openany}{book}}
\DeclareOption*{\PackageError{publivre}{Option inconnue '\CurrentOption'}}

\ifbrouillon\ExecuteOptions{@12pt,@a4paper,@openany}\else
  \if@petitlivre\ExecuteOptions{@12pt,@a5paper}\else\ExecuteOptions{@10pt,@a5paper}\fi
\fi
\ProcessOptions

\LoadClass[twoside]{book}

% Francisation
\DeclareUnicodeCharacter{00A0}{~}
\frenchbsetup{AutoSpacePunctuation=false}
\frenchbsetup{og=«,fg=»}
\if@html
  \def\FB@og{\HCode{&laquo;&nbsp;}\ignorespaces}
  \def\FB@fg{\unskip\HCode{&nbsp;&raquo;}}
\fi

% Fichiers annexes
\newcommand\disable@UTF{%
  \def\UTFviii@two@octets##1##2{\string##1\string##2}%
  \def\UTFviii@three@octets##1##2##3{\string##1\string##2\string##3}%
  \def\UTFviii@four@octets##1##2##3##4{\string##1\string##2\string##3\string##4}%
}
\immediate\newwrite\metadata
\newcommand\@writemeta[1]{%
  \protected@write\metadata{\disable@UTF}{#1}%
}

\ifpdf % moteur pdflatex
  \RequirePackage[pdftex,
                  pdfpagelabels,
                  hyperindex=true,
                  colorlinks=true,
                  linkcolor=black,citecolor=black,
                  filecolor=black,urlcolor=black]{hyperref}
  \ifbrouillon\else
    \immediate\openout\metadata=\jobname.data
  \fi
\else % moteur tex
  \if@html
    \immediate\openout\metadata=\jobname.opf
    \@writemeta{<?xml version='1.0' encoding='utf-8'?>}
    \@writemeta{<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="calibre_id" version="2.0">}
    \@writemeta{<metadata xmlns:calibre="http://calibre.kovidgoyal.net/2009/metadata" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">}
  \else
    \RequirePackage[hypertex,colorlinks=false]{hyperref}
  \fi
\fi

% Informations sur le livre
\def\@titre{?Titre?}
\def\@auteur{\null}
\def\@auteurssecondaires{\null}
\def\@couvauteurssecondaires{\null}
\def\@couvresume{?Résumé?}
\def\@categorie{?Roman?}
\def\@editeur{?Auteur-Éditeur?}
\def\@licence{© \today\relax ?}
\def\@isbnnum{\null}
\def\@isbnpapier{\null}
\def\@impression{\null}
\def\@depotlegal{\null}
\def\@dumemeauteur{\null}

\newcommand\Titre[1]{%
  \def\@titre{#1}%
  \if@html\@writemeta{<dc:title opf:type="main">#1</dc:title>}\fi%
}
\newcommand\Auteur[2]{%
  \ifthenelse{\equal{\@auteur}{\null}}{%
    \def\@auteur{#2 #1}%
  }{%
    \expandafter\def\expandafter\@auteur\expandafter{\@auteur, #2 #1}%
  }%
  \if@html\@writemeta{<dc:creator opf:file-as="#1, #2" opf:role="aut">#2 #1</dc:creator>}\fi%
}
\newcommand\AuteurSecondaire[4]{%
  \expandafter\def\expandafter\@auteurssecondaires\expandafter{\@auteurssecondaires\par#4 : #2 #1}%
  \ifthenelse{\equal{\@couvauteurssecondaires}{\null}}{%
    \def\@couvauteurssecondaires{#4 : #2 #1 }%
  }{%
  \expandafter\def\expandafter\@couvauteurssecondaires\expandafter{\@couvauteurssecondaires — #4 : #2 #1 }%
  }%
  \if@html\@writemeta{<dc:contributor opf:file-as="#1, #2" opf:role="#3">#2 #1</dc:contributor>}\fi%
}
\if@html%
\def\CouvResume{\begingroup\obeylines\@CouvResume}
\begingroup\obeylines%
\gdef\@CouvResume#1{%
  \obeylines%
  \def^^M^^M{^^J}%
  \@writemeta{<dc:description>#1</dc:description>}%
  \endgroup%
}
\endgroup
\else
\newcommand\CouvResume[1]{%
  \def\@couvresume{#1}%
}
\fi
\newcommand\Categorie[1]{%
  \def\@categorie{#1}%
  \if@html\@writemeta{<dc:subject>#1</dc:subject>}\fi%
}
\newcommand\Editeur[1]{%
  \def\@editeur{#1}%
  \if@html\@writemeta{<dc:publisher>#1</dc:publisher>}\fi%
}
\newcommand\Licence[1]{%
  \def\@licence{#1}%
  \if@html\@writemeta{<dc:rights>#1</dc:rights>}\fi%
}
\newcommand\Isbn[2]{%
  \def\@isbnnum{#1}%
  \def\@isbnpapier{#2}%
  \if@html%
    \ifthenelse{\equal{\@isbnnum}{\null}}{}{\@writemeta{<dc:identifier opf:scheme="ISBN">#1</dc:identifier>}}%
  \fi%
}
\newcommand\Impression[1]{%
  \def\@impression{#1}%
}
\newcommand\DepotLegal[1]{%
  \def\@depotlegal{Dépôt légal : #1}%
}
\newcommand\PresseEtrangere{%
  \@imprimefrancefalse%
}
\newcommand\DuMemeAuteur[1]{%
  \def\@dumemeauteur{\begin{center}DU MÊME AUTEUR\par\par\end{center}\par#1}%
}

% AfterBeginDocument n'est pas défini en HTML
\if@html
  \def\after@begindocument{\null}
  \newcommand\AfterBeginDocument[1]{%
    \def\after@begindocument{#1}%
  }
\fi

% Pas de saut de page en mode brouillon
\ifbrouillon
  \renewcommand\chapter{%
    \thispagestyle{plain}%
    \global\@topnum\z@%
    \@afterindentfalse%
    \secdef\@chapter\@schapter%
  }
\fi

% Réglage des longueurs
\newlength{\@margecote}
\newlength{\@margereliure}
\newlength{\@margehaut}
\newlength{\@margehautsep}
\newlength{\@margebas}
\newlength{\@margebassep}

\ifbrouillon
\setlength{\@margehaut}{15mm}
\setlength{\@margehautsep}{8mm}
\setlength{\@margebas}{15mm}
\setlength{\@margebassep}{8mm}
\setlength{\@margereliure}{5mm}
\setlength{\@margecote}{20mm}
\else
\setlength{\@margehaut}{18mm}
\setlength{\@margehautsep}{10mm}
\setlength{\@margebas}{22mm}
\setlength{\@margebassep}{10mm}
\if@petitlivre\setlength{\@margereliure}{2mm}\else\setlength{\@margereliure}{1mm}\fi
\setlength{\@margecote}{25mm}
\fi

\setlength{\pdfpageheight}{\paperheight}
\setlength{\pdfpagewidth}{\paperwidth}

\setlength{\topmargin}{-1in}
\setlength{\textheight}{\paperheight}
\addtolength{\textheight}{-\@margehaut}
\addtolength{\textheight}{-\@margehautsep}
\addtolength{\textheight}{-\@margebas}
\addtolength{\textheight}{-\@margebassep}
\addtolength{\topmargin}{\@margehaut}
\setlength{\headheight}{\baselineskip}
\addtolength{\topmargin}{-\headheight}
\setlength{\headsep}{\@margehautsep}
\setlength{\footskip}{\@margebassep}
\addtolength{\footskip}{\baselineskip}

\setlength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{-1in}
\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-2\@margecote}
\addtolength{\textwidth}{-\@margereliure}
\addtolength{\oddsidemargin}{\@margecote}
\addtolength{\oddsidemargin}{\@margereliure}
\addtolength{\evensidemargin}{\@margecote}

\ifbrouillon
\renewcommand{\baselinestretch}{1.5}
\else
\if@petitlivre\renewcommand{\baselinestretch}{1.2}\fi
\fi
\setlength{\parskip}{4pt plus 4pt minus 2pt}

\tolerance=500
\emergencystretch=3em

% En-tête et pieds de page
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{\thepage}%
  \ifbrouillon%
    \fancyhead[L]{\textit{\@titre}}%
    \fancyhead[R]{Version du \today}%
  \fi%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}%
}
\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\thepage}
\ifbrouillon
\fancyhead[L]{\textit{\@titre}}
\fancyhead[R]{Version du \today}
\else
\fancyhead[CE]{\small{\@auteur}}
\fancyhead[CO]{\textit{\@titre}}
\fi
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{0pt}

% Saut de page avec reprise sur page impaire
\renewcommand\cleardoublepage{%
  \clearpage%
  \ifodd\c@page%
  \else%
    \null%
    \thispagestyle{empty}%
    \newpage%
  \fi%
}

% Mettre des valeurs par défaut
\AtBeginDocument{%
  \if@chapnum\else\renewcommand\thechapter{}\fi%
  \if@chapindic\else\renewcommand\chaptername{}\fi%
  \ifthenelse{\equal{\@auteur}{\null}}{\def\@auteur{?Auteur?}}{}%
}

% Données de couverture
\ifpdf\ifbrouillon\else
  \AtBeginDocument{%
    \@writemeta{\@titre}%
    \@writemeta{\@auteur}%
    \@writemeta{\@couvauteurssecondaires}%
    \@writemeta{\@editeur}%
    \@writemeta{\@isbnpapier}%
    \@writemeta{\@couvresume}%
    \closeout\metadata%
  }
\fi\fi

% Spécificité HTML
\if@html
  \let\oldclrearpage\clearpage
  \def\mypagebreak{\Configure{newpage}{\ifvmode\IgnorePar\fi\EndP\HCode{<div class="newpage"></div>}}}
  \renewcommand\cleardoublepage{\clearpage} % Inutile de sauter 2 pages sur un livre électronique

  \AtBeginDocument{%
    \mypagebreak % Redéfinir newpage
    \Css{.newpage{page-break-before:always;}}%
    \Css{body > p.noindent{text-indent:1.5em;}}%
    \Css{.tpauthor{height:30\%;text-align:center;}}%
    \Css{.tptitle{height:50\%;text-align:center;}}%
    \Css{.tptitle p{text-indent:0;margin-top:1em;}}%
    \Css{.tppublisher{text-align:center;}}%
    \Css{.fplegal{margin-top:50\%;text-align:center;}}%
    \Css{.fplegal p {text-indent:0;}}%
    \Tag{TITLE+}{\@titre}%
    \Configure{@BODY}{\def\clearpage{\bgroup\mypagebreak\oldclrearpage\egroup}\after@begindocument}%
    \Configure{@/BODY}{\global\let\clearpage\oldclrearpage\Configure{newpage}{}}%
    \@writemeta{<dc:language>fr</dc:language>}%
    \@writemeta{</metadata>}%
    \@writemeta{<manifest/>}%
    \@writemeta{<spine/>}%
    \@writemeta{<guide/>}%
    \@writemeta{</package>}%
    \closeout\metadata%
  }
\fi

% Pages standards du début du livre
\AfterBeginDocument{%
  {\pagestyle{empty}%
  %
  % Mode brouillon
  \ifbrouillon%
    \begin{center}%
      {\Large\textsc{Confidentiel — Merci de ne pas diffuser}\par\par}%
      {\Large\@auteur\par}%
      {\Huge\@titre\par}\vspace{\baselineskip}\textsc{\@categorie}\par%
      (mode révision)\par%
    \end{center}%
    {\small\emph{N'hésitez pas à annoter le texte directement, si possible au stylo rouge. %
    Des marques dans la marge pour repérer plus facilement les annotations seront appréciées.}}\par%
    Résumé :\par\@couvresume\par\par%
    \vspace*{\stretch{1}}{\small\@dumemeauteur\par\hrulefill\@auteurssecondaires}%
    \begin{center}%
      {\Large\par\par\textsc{Confidentiel — Merci de ne pas diffuser}}%
    \end{center}%
    \newpage%
  %
  % Mode HTML
  \else\if@html%
    \HCode{<div class="tpauthor">}{\Large\@auteur}\HCode{</div>}%
    \HCode{<div class="tptitle">}{\Huge\@titre}\par\textsc{\@categorie}\HCode{</div>}%
    \HCode{<div class="tppublisher">}{\bfseries\@editeur}\HCode{</div>}%
    \newpage%
  %
  % Mode livre
  \else%
    \null\newpage%
    \null\newpage%
    \begin{center}%
      \vspace*{\stretch{1}}\@titre\vspace*{\stretch{2}}%
    \end{center}%
    \newpage%
    \@dumemeauteur\vspace*{\stretch{1}}{\small\@auteurssecondaires}%
    \newpage%
    \begin{center}%
      {\Large\@auteur\par}%
      \vspace*{\stretch{1}}%
      {\Huge\@titre\par}\vspace{\baselineskip}\textsc{\@categorie}\par%
      \vspace*{\stretch{2}}%
      {\bfseries\@editeur}%
    \end{center}%
    \newpage%
    \vspace*{\fill}%
    \begin{center}%
      \@licence\par%
      \null\par%
      \ifthenelse{\equal{\@isbnpapier}{\null}}{}{N° ISBN : \@isbnpapier}%
    \end{center}%
    \newpage%
  \fi\fi}%
}

% Pages standards a la fin du livre
\AtEndDocument{%
  \clearpage%
  %
  % Mode brouillon
  \ifbrouillon%
  %
  % Mode HTML
  \else\if@html%
    \@dumemeauteur%
    \HCode{<div class="newpage"></div>}%
    \HCode{<div class="fplegal">}%
    \@licence\par%
    \@auteurssecondaires\par%
    \ifthenelse{\equal{\@isbnnum}{\null}}{}{N° ISBN : \@isbnnum\par}%
    \@depotlegal%
    \HCode{</div>}%
  %
  % Mode livre
  \else%
    {\pagestyle{empty}%
    \newcount\pageMod\pageMod=\value{page}%
    \divide\pageMod by 4% Il faut un multiple de 4 pages
    \pageMod=\number\numexpr\value{page}-\pageMod*4\relax%
    \ifthenelse{\pageMod=0}{\null\newpage}{}%
    \ifthenelse{\pageMod<3}{\null\cleardoublepage}{}%
    \vspace*{\fill}%
    \begin{center}%
      \if@imprimefrance\emph{Imprimé en France}\par\fi%
      \@impression\par\null\par\@depotlegal%
    \end{center}%
    \newpage\thispagestyle{empty}\null}%
    \fi\fi%
}

% Construction du sommaire
\newcommand\sommaire{%
  \setlength{\parskip}{0pt plus 1.0pt}%
  \chapter*{Sommaire}\par%
  \@starttoc{som}%
  \setlength{\parskip}{0pt plus 1.0pt}%
}

\let\aclORIG\addcontentsline
\renewcommand{\addcontentsline}[3]{%
  \aclORIG{#1}{#2}{#3}%
  \ifthenelse{% Inserer chapitres et parties 
    \equal{#2}{chapter} \or \equal{#2}{part}}{%
    \aclORIG{som}{#2}{#3}}{}}

% Style barré
\newlength{\temp@long}%
\newcommand\sout[1]{%
  \if@html%
    \HCode{<s>}#1\HCode{</s>}%
  \else%
    \settowidth{\temp@long}{#1}%
    \makebox[0cm][l]{#1}%
    \rule[0.5ex]{\temp@long}{0.2pt}%
  \fi%
}

% Langue étrangère
\newcommand\etranger[1]{%
  \emph{#1}%
}

% Séparateur de parties
\newcommand\separateurpar{%
  \begin{center}%
  \if@html%
    \HCode{&\#x2042;}%
  \else%
    \mbox{%
      \makebox[1.5em][c]{*}\hspace{-1.5em}%
      \raisebox{-1em}{\makebox[1.5em][c]{*\hfill{}*}}%
    }%
  \fi%
  \end{center}%
}

% Environnement dédicace
\newenvironment{dedicace}{%
  \cleardoublepage\thispagestyle{empty}\vspace*{\fill}\begin{flushright}\slshape%
}{%
  \upshape\end{flushright}\vspace*{\fill}\cleardoublepage%
}

% Environnement manuscrit
\newenvironment{manuscrit}{%
  \if@html%
    \HCode{<i>}%
  \else%
    \fontfamily{pzc}\selectfont%
  \fi%
}{%
  \if@html%
    \HCode{</i>}%
  \else%
    \null%
  \fi%
}

% Fin du fichier
\makeatother
\endinput

