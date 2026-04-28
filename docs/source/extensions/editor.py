from docutils import nodes
from sphinx.util.docutils import SphinxDirective

class EditorNode(nodes.General, nodes.Element):
    tagname = 'editor'
    pass

class EditorDirective(SphinxDirective):
    """A directive to attach Codea editor affordance roles to an API entry"""

    optional_arguments = 16
    final_argument_whitespace = True
    has_content = True

    def run(self):
        node = EditorNode()
        source = ' '.join([*self.arguments, *self.content])
        node['roles'] = [role.strip() for role in source.replace(',', ' ').split() if role.strip()]
        return [node]

def html_visit_editor_node(self, node):
    pass

def html_depart_editor_node(self, node):
    pass

def setup(app):
    app.add_node(EditorNode, html=(html_visit_editor_node, html_depart_editor_node))
    app.add_directive('editor', EditorDirective)
