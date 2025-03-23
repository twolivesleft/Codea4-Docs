graphics commands
=================

*(global)*

Background
##########

.. lua:function:: background(<color>)

   Clears the current context with solid color, can also be used to set image backgrounds when combined with :lua:func:`context.push`

   .. helptext:: set the background color, image or shader

.. lua:function:: background(cubeImage, [mipLevel = 0])

   Clears the current background with the contents of a cube image, using the current camera settings to define eye direction

   :param cubeImage: The image to clear the background with
   :param mipLevel: The mip level of the image to use, useful for displaying pre-blurred image mips, such as those calculated using :lua:meth:`image.generateIrradiance`

.. lua:function:: background(shader)

   Clears the current background using a custom shader

   .. collapse:: Example

      .. literalinclude:: /code/Background Shader.codea/Main.lua
         :language: lua

Vector Graphics
###############

A set of graphics functions which are so commonly used they are in the global namespace for convenience

.. lua:function:: line(x1, y1, x2, y2)

   Draws 2D line from the start point (x1, y1) to the end point (x2, y2) based on the current style:

   - *Color* with :lua:func:`style.stroke`
   - *Width* with :lua:func:`style.strokeWidth`
   - *End Caps* with :lua:func:`style.lineCapMode`
      - |square_cap| :lua:attr:`SQUARE`
      - |project_cap| :lua:attr:`PROJECT`
      - |round_cap| :lua:attr:`ROUND`

   .. |square_cap| image:: /images/example_lineCap_SQUARE.png
      :width: 100

   .. |round_cap| image:: /images/example_lineCap_ROUND.png
      :width: 100

   .. |project_cap| image:: /images/example_lineCap_PROJECT.png
      :width: 100

.. lua:function:: line(x, y)

   Variation of line command used as part of shape drawing

.. lua:function:: polyline(x1, y1, x2, y2, ... xn, yn)

   Draws a continuous 2D line with an arbitrary number of points (x1, y1, etc...) based on the current style

   - *Color* with :lua:func:`style.stroke`
   - *Width* with :lua:func:`style.strokeWidth`
   - *End Caps* with :lua:func:`style.lineCap`
   - *Line Joins* with :lua:func:`style.lineJoin`
      - |round_join| :lua:attr:`ROUND`
      - |miter_join| :lua:attr:`MITER`
      - |bevel_join| :lua:attr:`BEVEL`

   .. |round_join| image:: /images/example_lineJoin_ROUND.png
      :width: 100

   .. |miter_join| image:: /images/example_lineJoin_MITER.png
      :width: 100

   .. |bevel_join| image:: /images/example_lineJoin_BEVEL.png
      :width: 100

.. lua:function:: polygon(x1, y1, x2, y2, ... xn, yn)

   Draws a closed 2D polygon with an arbitrary number of points based on the current style

.. lua:function:: bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2)

   Draw a quadratic bezier curve using four points based on the current style

.. lua:function:: bezier(cx1, cy1, cx2, cy2, x2, y2)

   Variation of bezier command used as part of shape drawing

.. lua:function:: arc(x, y, radius, startAngle, endAngle, dir)

   Draws a 2D arc with a given origin, radius and start, end angles + direction

   :param x: x coordinate of the arc origin
   :param y: y coordinate of the arc origin
   :param radius: the radius arc
   :param startAngle: the start angle of the arc (in degrees)
   :param endAngle: the end angle of the arc (in degrees)
   :param dir: the direction of the arc, 1 or clockwise, -1 for anti-clockwise

.. lua:function:: ellipse(x, y, w, h)
                  ellipse(x, y, r)

   Draw an ellipse with a given origin point and width / height (or radius)

.. lua:function:: rect(x, y, w, h)
                  rect(x, y, w, h, r)
                  rect(x, y, w, h, r1, r2, r3, r4)

   Draws a rectangle with a given origin point and width / height, origin and sizing behaviour depends on :lua:func:`style.shapeMode`

   Additional arguments allow for rounded corners (either all one radius or four separate radii)

Sprites
#######

.. lua:function:: sprite(image, x, y, [w, h])
                  sprite(asset.key, x, y, [w, h])
                  sprite(sprite.slice, x, y, [w, h])

   Draws a sprite using a an asset - :lua:class:`image`, :lua:class:`asset.key` or :lua:class:`sprite.slice`


