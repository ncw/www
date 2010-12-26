<%inherit file="base.mako" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- $Id$ -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  ${self.head()}
</head>

<body>
<div id="Header"><table width="100%" cellpadding="0">
  <tr>
    <td width="80%"><h1>${self.title()}</h1></td>
    <td width="20%" align="right">${self.date()}</td>
  </tr>
</table>
</div>

<div id="Content">
  <div id="main_block">
    <div id="prose_block">
      ${next.body()}
    </div><!-- End Prose Block -->
  </div><!-- End Main Block -->
  <div id="footer">
    ${self.footer()}
  </div> <!-- End Footer -->
</div> <!-- End Content -->

<div id="Menu">
<%
    # Write the menu
    nav = self.nav().strip()
    basename = "FIXME" # don't know this!!!
    for line in nav.split("\n"):
        line = line.rstrip()
        path, name = line.split(None, 1)
        if name == ".":
            context.write('<hr />')
        elif path == basename:
            context.write('<b>%s</b><br />' % name)
        else:
            context.write('<a href="%s">%s</a><br />' % (path, name))
%>

<p class="copyright">&copy; <a href="mailto:nick@craig-wood.com">Nick Craig-Wood</a> 2009</p>
<hr />
<p class="buttons">
  <a href="http://validator.w3.org/check?uri=referer"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/valid-xhtml10.png')}" alt="[Valid XHTML 1.0]" width="88" height="31" /></a>
  <a href="http://www.anybrowser.org/campaign/"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/anybrowser.gif')}" alt="[Best viewed with any browser]" width="88" height="31" /></a>
  <a href="http://www.mersenne.org/prime.htm"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/gimps.gif')}" alt="[Great Internet Prime Search]"width="88" height="31" /></a>
  <a href="${bf.util.site_path_helper(bf.config.site.path,'/holly.html')}"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/csn.gif')}" alt="[Cocker Spaniel Now!]" width="88" height="31" /></a>
</p>
<p>
  <script language="javascript" type="text/javascript" src="http://www.librarything.com/jswidget.php?reporton=ncw&amp;show=random&amp;header=1&amp;num=5&amp;covers=small&amp;text=all&amp;tag=alltags&amp;amazonassoc=niccrawoosweb-21&amp;css=1&amp;style=1&amp;version=1"></script>
</p>
</div>
</body>
</html>

<%def name="head()">
  <title>${self.title()}</title>
## FIXME  <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed')}" />
## FIXME  <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom')}" />
  <link rel='stylesheet' href='${bf.util.site_path_helper(bf.config.site.path,'/css')}/pygments_${bf.config.filters.syntax_highlight.style}.css' type='text/css' />
  <link rel="stylesheet" title="Nick Craig-Wood's Style" href="${bf.util.site_path_helper(bf.config.site.path,'/default.css')}" type="text/css" media="screen" />
</%def>

<%def name="header()">
  <%include file="header.mako" />
</%def>

<%def name="footer()">
## FIXME  <%include file="footer.mako" />
</%def>

<%def name="nav()"><%
return "/index.html Home"
%></%def>

<%def name="title()">${bf.config.blog.name}</%def>

<%def name="date()"><%
import datetime 
context.write(str(datetime.date.today()))
%></%def>
