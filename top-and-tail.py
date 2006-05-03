#!/usr/bin/python

"""
Top and tail the web page passed in

"""
__author__ = "Nick Craig-Wood (nick@craig-wood.com)"
__version__ = "$Revision: 1.7 $"
__date__ = "$Date: 2006-05-03 10:46:29 $"
__copyright__ = "Copyright (C) Nick Craig-Wood 2004"

import sys, re, os, optparse

opt = None                              # options filled in by main()

def menu_nav(f):
    "Given a path to an html file - reads its Nav file and returns html"
    nav = os.path.join(os.path.dirname(f), "nav")
    basename = os.path.basename(f)
    assert os.path.exists(nav), "nav file '%s' not found" % nav
    menu = []
    for line in file(nav):
        line = line.rstrip()
        path, name = line.split(None, 1)
        if name == ".":
            menu.append('<hr />')
        elif path == basename:
            menu.append('<b>%s</b><br />' % name)
        else:
            menu.append('<a href="%s">%s</a><br />' % (path, name))
    return "\n".join(menu)
    
def transform(f, top_path):
    text = file(f).read()
    original_text = text[:]
    # read title
    match = re.search(r"<title>(.*)</title>", text)
    assert match, "No title found in %s" % f
    title, = match.groups()

    # Get rid of a title H1 if it exists
    title_quoted = re.sub(r"(\W)", r"\\\1", title) # Quote all the regex metacharacters
    text = re.sub(r"\s*<[Hh]1>"+title_quoted+"</[Hh]1>\s*", r"", text)

    # Look for CVS Id
    # <!-- $Id: top-and-tail.py,v 1.7 2006-05-03 10:46:29 ncw Exp $ -->
    # NB regexp is split to stop CVS substituting it!
    match = re.search(r"\$" + r"Id: (.*?),v ([0-9.]+) (\d\d\d\d)[-/](\d\d)[-/](\d\d) \d\d:\d\d:\d\d (\S+).*?\$", text)
    assert match, "Couldn't find CVS date in %s" % f
    cvs_file, cvs_rev, cvs_year, cvs_month, cvs_day, cvs_who = match.groups()

    header = """
<table width="100%%" cellpadding="0">
  <tr>
    <td width="80%%"><h1>%s</h1></td>
    <td width="20%%" align="right">%s-%s-%s</td>
  </tr>
</table>
""" % (title, cvs_year, cvs_month, cvs_day)

    menu = menu_nav(f)
    menu += """<hr />
<p class="copyright">(C) <a href="mailto:nick@craig-wood.com">Nick Craig-Wood</a> %(cvs_year)s</p>
<hr />
<p>
  <a href="http://validator.w3.org/check?uri=referer"><img src="%(top_path)sicon/valid-xhtml10.png" alt="[Valid XHTML 1.0]" border="0" align="middle" hspace="8" vspace="4" width="88" height="31" /></a>
  <a href="http://www.anybrowser.org/campaign/"><img src="%(top_path)sicon/anybrowser.gif" alt="[Best viewed with any browser]" border="0" align="middle" hspace="8" vspace="4" width="88" height="31" /></a>
  <a href="http://www.mersenne.org/prime.htm"><img src="%(top_path)sicon/gimps.gif" alt="[Great Internet Prime Search]" border="0" align="middle" hspace="8" vspace="4" width="88" height="31" /></a>
  <a href="%(top_path)sholly.html"><img src="%(top_path)sicon/csn.gif" alt="[Cocker Spaniel Now!]" border="0" align="middle" hspace="8" vspace="4" width="88" height="31" /></a>
</p>
""" % vars()

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
    parser.add_option("-b", "--base",
                      action="store", dest="base", default=".",
                      help='Path to base of HTML tree for relative links ["."]')
    (opt, files) = parser.parse_args()
    base = os.path.realpath(opt.base)
    base_len = len(base)
    if len(files) == 0:
        parser.error("Must supply at least one file!")
    for f in files:
        f_abs = os.path.realpath(f)
        assert f_abs[:base_len] == base, "File %s is not under %s!" % (f, base)
        relative_path = f_abs[base_len:]
        if relative_path[0] == os.path.sep:
            relative_path = relative_path[1:]
        depth = relative_path.count(os.path.sep)
        top_path = "../" * depth
        print >>sys.stderr, f, top_path
        transform(f, top_path)

if __name__ == "__main__": main()
