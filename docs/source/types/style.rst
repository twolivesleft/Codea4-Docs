style
=====

*(module)*

A module for setting the current drawing style used with various graphics functions in Codea, such as :lua:func:`line`

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


Constants - Style
#################

.. lua:attribute:: CORNER: const


.. lua:attribute:: CORNERS: const


.. lua:attribute:: CENTER: const


.. lua:attribute:: RADIUS: const


.. lua:attribute:: LEFT: const


.. lua:attribute:: CENTER: const


.. lua:attribute:: RIGHT: const


.. lua:attribute:: TOP: const


.. lua:attribute:: MIDDLE: const


.. lua:attribute:: BOTTOM: const


.. lua:attribute:: BASELINE: const


.. lua:attribute:: ROUND: const


.. lua:attribute:: SQUARE: const


.. lua:attribute:: PROJECT: const


.. lua:attribute:: MITER: const


.. lua:attribute:: BEVEL: const


Constants - Blend Modes
#######################

.. lua:attribute:: NORMAL: const

   The default blend mode (alpha blended transparency)
      .. math::
         RGBA_{final} = RGBA_{src} * A_{src} + RGBA_{dst} * (1-A_{src})

.. lua:attribute:: ADDITIVE: const

   Additive blend mode

.. lua:attribute:: MULTIPLY: const

   Multiply blend mode

.. lua:attribute:: SCREEN: const

   Screen blend mode

.. lua:attribute:: LIGHTEN: const

   Lighten blend mode

.. lua:attribute:: LINEAR_BURN: const

   Linear burn blend mode

.. lua:attribute:: PREMULTIPLIED: const

   Premultiplied blend mode

.. lua:attribute:: DISABLED: const

   Disables blending

Constants - Blend Factors
#########################

.. lua:attribute:: ZERO: const

   Blend factor of (0, 0, 0, 0)

.. lua:attribute:: ONE: const

   Blend factor or (1, 1, 1, 1)

.. lua:attribute:: SRC_COLOR: const

   Blend factor of (Rs, Gs, Bs, As)

.. lua:attribute:: ONE_MINUS_SRC_COLOR: const



.. lua:attribute:: SRC_ALPHA: const



.. lua:attribute:: ONE_MINUS_SRC_ALPHA: const



.. lua:attribute:: DST_ALPHA: const



.. lua:attribute:: ONE_MINUS_DST_ALPHA: const



.. lua:attribute:: DST_COLOR: const



.. lua:attribute:: SRC_ALPHA_SATURATE: const



Constants - Blend Functions
###########################

Used with :lua:`style.blendFunc` to set the current blend function (for color, alpha or both)

.. lua:attribute:: EQUATION_ADD: const


.. lua:attribute:: EQUATION_SUB: const


.. lua:attribute:: EQUATION_REVSUB: const


.. lua:attribute:: EQUATION_MIN: const


.. lua:attribute:: EQUATION_MAX: const


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
