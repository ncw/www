#!/usr/bin/python

"""
Top and tail the web page passed in

"""
__version__ = '$Id: top-and-tail.py,v 1.2 2004-09-24 07:09:41 ncw Exp $'

import sys, re, os, optparse

opt = None                              # options filled in by main()

def menu_nav(f):
    "Given a path to an html file - reads its Nav file and returns html"
    nav = os.path.join(os.path.dirname(f), "nav")
    assert os.path.exists(nav), "nav file '%s' not found" % nav
    menu = []
    for line in file(nav):
        line = line.rstrip()
        path, name = line.split(None, 1)
        if name == ".":
            menu.append('<hr />')
        else:
            menu.append('<a href="%s">%s</a><br />' % (path, name))
    return "\n".join(menu)
    
def transform(f):
    text = file(f).read()
    original_text = text[:]
    # read title
    match = re.search(r"<title>(.*)</title>", text)
    assert match, "No title found"
    title, = match.groups()

    # Get rid of a title H1 if it exists
    title_quoted = re.sub(r"(\W)", r"\\\1", title) # Quote all the regex metacharacters
    text = re.sub(r"\s*<[Hh]1>"+title_quoted+"</[Hh]1>\s*", r"", text)

    # Look for CVS Id
    # <!-- $Id: top-and-tail.py,v 1.2 2004-09-24 07:09:41 ncw Exp $ -->    
    match = re.search(r"\$Id: top-and-tail.py,v 1.2 2004-09-24 07:09:41 ncw Exp $", text)
    assert match, "Couldn't find CVS date"
    cvs_file, cvs_rev, cvs_year, cvs_month, cvs_day, cvs_who = match.groups()

    header = """
<table width="100%%" cellpadding="0">
  <tr>
    <td width="80%%">%s</td>
    <td width="20%%" align="right">%s-%s-%s</td>
  </tr>
</table>
""" % (title, cvs_year, cvs_month, cvs_day)

    menu = menu_nav(f)
    menu += """<hr />
<p class="copyright">(C) Nick Craig-Wood %s</p>
""" % cvs_year

    match = re.search(r'<div id="Content">', text)
    if not match:
        # Add divs - assume if no Content won't have other divs either
        top = """<body>
<div id="Header">
</div>

<div id="Content">"""
        text = re.sub(r'<body>', top, text)
        bot = """</div>

<div id="Menu">
</div>
</body>"""
        text = re.sub(r'</body>', bot, text)

    # If remove replace with empty lines
    if opt.remove:
        header = "\n"
        menu = "\n"
    # Replace Header
    text = re.sub(r'(?s)(<div id="Header">).*?(</div>)', r'\1' + header + r'\2', text) 
    # Replace Menu
    text = re.sub(r'(?s)(<div id="Menu">).*?(</div>)', r'\1' + menu + r'\2', text) 

    if text == original_text:
        print >>sys.stderr, "%s unchanged" % f
    else:
        if opt.debug:
            sys.stdout.write(text)
        else:
            os.rename(f, f + "~")
            file(f, "w").write(text)

def main():
    global opt
    parser = optparse.OptionParser(usage="usage: %prog [options] file file...")
    parser.add_option("-d", "--debug",
                      action="store_true", dest="debug",
                      help="don't re-write the file, just output it to stdout")
    parser.add_option("-r", "--remove",
                      action="store_true", dest="remove",
                      help="remove all the markup in the file (pre check-in)")
    (opt, files) = parser.parse_args()
    if len(files) == 0:
        parser.error("Must supply at least one file!")
    for f in files:
        print >>sys.stderr, f
        transform(f)

if __name__ == "__main__": main()
