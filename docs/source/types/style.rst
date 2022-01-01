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


.. lua:attribute:: ONE: const


.. lua:attribute:: SRC_COLOR: const


.. lua:attribute:: ONE_MINUS_SRC_COLOR: const


.. lua:attribute:: SRC_ALPHA: const


.. lua:attribute:: ONE_MINUS_SRC_ALPHA: const


.. lua:attribute:: DST_ALPHA: const


.. lua:attribute:: ONE_MINUS_DST_ALPHA: const


.. lua:attribute:: DST_COLOR: const


.. lua:attribute:: SRC_ALPHA_SATURATE: const
