# Makefile for Nick's Web site!

all:	top_and_tail

validate:
	find . -name \*.html | xargs validate --emacs

top_and_tail:
	find . -name \*.html | ./top-and-tail.py

upload:
	@echo "Not implemented yet!"

clean:
	rm -f *.pyc
	find . -name \*~ | xargs rm -f
