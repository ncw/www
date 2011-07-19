import docutils.core

config = {
    'name': "reStructuredText",
    'description': "Renders reStructuredText formatted text to HTML",
    'aliases': ['rst']
    }

def run(content):
    return docutils.core.publish_parts(content, writer_name='html')['html_body']

# Add the .. code directive

from docutils import nodes
from pygments import highlight
from pygments.lexers import get_lexer_by_name
from pygments.formatters import HtmlFormatter
from docutils.parsers.rst import directives

pygments_formatter = HtmlFormatter()

def pygments_directive(name, arguments, options, content, lineno,
                       content_offset, block_text, state, state_machine):
    try:
        lexer = get_lexer_by_name(arguments[0])
    except ValueError:
        # no lexer found - use the text one instead of an exception
        lexer = get_lexer_by_name('text')
    parsed = highlight(u'\n'.join(content), lexer, pygments_formatter)
    return [nodes.raw('', parsed, format='html')]
pygments_directive.arguments = (1, 0, 1) 
pygments_directive.content = 1
directives.register_directive('code', pygments_directive)
