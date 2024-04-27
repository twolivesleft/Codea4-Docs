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
        self.documents[docname] = self.env.get_doctree(docname)

    def finish(self):
        output = {}
        for docname, doctree in self.documents.items():
            visitor = LuaJSONVisitor(self, doctree)
            doctree.walkabout(visitor)
            output[docname] = visitor.get_data()

        with open(os.path.join(self.outdir, 'output.json'), 'w') as f:
            json.dump(output, f, indent=2)

class LuaJSONVisitor(nodes.NodeVisitor):
    def __init__(self, builder, doc):
        super().__init__(doc)
        self.builder = builder
        self.data = []
        self.stack = []

    def visit_target(self, node):
        pass #print(f"Target: visiting node: {node}")

    def visit_section(self, node):
        if node.attributes.get('domain') == 'lua' and node.attributes.get('objtype') in ['class', 'staticmethod', 'attribute']:
            if node.attributes['objtype'] == 'class':
                lua_class = LuaClass(node.children[0].astext().split()[-1])
                self.stack.append(lua_class)
                print("Found class")
            elif node.attributes['objtype'] == 'staticmethod':
                method = LuaMethod(node.children[0].astext().split()[-1])
                self.stack[-1].methods.append(method)
                self.stack.append(method)
                print("Found static method")
            elif node.attributes['objtype'] == 'attribute':
                attr_name = node.children[0].astext().split()[-1]
                attr_type = node.children[0].next_sibling.astext() if node.children[0].next_sibling else 'unknown'
                attribute = LuaAttribute(attr_name, attr_type)
                self.stack[-1].attributes.append(attribute)
                self.stack.append(attribute)
                print("Found attribute")
        self.generic_visit(node)

    def visit_paragraph(self, node):
        pass #print(f"Paragraph: visiting node: {node}")

    def visit_text(self, node):
        pass #print(f"Text: visiting node: {node}")        

    def visit_title(self, node):
        pass #print(f"Text: visiting node: {node}")                

    def unknown_visit(self, node):   
        if hasattr(node, 'attributes'):
            match node.attributes.get('objtype'):
                case 'attribute':
                    attribute = LuaAttribute(node)
                    print(f"⭐️ {attribute}")
                    # for child in node.children:
                    #     print("\n")
                    #     print(vars(child))
                    #     print("\n")

                case 'staticmethod':
                    staticmethod = LuaStaticMethod(node)
                    print(f"⭐️ {staticmethod}")
                    for child in node.children:
                        print("\n")
                        print(child)
                        print("\n")

    def unknown_departure(self, node):        
        pass #print(f"Departing unknown node type: {type(node).__name__}")

    def generic_visit(self, node):
        if node.attributes.get('domain') == 'lua' and node.attributes.get('objtype'):
            print(f"Generic node: {node.attributes['objtype']}")

    def get_data(self):
        return self.data

def setup(app):
    app.add_builder(LuaJSONBuilder)


import inspect

def get_attributes(obj):
    # Fetch all members of the object that are not callable (hence not methods)
    # and also not any of the built-in Python attributes (typically named with double underscores).
    attributes = inspect.getmembers(obj, lambda a: not(inspect.isroutine(a)))
    return [a for a in attributes if not (a[0].startswith('__') and a[0].endswith('__'))]

