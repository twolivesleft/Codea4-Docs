import json
from sphinx.builders import Builder
from sphinx.addnodes import desc, desc_content
from docutils.nodes import field_list, field, paragraph, literal_block, title, section
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

    def finish(self):
        config_path = os.path.join(self.env.srcdir, 'chapters_config.json')
        if not os.path.exists(config_path):
            return
        with open(config_path, 'r') as f:
            chapters_config = json.load(f)
        chapters_out = []
        for chapter in chapters_config:
            chapters_out.append({
                'id': chapter['id'],
                'title': chapter['title'],
                'subtitle': chapter['subtitle'],
                'icon': chapter.get('icon'),
                'sources': [f"{e}.json" for e in chapter.get('entries', [])]
            })
        out_path = os.path.join(self.outdir, 'chapters.json')
        print(f"Writing chapters index to {out_path}")
        with open(out_path, 'w') as f:
            json.dump(chapters_out, f, indent=2)

class LuaJSONVisitor(nodes.NodeVisitor):
    def __init__(self, builder, doc):
        super().__init__(doc)
        self.entries = []
        self.class_stack = []
        self.document_group = None   # top-level (file) title
        self.section_group = None    # level-2 section title — used as group for sub-section overviews
        self.current_group = None    # current group for API entries
        self.current_name = None     # subsection title — used as name for overview entries
        self.current_section_content = []

    def has_desc_ancestor(self, node):
        """Walk up parent chain to check for desc ancestors"""
        current = node
        while current:
            if isinstance(current, desc):
                return True
            current = current.parent
        return False

    def visit_paragraph(self, node):
        if isinstance(node.parent, section) and not self.has_desc_ancestor(node):
            self.current_section_content.append(OverviewContent(DocutilsUtils.markdown_children(node), OverviewContentKind.TEXT))

    def visit_literal_block(self, node):
        if isinstance(node.parent, section) and not self.has_desc_ancestor(node):
            self.current_section_content.append(OverviewContent(node.astext(), OverviewContentKind.CODE))

    def visit_table(self, node):
        if isinstance(node.parent, section) and not self.has_desc_ancestor(node):
            title, header, rows = DocutilsUtils.extract_table(node)
            self.current_section_content.append(OverviewContent({'title': title, 'header': header, 'rows': rows}, OverviewContentKind.TABLE))
        raise nodes.SkipNode

    def visit_title(self, node):
        self.flush_content()
        title_text = node.astext()
        parent = node.parent
        grandparent = parent.parent if parent else None
        great_grandparent = grandparent.parent if grandparent else None

        is_top_level = isinstance(grandparent, nodes.document) if parent else False
        is_level2 = (isinstance(grandparent, nodes.section) and
                     isinstance(great_grandparent, nodes.document)) if parent else False

        if is_top_level:
            self.document_group = title_text
            self.section_group = None
            self.current_name = None
        elif is_level2:
            self.section_group = title_text
            self.current_name = None
        else:
            self.current_name = title_text
        self.current_group = title_text

    def depart_section(self, node):
        self.flush_content()

    def flush_content(self):
        if self.current_section_content:
            if self.current_name is None:
                # Content directly under a level-2 section (no sub-section entered yet).
                # Group under the document title; name the overview after the section itself.
                group = self.document_group or self.current_group
                name = self.section_group
            else:
                # Content under a level-3+ sub-section — use the level-2 section as the group.
                group = self.section_group or self.document_group or self.current_group
                name = self.current_name
            self.entries.append(LuaOverview(self.current_section_content, group, name))
            self.current_section_content = []

    def visit_text(self, node):
        pass

    def visit_index(self, node):
        pass

    def unknown_visit(self, node):
        if hasattr(node, 'attributes'):
            objtype = node.attributes.get('objtype')          

            # Flush content before any Lua object
            if objtype:
                self.flush_content()

            if objtype == 'method':
                method = LuaFunction(node, 'method', self.current_group)
                self.add_to_current_scope(method)

            elif objtype == 'class':
                cls = LuaClass(node, self.current_group)
                self.add_to_current_scope(cls)
                self.class_stack.append(cls)

            elif objtype == 'function':
                self.entries.append(LuaFunction(node, 'function', self.current_group))

            elif objtype == 'attribute' or objtype == 'classattribute':
                attribute = LuaAttribute(node, objtype, self.current_group)
                self.add_to_current_scope(attribute)

                # Check if this attribute should create an anonymous LuaClass
                if attribute.type == 'table':
                    if attribute.module:
                        lua_class_name = f"table#{attribute.module}#{attribute.name}"
                    else:
                        lua_class_name = f"table#{attribute.name}"
                    lua_class = LuaClass(name=lua_class_name, description=attribute.description, module=attribute.module, group=self.current_group)
                    fields = attribute.extract_fields(node)

                    if fields:
                        for field in fields:
                            lua_class.members.append(field)
                        self.add_to_current_scope(lua_class)
                        # Update the attribute's type to refer to this new anonymous class
                        attribute.type = lua_class.name

            elif objtype == 'classattribute':
                self.add_to_current_scope(LuaAttribute(node, objtype, self.current_group))

            elif objtype == 'staticmethod':
                method = LuaFunction(node, 'staticmethod', self.current_group)
                self.add_to_current_scope(method)

    def unknown_departure(self, node):  
        if hasattr(node, 'attributes'):            
            if node.attributes.get('objtype') == 'class':
                self.class_stack.pop()

    def generic_visit(self, node):
        pass

    def get_data(self):
        return [entry.to_dict() for entry in self.entries]
    
    def add_to_current_scope(self, element):
        if self.class_stack:
            self.class_stack[-1].members.append(element)
        else:
            self.entries.append(element)


def setup(app):
    app.add_builder(LuaJSONBuilder)


import inspect

def get_attributes(obj):
    # Fetch all members of the object that are not callable (hence not methods)
    # and also not any of the built-in Python attributes (typically named with double underscores).
    attributes = inspect.getmembers(obj, lambda a: not(inspect.isroutine(a)))
    return [a for a in attributes if not (a[0].startswith('__') and a[0].endswith('__'))]

