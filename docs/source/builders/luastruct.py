from docutils import nodes

class DocutilsUtils:
    @staticmethod
    def extract_name(node):
        name_node = next((child for child in node.traverse() if child.tagname == 'desc_name'), None)
        return name_node.astext() if name_node else None
    
    @staticmethod
    def extract_description(node):
        content_node = next((child for child in node.traverse() if child.tagname == 'paragraph'), None)
        return content_node.astext() if content_node else None
    
    @staticmethod
    def extract_module(node):
        signature_node = next((child for child in node.traverse() if child.tagname == 'desc_signature'), None)
        # Check if the node directly contains a 'module' attribute
        if 'module' in signature_node.attributes:
            return signature_node.attributes['module']

        # Return None or a default if no module attribute is found
        return None


class LuaModule:
    def __init__(self, node):
        self.name = DocutilsUtils.extract_name(node)
        self.description = DocutilsUtils.extract_description(node)

    def __str__(self):
        return f"{self.name}\n\t{self.description}"

    def to_dict(self):
        return {
            'name': self.name,
            'description': self.description,
        }

class LuaClass:
    def __init__(self, node):
        self.name = DocutilsUtils.extract_name(node)
        self.description = DocutilsUtils.extract_description(node)
        self.module = DocutilsUtils.extract_module(node)
        self.members = []

    def __str__(self):
        return f"{self.name} [{self.module}]\n\t{self.description}"

    def to_dict(self):
        return {
            'name': self.name,
            'description': self.description,
            'module': self.module,
            'members': [members.to_dict() for members in self.members]
        }
    
class LuaParameter:
    def __init__(self, name, type_hint=None, optional=False, description=None, default=None):
        self.name = name
        self.type_hint = type_hint
        self.optional = optional
        self.description = description
        self.default = default

    def __str__(self):
        default_str = f" [default = {self.default}]" if self.default is not None else ""
        optional_str = "Optional" if self.optional else "Required"
        return f"Parameter(Name: {self.name}, Type: {self.type_hint}, {optional_str}{default_str}, Description: {self.description})"

    def to_dict(self):
        return {
            'name': self.name,
            'type_hint': self.type_hint,
            'optional': self.optional,
            'description': self.description,
            'default': self.default
        }
    
class LuaReturn:
    def __init__(self, type_hint=None, description=None):
        self.type_hint = type_hint
        self.description = description

    def __str__(self):
        return f"Returns `{self.type_hint}`\n\t{self.description}"

    def to_dict(self):
        return {
            'type_hint': self.type_hint,
            'description': self.description
        }

class LuaFunction:
    def __init__(self, node, type):
        self.name = DocutilsUtils.extract_name(node)
        self.module = DocutilsUtils.extract_module(node)
        self.description = DocutilsUtils.extract_description(node)
        self.parameters = self.extract_parameters(node)
        self.returns = self.extract_returns(node)        
        self.type = type

    def extract_parameters(self, node):
        params = []
        param_list = node.next_node(condition=lambda n: n.tagname == 'desc_parameterlist')
        # Search for the field list that contains parameter details
        field_list = node.next_node(condition=lambda n: n.tagname == 'field_list')
        param_details = {}
        if field_list:
            for field in field_list.children:
                if isinstance(field, nodes.field):
                    param_name_node = field.next_node(condition=lambda n: n.tagname == 'literal_strong')
                    param_description_nodes = field.next_node(condition=lambda n: n.tagname == 'paragraph')
                    if param_name_node and param_description_nodes:
                        param_name = param_name_node.astext().split('=')[0].strip()  # Handle default values here if specified
                        default_value = param_name_node.astext().split('=')[1].strip() if '=' in param_name_node.astext() else None
                        # Extract the type if available within parenthesis
                        param_type = None
                        description_text = param_description_nodes.astext()
                        if '(' in description_text and ')' in description_text:
                            start = description_text.find('(') + 1
                            end = description_text.find(')')
                            param_type = description_text[start:end]
                        # Description often follows the type enclosed in dash
                        param_description = description_text.split('–')[-1].strip()
                        param_details[param_name] = {
                            'type': param_type,
                            'description': param_description,
                            'default': default_value
                        }

        if param_list:
            for child in param_list.children:
                if child.tagname == 'desc_parameter' or child.tagname == 'desc_optional':
                    for param_node in child.children:
                        param_name = param_node.astext().split('=')[0].strip()
                        default_value = param_node.astext().split('=')[1].strip() if '=' in param_node.astext() else None
                        optional = child.tagname == 'desc_optional'
                        param_info = param_details.get(param_name, {})
                        params.append(LuaParameter(name=param_name,
                                                   type_hint=param_info.get('type'),
                                                   optional=optional,
                                                   description=param_info.get('description'),
                                                   default=default_value or param_info.get('default')))

        return params

    def extract_returns(self, node):
        returns = []
        return_nodes = node.next_node(condition=lambda n: n.tagname == 'field_list')
        if return_nodes:
            for field in return_nodes.children:
                if isinstance(field, nodes.field) and 'Returns' in field.children[0].astext():
                    return_desc = field.children[1].astext()
                    returns.append(LuaReturn(description=return_desc))
                elif isinstance(field, nodes.field) and 'Return type' in field.children[0].astext():
                    # We assume there's an <inline> tag wrapping the type description
                    for para in field.traverse(nodes.paragraph):
                        type_text = ''.join([n.astext() for n in para.traverse() if isinstance(n, nodes.Text)])
                        if returns:
                            returns[0].type_hint = type_text  # Assuming only one return entry is common
                        else:
                            # In case the return type is specified before the description
                            returns.append(LuaReturn(type_hint=type_text))
        return returns

    def __str__(self):
        parameter_str = "\n\t".join(str(param) for param in self.parameters)
        returns_str = "\n\t".join(str(return_val) for return_val in self.returns)
        return f"{self.name}\n\tDescription: {self.description}\n\tParameters:\n\t{parameter_str}\n\tReturns:\n\t{returns_str}"

    def to_dict(self):
        return {
            'name': self.name,
            'memberType': self.type,
            'module': self.module,
            'description': self.description,
            'parameters': [p.to_dict() for p in self.parameters],
            'returns': [r.to_dict() for r in self.returns]
        }


class LuaAttribute:
    def __init__(self, node):
        self.name = DocutilsUtils.extract_name(node)
        self.module = DocutilsUtils.extract_module(node)
        self.default_value = None  # Initializing default value
        self.type = self.extract_type(node)
        self.description = DocutilsUtils.extract_description(node)        

    def extract_type(self, node):
        # Finds the first 'desc_type' element and extracts its text, along with any default value if specified.
        type_node = next((child for child in node.traverse() if child.tagname == 'desc_type'), None)
        if type_node:
            type_text = type_node.astext()
            # Check for default value pattern in the type text
            if '[' in type_text and 'default' in type_text:
                # Extract the type up to the '['
                type_name = type_text[:type_text.find('[')].strip()
                # Extract default value after 'default ='
                default_start = type_text.find('default =') + len('default =')
                default_end = type_text.find(']', default_start)
                self.default_value = type_text[default_start:default_end].strip()
                return type_name
            return type_text
        return None

    def __str__(self):
        return f"{self.name}: {self.type} [default = {self.default_value}]\n\t{self.description}"

    def to_dict(self):
        return {
            'name': self.name,
            'memberType': 'attribute',
            'module': self.module,
            'type': self.type,
            'default_value': self.default_value,
            'description': self.description
        }

