<%inherit file="site.mako" />
<%def name="nav()"><%
return """
.		Home
.		.
android/	Android
articles/	Articles
armprime/	ARMprime
software.html	RISCOS
animations/	Animations
holly.html	Holly
oxo2d/		Oxo2d
ncw.html	Personal
xmas/		Xmas letters
istec/		ISTEC 1008
.		.
links.html	Links
"""
%></%def>
${next.body()}