.. lua:function:: sprite(shader, x, y, w, h)


Text
####

.. lua:function:: text(str, x, y, [w, h])

   Draws one or more lines of text based on the current style. Use the optional width and height parameters to draw a fixed size text box with line wrapping enabled

   - *Text Color* with :lua:func:`style.fill`
   - *Text Outline* with :lua:func:`style.stroke`
   - *Text Outline Thickness* with :lua:func:`style.strokeWidth`
   - *Text Alignment* with :lua:func:`style.textAlign`
      - ``LEFT``
      - ``CENTER``
      - ``RIGHT``
      - ``TOP``
      - ``MIDDLE``
      - ``BOTTOM``
   - *Text Style* with :lua:func:`style.textStyle`
      - ``TEXT_NORMAL``

        - Renders the text normally

      - ``TEXT_BACKGROUND``

        - Renders a rectangle behind the text using the background color

      - ``TEXT_UNDERLINE``

        - Renders a line below the text
        
      - ``TEXT_OVERLINE``

        - Renders a line above the text

      - ``TEXT_STRIKE_THROUGH``

        - Renders a line through the text

      - ``TEXT_BOLD``

        - Renders the text in bold

      - ``TEXT_ITALICS``

        - Renders the text in italics

      - ``TEXT_RICH``

        - Enables rich text, which parses xml tags within the supplied string to format individual characters.

      - ``TEXT_UPPERCASE``

        - Renders all text in uppercase

      - ``TEXT_LOWERCASE``

        - Renders all text in lowercase

      - ``TEXT_NATIVE``

        - Enables native text rendering, which uses the system font renderer to draw text and supports emojis. Note that other text styles are disabled while using the native renderer.

   **Built-In Tags**

   *Bold and Italic*

   .. epigraph::

      The <i>quick brown fox</i> jumps over the <b>lazy dog</b>.

      .. image:: /images/example_richText_bold_italic.png
         :width: 512

   *Custom Tags*

   Custom tags can assigned using a callback function - ``text.style.myCustomTag = function(tag, format) ... end``

   The ``tag`` parameter gives access to custom xml tag attributes

   The ``format`` parameter gives access to text formatting options that can be adjusted per tag, derived from text styles in the ``style`` module

   - ``textAlign``
   - ``textStyle``
   - ``fontSize``
   - ``fontName``
   - ``fillColor``
   - ``strokeColor``
   - ``strokeWidth``
   - ``textOverline``
   - ``textUnderline``
   - ``textStrikeThrough``
   - ``textBackground``
   - ``textShadow``
   - ``textShadowOffset``
   - ``textShadowSoftner``
   - ``callback``

   The additional parameter ``callback`` is a special function used to modify individual glyphs (characters) when the text is rendered. The callback function has the following parameters:

   - ``str`` - the string being drawn
   - ``index`` - the index of the current glyph in the string
   - ``mod`` - a reference to a glyphModifier object, used to modify the current glyph

   A ``glyphModifier`` has the follwing properties:

   - ``offsetX`` - the amount to offset the glyphs x position in pixels
   - ``offsetY`` - the amount to offset the glyphs y position in pixels
   - ``alpha`` - the alpha of the current glyph (0-255)
   - ``color`` - the color the of the current glyph

   .. collapse:: Example

      .. literalinclude:: /code/Example_text_glyph_callback.codea/Main.lua
         :language: lua

   :param x: the x coordinate of the text
   :param y: the x coordinate of the text
   :param w: optional width of the text box
   :param h: optional height of the text box
   :param callback: a special glyph modifier callback

Gizmos
######

Gizmos are useful for drawing shapes in 2D/3D space for debugging and editing

.. lua:module:: gizmos

.. lua:function:: line(x1, y1, z1, x2, y2, z2)

   Draws a 3D antialiased line

Contexts
########

.. lua:module:: context

.. lua:function:: push(image, [layer = 0, mip = 0])

   Pushes an :lua:class:`image` to the context, causing subsequent drawing operations to be applied to said image until :lua:func:`context.pop` is called

   :param image: The image to push
   :param layer: The layer of image to draw to
   :param mip: The mip of the image to draw to

.. lua:function:: pop

   Pops the current image from the context if one exists, subsequent drawing operations are again applied to the main context (i.e. the display)
