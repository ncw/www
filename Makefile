# Makefile for Nick's Web site!

all:	markup

validate:
	find . -name \*.html | xargs validate --emacs

markup:
	blogofile build

serve:	markup
	blogofile serve

keywords:
	find . -name \*.mako | xargs svn propset svn:keywords "Date Revision Id"

uploadonly:
	rsync -avz --checksum --cvs-exclude -e ssh . ncw@box.craig-wood.com:public_html/

upload:	markup validate uploadonly

quickupload:	markup uploadonly

clean:
	rm -f *.pyc
	find . -name \*~ | xargs rm -f
