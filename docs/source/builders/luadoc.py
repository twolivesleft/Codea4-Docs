import json
from sphinx.builders import Builder
from docutils import nodes
from luastruct import *
import os

class LuaJSONBuilder(Builder):
    name = 'luadoc'
    epilog = 'Building custom JSON output.'

    def init(self):
        self.docnames = []
        self.documents = {}

    def get_outdated_docs(self):
        return self.env.found_docs

    def get_target_uri(self, docname, typ=None):
        return f"{docname}.json"

    def prepare_writing(self, docnames):
        self.docnames.extend(docnames)

    def write_doc(self, docname, doctree):
        print(f"Parsing {docname}")
        visitor = LuaJSONVisitor(self, doctree)
        doctree.walkabout(visitor)
        self.documents[docname] = self.env.get_doctree(docname)
        data = visitor.get_data()
        path = os.path.join(self.outdir, f"{docname}.json")
        print(f"Writing to path {path}")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w') as f:
            json.dump(data, f, indent=2)

class LuaJSONVisitor(nodes.NodeVisitor):
    def __init__(self, builder, doc):
        super().__init__(doc)
        self.entries = []
        self.current_class = None

    def visit_section(self, node):
        pass

    def visit_paragraph(self, node):
        pass

    def visit_text(self, node):
        pass

    def visit_title(self, node):
        pass

    def visit_index(self, node):
        pass

    def unknown_visit(self, node):
        if hasattr(node, 'attributes'):
            objtype = node.attributes.get('objtype')          
            if objtype == 'method':     
                method = LuaFunction(node, 'method')
                if self.current_class:
                    self.current_class.members.append(method)
                else:
                    self.entries.append(method)

            elif objtype == 'class':
                self.current_class = LuaClass(node)
                self.entries.append(self.current_class)

            elif objtype == 'function':
                self.entries.append(LuaFunction(node, 'function'))

            elif objtype == 'attribute':
                if self.current_class:
                    self.current_class.members.append(LuaAttribute(node))
                else:
                    self.entries.append(LuaAttribute(node))

            elif objtype == 'staticmethod':
                method = LuaFunction(node, 'staticmethod')
                if self.current_class:
                    self.current_class.members.append(method)
                else:
                    self.entries.append(method)

    def unknown_departure(self, node):  
        if hasattr(node, 'attributes'):            
            if node.attributes.get('objtype') == 'class':
                self.current_class = None

    def generic_visit(self, node):
        pass

    def get_data(self):
        return {
            'entries' : [entry.to_dict() for entry in self.entries]
        }

def setup(app):
    app.add_builder(LuaJSONBuilder)


import inspect

def get_attributes(obj):
    # Fetch all members of the object that are not callable (hence not methods)
    # and also not any of the built-in Python attributes (typically named with double underscores).
    attributes = inspect.getmembers(obj, lambda a: not(inspect.isroutine(a)))
    return [a for a in attributes if not (a[0].startswith('__') and a[0].endswith('__'))]

