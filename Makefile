
init: compile-main
	mkdir flatten
	./flatten_doc old

end: compile-main
	./flatten_doc new

diff: end
	latexdiff flatten/flatten-doc-old.tex flatten/flatten-doc-new.tex > flatten/diff.tex

pdf-diff: compile-diff
	open diff.pdf

compile-diff: diff
	lualatex flatten/diff.tex ./

pdf-main: compile-main
	open main.pdf

compile-main: bib-main
	lualatex main.tex

bib-main:
	bibtex main

clean:
	rm -rf flatten
	rm -f diff.{ps,log,aux,out,dvi,bbl,blg,lof,run.xml,toc}
	rm -f diff-blx.bib