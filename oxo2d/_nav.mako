<%inherit file="/site.mako" />
<%def name="title()">Oxo2d</%def>
<%def name="nav()"><%
return """
../			Home
.			.
./			Oxo2d Home
"""
%></%def>
${next.body()}
