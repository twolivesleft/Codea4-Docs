from docutils import nodes
from sphinx.util.docutils import SphinxDirective

class VisibilityNode(nodes.General, nodes.Element):
    tagname = 'visibility'
    pass

class VisibilityDirective(SphinxDirective):
    """A directive to control API visibility (public/private)"""

    has_content = True

    def run(self):
        node = VisibilityNode()
        node['value'] = ' '.join(self.content).strip()
        return [node]

def html_visit_visibility_node(self, node):
    pass

def html_depart_visibility_node(self, node):
    pass

def setup(app):
    app.add_node(VisibilityNode, html=(html_visit_visibility_node, html_depart_visibility_node))
    app.add_directive('visibility', VisibilityDirective)
