graphics
========

*(global)*

Background
##########

Test!

.. lua:function:: background(<color>)

   Clears the current context with solid color, can also be used to set image backgrounds when combined with :lua:func:`context.push`

.. lua:function:: background(cubeImage, [mipLevel = 0])

   Clears the current backgrond with the contents of a cube image, using the current camera settings to define eye direction

   :param cubeImage: The image to clear the background with
   :param mipLevel: The mip level of the image to use, useful for displaying pre-blurred image mips, such as those calculated using :lua:meth:`image.generateIrradiance`

.. lua:function:: background(shader)

Vector Graphics
###############

A set of graphics functions which are so commonly used they are in the global namespace for convenience

.. lua:function:: line(x1, y1, x2, y2)

   Draws 2D line based on the current style, :lua:func:`style.stroke` and :lua:func:`style.strokeWidth` to determine color and stroke width

   Supports dynamic number arguments

.. lua:function:: line(x, y)

   Variation of line command used as part of shape drawing

.. lua:function:: ellipse(x, y, w, h)
                  ellipse(x, y, r)

.. lua:function:: rect(x, y, w, h)
                  rect(x, y, w, h, r)
                  rect(x, y, w, h, r1, r2, r3, r4)

   Draws a rectangle with a given origin point and width / height, origin and sizing behaviour depends on :lua:func:`style.shapeMode`

   Additional arguments allow for rounded corners (either all one radius or four separate radii)

Sprites
#######

.. lua:function:: sprite(image, x, y)
                  sprite(image, x, y, w)
                  sprite(image, x, y, w, h)
                  sprite(asset.key, x, y)
                  sprite(asset.key, x, y, w)
                  sprite(asset.key, x, y, w, h)
                  sprite(sprite.slice, x, y)
                  sprite(sprite.slice, x, y, w)
                  sprite(sprite.slice, x, y, w, h)
                  sprite(shader, x, y, w, h)

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
