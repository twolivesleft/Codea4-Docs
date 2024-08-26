.. Codea documentation master file, created by
   sphinx-quickstart on Fri Dec 31 14:32:21 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Codea 4
=======

.. code-block:: lua
   :linenos:

   function setup()
      print("Hello Codea!")
   end

   function draw()
      sprite(asset.builtin.Cargo_Bot.Codea_Icon, WIDTH/2, HEIGHT/2)
   end

   function touched(touch)
   end

.. toctree::
   :maxdepth: 2
   :caption: Manual:

   manual
   manual/codea_3x
   manual/codea
   manual/drawing
   manual/sound
   manual/assets
   manual/input
   manual/physics2d
   manual/physics3d
   manual/scenes
   manual/shaders

.. toctree::
   :maxdepth: 2
   :caption: API:

   api
   api/lua
   api/math_types
   api/graphics
   api/style
   api/matrix
   api/input
   api/image
   api/mesh
   api/shader
   api/gpu_noise_lib
   api/material
   api/sound
   api/scene
   api/entity
   api/camera
   api/light
   api/tween
   api/ui
   api/objc
   api/physics2d
   api/physics3d
   api/viewer

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
