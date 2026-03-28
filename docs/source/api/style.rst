style
=====

*(module)*

A module for setting the current drawing style used with various graphics functions in Codea, such as :lua:func:`line`

General
#######

.. lua:module:: style

.. lua:function:: push()

   Push the current style onto the stack

   .. helptext:: push the current style onto the stack

.. lua:function:: push(style)

   Push a specific style onto the stack

   .. helptext:: push a style onto the stack

.. lua:function:: pop()

   Pop the current style from the stack, restoring the previous style

   .. helptext:: pop the current style from the stack

.. lua:function:: reset()

   Reset the current style to defaults. Use this to restore the default style

   .. helptext:: reset the style to defaults

.. lua:function:: get()

   Gets the current style as a graphicsStyle object, allowing styles to be saved and restored arbitrarily

   .. helptext:: get the current style

.. lua:function:: set(style)

   Sets the current style from a graphicsStyle object

   .. helptext:: set the current style

.. lua:function:: fill(<color>)
                  fill() -> r, g, b, a

   Sets/gets the fill color for use in vector drawing operations

   .. helptext:: set the fill color

.. lua:function:: noFill()

   Disables fill

   .. helptext:: clear the fill color

.. lua:function:: stroke()

   Gets the current stroke color for use in vector drawing operations

   .. helptext:: get the stroke color
   
.. lua:function:: stroke(color)

   Sets the stroke color to the specified color, or a grayscale value

   .. helptext:: set the stroke color

   :param color: The color to set the stroke to, or a grayscale value
   :type color: color or number

.. lua:function:: stroke(gray, alpha)

   Sets the stroke color to the specified grayscale value and alpha

   :param number gray: The grayscale value to set the stroke to
   :param number alpha: The alpha value to set the stroke to

   .. helptext:: set the stroke color

.. lua:function:: stroke(red, green, blue)

   Sets the stroke color to the specified red, green, and blue values

   :param number red: The red value to set the stroke to
   :param number green: The green value to set the stroke to
   :param number blue: The blue value to set the stroke to

   .. helptext:: set the stroke color

.. lua:function:: stroke(red, green, blue, alpha)

   Sets the stroke color to the specified red, green, blue, and alpha values

   :param number red: The red value to set the stroke to
   :param number green: The green value to set the stroke to
   :param number blue: The blue value to set the stroke to
   :param number alpha: The alpha value to set the stroke to

   .. helptext:: set the stroke color

.. lua:function:: noStroke()

   Disables stroke

   .. helptext:: clear the stroke color

.. lua:function:: tint(<color>)

   Sets the tint color for use with :lua:func:`sprite` and :lua:meth:`mesh.draw`

   .. helptext:: set the tint color for images drawn with sprite()

.. lua:function:: tint() -> r, g, b, a

   Gets the current tint color

   .. helptext:: get the tint color

.. lua:function:: pixelScaling(scale)

   Sets/gets the scale of a sprite when rendering

   :param number scale: the scaling factor of the sprite image

   .. helptext:: set the pixel scaling for sprite()

.. lua:function:: strokeWidth(width)

   Sets the stroke width for use in vector drawing operations

   .. helptext:: set the width of outlines

.. lua:function:: strokeWidth() -> number

   Gets the current stroke width

   .. helptext:: get the current outline width

.. lua:function:: lineCap(mode)

   Sets the current line cap mode, used by :lua:`line`, :lua:`polyline` and :lua:`shape`

   - :lua:attr:`ROUND`
   - :lua:attr:`SQUARE`
   - :lua:attr:`PROJECT`

   .. helptext:: set the cap style of line()

.. lua:function:: lineCap() -> enum

   Gets the current line cap mode

   .. helptext:: get the current line cap style

.. lua:function:: lineJoin(mode)

   Sets the current line join mode, used by :lua:`polyline`, :lua:`polygon` and :lua:`shape` when joining multiple line segments

   - :lua:attr:`ROUND`
   - :lua:attr:`MITER`
   - :lua:attr:`BEVEL`

   .. helptext:: set the join style of polyline()

.. lua:function:: lineJoin() -> enum

   Gets the current line join mode

   .. helptext:: get the current line join style

