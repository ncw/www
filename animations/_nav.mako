<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../			Home
.			.
./			Animations
"""
%></%def>
${next.body()}
