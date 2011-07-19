<%inherit file="/_nav.mako" />
<%def name="title()">Nick Craig-Wood's Home Page</%def>
<p>Here you will find a somewhat random dump of stuff that I want to make public. Quite a bit of software, some personal stuff, some fun stuff and maybe the odd rant ;-)</p>

<h4>Software by me</h4>

<ul>
  <li><a href="android/">Software for Android - Google's smartphone OS</a></li> 
  <li><a href="software.html">Software for RISCOS - Acorn's once great OS</a></li>
  <li><a href="armprime/">ARM based Mersenne prime tester for GIMPs</a></li>
  <li><a href="software/">Downloads of my released software</a></li>
  <li><a href="pub/">My dumping ground for useful scripts</a></li>
</ul>

<h4>Personal</h4>

<ul>
  <li><a href="ncw.html">Nick Craig-Wood's personal page</a></li>
  <li><a href="xmas/">The Christmas letter archives</a></li>
</ul>

<h4>Fun</h4>

<ul>
  <li><a href="animations/">Some daft juggling animations</a></li>
  <li><a href="oxo2d/">An HTML noughts-and-crosses / tic-tac-toe player</a></li>
</ul>

<h4>Other</h4>

<ul>
  <li><a href="articles/">Articles</a></li>
  <ul>
% for post in [p for p in bf.config.blog.posts if not p.draft]:
%   if not post.draft:
    <li><a href="${post.path}">${post.title}</a></li>
%   endif
% endfor
  </ul>
  <li><a href="links.html">Links</a></li>
</ul>
