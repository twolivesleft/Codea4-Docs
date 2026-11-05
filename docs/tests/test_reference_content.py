"""Reference metadata must preserve content, coverage and migration information."""
import json
from pathlib import Path
import sys
import unittest
from types import SimpleNamespace
from docutils import nodes
from sphinx import addnodes

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'source/builders'))
from luastruct import DocutilsUtils
sys.path.insert(0, str(ROOT / "source/extensions"))
from referencecontent import MediaDirective


class ReferenceContentTests(unittest.TestCase):
    def test_short_preview_metadata_and_html_playback(self):
        directive = SimpleNamespace(arguments=['https://example.com/clip.mp4'],
                                    options={'type': 'video', 'playback': 'preview', 'alt': 'A circle'})
        node = MediaDirective.run(directive)[0]
        self.assertEqual(node['codea_media']['playback'], 'preview')
        html = next(node.findall(nodes.raw)).astext()
        self.assertIn('autoplay muted loop playsinline', html)
        self.assertNotIn('controls', html)
        directive.options.pop('playback')
        manual = next(MediaDirective.run(directive)[0].findall(nodes.raw)).astext()
        self.assertIn('controls', manual)
        self.assertNotIn('autoplay', manual)

    def test_deprecation_does_not_leak_from_member_to_parent(self):
        parent = addnodes.desc()
        content = addnodes.desc_content()
        parent += content
        member = addnodes.desc()
        content += member
        deprecated = addnodes.versionmodified(type='deprecated')
        deprecated += nodes.paragraph(text='Use the new API.')
        member += deprecated
        self.assertIsNone(DocutilsUtils.extract_deprecation(parent))
        self.assertEqual(DocutilsUtils.extract_deprecation(member), 'Use the new API.')

    def test_runnable_example_retains_indentation(self):
        parent = addnodes.desc()
        content = addnodes.desc_content()
        parent += content
        block = nodes.container()
        code = 'function draw()\n    ellipse(20, 20, 10)\nend'
        block['codea_example'] = {'title': 'Circle', 'code': code, 'runnable': True}
        block += nodes.literal_block(text=code)
        content += block
        self.assertEqual(DocutilsUtils.extract_code_samples(parent), [block['codea_example']])

    def test_every_api_source_is_in_a_chapter(self):
        config = json.loads((ROOT / 'source/chapters_config.json').read_text())
        entries = [entry for chapter in config for entry in chapter['entries']]
        expected = {'api/' + path.stem for path in (ROOT / 'source/api').glob('*.rst')}
        self.assertEqual(expected - set(entries), set())
        self.assertEqual(len(entries), len(set(entries)))

    def test_camera_effects_and_legacy_metadata(self):
        camera = json.loads((ROOT / 'build/luadoc/api/camera.json').read_text())
        cls = next(entry for entry in camera if entry.get('kind') == 'class' and entry['name'] == 'camera')
        names = {entry['name'] for entry in cls['members']}
        self.assertTrue({'bloom', 'tiltShift', 'saturation', 'vignette', 'grain', 'effectsEnabled', 'addEffect', 'removeEffect', 'clearEffects', 'bloom.strength', 'tiltShift.falloff'} <= names)
        legacy = json.loads((ROOT / 'build/luadoc/api/legacy.json').read_text())
        read_image = next(entry for entry in legacy if entry.get('name') == 'readImage')
        self.assertIn('image.read', read_image['deprecation'])

    def test_web_coverage_is_preserved_in_app_metadata(self):
        image_entries = json.loads((ROOT / 'build/luadoc/api/image.json').read_text())
        image = next(entry for entry in image_entries if entry.get('kind') == 'class' and entry['name'] == 'image')
        names = [entry['name'] for entry in image['members']]
        self.assertTrue({'dfg', 'filter', 'wrap', 'slice', 'setPixel', 'getPixel',
                         'setValue', 'getValue', 'setForEach', 'apply', 'readback'} <= set(names))
        self.assertEqual(names.count('pixel'), 1)
        input_entries = json.loads((ROOT / 'build/luadoc/api/input.json').read_text())
        touch = next(entry for entry in input_entries if entry.get('kind') == 'class' and entry['name'] == 'touch')
        self.assertTrue({'began', 'changed', 'moving', 'ended', 'cancelled', 'tapCount',
                         'current', 'cancel', 'makeExclusive'} <= {entry['name'] for entry in touch['members']})
        self.assertEqual({entry['name'] for entry in input_entries if entry.get('module') == 'keyboard'},
                         {'show', 'hide', 'visible', 'text'})

    def test_reference_titles_are_editorial_and_mesh_examples_are_runnable(self):
        def check(entry):
            group = entry.get('group')
            if group:
                self.assertFalse(group[0].islower(), group)
            if entry.get('kind') == 'overview':
                self.assertTrue(entry.get('name'), entry)
                self.assertNotEqual(entry['name'], group)
            for member in entry.get('members', []):
                check(member)
        for path in (ROOT / 'build/luadoc/api').glob('*.json'):
            for entry in json.loads(path.read_text()):
                check(entry)
        mesh = json.loads((ROOT / 'build/luadoc/api/mesh.json').read_text())
        overview = next(entry for entry in mesh if entry.get('kind') == 'overview')
        self.assertEqual((overview['group'], overview['name']), ('Mesh', 'Using Meshes'))
        examples = [part['content'] for part in overview['content'] if part['type'] == 'example']
        self.assertEqual(len(examples), 3)
        self.assertTrue(all(example['runnable'] for example in examples))
        self.assertTrue(any(entry.get('kind') == 'class' and entry.get('name') == 'mesh' for entry in mesh))

    def test_placeholder_overviews_are_not_emitted(self):
        for path in (ROOT / 'build/luadoc/api').glob('*.json'):
            for entry in json.loads(path.read_text()):
                if entry.get('kind') == 'overview':
                    self.assertNotIn(entry.get('content'), [[{'type': 'text', 'content': label}] for label in ('*(global)*', '*(class)*', '*(module)*')], str(path))


