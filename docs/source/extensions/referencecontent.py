"""Structured examples and media shared by the website and Probe Browser."""
from pathlib import Path
from html import escape
import shutil
import posixpath
from docutils import nodes
from docutils.parsers.rst import directives
from sphinx.util.docutils import SphinxDirective


class ExampleDirective(SphinxDirective):
    required_arguments = 1
    final_argument_whitespace = True
    has_content = True
    option_spec = {'project': directives.unchanged, 'poster': directives.unchanged}

    def run(self):
        if not self.content and not self.options.get('project'):
            raise self.error('A runnable example needs Lua code or a bundled project.')
        code_text = '\n'.join(self.content)
        if not code_text and self.options.get('project'):
            root = Path(self.env.srcdir).resolve()
            project = (root / self.options['project'].lstrip('/')).resolve()
            source = project / 'Main.lua'
            if not project.is_relative_to(root) or project.suffix != '.codea' or not source.is_file():
                raise self.error('A bundled example needs a .codea directory with Main.lua inside the documentation source.')
            self.env.note_dependency(str(source))
            code_text = source.read_text(encoding='utf-8')
        container = nodes.container()
        container['codea_example'] = {
            'title': self.arguments[0], 'code': code_text,
            'runnable': True, **self.options
        }
        container += nodes.caption(text=self.arguments[0])
        code = nodes.literal_block(text=code_text)
        code['language'] = 'lua'
        container += code
        return [container]


class MediaDirective(SphinxDirective):
    required_arguments = 1
    option_spec = {'type': lambda value: directives.choice(value, ('image', 'video')),
                   'alt': directives.unchanged, 'caption': directives.unchanged,
                   'poster': directives.unchanged,
                   'playback': lambda value: directives.choice(value, ('preview', 'controls'))}

    def run(self):
        uri = self.arguments[0]
        kind = self.options.get('type', 'image')
        container = nodes.container()
        container['codea_media'] = {'kind': kind, 'source': uri, **self.options}
        container['codea_media'].pop('type', None)
        if kind == 'image':
            image_uri = uri if uri.startswith('https://') else '/' + uri.lstrip('/')
            container += nodes.image(uri=image_uri, alt=self.options.get('alt', ''))
        else:
            # Local videos are copied beside the HTML output as well as luadoc.
            if not uri.startswith('https://'):
                source = (Path(self.env.srcdir) / uri.lstrip('/')).resolve()
                root = Path(self.env.srcdir).resolve()
                if not source.is_relative_to(root) or not source.is_file():
                    raise self.error('Video must be a file inside the documentation source directory.')
                self.env.note_dependency(str(source))
                videos = getattr(self.env, 'reference_videos', set())
                videos.add(source.relative_to(root).as_posix())
                self.env.reference_videos = videos
                destination = '_reference_media/' + source.relative_to(root).as_posix()
                uri = posixpath.relpath(destination, posixpath.dirname(self.env.docname) or '.')
            playback = 'autoplay muted loop playsinline preload="metadata"' if self.options.get('playback') == 'preview' else 'controls preload="none"'
            container += nodes.raw('', '<video ' + playback + ' style="max-width:100%" aria-label="' + escape(self.options.get('alt', 'Video'), quote=True) + '" src="' + escape(uri, quote=True) + '"></video>', format='html')
        if self.options.get('caption'):
            container += nodes.paragraph(text=self.options['caption'])
        return [container]


def copy_html_videos(app, exception):
    if exception or app.builder.format != 'html':
        return
    for relative in getattr(app.env, 'reference_videos', set()):
        destination = Path(app.outdir) / '_reference_media' / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(Path(app.srcdir) / relative, destination)


def setup(app):
    app.add_directive('codea-example', ExampleDirective)
    app.add_directive('codea-media', MediaDirective)
    app.connect('build-finished', copy_html_videos)
    return {'parallel_read_safe': False}
