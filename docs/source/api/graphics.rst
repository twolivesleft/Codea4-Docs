graphics commands
=================

*(global)*

Background
##########

.. lua:function:: background(red, green, blue, alpha)

   Clears the current context with solid color, can also be used to set image backgrounds when combined with :lua:func:`context.push`

   :param red: The red component of the color (0-255)
   :type red: number
   :param green: The green component of the color (0-255)
   :type green: number
   :param blue: The blue component of the color (0-255)
   :type blue: number
   :param alpha: The alpha component of the color (0-255)
   :type alpha: number

   .. helptext:: set the background color
   .. editor:: color

.. lua:function:: background(color)

   Clears the current context with solid color, can also be used to set image backgrounds when combined with :lua:func:`context.push`

   :param color: The color to set the background to
   :type color: color

   .. helptext:: set the background color
   .. editor:: color      

.. lua:function:: background(cubeImage, [mipLevel = 0])

   Clears the current background with the contents of a cube image, using the current camera settings to define eye direction

   .. helptext:: clear the background with a cube image

   :param cubeImage: The image to clear the background with
   :type cubeImage: image
   :param mipLevel: The mip level of the image to use, useful for displaying pre-blurred image mips, such as those calculated using :lua:meth:`image.generateIrradiance`
   :type mipLevel: number

.. lua:function:: background(shader)

   Clears the current background using a custom shader

   :param shader: The shader to use when clearing the background, should be a shader that is compatible with sprite rendering (i.e. uses the same vertex attributes)
   :type shader: shader

   .. helptext:: clear the background with a shader

   .. collapse:: Example

      .. literalinclude:: /code/Background Shader.codea/Main.lua
         :language: lua

Vector Graphics
###############

A set of graphics functions which are so commonly used they are in the global namespace for convenience

.. lua:function:: line(x1, y1, x2, y2)

   Draws 2D line from the start point (x1, y1) to the end point (x2, y2) based on the current style:

   :param x1: the x coordinate of the start point
   :type x1: number
   :param y1: the y coordinate of the start point
   :type y1: number
   :param x2: the x coordinate of the end point
   :type x2: number
   :param y2: the y coordinate of the end point
   :type y2: number

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

   .. helptext:: draw a line between two points

.. lua:function:: line(x, y)

   Adds a straight segment from the last point to (x, y), when called inside :lua:func:`shape`

   .. helptext:: draw a line between two points

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

   .. helptext:: draw a continuous polyline

.. lua:function:: polygon(x1, y1, x2, y2, ... xn, yn)

   Draws a closed 2D polygon with an arbitrary number of points based on the current style

   .. helptext:: draw a closed polygon

.. lua:function:: bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2)

   Draw a quadratic bezier curve using four points based on the current style

   .. helptext:: draw a cubic bezier curve

.. lua:function:: bezier(cx1, cy1, cx2, cy2, x2, y2)

   Adds a curved segment from the last point to (x2, y2), when called inside :lua:func:`shape`

   .. helptext:: draw a bezier curve segment

.. lua:function:: shape(x, y, [closed = true], func)

   Draws a shape from a path that starts at (x, y) and is built by the drawing commands called inside ``func``. The shape is filled and outlined using the current style

   Inside ``func``, use :lua:func:`line(x, y) <line>` and :lua:func:`bezier(cx1, cy1, cx2, cy2, x2, y2) <bezier>` to add segments from the last point. Commands such as :lua:func:`rect` and :lua:func:`ellipse` add separate outlines to the shape. An outline inside another one cuts a hole in it

   :param x: the x coordinate of the first point
   :type x: number
   :param y: the y coordinate of the first point
   :type y: number
   :param closed: whether to join the last point back to the first and fill the shape. An open shape is only outlined
   :type closed: boolean
   :param func: a function that builds the shape
   :type func: function

   .. code-block:: lua
      :caption: A speech bubble with a hole

      function draw()
          background(40, 40, 50)
          style.fill(255, 200, 50).stroke(220, 120, 30).strokeWidth(4)

          shape(200, 300, function()
              -- The tail
              line(250, 300)
              line(220, 230)
              line(300, 300)

              line(500, 300)
              bezier(560, 300, 560, 450, 500, 450)
              line(200, 450)
              bezier(140, 450, 140, 300, 200, 300)

              -- This outline cuts a hole in the bubble
              ellipse(350, 375, 60, 60)
          end)
      end

   .. image:: /images/example_shape.png
      :width: 300

   .. helptext:: draw a shape from lines and curves

