<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../			Home
.			.
./			Armprime Home
math.html		Math
todo.html		To Do
"""
%></%def>
${next.body()}