if __name__ == '__main__':
    unittest.main()

class ResourcePackagingTests(unittest.TestCase):
    def test_local_media_and_project_are_copied_without_escaping_source(self):
        from tempfile import TemporaryDirectory
        from types import SimpleNamespace
        from luadoc import LuaJSONBuilder
        from sphinx.errors import SphinxError
        with TemporaryDirectory() as temporary:
            root = Path(temporary) / 'source'
            out = Path(temporary) / 'output'
            root.mkdir()
            project = root / 'code/Test.codea'
            project.mkdir(parents=True)
            (project / 'Main.lua').write_text('function draw() end')
            video = root / 'videos/test.mp4'
            video.parent.mkdir()
            video.write_bytes(b'test-fixture')
            context = SimpleNamespace(env=SimpleNamespace(srcdir=str(root)), outdir=str(out))
            result = LuaJSONBuilder.copy_resource(context, 'code/Test.codea', 'manual/test', 'examples')
            self.assertEqual((out / result / 'Main.lua').read_text(), 'function draw() end')
            result = LuaJSONBuilder.copy_resource(context, 'videos/test.mp4', 'manual/test')
            self.assertEqual((out / result).read_bytes(), b'test-fixture')
            with self.assertRaises(SphinxError):
                LuaJSONBuilder.copy_resource(context, '../outside.mp4', 'manual/test')
            with self.assertRaises(SphinxError):
                LuaJSONBuilder.copy_resource(context, 'https://example.com/Test.codea', 'manual/test', 'examples')

class ImageSubstitutionTests(unittest.TestCase):
    def test_substitution_definition_does_not_duplicate_inline_image(self):
        parent = addnodes.desc()
        content = addnodes.desc_content()
        parent += content
        paragraph = nodes.paragraph()
        paragraph += nodes.image(uri='images/cap.png', alt='square cap')
        paragraph += nodes.literal(text='SQUARE')
        content += paragraph
        definition = nodes.substitution_definition()
        definition += nodes.image(uri='images/cap.png')
        content += definition
        media = DocutilsUtils.extract_media(parent)
        self.assertEqual(len(media), 1)
        self.assertEqual(media[0]['caption'], '`SQUARE`')
        self.assertNotIn('square cap', DocutilsUtils.extract_description(parent))

class EditorHelptextTests(unittest.TestCase):
    def test_overloads_share_the_editors_single_summary(self):
        from collections import defaultdict
        summaries = defaultdict(set)
        def visit(entries):
            for entry in entries:
                if entry.get('kind') in ('function', 'staticmethod', 'constructor') and entry.get('parameters') and entry.get('helptext'):
                    name = '.'.join(part for part in (entry.get('module'), entry.get('name')) if part)
                    summaries[name].add(entry['helptext'])
                visit(entry.get('members') or [])
        config = json.loads((ROOT / 'source/chapters_config.json').read_text())
        for chapter in config:
            for source in chapter['entries']:
                visit(json.loads((ROOT / 'build/luadoc' / (source + '.json')).read_text()))
        self.assertEqual({name: values for name, values in summaries.items() if len(values) > 1}, {})

class ModernProjectTests(unittest.TestCase):
    def test_every_modern_project_is_packaged_and_has_all_tabs(self):
        import plistlib
        source = ROOT / 'source/code/Modern'
        output = ROOT / 'build/luadoc'
        references = {}
        def visit(value):
            if isinstance(value, dict):
                if value.get('project', '').startswith('examples/code/Modern/'):
                    references[value['project']] = value
                for item in value.values():
                    visit(item)
            elif isinstance(value, list):
                for item in value:
                    visit(item)
        for path in (output / 'manual').glob('*.json'):
            visit(json.loads(path.read_text()))
        projects = sorted(source.glob('*.codea'))
        self.assertEqual(len(projects), 17)
        for project in projects:
            relative = 'examples/code/Modern/' + project.name
            with self.subTest(project=project.name):
                self.assertIn(relative, references)
                self.assertEqual(references[relative]['code'], (project / 'Main.lua').read_text())
                info = plistlib.loads((project / 'Info.plist').read_bytes())
                self.assertEqual(info['Runtime Type'], 'modern')
                self.assertEqual(set(info['Buffer Order']), {p.stem for p in project.glob('*.lua')})
                self.assertEqual(len(info['Buffer Order']), len(set(info['Buffer Order'])))
                for file in project.iterdir():
                    self.assertEqual(file.read_bytes(), (output / relative / file.name).read_bytes())
