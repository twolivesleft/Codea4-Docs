Camera Effects
==============

Camera effects change the finished picture of a scene. Add bloom to make bright
areas glow, adjust the colors, darken the edges with a vignette, or blur part of
the picture with tilt shift.

Getting started
---------------

Attach a camera to a scene entity and set its effect properties. Effects run
when the camera draws the scene. ``camera:apply()`` sets the drawing matrices
only; it does not apply effects to shapes or meshes you draw yourself.

.. code-block:: lua

   function setup()
       local world = scene()
       local eye = world:entity("Camera")
       eye.z = -8
       local cam = eye:add(camera.perspective(60))
       cam.bloom.strength = 0.6
       cam.bloom.threshold = 0.9
       cam.saturation = 1.1
       cam.vignette = 0.2
       cam.grain = 0.02
       local ball = world:entity("Ball")
       ball:add(mesh.sphere(1))
       scene.main = world
   end

Tilt shift and custom effects
-----------------------------

``cam.tiltShift.blur = 6`` adds up to six points of blur outside the sharp band.
The defaults keep the middle of the image sharp. Adjust ``focus``, ``range`` and
``falloff`` together to place the band and soften its edges.

Add your own shader with ``cam:addEffect(source)``. Custom effects run in the
order you add them, after the built-in effects. Each receives the picture so far
as ``source``; declare a ``scene`` sampler to also read the original picture.
Use the returned shader to change its uniforms. See :doc:`/api/camera` for details.

Layering cameras and controlling effects
----------------------------------------

With ``camera.none`` or ``camera.depth`` as the clear mode, the finished picture
is drawn over what is already on screen. Keep alpha in custom shaders so
transparent areas stay transparent. A camera that clears color first clears
its whole image. Effects follow the camera’s viewport and resize with it.

Bloom uses smaller images, while tilt shift and custom shaders work on full-size
images and can cost more to draw. Set bloom strength or tilt-shift blur to zero
to skip that effect. Set ``cam.effectsEnabled = false`` to turn off all effects.
``cam:clearEffects()`` removes custom effects without resetting the built-in settings.
