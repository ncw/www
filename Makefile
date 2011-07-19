# Makefile for Nick's Web site!

all:	serve

validate: markup
	echo "Validate broken"
	-#find _site -name \*.html | xargs validate --emacs

markup:
	blogofile build

serve:	markup
	blogofile serve

keywords:
	find . -name \*.mako | xargs svn propset svn:keywords "Date Revision Id"

uploadonly:
	rsync -avz --checksum --cvs-exclude -e ssh _site/ ncw@box.craig-wood.com:public_html/

upload:	markup validate uploadonly

quickupload:	markup uploadonly

clean:
	rm -rf _site
	find . -name \*~ -or -name \*.bak -or -name \*.pyc | xargs -d '\n' rm -f
