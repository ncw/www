# Makefile for Nick's Web site!

all:	markup

validate:
	find . -name \*.html | xargs validate --emacs

markup:
	find . -name \*.html | xargs ./top-and-tail.py

unmarkup:
	find . -name \*.html | xargs ./top-and-tail.py -r

upload:	markup validate
	rsync -avz --cvs-exclude -e ssh . ncw@box.craig-wood.com:public_html/

clean:
	rm -f *.pyc
	find . -name \*~ | xargs rm -f
