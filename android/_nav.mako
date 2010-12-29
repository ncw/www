<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../			Home
.			.
oxo3d/		        Oxo 3D
"""
%></%def>
${next.body()}
