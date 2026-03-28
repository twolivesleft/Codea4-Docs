from docutils import nodes
from sphinx.util.docutils import SphinxDirective

import logging

logger = logging.getLogger(__name__)

class HelpTextNode(nodes.General, nodes.Element):
    tagname = 'helptext'
    pass

class HelpTextDirective(SphinxDirective):
    """A directive to add Codea's help text information"""

    has_content = True

    def run(self):
        node = HelpTextNode()
        node['text'] = ' '.join(self.content)
        return [node]

def html_visit_helptext_node(self, node):
    pass

def html_depart_helptext_node(self, node):
    pass

def setup(app):
    app.add_node(HelpTextNode, html=(html_visit_helptext_node, html_depart_helptext_node))
    app.add_directive('helptext', HelpTextDirective)
