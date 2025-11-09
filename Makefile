FILE = index

all:
	pandoc -t revealjs -s $(FILE).md -o $(FILE).html \
		--katex \
		--citeproc \
		--highlight-style syntax.theme \
		--slide-level=2 \
		-V revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@^5.2.0

clean:
	rm *.html