.. lua:function:: arc(x, y, radius, startAngle, endAngle, dir)

   Draws a 2D arc with a given origin, radius and start, end angles + direction

   :param x: x coordinate of the arc origin
   :type x: number
   :param y: y coordinate of the arc origin
   :type y: number
   :param radius: the radius arc
   :type radius: number
   :param startAngle: the start angle of the arc (in degrees)
   :type startAngle: number
   :param endAngle: the end angle of the arc (in degrees)
   :type endAngle: number
   :param dir: the direction of the arc, 1 or clockwise, -1 for anti-clockwise
   :type dir: integer

   .. helptext:: draw a 2D arc

.. lua:function:: ellipse(x, y, w, h)
                  ellipse(x, y, r)

   Draw an ellipse with a given origin point and width / height (or radius)

   .. helptext:: draw a circle or oval

.. lua:function:: rect(x, y, w, h, [radius = 0])

   Draws a rectangle with a given origin point and width / height, origin and sizing behaviour depends on :lua:func:`style.shapeMode`

   Optional parameter ``radius`` specified the corner radius

   :param x: the x coordinate of the rectangle
   :type x: number
   :param y: the y coordinate of the rectangle
   :type y: number
   :param w: the width of the rectangle
   :type w: number
   :param h: the height of the rectangle
   :type h: number
   :param radius: the radius of the rounded corners
   :type radius: number

   .. helptext:: draw a rectangle

.. lua:function:: rect(x, y, w, h, r1, r2, r3, r4)

   Draws a rectangle with a given origin point and width / height, origin and sizing behaviour depends on :lua:func:`style.shapeMode`

   The corner radius of each corner can be set independently using the additional parameters r1, r2, r3 and r4

   :param x: the x coordinate of the rectangle
   :type x: number
   :param y: the y coordinate of the rectangle
   :type y: number
   :param w: the width of the rectangle
   :type w: number
   :param h: the height of the rectangle
   :type h: number
   :param r1: the radius of the top-left corner
   :type r1: number
   :param r2: the radius of the top-right corner
   :type r2: number
   :param r3: the radius of the bottom-right corner
   :type r3: number
   :param r4: the radius of the bottom-left corner
   :type r4: number

   .. helptext:: draw a rectangle with rounded corners      


Sprites
#######

.. lua:function:: sprite(image, x, y, [w, h])
                  sprite(asset.key, x, y, [w, h])
                  sprite(sprite.slice, x, y, [w, h])

   Draws a sprite using an asset - :lua:class:`image`, :lua:class:`asset.key` or :lua:class:`sprite.slice`

   .. helptext:: draw a sprite or image
   .. editor:: sprite


.. lua:function:: sprite(shader, x, y, w, h)

   .. helptext:: draw using a shader
   .. editor:: shader


Text
####

.. lua:currentmodule:: None

.. lua:function:: text(str, x, y[, w, h])

   Draws text at ``x, y``. Call it inside ``draw()`` to show the text every frame.
   Set :lua:func:`style.fontSize`, :lua:func:`style.font`, and :lua:func:`style.fill`
   before drawing to choose its size, font, and color. Emoji work by default.

   Use ``\n`` for a new line, or supply ``w`` to wrap a longer message. Add ``h``
   to align the text within a box using :lua:func:`style.textAlign`. The box controls
   layout; it does not clip text that extends beyond it. Numbers and other values
   are converted to strings.

   .. code-block:: lua

      style.fontSize(32)
      style.fill(255)
      text("Score: 120", WIDTH/2, HEIGHT/2)

   .. helptext:: draw text at a location
   .. editor:: text

   See :doc:`/manual/drawing` for positioning, wrapping, shadows, and tagged-text
   examples. For advanced per-letter effects, see :lua:attr:`text.style`.

   :param str: The value to draw (converted to a string).
   :type str: any
   :param x: The x coordinate of the text.
   :type x: number
   :param y: The y coordinate of the text.
   :type y: number
   :param w: Optional wrapping width in points; zero means unbounded.
   :type w: number
   :param h: Optional box height in points; zero means unbounded.
   :type h: number

.. lua:function:: textSize(str[, width])

   Measures text in points so you can reserve space for it or position nearby
   content. Set the same font, size, and other text settings that you will use
   when drawing. Supply ``width`` when measuring wrapped text.

   The returned size does not depend on paragraph alignment. If you use
   ``textWrapWidth``, that width applies when no explicit width is supplied.

   .. helptext:: get the width and height of the drawn string

   :param str: the text to query
   :type str: string
   :param width: the width of the textbox
   :type width: number
   :return: The ``width`` and ``height`` of the text
   :rtype: number, number


