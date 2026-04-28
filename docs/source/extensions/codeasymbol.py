from docutils import nodes
from docutils.parsers.rst import directives
from sphinx.util.docutils import SphinxDirective

class SymbolNode(nodes.General, nodes.Element):
    tagname = 'symbol'
    pass

class SymbolDirective(SphinxDirective):
    """A directive to attach Codea symbol classification metadata to an API entry"""

    optional_arguments = 16
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        'group': directives.unchanged
    }

    def run(self):
        node = SymbolNode()
        source = ' '.join([*self.arguments, *self.content])
        node['types'] = [symbol_type.strip() for symbol_type in source.replace(',', ' ').split() if symbol_type.strip()]
        group = self.options.get('group')
        if group:
            node['group'] = group
        return [node]

def html_visit_symbol_node(self, node):
    pass

def html_depart_symbol_node(self, node):
    pass

def setup(app):
    app.add_node(SymbolNode, html=(html_visit_symbol_node, html_depart_symbol_node))
    app.add_directive('symbol', SymbolDirective)
