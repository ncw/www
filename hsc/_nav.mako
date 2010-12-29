<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../			Home
.			.
./			HSC Home
"""
%></%def>
${next.body()}
