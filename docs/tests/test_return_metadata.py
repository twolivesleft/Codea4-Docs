"""Run with the documentation virtualenv's Python."""
import sys
import unittest
from pathlib import Path
from docutils import nodes

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'source/builders'))
from luastruct import LuaFunction


class ReturnMetadataTests(unittest.TestCase):
    def extract(self, types):
        root = nodes.section()
        fields = nodes.field_list()
        root += fields
        for title, value in [('Returns', 'Measured values.'), ('Return type', types)]:
            field = nodes.field()
            field += nodes.field_name(text=title)
            field += nodes.field_body('', nodes.paragraph(text=value))
            fields += field
        function = LuaFunction.__new__(LuaFunction)
        function.module = 'style'
        return [value.to_dict() for value in function.extract_returns(root)]

    def test_multiple_values_are_separate_types(self):
        result = self.extract('number, number')
        self.assertEqual([value['type'] for value in result], ['number', 'number'])
        self.assertEqual(result[0]['description'], 'Measured values.')

    def test_fluent_return_remains_a_single_type(self):
        self.assertEqual(self.extract('style')[0]['type'], 'style')

    def test_structural_and_compound_types_are_preserved(self):
        result = self.extract('table$private.result, table<string, number>')
        self.assertEqual(result[0]['type'], 'style.private.result')
        self.assertEqual(result[0]['displayType'], 'table')
        self.assertEqual(result[1]['type'], 'table<string, number>')


if __name__ == '__main__':
    unittest.main()
