\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myreport}[2019/03/18 Meeting report latex class]

\RequirePackage{color}
\RequirePackage{xcolor}
\RequirePackage[sfdefault,scaled=.85]{FiraSans}
\RequirePackage{environ}
\RequirePackage{fancyhdr}
\RequirePackage{fancyvrb}

\definecolor{csec}{RGB}{0,76,62}
\definecolor{csubsec}{RGB}{130,0,30}
\definecolor{csubsubsec}{RGB}{90,90,90}
\definecolor{mbg}{RGB}{246,248,250}
\definecolor{qbg}{RGB}{240,240,255}
\definecolor{vbg}{RGB}{230,230,230}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}% or book or whatever
}

\newcommand{\babl}{english}

\ProcessOptions\relax
\RequirePackage{babel}
\PassOptionsToPackage{\babl}{babel}

\LoadClass{article}

\let\@startsection\relax
\let\@sect\relax
\let\@part\relax
\let\@spart\relax

\def\@partorsectname{}

\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2<2
  \def\@partorsectname{#8}
  \fi
  \ifnum #2>\c@secnumdepth
  \let\@svsec\@empty
  \else
  \refstepcounter{#1}%
  \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
  \begingroup
  #6{%
    \@hangfrom{\hskip #3\relax\@svsec}%
    \interlinepenalty \@M #8\@@par}%
  \endgroup
  \csname #1mark\endcsname{#7}%
  \addcontentsline{toc}{#1}{%
    \ifnum #2>\c@secnumdepth \else
    \protect\numberline{\csname the#1\endcsname}%
    \fi
    #7}%
  \else
  \def\@svsechd{%
    #6{\hskip #3\relax
      \@svsec #8}%

    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
      \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}}%
  \fi
  \@xsect{#5}}

\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
  \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
  \everypar{}%
  \else
  \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
  {\@ssect{#3}{#4}{#5}{#6}}%
  {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\@part[#1]#2{%
  \def\@partorsectname{#2}
  \ifnum \c@secnumdepth >\m@ne
  \refstepcounter{part}%
  \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
  \addcontentsline{toc}{part}{#1}%
  \fi
  {\parindent \z@ \raggedright
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >\m@ne
    \Large\bfseries \partname\nobreakspace\thepart
    \par\nobreak
    \fi
    \vskip -.4em
    \hskip 1em
    \huge \bfseries #2%
    \markboth{}{}\par}%
  \nobreak
  \vskip 3ex
  \@afterheading}

\def\@spart#1{%
  {\parindent \z@ \raggedright
    \interlinepenalty \@M
    \normalfont
    \huge \bfseries #1\par}%
  \nobreak
  \vskip 3ex
  \@afterheading}

\newcommand\oneof[2]{%
  \begingroup
    \def\@tempa{#1}%
    \@onelevel@sanitize\@tempa
    \def\@tempb{}%
    \@onelevel@sanitize\@tempb
    \ifx\@tempa\@tempb
       \aftergroup\@firstoftwo
    \else
      \aftergroup\@secondoftwo
    \fi
  \endgroup
    {#1}
    {#2}%
  }

\fancypagestyle{defaultpagestyle}{
  \fancyhf{}
  \fancyhead[LE,RO]{\expandafter\MakeUppercase\expandafter{\sffamily\footnotesize\@title}}
  \fancyhead[RE,LO]{\sffamily\@author}
  \fancyfoot[CE,CO]{}
  \fancyfoot[RE,LO]{\sffamily\oneof{\leftmark}{\@partorsectname}}
  \fancyfoot[LE,RO]{\thepage}
  \renewcommand{\footrulewidth}{0.4pt}
  \renewcommand{\headrulewidth}{0.4pt}
}

\fancypagestyle{firstpagestyle}{
  \fancyhf{}
  \fancyhead[LE,RO]{}
  \fancyhead[RE,LO]{}
  \fancyfoot[CE,CO]{}
  \fancyfoot[RE,LO]{\sffamily\leftmark}
  \fancyfoot[LE,RO]{\thepage}
  \renewcommand{\footrulewidth}{0.4pt}
  \renewcommand{\headrulewidth}{0pt}
}

% \pagestyle{defaultpagestyle}


\renewcommand{\labelitemi}{\textbullet}
\renewcommand{\labelitemii}{$\star$}
\renewcommand{\labelitemiii}{$\rightarrow$}

\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{firstpagestyle}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  % \global\let\@author\@empty
  \global\let\@date\@empty
  % \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \pagestyle{defaultpagestyle}
}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
    \noindent\rule{\textwidth}{1pt}
    \let \footnote \thanks
    {\huge \@title \par}%
    \vskip -.3em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip -.6em%
    {\large \@date}%
    \ifx\@presents\undefined
    \else
    \vskip -.1em%
    Personnes pr\'esentes : \@presents
    \fi
    \\\noindent\rule{\textwidth}{1pt}
  \end{center}%
  \par
  \vskip 0.5em}

\renewcommand{\thefigure}{\bf\thesection.\arabic{figure}}
\addto\captionsenglish{\renewcommand{\figurename}{\bf Figure}}

\newcommand{\presents}[1]{\def\@presents{#1}}

\renewcommand\part{%
  \if@noskipsec \leavevmode \fi
  % \par
  \newpage
  \thispagestyle{firstpagestyle}
  \addvspace{4ex}%
  \@afterindentfalse
  \noindent\rule{\textwidth}{1pt}
  \secdef\@part\@spart}
\renewcommand\section{\setcounter{figure}{0}
  \@startsection {section}{1}{\z@}%
  {-0.5ex \@plus -1ex \@minus -.2ex}%
  {0.3ex \@plus.2ex}%
  {\normalfont\color{csec}\bfseries}}
\renewcommand\subsection{\@startsection {subsection}{2}{\z@}%
  {-0.5ex \@plus -1ex \@minus -.2ex}%
  {0.3ex \@plus.2ex}%
  {\normalfont\color{csubsec}\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-.5ex \@plus -1ex \@minus -.2ex}%
  {.2ex \@plus .2ex}%
  {\normalfont\normalsize\color{csubsubsec}\bfseries}}

\NewEnviron{mycolor}
{\colorbox{qbg}{\parbox{\textwidth - 2.1cm}{\BODY}}}

\NewEnviron{mycolorv}
{\colorbox{vbg}{\parbox{\textwidth - 2.1cm}{\BODY}}}

\renewenvironment{verse}
{\let\\\@centercr
  \list{}{\itemsep      \z@
    \itemindent   -1.5em%
    \listparindent\itemindent
    \rightmargin  \leftmargin
    \advance\leftmargin 1.5em}%
\item\relax}
{\endlist}
\renewenvironment{quotation}
{list{}{\listparindent 1.5em%
    \itemindent    \listparindent
    \rightmargin   \leftmargin
    \parsep        \z@ \@plus\p@}%
\item\relax}
{\endlist}
\renewenvironment{quote}
{\list{}{\rightmargin1cm\leftmargin1cm}\item[] \mycolor}%

{\endmycolor \endlist}
% \renewcommand{\quote}{\myquote}
% \renewcommand{\endquote}{\endmyquote}

\newcommand{\textttt}[1]{\colorbox{vbg}{\texttt{#1}}}

\newenvironment{myverbatim}
{\list{}{\rightmargin1cm\leftmargin1cm}\item[] \mycolorv \tt}
{\endmycolorv \endlist}

\def\restrict{\raise-.5ex\hbox{\ensuremath|}}

\NewEnviron{MyFramed}
{\noindent\fbox{\parbox{\textwidth - 5pt}{\BODY}}}

\endinput
