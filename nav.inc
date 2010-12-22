<%inherit file="site.mako" />
<%def name="nav()"><%
return """
index.html		Home
.			.
android/index.html      Android
armprime/index.html	ARMprime
software.html		RISCOS
animations/index.html	Animations
holly.html		Holly
oxo2d/index.html	Oxo2d
ncw.html		Personal
xmas/index.html		Xmas letters
istec/index.html	ISTEC 1008
.			.
links.html		Links
"""
%></%def>
${next.body()}
