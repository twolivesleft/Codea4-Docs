import json
from sphinx.builders import Builder
from sphinx.addnodes import desc, desc_content
from docutils.nodes import field_list, field, paragraph, literal_block, title, section
from docutils import nodes
from luastruct import *
import os
import shutil
from pathlib import Path
from sphinx.errors import SphinxError

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
        if docname.startswith('manual/'):
            # A guide is a reading sequence, not a list of one-paragraph pages.
            combined = []
            for entry in data:
                if entry['kind'] == 'overview':
                    heading = entry.get('name') or entry.get('group')
                    if combined and combined[-1]['kind'] == 'overview':
                        if heading and heading != combined[-1]['name']:
                            combined[-1]['content'].append({'type': 'text', 'content': '## ' + heading})
                        combined[-1]['content'].extend(entry['content'])
                        continue
                    entry['name'] = heading
                    entry['group'] = self.env.metadata.get(docname, {}).get('reference-section', 'Guides')
                combined.append(entry)
            data = combined
        self.prepare_resources(data, docname)
        path = os.path.join(self.outdir, f"{docname}.json")
        print(f"Writing to path {path}")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w') as f:
            json.dump(data, f, indent=2)

    def copy_resource(self, uri, docname, category='media'):
        if uri.startswith('https://'):
            if category == 'examples':
                raise SphinxError('Runnable projects must be bundled local directories')
            return uri
        root = Path(self.env.srcdir).resolve()
        source = (root / uri.lstrip('/')).resolve()
        if not source.exists() and not uri.startswith('/'):
            source = (root / Path(docname).parent / uri).resolve()
        if not source.is_relative_to(root) or not source.exists():
            raise SphinxError(f'Missing or invalid reference resource: {uri} in {docname}')
        if category == 'examples' and (not source.is_dir() or source.suffix != '.codea'):
            raise SphinxError('Runnable project resources must be .codea directories')
        relative = Path(category) / source.relative_to(root)
        destination = Path(self.outdir) / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        if source.is_dir():
            shutil.copytree(source, destination, dirs_exist_ok=True)
        else:
            shutil.copy2(source, destination)
        return relative.as_posix()

    def prepare_resources(self, value, docname):
        if isinstance(value, list):
            for item in value:
                self.prepare_resources(item, docname)
        elif isinstance(value, dict):
            if value.get('kind') in ('image', 'video') and 'source' in value:
                value['source'] = self.copy_resource(value['source'], docname)
            if value.get('project'):
                value['project'] = self.copy_resource(value['project'], docname, 'examples')
            if value.get('poster'):
                value['poster'] = self.copy_resource(value['poster'], docname)
            for item in value.values():
                if isinstance(item, (list, dict)):
                    self.prepare_resources(item, docname)

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
        self.current_symbol = None
        self.symbol_stack = []
        self.desc_symbol_stack = []
        self.section_stack = []

    def has_desc_ancestor(self, node):
        """Walk up parent chain to check for desc ancestors"""
        current = node
        while current:
            if isinstance(current, desc):
                return True
            current = current.parent
        return False

    def visit_section(self, node):
        self.symbol_stack.append(self.current_symbol)
        self.section_stack.append((self.document_group, self.section_group, self.current_group, self.current_name))

    def visit_paragraph(self, node):
        if isinstance(node.parent, section) and not self.has_desc_ancestor(node):
            if node.astext().strip() not in ('(global)', '(class)', '(module)'):
                self.current_section_content.append(OverviewContent(DocutilsUtils.markdown_children(node), OverviewContentKind.TEXT))

    def visit_container(self, node):
        if 'codea_example' in node or 'codea_media' in node:
            if not self.has_desc_ancestor(node):
                key, kind = ('codea_example', OverviewContentKind.EXAMPLE) if 'codea_example' in node else ('codea_media', OverviewContentKind.MEDIA)
                self.current_section_content.append(OverviewContent(node[key], kind))
            raise nodes.SkipNode

    def depart_container(self, node):
        pass

    def visit_image(self, node):
        if not self.has_desc_ancestor(node):
            self.current_section_content.append(OverviewContent({'kind': 'image', 'source': node['uri'], 'alt': node.get('alt', '')}, OverviewContentKind.MEDIA))
        raise nodes.SkipNode

    def visit_bullet_list(self, node):
        if not self.has_desc_ancestor(node):
            text = '\n'.join('- ' + DocutilsUtils.markdown_children(item) for item in node.children)
            self.current_section_content.append(OverviewContent(text, OverviewContentKind.TEXT))
        raise nodes.SkipNode

    def visit_literal_block(self, node):
        if isinstance(node.parent, section) and not self.has_desc_ancestor(node):
            self.current_section_content.append(OverviewContent(node.astext(), OverviewContentKind.CODE))
        elif isinstance(node.parent, nodes.container) and 'literal-block-wrapper' in node.parent.get('classes', []) and not self.has_desc_ancestor(node):
            caption = next((child for child in node.parent.children if isinstance(child, nodes.caption)), None)
            if caption is not None:
                self.current_section_content.append(OverviewContent('**' + caption.astext() + '**', OverviewContentKind.TEXT))
            self.current_section_content.append(OverviewContent(node.astext(), OverviewContentKind.CODE))
        elif self.is_overview_collapse(node.parent) and not self.has_desc_ancestor(node):
            # A collapsed example (.. collapse:: Title): its title, then its code
            label = getattr(node.parent, 'label', None)
            if label and node is node.parent.next_node(literal_block):
                self.current_section_content.append(OverviewContent(f"*{label}*", OverviewContentKind.TEXT))
            self.current_section_content.append(OverviewContent(node.astext(), OverviewContentKind.CODE))

    def is_overview_collapse(self, node):
        return node.__class__.__name__ == 'CollapseNode' and isinstance(node.parent, section)

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
        self.current_symbol = self.symbol_stack.pop() if self.symbol_stack else None
        self.document_group, self.section_group, self.current_group, self.current_name = self.section_stack.pop()

    def extract_symbol(self, node):
        return DocutilsUtils.extract_symbol(node)

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
        if node.tagname in ('note', 'warning', 'important', 'tip', 'admonition', 'caution', 'attention', 'hint', 'danger', 'error') and not self.has_desc_ancestor(node):
            paragraphs = [DocutilsUtils.markdown_children(child) for child in node.children if isinstance(child, nodes.paragraph)]
            if paragraphs:
                self.current_section_content.append(OverviewContent('**' + node.tagname.capitalize() + '**\n\n' + '\n\n'.join(paragraphs), OverviewContentKind.TEXT))
            # Leave code/media children available to their dedicated visitors.
        if hasattr(node, 'attributes'):
            objtype = node.attributes.get('objtype')          

            if getattr(node, 'tagname', None) == 'symbol' and not self.has_desc_ancestor(node):
                self.current_symbol = {
                    'types': node.attributes['types']
                }
                group = node.attributes.get('group')
                if group:
                    self.current_symbol['group'] = group
                return

            # Flush content before any Lua object
            if objtype:
                self.flush_content()
                symbol = self.extract_symbol(node) or self.current_symbol
                self.desc_symbol_stack.append(self.current_symbol)
                self.current_symbol = symbol
            else:
                symbol = self.current_symbol

            if objtype == 'method':
                method = LuaFunction(node, 'method', self.current_group, symbol)
                self.add_to_current_scope(method)

            elif objtype == 'class':
                cls = LuaClass(node, self.current_group, symbol=symbol)
                self.add_to_current_scope(cls)
                self.class_stack.append(cls)

            elif objtype == 'function':
                function = LuaFunction(node, 'function', self.current_group, symbol)
                self.entries.append(function)

            elif objtype == 'attribute' or objtype == 'classattribute':
                attribute = LuaAttribute(node, objtype, self.current_group, symbol=symbol)
                self.add_to_current_scope(attribute)

                # A table attribute with documented fields represents a structural
                # table type for Codea's autocomplete. Keep the public attribute
                # display type as `table`, but point lookup at a private module-
                # scoped class that carries the field metadata.
                if attribute.type == 'table':
                    if attribute.module:
                        lua_class_name = f"private.{attribute.name}"
                        lookup_type = f"{attribute.module}.{lua_class_name}"
                    else:
                        lua_class_name = f"private.{attribute.name}"
                        lookup_type = lua_class_name
                    lua_class = LuaClass(name=lua_class_name, description=attribute.description, module=attribute.module, group=self.current_group, visibility='private', symbol=symbol)
                    fields = attribute.extract_fields(node)

                    if fields:
                        for field in fields:
                            lua_class.members.append(field)
                        self.add_to_current_scope(lua_class)
                        attribute.type = lookup_type
                        attribute.display_type = 'table'

            elif objtype == 'classattribute':
                self.add_to_current_scope(LuaAttribute(node, objtype, self.current_group, symbol=symbol))

            elif objtype == 'staticmethod':
                if self.is_constructor_node(node):
                    current_class = self.class_stack[-1]
                    parsed = LuaFunction(node, 'constructor', self.current_group, symbol)
                    method = LuaFunction(
                        node,
                        'constructor',
                        self.current_group,
                        symbol,
                        name=current_class.name,
                        module=current_class.module,
                        returns=parsed.returns or [LuaReturn(type_hint=current_class.full_name())]
                    )
                else:
                    method = LuaFunction(node, 'staticmethod', self.current_group, symbol)
                self.add_to_current_scope(method)

    def unknown_departure(self, node):  
        if hasattr(node, 'attributes'):            
            if node.attributes.get('objtype') == 'class':
                self.class_stack.pop()
            if node.attributes.get('objtype') and self.desc_symbol_stack:
                self.current_symbol = self.desc_symbol_stack.pop()

    def generic_visit(self, node):
        pass

    def get_data(self):
        return [entry.to_dict() for entry in self.entries]
    
    def add_to_current_scope(self, element):
        if self.class_stack:
            self.class_stack[-1].members.append(element)
        else:
            self.entries.append(element)

    def is_constructor_node(self, node):
        if not self.class_stack:
            return False

        method_name = DocutilsUtils.extract_name(node)
        class_name = self.class_stack[-1].name
        return method_name == class_name.split('.')[-1]

def setup(app):
    app.add_builder(LuaJSONBuilder)


import inspect

def get_attributes(obj):
    # Fetch all members of the object that are not callable (hence not methods)
    # and also not any of the built-in Python attributes (typically named with double underscores).
    attributes = inspect.getmembers(obj, lambda a: not(inspect.isroutine(a)))
    return [a for a in attributes if not (a[0].startswith('__') and a[0].endswith('__'))]
