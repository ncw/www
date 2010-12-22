<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../index.html		Home
.			.
oxo3d/index.html        Oxo 3D
"""
%></%def>
${next.body()}
