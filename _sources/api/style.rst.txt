style
=====

*(module)*

A module for setting the current drawing style used with various graphics functions in Codea, such as :lua:func:`line`

General
#######

.. lua:module:: style

.. lua:function:: push()
                  push(style)
                  pop()
                  reset()

   Functions for manipulating the style stack, use these when you want to temporarily change the style and restore it to it's previous state

   Use :lua:func:`style.reset` to restore the default style

.. lua:function:: get()
                  set(style)

   Gets/sets the current style as a graphicsStyle object allowing styles to be saved and restored arbitrarily

.. lua:function:: fill(<color>)
                  fill() -> r, g, b, a

   Sets/gets the fill color for use in vector drawing operations

.. lua:function:: stroke(<color>)
                  stroke() -> r, g, b, a

   Sets/gets the stroke color for use in vector drawing operations

.. lua:function:: tint(<color>)
                  tint() -> r, g, b, a

   Sets/gets the tint color for use to tint calls to :lua:func:`sprite` and :lua:meth:`mesh.draw`

.. lua:function:: strokeWidth(width)
                  stroke() -> number

   Sets/gets the stroke width for use in vector drawing operations

.. lua:function:: lineCap(mode)
                  lineCap() -> enum

   Sets/gets the current line cap mode, used by :lua:`line`, :lua:`polyline` and :lua:`shape`

   - :lua:attr:`ROUND`
   - :lua:attr:`SQUARE`
   - :lua:attr:`PROJECT`

.. lua:function:: lineJoin(mode)
                  lineJoin() -> enum

   Sets/gets the current line join mode, used by :lua:`polyline`, :lua:`polygon` and :lua:`shape` used when joining multiple line segments

   - :lua:attr:`ROUND`
   - :lua:attr:`MITER`
   - :lua:attr:`BEVEL`

.. lua:function:: shapeMode(mode)
                  shapeMode() -> enum

   Sets/gets the current shape mode, used by :lua:`rect`, :lua:`ellipse` and :lua:`sprite`

   - :lua:attr:`CENTER` - Draw shapes from the center and size using width/height
   - :lua:attr:`CORNERS` - Draw shapes by specifying the two opposite corners
   - :lua:attr:`CORNER` - Draw shapes by specifying the bottom left corner and then width/height
   - :lua:attr:`RADIUS` - Draw shapes by specifying center and radius

Constants - Shape Mode
**********************

.. lua:attribute:: CORNER: const


.. lua:attribute:: CORNERS: const


.. lua:attribute:: CENTER: const


.. lua:attribute:: RADIUS: const

.. lua:function:: sortOrder(order)

Blending Style
##############

Functions
*********

.. lua:function:: blend(mode)

   Sets the current blend mode to one of the available presets. Blending composites pixels onto the current drawing context based on source and destination color and alpha values

   The default mode is :lua:`NORMAL` which applies standard alpha blended transparency with the following equation:

   .. math::
      RGBA = RGBA_{s} * A_{s} + RGBA_{d} * (1-A_{s})

   :lua:`DISABLED` can be used to disable alpha blending entirely

.. lua:function:: blend(src, dst)

   Sets a custom blend mode for both rgb and alpha components using ``src`` (source) and ``dst`` destination blending factors

.. lua:function:: blend(src, dst, srcAlpha, dstAlpha)

   Sets a custom blend mode with separate blending factors for both rgb and alpha components

.. lua:function:: blend() -> src, dst, srcAlpha, dstAlpha

   Returns the current blend factors for both rgb and alpha components (regardless of how the blend modes were set)

.. lua:function:: blendFunc(func)
                  blendFunc(func, alphaFunc)

   Sets the current blend function (the default is :lua:`EQUATION_ADD`) which determines how source and destination parts of the blending equation are combined

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

.. lua:function:: blendFunc() -> func, alphaFunc

   Returns the current blend function for both rgb and alpha components (regardless of how the functions were set)

Constants - Blend Modes
***********************

.. lua:attribute:: NORMAL: const

   The default blend mode (alpha blended transparency)

   .. image:: /images/example_blendMode_NORMAL.png
      :width: 200

.. lua:attribute:: ADDITIVE: const

   Additive blend mode

   .. image:: /images/example_blendMode_ADDITIVE.png
      :width: 200

.. lua:attribute:: MULTIPLY: const

   Multiply blend mode

   .. image:: /images/example_blendMode_MULTIPLY.png
      :width: 200

.. lua:attribute:: SCREEN: const

   Screen blend mode

   .. image:: /images/example_blendMode_SCREEN.png
      :width: 200

.. lua:attribute:: LIGHTEN: const

   Lighten blend mode

   .. image:: /images/example_blendMode_LIGHTEN.png
      :width: 200

.. lua:attribute:: LINEAR_BURN: const

   Linear burn blend mode

   .. image:: /images/example_blendMode_LINEAR_BURN.png
      :width: 200