.. lua:function:: shapeMode(mode)
                  shapeMode() -> enum

   Sets/gets the current shape mode, used by :lua:`rect`, :lua:`ellipse` and :lua:`sprite`

   - :lua:attr:`CENTER` - Draw shapes from the center and size using width/height
   - :lua:attr:`CORNERS` - Draw shapes by specifying the two opposite corners
   - :lua:attr:`CORNER` - Draw shapes by specifying the bottom left corner and then width/height
   - :lua:attr:`RADIUS` - Draw shapes by specifying center and radius

   .. helptext:: set the drawing origin for rect() and ellipse()

Constants - Shape Mode
**********************

.. lua:attribute:: CORNER: const

   .. helptext:: corner rect mode constant


.. lua:attribute:: CORNERS: const

   .. helptext:: corners rect mode constant


.. lua:attribute:: CENTER: const

   .. helptext:: center mode constant


.. lua:attribute:: RADIUS: const

   .. helptext:: radius mode constant

.. lua:function:: sortOrder(order)

   .. helptext:: set the sort order for drawing

Blending Style
##############

Functions
*********

.. lua:function:: blend(mode)

   Sets the current blend mode to one of the available presets. Blending composites pixels onto the current drawing context based on source and destination color and alpha values

   .. helptext:: set the blend mode for drawing

   The default mode is :lua:`NORMAL` which applies standard alpha blended transparency with the following equation:

   .. math::
      RGBA = RGBA_{s} * A_{s} + RGBA_{d} * (1-A_{s})

   :lua:`DISABLED` can be used to disable alpha blending entirely

.. lua:function:: blend(src, dst)

   Sets a custom blend mode for both rgb and alpha components using ``src`` (source) and ``dst`` destination blending factors

   .. helptext:: set a custom blend mode

.. lua:function:: blend(src, dst, srcAlpha, dstAlpha)

   Sets a custom blend mode with separate blending factors for both rgb and alpha components

   .. helptext:: set a custom blend mode with separate alpha factors

.. lua:function:: blend() -> src, dst, srcAlpha, dstAlpha

   Returns the current blend factors for both rgb and alpha components (regardless of how the blend modes were set)

   .. helptext:: get the current blend factors

.. lua:function:: blendFunc(func)

   Sets the same blend function for both rgb and alpha components (the default is :lua:`EQUATION_ADD`) which determines how source and destination parts of the blending equation are combined

   - :lua:`EQUATION_ADD` - Add (default)
      :math:`R = R_s*k_s+R_d*k_d`
   - :lua:`EQUATION_SUB` - Subtract
      :math:`R = R_s*k_s-R_d*k_d`
   - :lua:`EQUATION_REVSUB` - Reverse subtract
      :math:`R = R_d*k_d-R_s*k_s`
   - :lua:`EQUATION_MIN` - Minimum (blend factors are ignored)
      :math:`R = min(R_s, R_d)`
   - :lua:`EQUATION_MAX` - Maximum (blend factors are ignored)
      :math:`R = max(R_s, R_d)`

   .. helptext:: set the blend equation function

.. lua:function:: blendFunc(func, alphaFunc)

   Sets separate blend functions for rgb and alpha components

   .. helptext:: set separate blend equation functions for rgb and alpha

.. lua:function:: blendFunc() -> func, alphaFunc

   Returns the current blend function for both rgb and alpha components (regardless of how the functions were set)

   .. helptext:: get the current blend equation function

Constants - Blend Modes
***********************

.. lua:attribute:: NORMAL: const

   The default blend mode (alpha blended transparency)

   .. image:: /images/example_blendMode_NORMAL.png
      :width: 200

   .. helptext:: normal blend mode constant

.. lua:attribute:: ADDITIVE: const

   Additive blend mode

   .. image:: /images/example_blendMode_ADDITIVE.png
      :width: 200

   .. helptext:: additive blend mode constant

.. lua:attribute:: MULTIPLY: const

   Multiply blend mode

   .. image:: /images/example_blendMode_MULTIPLY.png
      :width: 200

   .. helptext:: multiply blend mode constant

