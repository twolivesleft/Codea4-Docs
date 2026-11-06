Drawing
=======

Drawing in Codea
----------------

Codea can draw 2D and 3D graphics.

The :lua:`draw()` function is called once per frame to draw the contents of the screen.

The :lua:`background(r,g,b,a)` function clears the background with a given color. You typically call this once at the start of ``draw()``. When it isn't called, the contents of the background stay the same as the previous frame.

Draw other elements with functions such as :lua:`line()`, :lua:`sprite()` and :lua:`rect()`.

These functions use the current drawing style, which affects things like fill color, stroke color, and stroke width.

Try it: an animated circle
--------------------------

This project draws a circle that moves back and forth across the screen. We use
elapsed time to calculate the position of the circle.

.. codea-example:: Animated circle

   function setup()
   end

   function draw()
       background(24, 28, 38)
       style.fill(100, 220, 200).noStroke()
       local x = WIDTH * (0.5 + 0.25 * math.sin(time.elapsed))
       ellipse(x, HEIGHT / 2, 80, 80)
   end


.. codea-media:: videos/animated-circle.mp4
   :type: video
   :playback: preview
   :alt: A mint circle moving horizontally on a dark background
   :caption: The animated circle example running. Press Run Example above to run it yourself.

Style
-----

The ``style`` module contains functions that set the drawing state.

You can chain multiple style commands together:

.. code-block:: lua

   -- Draw a red ellipse with a 5px white stroke
   style.push().fill(color.red).stroke(color.white).strokeWidth(5)
   ellipse(WIDTH/2, HEIGHT/2, 100, 100)
   style.pop()

See :doc:`Style </api/style>` for the complete reference.

Anywhere a color is used as a parameter, you can use the following forms:

.. code-block:: lua

   style.func(r, g, b, a) -- separate color components in the range 0-255
   style.func(r, g, b) -- only red, green, blue color components with alpha assumed to be 255
   style.func(grey, alpha) -- only greyscale and alpha
   style.func(grey) -- only grayscale with alpha assumed to be 255
   style.func(color) -- a color object

Matrix
------

Use ``matrix`` to move, rotate, and scale your drawings. Its view and projection matrices control where the camera looks and how a 3D scene appears on screen. You can also use a :lua:class:`camera` to manage these settings.

Matrix commands can be chained too. Use ``push()`` to save the current matrices and ``pop()`` to restore them after drawing:

.. code-block:: lua

   -- Translate then rotate in one expression
   matrix.push().translate(100, 100).rotate(45)
   rect(0, 0, 50, 50)
   matrix.pop()

See :doc:`/api/matrix` for a complete reference

3D Drawing
----------

To draw in 3D, switch from the default 2D orthographic projection to a perspective projection using :lua:func:`matrix.perspective`. Always wrap 3D drawing in a :lua:func:`matrix.push` / :lua:func:`matrix.pop` pair so the 2D projection is restored afterwards.

.. important::

   With :lua:func:`matrix.perspective`, the camera sits at the origin and looks toward **+Z**. Objects must have a **positive Z coordinate** to be visible. Use :lua:func:`matrix.translate` to move objects in front of the camera.

.. code-block:: lua

   function draw()
       background(20, 20, 30)

       -- All 3D drawing goes inside a matrix.push/pop block
       matrix.push()
           matrix.perspective(60)          -- 60° field of view
           matrix.translate(0, 0, 5)       -- move object 5 units forward (+Z)
           matrix.rotate(angle, 0, 1, 0)   -- spin around Y axis
           myMesh:draw()
       matrix.pop()

       -- 2D drawing after matrix.pop() uses the default screen projection
       text("Hello", WIDTH/2, 40)
   end

To position the camera elsewhere in the scene, set a custom view matrix using :lua:func:`matrix.view` together with :lua:func:`mat4.orbit`:

.. code-block:: lua

   matrix.push()
       matrix.perspective(60)
       -- Orbit camera: looking at origin from distance 8, tilted 20° up and 45° around Y
       matrix.view(mat4.orbit(vec3(0, 0, 0), 8, 20, 45))
       myMesh:draw()
   matrix.pop()

Background
----------

:lua:func:`background` clears the screen each frame with a solid color (or image/shader):