.. lua:function:: textRenderer(renderer)

   Alias of :lua:func:`style.textRenderer`. Use ``style.native`` for everyday text
   and emoji, or ``style.atlas`` for tags, decorations, and animated letters.
   Set this before drawing and measuring text.

   .. helptext:: select native or atlas text rendering

   :param renderer: ``style.native`` or ``style.atlas``.
   :type renderer: enum
   :returns: The style table, for chaining.
   :rtype: style

.. lua:function:: textRenderer()

   Alias of :lua:func:`style.textRenderer`. Gets the current text renderer.

   .. helptext:: get the current text renderer

   :returns: ``style.native`` or ``style.atlas``.
   :rtype: enum

.. lua:function:: textLineHeight()

   Gets the atlas font line height. This currently uses atlas metrics even when
   ``style.native`` is selected. For native measurements, use :lua:func:`textSize`.

   .. helptext:: get the atlas font line height

   :return: The line height, or zero if the atlas font cannot be loaded.
   :rtype: number

.. lua:function:: textBounds(str, x, y)

   Reserved API. Currently returns four zeros; bounds calculation is not implemented.
   Use :lua:func:`textSize` for working width and height measurements.

   .. helptext:: reserved text bounds query

   :param str: The text to query.
   :type str: string
   :param x: The draw x coordinate.
   :type x: number
   :param y: The draw y coordinate.
   :type y: number
   :return: Four zeros (not implemented).
   :rtype: number, number, number, number

.. lua:function:: glyphBounds(str, x, y, index)

   Reserved API. Currently returns four zeros; glyph bounds calculation is not implemented.

   .. helptext:: reserved glyph bounds query

   :param str: The text to query.
   :type str: string
   :param x: The draw x coordinate.
   :type x: number
   :param y: The draw y coordinate.
   :type y: number
   :param index: The one-based glyph index.
   :type index: integer
   :return: Four zeros (not implemented).
   :rtype: number, number, number, number

.. lua:attribute:: text.style: table

   Defines reusable formatting and animation effects for tagged text. Register
   your tags in ``setup()``. For example, give warning messages a consistent color:

   .. code-block:: lua

      text.style.warning = function(tag, format)
          format.fillColor = color(255, 180, 40)
          format.fontName = "Helvetica-Bold"
      end

   Then use the tag when drawing:

   .. code-block:: lua

      style.textRenderer(style.atlas)
      text("<warning>Low fuel!</warning>", WIDTH/2, HEIGHT/2)

   Each handler receives ``tag``, ``format``, and an optional ``index`` argument.
   Read custom tag attributes through :lua:class:`textTag`, and change the span's
   appearance through :lua:class:`textFormatting`. ``index`` is the zero-based
   text index. Handlers are registered by assignment; the table does not return
   previously registered handlers.

   To animate individual letters, assign a function to ``format.callback``.
   It receives the text, a one-based glyph index, and a :lua:class:`glyphModifier`.
   Adjust the modifier's position, color, or opacity to make letters wave, shake,
   or appear gradually. See :doc:`/manual/drawing` for a short wave example, or
   explore the combined effects below.

   .. collapse:: Example: waving, shaking, and revealing text

      .. literalinclude:: /code/Example_text_glyph_callback.codea/Main.lua
         :language: lua

   .. helptext:: register custom rich-text tag handlers

.. lua:class:: textTag

   A tag supplied to a rich-text callback. Created by the renderer; no constructor.

   .. lua:method:: number(name, default)

      Reads a numeric XML attribute, returning the default if it is missing or invalid.

      .. helptext:: get a numeric tag attribute

      :param name: The attribute name.
      :type name: string
      :param default: The fallback value.
      :type default: number
      :return: The attribute value or fallback.
      :rtype: number

