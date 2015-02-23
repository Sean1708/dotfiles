@default_files = ('*.tex', '*.ltx', '*.latex');

$dvi_mode = $postscript_mode = 0;
$pdf_mode = 1;
$pdflatex = 'lualatex -interaction=nonstopmode -file-line-error %O %S';

$recorder = 1;
$bibtex_use = 2;
$clean_ext = "run.xml"
