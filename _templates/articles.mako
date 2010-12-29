<%inherit file="site.mako" />
<%def name="nav()"><%
return """
@/			Home
.			.
@/articles/		Articles
""".replace("@", bf.util.site_path_helper())
%></%def>
${next.body()}

<%def name="footer()">
<%include file="footer.mako" />
</%def>
