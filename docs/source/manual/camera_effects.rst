Camera Effects
==============

Add polish to a scene by configuring its camera rather than drawing a separate
post-processing pipeline. Each camera owns its settings and custom shader chain.
Start with bloom or a gentle color grade, then add tilt shift or a custom shader
only when the picture calls for it.

Getting started
---------------

Attach a camera to a scene entity and keep the returned camera component. Effects
run when that camera draws the scene. Calling ``camera:apply()`` only changes
matrices and does not wrap immediate-mode drawing in an effect pass.

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

Custom effects are appended with ``cam:addEffect(source)``. They receive the
picture so far as ``source`` and run in insertion order after the built-in
finish. Use the returned shader to change uniforms. Declare a ``scene`` sampler
when an effect needs the untouched camera picture, for example to keep stars or
fine details sharp. See the camera API for the full shader contract.

Compositing and performance
---------------------------

Cameras with ``camera.none`` or ``camera.depth`` clear modes composite their
finished image over the existing viewport. Preserve alpha in custom shaders.
Cameras clearing color clear their entire offscreen image before rendering.
Effects honor the camera viewport and resize their images with it.

Effect images are allocated only when first needed. Bloom uses reduced-size
images; tilt shift and custom passes require full-size images. Set bloom
strength and tilt-shift blur to zero to skip those passes. For a secondary draw,
set ``cam.effectsEnabled = false``, draw, then restore the previous value.
``cam:clearEffects()`` removes custom effects only; it does not reset built-ins.