.. code-block:: lua

   background(0, 0, 0)        -- black
   background(40, 40, 50)     -- dark blue-grey
   background(color.white)    -- using a color object

See :doc:`/api/graphics` for full documentation

Vector Drawing
--------------

Draw lines and shapes using the current :doc:`/api/style` settings:

.. code-block:: lua

   -- Lines
   style.push().stroke(255, 0, 0).strokeWidth(4)
   line(100, 100, 400, 300)
   style.pop()

   -- Shapes
   style.push().fill(0, 128, 255).stroke(255).strokeWidth(2)
   rect(WIDTH/2, HEIGHT/2, 200, 100)       -- centered rectangle
   ellipse(WIDTH/2, HEIGHT/2, 150, 150)    -- circle
   style.pop()

   -- Polygon
   style.push().fill(255, 200, 0)
   polygon(200,100, 300,200, 250,300, 150,300, 100,200)
   style.pop()

See :doc:`/api/graphics` for a complete list of vector drawing functions

Text
----

Draw text on the screen with :lua:func:`text`, followed by its horizontal and vertical
position. Put the call in ``draw()`` so the message appears every frame:

.. code-block:: lua

   function draw()
       background(30)
       text("Hello, Codea!", WIDTH/2, HEIGHT/2)
   end

The bottom-left corner of the screen is ``(0, 0)``. Increase ``x`` to move text to
the right, or ``y`` to move it up. ``WIDTH/2, HEIGHT/2`` is the center of the screen.

**Size, color, and font**

Set these before drawing your text. The following examples belong inside
``draw()`` too:

.. code-block:: lua

   style.fontSize(40)
   style.fill(255, 210, 80)
   style.font("Arial-BoldMT")
   text("You win! 🎉", WIDTH/2, HEIGHT/2)

Use ``fontSize`` to control the size in points, ``fill`` to set the color, and ``font``
to choose a font face.

**Positioning and multiple lines**

Use ``style.textMode`` to choose which part of a message sits at the coordinates
you give to ``text``. ``CORNER`` places the lower-left corner there, which is handy
for a score near the edge of the screen:

.. code-block:: lua

   style.fontSize(32)
   style.textMode(CORNER)
   text("Score: 120", 40, 40)

``CENTER`` places the center of the whole message at that point:

.. code-block:: lua

   style.textMode(CENTER)
   text("Level complete!", WIDTH/2, HEIGHT/2)

To center your text at a point, set both horizontal and vertical alignment:

.. code-block:: lua

   style.fontSize(32)
   style.textAlign(CENTER | MIDDLE)
   text("Level complete!\nTap to continue", WIDTH/2, HEIGHT/2)

Use ``\n`` to start a new line. For a longer message, pass a width to ``text()`` to wrap it:

.. code-block:: lua

   text("Explore the island and find three hidden keys before sunset.",
        40, HEIGHT/2, WIDTH - 80)

You can also supply a height to align text within a box. See
:lua:func:`style.textAlign` for the available alignments and their positioning rules.

**Measuring text**

Use :lua:func:`textSize` when you need to leave room for a label or place another
message below it. Set the font and size before measuring, just as you would before
drawing:

.. code-block:: lua

   style.fontSize(32)
   style.textAlign(CENTER | MIDDLE)
   local message = "Score: 120"
   local width, height = textSize(message)
   text(message, WIDTH/2, HEIGHT/2)
   text("Best: 200", WIDTH/2, HEIGHT/2 - height - 12)

For wrapped text, pass the same width to ``textSize`` and ``text``.

To align different fonts along the same baseline, use :lua:func:`font.metrics`.
It returns measurements such as ascent, descent, and capital-letter height for
the current font and size. These describe the font rather than a particular
message.

**Making text stand out**

A shadow helps a label remain readable over a busy background:

.. code-block:: lua

   style.fontSize(40)
   style.fill(255)
   style.textShadow(color(0, 0, 0, 180), vec2(2, -2), 3)
   text("Ready?", WIDTH/2, HEIGHT/2)

The color controls its tint and opacity, ``offset`` moves it relative to the text,
and ``radius`` controls the blur. A radius of zero gives a sharp shadow.
Use ``style.noTextShadow()`` to turn the shadow off. To change the appearance of
just one label, surround its settings and drawing calls with ``style.push()`` and
``style.pop()``. That restores the settings used by the rest of your drawing.
Text settings reset each frame, so keep them inside ``draw()``.

