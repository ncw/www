<%inherit file="/site.mako" />
<%def name="nav()"><%
return """
../			Home
.			.
./			FCFS Home
making.html		Make
restoring.html		Restore
multi.html		Multitask
images.html		Images
using.html		Using
history.html		History
legal.html		Legal
"""
%></%def>
${next.body()}
