"""Verify shadow completion signatures in the bundled editor reference."""
import json
import unittest
from pathlib import Path


class ShadowMetadataTests(unittest.TestCase):
    def test_shadow_overloads_and_removed_members(self):
        root = Path(__file__).resolve().parents[1] / 'build/luadoc/api'
        style = json.loads((root / 'style.json').read_text())
        graphics = json.loads((root / 'graphics.json').read_text())
        formatting = next(e for e in graphics if e.get('name') == 'textFormatting')['members']
        for entries, return_type in [(style, 'style'), (formatting, 'textFormatting')]:
            with self.subTest(return_type=return_type):
                names = [e.get('name') for e in entries]
                self.assertNotIn('textShadowOffset', names)
                self.assertNotIn('textShadowSoftner', names)
                overloads = [e for e in entries if e.get('name') == 'textShadow']
                self.assertEqual(len(overloads), 2)
                self.assertEqual([p['name'] for p in overloads[0]['parameters']], ['color', 'offset', 'radius'])
                self.assertEqual([p['type'] for p in overloads[0]['parameters']], ['color', 'vec2', 'number'])
                for setter in overloads[:1]:
                    self.assertEqual(setter['returns'][0]['type'], return_type)
                    self.assertIn('color', setter['editor']['roles'])
                    self.assertTrue(setter['helptext'])
                self.assertEqual([r['type'] for r in overloads[-1]['returns']], ['color', 'vec2', 'number'])


if __name__ == '__main__':
    unittest.main()
