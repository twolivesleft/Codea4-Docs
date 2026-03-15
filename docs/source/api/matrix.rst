matrix
======

*(module)*

A module for setting the current matrices used with various graphics functions in Codea

.. lua:module:: matrix

General
#######

.. lua:function:: push()
                  pop()
                  reset()

   Functions for manipulating the matrix stack, use these when you want to temporarily change current space-transform for drawing operations

   .. helptext:: push, pop and reset the matrix stack

.. lua:function:: model()
                  model(matrix)
                  

   Gets/sets the model matrix used to transform from local to world space

   .. helptext:: get or set the model matrix

.. lua:function:: view()
                  view(matrix)

   Gets/sets the view matrix used to transform from world to view space (generally controlled by cameras)

   .. helptext:: get or set the view matrix

.. lua:function:: projection()
                  projection(matrix)

   Gets/sets the projection matrix, used for final projection (i.e. othro and perspective projection)

   .. helptext:: get or set the projection matrix

Transform
#########

.. lua:function:: transform2d(x, y[, sx = 1, sy = 1, r = 0])

   Apply a generic 2D transform to the model matrix

   .. helptext:: apply a 2D transform to the model matrix

.. lua:function:: transform3d(x, y, z, sx, sy, sz, rx, ry, rz)

   Apply a generic 3D transform to the model matrix

   .. helptext:: apply a 3D transform to the model matrix

.. lua:function:: translate(x, y[, z])

   Translate the current model matrix

   .. helptext:: translate the current transform

.. lua:function:: rotate(quat)

   .. helptext:: rotate the current transform
.. lua:function:: rotate(angle, x, y, z)

   Rotate the current model matrix

   .. helptext:: rotate the current transform

.. lua:function:: scale(x, y[, z])

   Scale the current model matrix

   .. helptext:: scale the current transform

Projection
##########

.. lua:function:: ortho()

   Set the projection matrix to ortho using the device screen settings (i.e. coordinates range ``[0, 0]`` to ``[WIDTH, HEIGHT]``)

   .. helptext:: setup an orthographic view

.. lua:function:: ortho(height)

   Sets an orthographic projection matrix ``height`` units high, using the aspect ratio of the screen to set the width

   .. helptext:: setup an orthographic view

   :param height: The height of the orthographic projection
   :type number:

.. lua:function:: ortho(left, right, bottom, top[, near, far])

   Sets an orthographic projection matrix using the supplied edge values

   .. helptext:: setup an orthographic view

.. lua:function:: perspective(fov, aspect, near, far])

   Sets a perspective projection matrix

   .. helptext:: setup a perspective view
