\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{readme}[2019/03/18 Meeting report latex class]

\RequirePackage{color}
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

\ProcessOptions\relax

\LoadClass{article}

\fancypagestyle{defaultpagestyle}{
  \fancyhf{}
  \fancyhead[LE,RO]{\expandafter\MakeUppercase\expandafter{\sffamily\footnotesize\@title}}
  \fancyhead[RE,LO]{\sffamily\@author}
  \fancyfoot[CE,CO]{}
  \fancyfoot[RE,LO]{\sffamily\leftmark}
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

\newcommand{\presents}[1]{\def\@presents{#1}}
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {-0.5ex \@plus -1ex \@minus -.2ex}%
  {0.3ex \@plus.2ex}%
  {\normalfont\color{csec}\bfseries}}
\renewcommand\subsection{\@startsection {subsection}{2}{\z@}%
  {-0.5ex \@plus -1ex \@minus -.2ex}%
  {0.3ex \@plus.2ex}%
  {\normalfont\color{csubsec}\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-.5ex\@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
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

\endinput
