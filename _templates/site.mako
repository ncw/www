<%inherit file="base.mako" />
<% from urllib.parse import urljoin %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- $Id$ -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
  <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
  ${self.head()}
  <script src="http://connect.facebook.net/en_US/all.js#appId=232073720158744&amp;xfbml=1"></script>
  <meta property="og:title" content="${self.title()}" />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="${urljoin(bf.config.site.url,bf.template_context.render_path)}" />
  <meta property="og:image" content="${bf.config.site.url}/small/njcw.jpg" />
  <meta property="og:site_name" content="${bf.config.blog.name}" />
  <meta property="fb:admins" content="662368412" />
  <script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-24691001-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
  </script>
</head>

<body>
<div class="heading"><table width="100%" cellpadding="0">
  <tr>
    <td width="100%"><h1>${self.title()}</h1></td>
    <td><div id="fb-root"></div><fb:like href="" send="false" layout="button_count" width="50" show_faces="false" font=""></fb:like></td>
    <td><a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via="njcw">Tweet</a></td>
    <td><g:plusone size="medium"></g:plusone></td>
    <td align="right" style="white-space:nowrap;">${self.date()}</td>
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

<%
   import datetime
   today = datetime.date.today() 
%>

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

<hr />

<div id="blog_post_list">
  <p>Latest Articles</p>
  <ul class="menulist">
% for post in [p for p in bf.config.blog.posts if not p.draft][:5]:
%   if not post.draft:
  <li><a href="${post.path}">${post.title}</a></li>
%   endif
% endfor
  </ul>
  </small>
</div>

<div id="categories">
  <p>Categories</p>
  <ul class="menulist">
% for category, num_posts in sorted(bf.config.blog.all_categories, key=lambda x:x[0].name):
  <li><a href="${category.path}">${category.name.title()}</a> (<a href="${category.path}/feed">rss</a>) (${num_posts})</li>
% endfor
  </ul>
</div> 

<p class="copyright">&copy; <a href="mailto:nick@craig-wood.com">Nick Craig-Wood</a> ${today.year}</p>
<hr />
<p class="buttons">
  <a href="http://validator.w3.org/check?uri=referer"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/valid-xhtml10.png')}" alt="[Valid XHTML 1.0]" width="88" height="31" /></a>
  <a href="http://www.anybrowser.org/campaign/"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/anybrowser.gif')}" alt="[Best viewed with any browser]" width="88" height="31" /></a>
  <a href="http://www.mersenne.org/prime.htm"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/gimps.gif')}" alt="[Great Internet Prime Search]"width="88" height="31" /></a>
  <a href="${bf.util.site_path_helper(bf.config.site.path,'/holly.html')}"><img src="${bf.util.site_path_helper(bf.config.site.path,'/icon/csn.gif')}" alt="[Cocker Spaniel Now!]" width="88" height="31" /></a>
</p>
<hr />
<div id="w761bb85b0e2abbf9329a9476b547e309"></div><script type="text/javascript" charset="UTF-8" src="http://www.librarything.com/widget_get.php?userid=ncw&amp;theID=w761bb85b0e2abbf9329a9476b547e309"></script><noscript><a href="http://www.librarything.com/profile/ncw">My Library</a> at <a href="http://www.librarything.com">LibraryThing</a></noscript>
</div>
</body>
</html>

<%def name="head()">
  <title>${self.title()}</title>
  <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed')}" />
  <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom')}" />
  <link rel='stylesheet' href='${bf.util.site_path_helper(bf.config.site.path,'/css')}/pygments_${bf.config.filters.syntax_highlight.style}.css' type='text/css' />
  <link rel="stylesheet" title="Nick Craig-Wood's Style" href="${bf.util.site_path_helper(bf.config.site.path,'/default.css')}" type="text/css" media="screen" />
  <link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.site.path,'/docutils.css')}" type="text/css" media="screen" />
</%def>

<%def name="header()">
  <%include file="header.mako" />
</%def>

<%def name="footer()">
## FIXME  <%include file="footer.mako" />
</%def>

<%def name="nav()"><%
return ". Home"
%></%def>

<%def name="title()">${bf.config.blog.name}</%def>

<%def name="date()"><%
import os
import datetime
# FIXME this should be a filter?
# Read the timestamp from the file, but fall back to today
# FIXME for blog posts this should be the date of the post
try:
    m = os.path.getmtime(bf.template_context.template_name)
    timestamp = datetime.datetime.fromtimestamp(m).date()
except Exception:
    timestamp = datetime.date.today()
context.write(str(timestamp))
%></%def>
