<%inherit file="/site.mako" />
<%def name="title()">Oxo2d</%def>
<%def name="nav()"><%
return """
../index.html		Home
.			.
index.html		Oxo2d Home
"""
%></%def>
${next.body()}
