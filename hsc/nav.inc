<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../index.html		Home
.			.
index.html		HSC Home
"""
%></%def>
${next.body()}
