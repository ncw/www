# Makefile for Nick's Web site!

all:	markup

validate:
	find . -name \*.html | xargs validate --emacs

markup:
	find . -name \*.html | xargs ./top-and-tail.py

unmarkup:
	find . -name \*.html | xargs ./top-and-tail.py -r

upload:
	@echo "Not implemented yet!"

clean:
	rm -f *.pyc
	find . -name \*~ | xargs rm -f
