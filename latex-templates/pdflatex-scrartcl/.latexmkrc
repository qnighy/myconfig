#!/usr/bin/env perl

# tex -> pdf
$pdf_mode = 1;

# pdflatex: LaTeX with PDF output
# -synctex=1: output *.synctex.gz for forward/backward search
# -file-line-error: enable file:line:error style messages
# -halt-on-error: halt on error, instead of asking interactively
# -interaction=nonstopmode: halt on file not found, instead of asking interactively
# %O: options
# %S: source file (*.tex)
$pdflatex = 'pdflatex -synctex=1 -file-line-error -halt-on-error -interaction=nonstopmode %O %S';

# bibtex: plain BibTeX
# %O: options
# %B: source file basename (*(.aux))
$bibtex = 'bibtex %O %B';

# biber: BibLaTeX backend used when *.bcf exists
# -u: input encoding utf8
# -U: output encoding utf8
# %O: options
# %S: source file (*.bcf)
$biber = 'biber -u -U %O %S';

# makeindex: Plain index processor
# %O: options
# -o %D: destination file (*.ind)
# %S: source file (*.idx)
$makeindex = 'makeindex %O -o %D %S';
