"""Check the bundled metadata consumed by editor completion and highlighting."""
import json
import unittest
from pathlib import Path


class TextRendererMetadataTests(unittest.TestCase):
    def entries(self, chapter):
        path = Path(__file__).resolve().parents[1] / 'build/luadoc/api' / (chapter + '.json')
        return json.loads(path.read_text())

    def test_removed_style_api_is_absent(self):
        for chapter in ['style', 'graphics']:
            for entry in self.entries(chapter):
                self.assertNotEqual(entry.get('name'), 'textStyle')
                self.assertFalse(str(entry.get('name', '')).startswith('TEXT_'))

    def test_style_and_global_overloads(self):
        for chapter, module in [('style', 'style'), ('graphics', None)]:
            with self.subTest(chapter=chapter):
                entries = [entry for entry in self.entries(chapter)
                           if entry.get('name') == 'textRenderer']
                self.assertEqual(len(entries), 2)
                setter = next(entry for entry in entries if entry['parameters'])
                getter = next(entry for entry in entries if not entry['parameters'])
                for entry in entries:
                    self.assertEqual(entry['module'], module)
                    self.assertTrue(entry['helptext'])
                self.assertEqual(setter['parameters'][0]['type'], 'enum')
                self.assertEqual(setter['returns'][0]['type'], 'style')
                self.assertEqual(getter['returns'][0]['type'], 'enum')

    def test_renderer_constants_have_highlighting_and_types(self):
        entries = self.entries('style')
        for name in ['native', 'atlas']:
            with self.subTest(name=name):
                entry = next(entry for entry in entries if entry.get('name') == name)
                self.assertEqual(entry['module'], 'style')
                self.assertEqual(entry['type'], 'string')
                self.assertEqual(entry['symbol']['types'], ['const'])
                self.assertEqual(entry['symbol']['group'], 'text-renderer')
                self.assertTrue(entry['helptext'])


if __name__ == '__main__':
    unittest.main()
