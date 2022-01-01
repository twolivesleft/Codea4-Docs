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
   :caption: Contents:

   codea
   drawing
   sound
   assets
   input
   physics2d
   physics3d
   scenes
   types/lua
   types/math_types
   types/graphics
   types/style
   types/image
   types/mesh
   types/shader
   types/material
   types/sound
   types/scene
   types/entity
   types/physics2d
   types/physics3d


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