.. lua:attribute:: SCREEN: const

   Screen blend mode

   .. image:: /images/example_blendMode_SCREEN.png
      :width: 200

   .. helptext:: screen blend mode constant

.. lua:attribute:: LIGHTEN: const

   Lighten blend mode

   .. image:: /images/example_blendMode_LIGHTEN.png
      :width: 200

   .. helptext:: lighten blend mode constant

.. lua:attribute:: LINEAR_BURN: const

   Linear burn blend mode

   .. image:: /images/example_blendMode_LINEAR_BURN.png
      :width: 200

   .. helptext:: linear burn blend mode constant

.. lua:attribute:: PREMULTIPLIED: const

   Premultiplied blend mode

   .. image:: /images/example_blendMode_PREMULTIPLIED.png
      :width: 200

   .. helptext:: premultiplied blend mode constant

.. lua:attribute:: DISABLED: const

   Disables blending

   .. image:: /images/example_blendMode_DISABLED.png
      :width: 200

   .. helptext:: disabled blend mode constant

Constants - Blend Functions
***************************

.. lua:attribute:: EQUATION_ADD: const

   Combines source and destination pixels using addition

   .. helptext:: additive blend equation constant

.. lua:attribute:: EQUATION_SUB: const

   Combines source and destination pixels using subtraction

   .. helptext:: subtractive blend equation constant

.. lua:attribute:: EQUATION_REVSUB: const

   Combines source and destination pixels using subtraction in reverse order

   .. helptext:: reverse subtractive blend equation constant

.. lua:attribute:: EQUATION_MIN: const

   Combines source and destination pixels by taking the minimum of each component (ignores blend factors)

   .. helptext:: minimum blend equation constant

.. lua:attribute:: EQUATION_MAX: const

   Combines source and destination pixels by taking the maximum of each component (ignores blend factors)

   .. helptext:: maximum blend equation constant

Constants - Blend Factors
*************************

.. lua:attribute:: ZERO: const

   Blend factor of :math:`(0, 0, 0, 0)`

   .. helptext:: zero blend factor constant

.. lua:attribute:: ONE: const

   Blend factor or :math:`(1, 1, 1, 1)`

   .. helptext:: one blend factor constant

.. lua:attribute:: SRC_COLOR: const

   Blend factor of :math:`(R_s, G_s, B_s, A_s)`

   .. helptext:: source color blend factor constant

.. lua:attribute:: ONE_MINUS_SRC_COLOR: const

   Blend factor of :math:`(1-R_s, 1-G_s, 1-B_s, 1-A_s)`

   .. helptext:: one minus source color blend factor constant

.. lua:attribute:: SRC_ALPHA: const

   Blend factor of :math:`(A_s, A_s, A_s, A_s)`

   .. helptext:: source alpha blend factor constant

.. lua:attribute:: ONE_MINUS_SRC_ALPHA: const

   Blend factor of :math:`(1-A_s, 1-A_s, 1-A_s, 1-A_s)`

   .. helptext:: one minus source alpha blend factor constant

.. lua:attribute:: DST_ALPHA: const

   Blend factor of :math:`(A_d, A_d, A_d, A_d)`

   .. helptext:: destination alpha blend factor constant

.. lua:attribute:: ONE_MINUS_DST_ALPHA: const

   Blend factor of :math:`(1-A_d, 1-A_d, 1-A_d, 1-A_d)`

   .. helptext:: one minus destination alpha blend factor constant

.. lua:attribute:: DST_COLOR: const

   Blend factor of :math:`(R_d, G_d, B_d, A_d)`

   .. helptext:: destination color blend factor constant

.. lua:attribute:: SRC_ALPHA_SATURATE: const

   Blend factor of :math:`(f, f, f, 1)` where :math:`f = min(A_s, 1 - A_d)`

   .. helptext:: source alpha saturate blend factor constant

Viewport
########

.. lua:function:: viewRect(x, y, w, h)

   Sets the viewport of the renderer

   :param number x: The x position of the viewport
   :param number y: The y position of the viewport
   :param number w: The width of the viewport
   :param number h: The height of the viewport

   .. helptext:: set the viewport of the renderer