.. lua:attribute:: PREMULTIPLIED: const

   Premultiplied blend mode

   .. image:: /images/example_blendMode_PREMULTIPLIED.png
      :width: 200

.. lua:attribute:: DISABLED: const

   Disables blending

   .. image:: /images/example_blendMode_DISABLED.png
      :width: 200

Constants - Blend Functions
***************************

.. lua:attribute:: EQUATION_ADD: const

   Combines source and destination pixels using addition

.. lua:attribute:: EQUATION_SUB: const

   Combines source and destination pixels using subtraction

.. lua:attribute:: EQUATION_REVSUB: const

   Combines source and destination pixels using subtraction in reverse order

.. lua:attribute:: EQUATION_MIN: const

   Combines source and destination pixels by taking the minimum of each component (ignores blend factors)

.. lua:attribute:: EQUATION_MAX: const

   Combines source and destination pixels by taking the maximum of each component (ignores blend factors)

Constants - Blend Factors
*************************

.. lua:attribute:: ZERO: const

   Blend factor of :math:`(0, 0, 0, 0)`

.. lua:attribute:: ONE: const

   Blend factor or :math:`(1, 1, 1, 1)`

.. lua:attribute:: SRC_COLOR: const

   Blend factor of :math:`(R_s, G_s, B_s, A_s)`

.. lua:attribute:: ONE_MINUS_SRC_COLOR: const

   Blend factor of :math:`(1-R_s, 1-G_s, 1-B_s, 1-A_s)`

.. lua:attribute:: SRC_ALPHA: const

   Blend factor of :math:`(A_s, A_s, A_s, A_s)`

.. lua:attribute:: ONE_MINUS_SRC_ALPHA: const

   Blend factor of :math:`(1-A_s, 1-A_s, 1-A_s, 1-A_s)`

.. lua:attribute:: DST_ALPHA: const

   Blend factor of :math:`(A_d, A_d, A_d, A_d)`

.. lua:attribute:: ONE_MINUS_DST_ALPHA: const

   Blend factor of :math:`(1-A_d, 1-A_d, 1-A_d, 1-A_d)`

.. lua:attribute:: DST_COLOR: const

   Blend factor of :math:`(R_d, G_d, B_d, A_d)`

.. lua:attribute:: SRC_ALPHA_SATURATE: const

   Blend factor of :math:`(f, f, f, 1)` where :math:`f = min(A_s, 1 - A_d)`

Text Style
##########

.. lua:function:: fontSize(size)

.. lua:function:: textAlign(align)

Constants - Text
****************

.. lua:attribute:: LEFT: const


.. lua:attribute:: CENTER: const


.. lua:attribute:: RIGHT: const


.. lua:attribute:: TOP: const


.. lua:attribute:: MIDDLE: const


.. lua:attribute:: BOTTOM: const


.. lua:attribute:: BASELINE: const


Constants - Style
#################

.. lua:attribute:: ROUND: const


.. lua:attribute:: SQUARE: const


.. lua:attribute:: PROJECT: const


.. lua:attribute:: MITER: const


.. lua:attribute:: BEVEL: const


Constants - Render Queues
#########################

.. lua:attribute:: BACKGROUND: const


.. lua:attribute:: OPAQUE: const


.. lua:attribute:: TRANSPARENT: const


.. lua:attribute:: OVERLAY: const

Constants - Color Mask
######################

Used by shaders to control which color components are written to color buffers (i.e. images and the main context)

.. lua:attribute:: COLOR_MASK_NONE: const


.. lua:attribute:: COLOR_MASK_RED: const


.. lua:attribute:: COLOR_MASK_GREEN: const


.. lua:attribute:: COLOR_MASK_BLUE: const


.. lua:attribute:: COLOR_MASK_ALPHA: const


.. lua:attribute:: COLOR_MASK_RGB: const


.. lua:attribute:: COLOR_MASK_RGBA: const



Constants - Culling
###################

Used by shaders / meshes to control which triangles are culled (based on winding order)

.. lua:attribute:: CULL_FACE_NONE: const


.. lua:attribute:: CULL_FACE_FRONT: const


.. lua:attribute:: CULL_FACE_BACK: const

Constants - Depth
#################

Used by shaders to control depth rejection for opaque and translucent fragments

.. lua:attribute:: DEPTH_WRITE_ENABLED: const


.. lua:attribute:: DEPTH_WRITE_DISABLED: const


.. lua:attribute:: DEPTH_FUNC_NEVER: const


.. lua:attribute:: DEPTH_FUNC_LESS: const


.. lua:attribute:: DEPTH_FUNC_EQUAL: const


.. lua:attribute:: DEPTH_FUNC_LESS_EQUAL: const


.. lua:attribute:: DEPTH_FUNC_GREATER: const


.. lua:attribute:: DEPTH_FUNC_NOT_EQUAL: const


.. lua:attribute:: DEPTH_FUNC_GREATER_EQUAL: const
