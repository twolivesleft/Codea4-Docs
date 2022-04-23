Migration from Codea 3.x
========================

Codea 4.x represents a significant change from all previous major versions, introducing powerful new features but also some API changes/improvements that break some backwards compatibility. I'll attempt to list them all here but no doubt there will be a few things that we've missed. Let us know via https://codea.io/talk or Discord if you spot something!

OpenGL ES 3 -> Metal
--------------------

No doubt you may have heard that Apple has deprecated OpenGL ES on iOS. What this means for us is that eventually Apple may (however unlikely) drop support for it all together. This would be bad for Codea to say the least, so several years ago we began working on a new runtime to solve this. Because of the nature of the old runtime, it's not as easy as just replace all OpenGL calls with equivalent Metal ones. This was a huge change and touches almost every part of the engine. Which is why we decided to start from scratch with 4 (code-named Carbide). This, understandably, has taken some time...

Drawing Commands
----------------

The original drawing commands all work the same way as they did before:

i.e. ``line(x1, y1, x2, y2)`` or ``sprite(assetKey, x, y, w, h)``

With the exception that you can now pass in ``vecx`` types as long as you pass in the correct number of arguments:

* ``line(vec2, vec2)``
* ``line(number, vec3)``
* ``line(number, number, vec2)``
* ``line(vec4)``

*Rect*

:lua:func:`rect` now supports rounded corners when supplied additional parameters

*New Commands*

* :lua:func:`polygon` - draw am arbitrary polygon from an set of points
* :lua:func:`polyline` - draw arbitrary line from a set of points
* :lua:func:`shape` - draw an arbitrary shape using various drawing commands

*New Types*
There is a new type called :lua:class:`image.slice` which can be used with :lua:func:`sprite` for more sophisticaed sprite drawing. This lets you take a slice of an image, rotate, flip, pad and stetch using 9-patch style borders

The :lua:class:`image.slice` type can be used with the new :lua:class:`atlas` type to quickly create and load spritesheets from a single image

Asset Loading/Saving
--------------------

The calling conventions for asset loading have been changed slightly. Intead of calling ``typeRead/Write()``, you now call ``type.read/write()``. This means that ``readImage()`` becomes ``image.read()``. This is more consistent across the board, introducting ``mesh.read()`` for instance

Scenes can also be saved and loaded with to files with :lua:meth:`scene.read` and :lua:meth:`scene.save`

Craft
-----

One of the major changes in 4.x is the removal of the craft namespace and merging of craft and standard codea types, removing redundant types

This means that there is no longer a ``craft.model`` type, but instead all functionality of ``craft.model`` has been merged into the :lua:class:`mesh` type. The same goes ``texture`` and :lua:class:`image` as well as ``craft.shader`` and :lua:class:`shader`

The practical upshot of this, is that you can use load meshes directly from a file and draw them to the screen using :lua:meth:`mesh.draw`

Part of the new streamlined API design is that almost all features that were restricted to craft scenes can be used directly in the immediate mode drawing API. We now have lighting which can be used with :lua:meth:`mesh.draw` and materials can be used directly with meshes as well

Scenes and Entities
-------------------

Scenes and the associated entity and component types have recieved some polish and changes too

* Scenes can be saved and loaded to a file (json format)
* Multiple scenes can be managed separately or drawn on top of each other
* Scenes support sprites and shapes for 2D drawing workflows
* Scenes can be run automatically using ``scene.main = myScene``
* Scenes support both 2D and 3D physics
* Scenes support shadow mapping along with environmental lighting
* Scenes now have autoupdate (no need to call update manually)
* Scenes process touches and redirect events to entity callbacks

Entities
--------

While entities work much the same, they have some new features and some changes compared to craft entities

* Meshes can be attached directly to an entity with ``myEntity.mesh = msh`` or ``myEntity:add(msh)``
* Sprites can be attached by using images and/or image slices ``myEntity.sprite = image|slice``

Entities now have dynamic storage, so setting new properties on them will store that property for the lifetime of the entity, even if you access it via a different means

Entities can be duplicated via ``entity:duplicate()``

Entity callbacks. You can set callback functions directly on an entity, which will then be called when the scene is updated/drawn. This allows entities to draw custom graphics, recieve touch events, update with the scene and more:

* ``entity:update(dt)``
* ``entity:fixedUpdate(dt)``
* ``entity:draw()``
* ``entity:destroyed()`` - called when the entity is about to be destroyed
* ``entity:touched(touch)``
* ``entity:layout()`` - for UI layout
* ``entity:computeSize()`` - for UI sizing

You can also create a lua class and attach that to an entity to recieve the callbacks

Physics
-------

* Physics worlds can now be created and destroyed
* 2D and 3D physics have the same API design
* Support for collision callbacks in 2D and 3D physics worlds (with and without scenes/entities)
* Support for joints in 2D and 3D physics worlds
* Support for compound colliders in 2D and 3D physics worlds (formally called collision shapes)

Fluent API (style, matrix, etc...)
----------------------------------

In 4.x we've changed style calls to a fluent/chaining syntax, where the namespace ``style`` is used to access all style related commands, where each one returns a reference to the style table so they can be chained one after the other

So the following code:

.. code-block:: lua
   :linenos:

   pushStyle()
   fill(255)
   stroke(128)
   strokeWidth(5)
   rect(WIDTH/2, HEIGHT/2, 100, 100)
   popStyle()

Can now he written as:

.. code-block:: lua
   :linenos:

   style.push().fill(255).stroke(128).strokeWidth(5)
   rect(WIDTH/2, HEIGHT/2, 100, 100)
   style.pop()

The same goes for matrix, camera and context

.. code-block:: lua
   :linenos:

   matrix.push().translate(x, y).scale(5)
   matrix.pop()

   camera.perspective()

   context.push(img)
   context.pop()

If you prefer the old syntax you can use the following in ``main.lua``:

.. code-block:: lua
   :linenos:

   require 'legacy':export()

Time
----

Intead of ElapsedTime, there is now the time module, which contains...

Matrix and Vector Types
-----------------------

The matrix type has now been split into mat2, mat3, mat4
