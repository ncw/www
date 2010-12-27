<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../index.html		Home
.			.
index.html		Istec Home
short.html		Description
tech.html		Technical
conf.html		Configure
pic.html		Picture
diag.html		Diagram
"""
%></%def>
${next.body()}