Clipping
########

.. lua:function:: clip(x, y, w, h)

   Settings the clipping rectangle, limiting drawing to within the clipping region

   *Note: the clipping rectangle is effected by the current matrix transform*

   .. helptext:: setup a clipping region on the screen

.. lua:function:: noClip()

   Disables clipping

   .. helptext:: disable clipping

Stencil
#######

.. code-block:: lua
   :caption: A simple mask effect using stencils

   function draw()
      background(40, 40, 50)

      -- When a pixel is drawn write 1 to the stencil buffer
      style.stencil 
      { 
         reference = 1, 
         pass = STENCIL_OP_REPLACE 
      }
      
      -- Use opacity clip to only draw pixels when alpha is great than .99
      style.opacityClip(0.99)
      style.blend(DISABLED) -- no blending needed
      matrix.push().transform2d(CurrentTouch.x, CurrentTouch.y, 1, 1, time.elapsed * 50)
      sprite(asset.builtin.Cargo_Bot.Codea_Icon, 0, 0, 400)
      matrix.pop()
      
      style.blend(NORMAL)
      style.noOpacityClip()
      -- Only draw if stencil is equal to one using the equal test condition
      style.stencil
      {
         reference = 1,
         condition = STENCIL_TEST_EQUAL
      }
      -- This sets the line thickness
      sprite(asset.builtin.SpaceCute.Beetle_Ship, WIDTH/2, HEIGHT/2, 400)
   end

Stencils are configured using a table with the following properties:

* ``reference``
* ``condition``
* ``readMask``
* ``pass``
* ``fail`` 
* ``zfail`` 

.. lua:function:: stencil(state)
                  stencil()

   Sets/gets the current stencil state for both front and back faces

   .. helptext:: set the stencil state for front and back faces

.. lua:function:: stencil(front, back)

   Sets/gets the current stencil state for both front and back faces

   .. helptext:: set separate stencil states for front and back faces



Constants - Stencil
*******************

Used by drawing commands and shaders to control stencil operations

**Stencil Test (conditions)**

.. lua:attribute:: STENCIL_TEST_LESS: const

   .. helptext:: less-than stencil test constant
.. lua:attribute:: STENCIL_TEST_LEQUAL: const

   .. helptext:: less-than-or-equal stencil test constant
.. lua:attribute:: STENCIL_TEST_EQUAL: const

   .. helptext:: equal stencil test constant
.. lua:attribute:: STENCIL_TEST_GEQUAL: const

   .. helptext:: greater-than-or-equal stencil test constant
.. lua:attribute:: STENCIL_TEST_GREATER: const

   .. helptext:: greater-than stencil test constant
.. lua:attribute:: STENCIL_TEST_NOTEQUAL: const

   .. helptext:: not-equal stencil test constant
.. lua:attribute:: STENCIL_TEST_NEVER: const

   .. helptext:: never stencil test constant
.. lua:attribute:: STENCIL_TEST_ALWAYS: const

   .. helptext:: always stencil test constant

**Stencil Operations (pass, fail, zfail)**

.. lua:attribute:: STENCIL_OP_ZERO: const

   .. helptext:: zero stencil operation constant
.. lua:attribute:: STENCIL_OP_KEEP: const

   .. helptext:: keep stencil operation constant
.. lua:attribute:: STENCIL_OP_REPLACE: const

   .. helptext:: replace stencil operation constant
.. lua:attribute:: STENCIL_OP_INCREMENT_WRAP: const

   .. helptext:: increment wrap stencil operation constant
.. lua:attribute:: STENCIL_OP_INCREMENT: const

   .. helptext:: increment stencil operation constant
.. lua:attribute:: STENCIL_OP_DECREMENT_WRAP: const

   .. helptext:: decrement wrap stencil operation constant
.. lua:attribute:: STENCIL_OP_DECREMENT: const

   .. helptext:: decrement stencil operation constant
.. lua:attribute:: STENCIL_OP_INVERT: const

   .. helptext:: invert stencil operation constant

Text Style
##########

.. lua:function:: font(assetKey)

   Adds a custom font in Codea using it's asset key