**Formatting parts of a message**

Tags let you make individual words bold, italic, or a different color. You must use the atlas text renderer by calling
``style.textRenderer(style.atlas)`` before drawing tagged text:

.. code-block:: lua

   style.push()
   style.textRenderer(style.atlas)
   style.fontSize(32)
   text('Find the <b>key</b> to open the <fill color="red">red door</fill>.',
        WIDTH/2, HEIGHT/2)
   style.pop()

``<b>...</b>`` makes a span bold, ``<i>...</i>`` makes it italic, and
``<fill color="red">...</fill>`` changes its color. Close each tag after the words
it should affect. Atlas text also supports decorations such as underlines:

.. code-block:: lua

   style.push()
   style.textRenderer(style.atlas)
   style.textUnderline(255)
   text("Next chapter", WIDTH/2, HEIGHT/2)
   style.pop()

A decoration's color enables it; set its alpha to zero to turn it off, for example
``style.textUnderline(255, 0)``.

**Animating letters**

When using atlas text, you can define your own tags for effects such as waving letters. Register the tag
in ``setup()``, then use it in the text you draw:

.. code-block:: lua

   function setup()
       text.style.wave = function(tag, format)
           format.callback = function(str, index, letter)
               letter.offsetY = math.sin(time.elapsed * 5 + index) * 6
           end
       end
   end

   function draw()
       background(30)
       style.fontSize(40)
       style.textRenderer(style.atlas)
       text("<wave>Hello!</wave>", WIDTH/2, HEIGHT/2)
   end

The callback adjusts each letter's position. You can also change its color or
opacity. See :lua:attr:`text.style` for custom tags and :lua:class:`glyphModifier`
for the per-letter controls.

**Choosing native or atlas text**

Most labels, scores, paragraphs, and emoji can use the default, ``style.native``.
Choose ``style.atlas`` when you want tags, underlines, or animated-letter effects.
Atlas text does not support color emoji, so keep emoji labels on native rendering.

Use ``style.textRenderer(style.native)`` to switch back. You can mix both in a frame;
``style.push()`` and ``style.pop()`` are useful for keeping each label's settings
local. Remember that your style and renderer choices apply to ``textSize``, so measure and draw with the same
settings.

See :doc:`/api/style` for individual text settings and :doc:`/api/graphics` for
drawing, measurement, and custom effects.

Images and Sprites
------------------

Images are loaded with :lua:meth:`image.read` and drawn with :lua:func:`sprite`:

.. code-block:: lua

   function setup()
       img = image.read(asset.builtin.Blocks.Brick)
   end

   function draw()
       background(0)
       sprite(img, WIDTH/2, HEIGHT/2, 200, 200)
   end

Context
-------

The context module lets you draw into an image instead of the screen, using :lua:func:`context.push` and :lua:func:`context.pop`:

.. code-block:: lua

   local target = image(512, 512)

   context.push(target)
       background(0)
       style.push().fill(255, 0, 0)
       ellipse(256, 256, 200, 200)
       style.pop()
   context.pop()

   -- Now draw that image to screen
   sprite(target, WIDTH/2, HEIGHT/2)

Meshes
------

Use a :lua:class:`mesh` to draw 3D objects or custom 2D shapes. Start with a built-in shape or define your own vertices.

**Built-in mesh generators**

.. code-block:: lua

   sphereMesh   = mesh.sphere(1)          -- sphere, radius 1
   boxMesh      = mesh.box(vec3(1,1,1))   -- box, 1×1×1
   cylinderMesh = mesh.cylinder(0.5, 1)   -- radius 0.5, height 1
   torusMesh    = mesh.torus(0.25, 1)     -- torus

**Drawing a mesh in 3D**

.. code-block:: lua

   function setup()
       sphereMesh = mesh.sphere(1)
       angle = 0
   end

   function draw()
       background(20, 20, 30)
       angle = angle + 0.5

       matrix.push()
           matrix.perspective(60)
           matrix.translate(0, 0, 4)
           matrix.rotate(angle, 0, 1, 0)
           sphereMesh:draw()
       matrix.pop()
   end