.. lua:class:: textFormatting

   Mutable formatting supplied to a rich-text tag callback. Created by the renderer;
   no constructor. Color values use :lua:class:`color` objects.

   .. lua:attribute:: textAlign: integer

      Text alignment flags.

      .. helptext:: get or set textAlign

   .. lua:attribute:: fontSize: number

      Font size in points.

      .. helptext:: get or set fontSize

   .. lua:attribute:: fontName: string

      Font name.

      .. helptext:: get or set fontName

   .. lua:attribute:: fillColor: color

      Text fill color.

      .. helptext:: get or set fillColor

   .. lua:attribute:: strokeColor: color

      Text outline color.

      .. helptext:: get or set strokeColor

   .. lua:attribute:: strokeWidth: number

      Text outline width.

      .. helptext:: get or set strokeWidth

   .. lua:attribute:: textOverline: color

      Overline color.

      A nonzero alpha enables this decoration; zero disables it. The default is transparent.

      .. helptext:: get or set textOverline

   .. lua:attribute:: textUnderline: color

      Underline color.

      A nonzero alpha enables this decoration; zero disables it. The default is transparent.

      .. helptext:: get or set textUnderline

   .. lua:attribute:: textStrikeThrough: color

      Strikethrough color.

      A nonzero alpha enables this decoration; zero disables it. The default is transparent.

      .. helptext:: get or set textStrikeThrough

   .. lua:attribute:: textBackground: color

      Background color.

      A nonzero alpha enables this decoration; zero disables it. The default is transparent.

      .. helptext:: get or set textBackground

   .. lua:method:: textShadow(color, offset, radius)

      Adds a shadow to this tagged span.

      Set the color, offset, and radius together. A transparent color disables the
      shadow. The default is no shadow. Shadows do not change text measurements.

      .. code-block:: lua

         format:textShadow(color(0, 0, 0, 160), vec2(2, -2), 4)

      .. helptext:: set text shadow color, offset, and blur radius
      .. editor:: color

      :param color: The shadow color, including opacity.
      :type color: color
      :param offset: The shadow displacement in points. Positive x moves right; positive y moves up.
      :type offset: vec2
      :param radius: The blur radius in points. Zero gives a sharp shadow; must be non-negative.
      :type radius: number
      :returns: The formatting object, for chaining.
      :rtype: textFormatting

   .. lua:method:: textShadow()

      Gets the shadow color, offset, and radius. A disabled shadow returns a
      transparent color while retaining its offset and radius.

      .. helptext:: get text shadow color, offset, and blur radius

      :returns: The color, offset, and radius.
      :rtype: color, vec2, number

   .. lua:method:: noTextShadow()

      Disables the shadow by setting its opacity to zero.

      .. helptext:: disable the text shadow

      :returns: The formatting object, for chaining.
      :rtype: textFormatting

   .. lua:attribute:: callback: function

      Glyph callback: ``function(str, index, mod)``. The index is one-based and ``mod`` is a glyphModifier. Used only by atlas rich text.

      .. helptext:: get or set callback

.. lua:class:: glyphModifier

   Mutable glyph data supplied to a formatting callback. Created by the renderer;
   no constructor. Changes affect the current glyph in atlas rich text.

   .. lua:attribute:: offsetX: number

      Horizontal glyph offset in pixels.

      .. helptext:: get or set glyph offsetX

   .. lua:attribute:: offsetY: number

      Vertical glyph offset in pixels.

      .. helptext:: get or set glyph offsetY

   .. lua:attribute:: alpha: number

      Sets glyph opacity from 0 to 255. The getter currently returns 255, not the edited opacity.

      .. helptext:: get or set glyph alpha

   .. lua:attribute:: color: color

      Sets glyph color. The getter currently returns a default color, not the edited glyph color.

      .. helptext:: get or set glyph color


Gizmos
######

Gizmos are useful for drawing shapes in 2D/3D space for debugging and editing

.. lua:module:: gizmos

.. lua:function:: line(x1, y1, z1, x2, y2, z2)

   Draws a 3D antialiased line

   .. helptext:: draw a line between two points

Color Space
###########

.. lua:currentmodule:: None

.. lua:function:: colorspace(type)

   Changes the color space used for drawing images and sprites

   :param type: Either ``GAMMA`` or ``LINEAR``

   .. helptext:: set the drawing color space

Contexts
########

.. lua:module:: context

.. lua:function:: push(image, [layer = 0, mip = 0])

   Pushes an :lua:class:`image` to the context, causing subsequent drawing operations to be applied to said image until :lua:func:`context.pop` is called

   :param image: The image to push
   :param layer: The layer of image to draw to
   :param mip: The mip of the image to draw to

   .. helptext:: push an image onto the drawing context

.. lua:function:: pop

   Pops the current image from the context if one exists, subsequent drawing operations are again applied to the main context (i.e. the display)

   .. helptext:: pop the current image from the drawing context
