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

.. lua:function:: model()
                  model(matrix)
                  

   Gets/sets the model matrix used to transform from local to world space

.. lua:function:: view()
                  view(matrix)

   Gets/sets the view matrix used to transform from world to view space (generally controlled by cameras)

.. lua:function:: projection()
                  projection(matrix)

   Gets/sets the projection matrix, used for final projection (i.e. othro and perspective projection)

Transform
#########

.. lua:function:: transform2d(x, y[, sx = 1, sy = 1, r = 0])

   Apply a generic 2D transform to the model matrix

.. lua:function:: transform3d(x, y, z, sx, sy, sz, rx, ry, rz)

   Apply a generic 3D transform to the model matrix

.. lua:function:: translate(x, y[, z])

   Translate the current model matrix

.. lua:function:: rotate(quat)
.. lua:function:: rotate(angle, x, y, z)

   Rotate the current model matrix

.. lua:function:: scale(x, y[, z])

   Scale the current model matrix

Projection
##########

.. lua:function:: ortho()

   Set the projection matrix to ortho using the device screen settings (i.e. coordinates range ``[0, 0]`` to ``[WIDTH, HEIGHT]``)

.. lua:function:: ortho(height)

   Sets an orthographic projection matrix ``height`` units high, using the aspect ratio of the screen to set the width

   :param height: The height of the orthographic projection
   :type number:

.. lua:function:: ortho(left, right, bottom, top[, near, far])

   Sets an orthographic projection matrix using the supplied edge values

.. lua:function:: perspective(fov, aspect, near, far])

   Sets a perspective projection matrix