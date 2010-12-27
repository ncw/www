<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../index.html		Home
.			.
index.html		Animations
"""
%></%def>
${next.body()}