**Building a mesh from vertices**

Set :lua:attr:`mesh.vertices` to draw a triangle for each group of three vertices. This also creates the indices that connect them. Use :lua:attr:`mesh.positions` when changing an existing shape while keeping its triangle connections:

.. code-block:: lua

   -- Each group of three vertices forms a triangle
   m = mesh()
   m.vertices = { vec3(0,0,0), vec3(1,0,0), vec3(0.5,1,0) }  -- one triangle
   m.colors   = { color(255,0,0), color(0,255,0), color(0,0,255) }
   m:draw()

   -- Use positions only to deform an existing mesh (preserves its index buffer)
   sph = mesh.sphere(1)
   -- modify sph.positions each frame to animate without breaking sphere indices

**Complete example: Rotating RGB Cube**

.. collapse:: Example

   .. literalinclude:: /code/RGB Cube.codea/Main.lua
      :language: lua

Shaders and Materials
---------------------

Both shaders and materials can be applied to a mesh to control how it is rendered. See :doc:`/api/shader`, :doc:`/api/material` and :doc:`shaders` for details.

Lighting
--------

Codea supports dynamic lighting via :doc:`/api/light`. Generated meshes (``mesh.sphere()``, ``mesh.box()``, etc.) use a lit material by default, so without any lights they render black. There are two ways to make them visible:

**Option 1: Unlit material with a color** (no light needed):

.. code-block:: lua

   sph = mesh.sphere(1)
   sph.material = material.unlit()
   sph.material.color = color(100, 180, 255)

**Option 2: Lit material with a directional light** (produces 3D shading):

.. code-block:: lua

   function setup()
       sph = mesh.sphere(1)
       sph.material = material.lit()
       sph.material.color = color(100, 180, 255)

       dirLight = light.directional(vec3(1, -1, 1))
       dirLight.intensity = 2
   end

   function draw()
       background(20, 20, 30)
       matrix.push()
           matrix.perspective(60)
           light.push(dirLight)
           matrix.translate(0, 0, 4)
           sph:draw()
           light.pop()
       matrix.pop()
   end

.. note::

   When drawing meshes directly, only ``light.directional()`` is supported. Point and spot lights are not supported for this kind of drawing.

.. collapse:: Full sphere example

   .. literalinclude:: /code/Sphere 3D.codea/Main.lua
      :language: lua

Drawing shapes and changing style
---------------------------------

Each row draws a shape with its default style, a colored fill, and a white outline. ``style.reset()`` restores the defaults. Try changing the last four ``rect()`` arguments to round each corner differently.

.. codea-example:: Drawing shapes and changing style
   :project: code/Modern/Basics 02 - Shapes.codea

Building an orbit with nested transforms
----------------------------------------

Satellites orbit a moving center while moons orbit each satellite. Each ``matrix.push()`` is paired with ``matrix.pop()``, so moving one moon does not move the next satellite. Try changing the orbit radii or the number of moons.

.. codea-example:: Building an orbit with nested transforms
   :project: code/Modern/Basics 03 - Matrix.codea

Comparing blend modes
---------------------

Choose a blend mode or change either color in **Controls** to see how overlapping colors combine. Drawing order matters: the second circle blends over the first. The images below the circles show how blending works with pictures.

.. codea-example:: Comparing blend modes
   :project: code/Modern/Basics 07 - Blending.codea

Saving and restoring styles
---------------------------

These swatches share three saved styles: foreground, background, and label. ``style.get()`` saves the settings and ``style.set()`` restores them. Change one saved style to update every swatch.

.. codea-example:: Saving and restoring styles
   :project: code/Modern/Basics 09 - Colors.codea

Interpolating vertex colors
---------------------------

Three vertices define a triangle, with a color at each corner. Codea blends these colors across its surface. Change its size in **Controls** and watch it rotate.

.. codea-example:: Interpolating vertex colors
   :project: code/Modern/Mesh 01 - Triangle.codea

Turning a polygon into triangles
--------------------------------

Tap around an outline without crossing its edges. ``mesh.triangulate()`` divides the polygon into triangles so it can be drawn as a filled shape.

.. codea-example:: Turning a polygon into triangles
   :project: code/Modern/Mesh 02 - Triangulate.codea
