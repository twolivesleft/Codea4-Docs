camera
======

*(class)*

.. lua:class:: camera

   A camera object used for rendering. Can also be used as a component in scenes

   .. code-block:: lua

      scn = scene()
      -- Create an entity and attach a perspective camera to it
      cam = scn:entity():add(camera.perspective(45, 0.1, 100))

   .. code-block:: lua

      -- Use a camera directly with drawing calls
      cam = camera.perspective(45, 0.1, 100)
      cam:apply()

   .. lua:staticmethod:: ortho(size[, near, far])

      :return: A new orthographic camera
      :rtype: camera

   .. lua:staticmethod:: perspective(fov[, near, far])

      :return: A new perspective camera
      :rtype: camera

   .. lua:attribute:: isOrtho: boolean

      Determines if the camera is orthographic or perspective

   .. lua:attribute:: orthoSize: number

      The ortho graphic size (height) of this camera when in orthographic mode

   .. lua:attribute:: clearMode: enum

      The clear mode, which can be one of the following values:

      * ``camera.none`` - do not clear the background
      * ``camera.color`` - clear the color only
      * ``camera.depth`` - clear the depth only
      * ``camera.depthAndColor`` - clear both the depth and color

   .. lua:attribute:: clearColor: color

      The color to use when clearing the screen with this camera

   .. lua:attribute:: fieldOfView: number

      The field of view for this camera when in perspective mode

   .. lua:attribute:: nearPlane: number

      The distance of near view plane from the view origin

   .. lua:attribute:: farPlane: number

      The distance of far view plane from the view origin

   .. lua:attribute:: priority: integer

      The priority of the camera when used within a scene (cameras with lower values are drawn first)

   .. lua:attribute:: projection: mat4

      Sets/gets a custom projection matrix

   .. lua:attribute:: view: mat4

      Sets/gets a custom view matrix

   .. lua:method:: apply()

      Apply this cameras settings to the matrix stack

   .. lua:method:: screenToWorld(x, y, z)

      Takes a 2D point on the screen (in points) and a depth value and unprojects this point into 3D space. Useful for things like raycasting from touches

      :return: The point at screen position ``x``, ``y`` projected ``z`` units into the screen in world space
      :rtype: number, number, number

   .. lua:method:: worldToScreen(x, y, z)

      Takes a 3D point in world space and projects it onto screen coordinates (in points)

      :return: The point in world space (``x``, ``y``, ``z``) projected onto the screen
      :rtype: number, number, number
   