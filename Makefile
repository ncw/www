# Makefile for Nick's Web site!

all:	markup

validate:
	find . -name \*.html | xargs validate --emacs

markup:
	find . -name \*.html | xargs ./top-and-tail.py

unmarkup:
	find . -name \*.html | xargs ./top-and-tail.py -r

keywords:
	find . -name \*.html | xargs svn propset svn:keywords "Date Revision Id"

uploadonly:
	rsync -avz --checksum --cvs-exclude -e ssh . ncw@box.craig-wood.com:public_html/

upload:	markup validate uploadonly

quickupload:	markup uploadonly

clean:
	rm -f *.pyc
	find . -name \*~ | xargs rm -f
