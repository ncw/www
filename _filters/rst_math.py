import re
import os
import blogofile_bf as bf
import hashlib
from mako.filters import html_entities_unescape
import tempfile
from subprocess import check_call
import cgi
from docutils import nodes, utils
from docutils.parsers.rst import directives, Directive, roles
import shutil

code_block_re = re.compile(
    r'(?:'
    r'(?P<before1><pre class="latex literal-block">\n)'
    r'(?P<code>.*?)'
    r'(?P<after1></pre>)'
    r'|'
    r'(?P<before2><tt class="latex docutils literal"><span class="pre">)'
    r'(?P<inline_code>.*?)'
    r'(?P<after2></span></tt>)'
    r')', re.DOTALL
)

# Lots of code borrowed from latexmath2png.py
# https://code.google.com/p/latexmath2png/source/browse/trunk/latexmath2png/latexmath2png.py

# Rst plugin from here
# http://stackoverflow.com/questions/3610551/math-in-restructuredtext-with-latex

"""
f you are willing to do a bit of hacking to extend your ReST processor, you can get a much nicer notation for the LaTeX literals, by defining a custom interpreted text role for inline latex (e.g. :latex:`x<\pi`) and a custom directive for multi line math, e.g.

.. latex::

  \begin{equation}
    x<\pi
  \end{equation}

The inline math notation can even be shortened to `x<\pi` if you use default-role.
"""
class Latex(Directive):
    """ Latex directive to display LaTeX as escaped literal wrapped in
        <pre class="latex">. 
    """
    required_arguments = 0
    optional_arguments = 0
    has_content = True
    def run(self):
        self.assert_has_content()
        prenode=nodes.literal_block(self.block_text,
                                    '\n'.join(self.content),
                                    classes=['latex'])
        return [prenode]
directives.register_directive('latex', Latex)

def latex_role(role, rawtext, text, lineno, inliner, options={}, content=[]):
    node = nodes.literal(rawtext,
                         '\(%s\)'%utils.unescape(text, 1),
                         classes=['latex'])
    return [node],[]
roles.register_local_role('latex', latex_role)

# Default latex packages to use when generating output
default_packages = [
        'amsmath',
        'amsthm',
        'amssymb',
        'bm'
        ]

def __build_preamble(packages):
    preamble = '\documentclass{article}\n'
    for p in packages:
        preamble += "\usepackage{%s}\n" % p
    preamble += "\pagestyle{empty}\n\\begin{document}\n"
    return preamble

def __write_output(infile, outfile, workdir='.', prefix = '', size = 1):
    try:
        #print(open(infile).read())
        # Generate the DVI file
        check_call(['latex', '-halt-on-error', '-output-directory', workdir, infile])

        # Convert the DVI file to PNG
        dvifile = infile.replace('.tex', '.dvi')
        check_call(["dvipng", "-T", "tight", "-x", str(size * 1000), "-z", "9", "-bg", "Transparent", "-o", outfile, dvifile])
    finally:
        # Cleanup temporaries
        basefile = infile.replace('.tex', '')
        tempext = [ '.aux', '.dvi', '.log' ]
        for te in tempext:
            tempfile = basefile + te
            if os.path.exists(tempfile):
                os.remove(tempfile)


def math2png(equation, outfile, packages = default_packages, prefix = '', size = 1):
    """
    Generate png images from $...$ style math environment equations.

    Parameters:
        equation    - An equation
        outfile     - Output file for PNG image
        packages    - Optional list of packages to include in the LaTeX preamble
        prefix      - Optional prefix for output files
        size        - Scale factor for output
    """
    try:
        # Set the working directory
        workdir = tempfile.gettempdir()

        # Get a temporary file
        fd, texfile = tempfile.mkstemp('.tex', 'eq', workdir, True)

        # Create the TeX document
        with os.fdopen(fd, 'w+') as f:
            f.write(__build_preamble(packages))
            f.write(equation)
            f.write("\n")
            f.write('\end{document}')

        __write_output(texfile, outfile, workdir, prefix, size)
    finally:
        if os.path.exists(texfile):
            os.remove(texfile)

def highlight_code(code, images_dir, images_url, cache_dir):
    # formatter
    file_name = hashlib.md5(code).hexdigest()+".png"
    cache_path = os.path.join(cache_dir, file_name)
    path = os.path.join(images_dir, file_name)
    url = images_url + "/" + file_name
    # print path, url
    if not os.path.exists(cache_path):
        math2png(code, cache_path, size=1.5)
    shutil.copy(cache_path, path)
    help_string = cgi.escape(code, quote=True)
    highlighted = '<img class="math" src="%s" alt="%s" title="%s" />' % (url, help_string, help_string)
    return highlighted

def run(src):
    location = bf.config.blog.math.images
    if not location:
        raise ValueError("Please set blog.math.images in your _config.py to point to the images directory, eg '/images/math'")
    images_dir = bf.util.path_join("_site",bf.util.fs_site_path_helper(location))
    cache_dir = bf.util.path_join(bf.util.fs_site_path_helper("_math_cache"))
    images_url = bf.util.site_path_helper(bf.config.site.path,location)
    bf.util.mkdir(images_dir)
    bf.util.mkdir(cache_dir)
    # FIXME clear out what is in the directory first
    def repl(m):
        before = m.group('before2') or '<div class="literal-block">'
        after = m.group('after2') or '</div>'
        code = m.group('code') or m.group('inline_code')
        code = html_entities_unescape(code)
        return before + highlight_code(code, images_dir, images_url, cache_dir) + after

    return code_block_re.sub(repl, src)
