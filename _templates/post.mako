<%page args="post,no_title=False"/>
<div class="blog_post">
% if not no_title:
<div class="heading"><table width="100%" cellpadding="0">
  <tr>
    <td width="80%">
      <h2 class="blog_post_title"><a href="${post.permapath()}" rel="bookmark" title="Permanent Link to ${post.title}">${post.title}</a></h2>
    </td>
    <td width="20%" align="right">${post.date.strftime("%Y-%m-%d %H:%M")}</td>
  </tr>
</table>
% endif
</div>
  <small>Categories: 
<% 
   category_links = []
   for category in post.categories:
       if post.draft:
           #For drafts, we don't write to the category dirs, so just write the categories as text
           category_links.append(category.name)
       else:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
${", ".join(category_links)}
% if bf.config.blog.disqus.enabled:
 | <a href="${post.permalink}#disqus_thread">View Comments</a>
% endif
  </small>
  <div class="post_prose">
    ${self.post_prose(post)}
  </div>
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>
