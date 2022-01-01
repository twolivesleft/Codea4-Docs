Drawing
=======

Drawing in Codea
----------------

Codea comes with several immediate mode drawing APIs that form the basis of
drawing both 2D and 3D graphics

The user-defined global :lua:`draw()` function is called once per frame to
update the contents of the screen

The :lua:`background(r,g,b,a)` function is used to clear the background to a given color. When this isn't called the contents of the background will stay the same as the preivous frame

Codea uses an hybrid-immediate mode drawing system, where various built-in functions can be used to paint objects to the screen when called, such as :lua:`line()`, :lua:`sprite()` and :lua:`rect()`

These functions use the current render state, defined by the current style and matrix in use, which effects things like fill color and stroke color / width

Style
-----

The style module contains functions that set the current drawing state

This module uses a fluent syntax, so any call that does not return a value, will instead return the style module itself, allowing multiple style commands to be chained together:

.. code-block:: lua

   -- Draw a red ellipse with a 5px white stroke
   style.push().fill(color.red).stroke(color.white).strokeWidth(5)
   ellipse(WIDTH/2, HEIGHT/2, 100, 100)
   style.pop()

See :doc:`types/style` for a complete reference of all functionality

Anywhere ``<color>`` is used as a parameter, the following forms can be used:

.. code-block:: lua

   style.func(r, g, b, a) -- separate color components in the range 0-255
   style.func(r, g, b) -- only red, green, blue color components with alpha assumed to be 255
   style.func(grey, alpha) -- only greyscale and alpha
   style.func(grey) -- only grayscale with alph assumed to be 255
   style.func(color) -- a color object









Matrix
------

Context
-------

Backround
---------

Vector Drawing
--------------

Text
----

Images and Sprites
------------------

Meshes
------

Shaders and Materials
---------------------

Lighting
--------