.. lua:function:: fontSize(size)

   .. helptext:: set the font size for text()

.. lua:function:: textAlign(align)

   .. helptext:: set alignment for text()

.. lua:function:: textStyle(style)

   .. helptext:: set the style for text()

Constants - Text
****************

.. lua:attribute:: LEFT: const

   .. helptext:: left alignment constant


.. lua:attribute:: CENTER: const

   .. helptext:: center mode constant


.. lua:attribute:: RIGHT: const

   .. helptext:: right alignment constant


.. lua:attribute:: TOP: const

   .. helptext:: top alignment constant


.. lua:attribute:: MIDDLE: const

   .. helptext:: middle alignment constant


.. lua:attribute:: BOTTOM: const

   .. helptext:: bottom alignment constant


.. lua:attribute:: BASELINE: const

   .. helptext:: baseline alignment constant


Constants - Style
#################

.. lua:attribute:: ROUND: const

   .. helptext:: round line cap constant


.. lua:attribute:: SQUARE: const

   .. helptext:: square line cap constant


.. lua:attribute:: PROJECT: const

   .. helptext:: project line cap constant


.. lua:attribute:: MITER: const

   .. helptext:: miter line join constant


.. lua:attribute:: BEVEL: const

   .. helptext:: bevel line join constant


Constants - Render Queues
#########################

.. lua:attribute:: BACKGROUND: const

   .. helptext:: background pass type constant


.. lua:attribute:: OPAQUE: const

   .. helptext:: opaque pass type constant


.. lua:attribute:: TRANSPARENT: const

   .. helptext:: transparent pass type constant


.. lua:attribute:: OVERLAY: const

   .. helptext:: overlay pass type constant

Constants - Color Mask
######################

Used by shaders to control which color components are written to color buffers (i.e. images and the main context)

.. lua:attribute:: COLOR_MASK_NONE: const

   .. helptext:: no color channels mask constant


.. lua:attribute:: COLOR_MASK_RED: const

   .. helptext:: red channel mask constant


.. lua:attribute:: COLOR_MASK_GREEN: const

   .. helptext:: green channel mask constant


.. lua:attribute:: COLOR_MASK_BLUE: const

   .. helptext:: blue channel mask constant


.. lua:attribute:: COLOR_MASK_ALPHA: const

   .. helptext:: alpha channel mask constant


.. lua:attribute:: COLOR_MASK_RGB: const

   .. helptext:: RGB channels mask constant


.. lua:attribute:: COLOR_MASK_RGBA: const

   .. helptext:: all color channels mask constant


Constants - Culling
###################

Used by shaders / meshes to control which triangles are culled (based on winding order)

.. lua:attribute:: CULL_FACE_NONE: const

   .. helptext:: no face culling constant


.. lua:attribute:: CULL_FACE_FRONT: const

   .. helptext:: front face culling constant


.. lua:attribute:: CULL_FACE_BACK: const

   .. helptext:: back face culling constant

Constants - Depth
#################

Used by shaders to control depth rejection for opaque and translucent fragments

.. lua:attribute:: DEPTH_WRITE_ENABLED: const

   .. helptext:: depth write enabled constant


.. lua:attribute:: DEPTH_WRITE_DISABLED: const

   .. helptext:: depth write disabled constant


.. lua:attribute:: DEPTH_FUNC_NEVER: const

   .. helptext:: never depth function constant


.. lua:attribute:: DEPTH_FUNC_LESS: const

   .. helptext:: less-than depth function constant


.. lua:attribute:: DEPTH_FUNC_EQUAL: const

   .. helptext:: equal depth function constant


.. lua:attribute:: DEPTH_FUNC_LESS_EQUAL: const

   .. helptext:: less-than-or-equal depth function constant


.. lua:attribute:: DEPTH_FUNC_GREATER: const

   .. helptext:: greater-than depth function constant


.. lua:attribute:: DEPTH_FUNC_NOT_EQUAL: const

   .. helptext:: not-equal depth function constant


.. lua:attribute:: DEPTH_FUNC_GREATER_EQUAL: const

   .. helptext:: greater-than-or-equal depth function constant
