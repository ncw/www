<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../index.html		Home
.			.
index.html		Armprime Home
math.html		Math
todo.html		To Do
"""
%></%def>
${next.body()}
