Scenes
======

Scenes in Codea
---------------

The :lua:class:`scene` system is the modern, high-level way to build 3D (and 2D) experiences in Codea. A scene manages a hierarchy of :lua:class:`entity` objects, each of which can have components — meshes, physics bodies, cameras, lights, custom Lua classes — attached to them.

Unlike the immediate-mode drawing API (``sprite``, ``rect``, etc.), scenes automatically handle the update loop, render pass, and physics simulation for you.

.. code-block:: lua

   function setup()
       scn = scene()

       -- Camera entity
       local cam = scn:entity("camera")
       cam:add(camera.perspective(60))
       cam:add(camera.rigs.orbit)
       cam.z = -10

       -- A sphere
       local sphere = scn:entity("sphere")
       sphere:add(mesh.sphere(1))

       -- Make this the active scene
       scene.main = scn
   end

Creating Scenes
---------------

Create a new scene by calling :lua:class:`scene` as a constructor. Assign it to ``scene.main`` to start rendering it each frame.

.. code-block:: lua

   scn = scene()
   scene.main = scn

You can have multiple scenes and switch between them by reassigning ``scene.main``.

Entities
--------

Entities are the basic building blocks of a scene. They have a transform (position, rotation, scale) and can hold any number of components.

Create entities with ``scene:entity()``:

.. code-block:: lua

   -- Named entity (accessible by name later)
   local ball = scn:entity("ball")

   -- Access by name
   print(scn.ball)

Child entities are created under an existing entity and inherit its transform:

.. code-block:: lua

   local arm = scn:entity("arm")
   local hand = arm:child("hand")
   hand.z = 2  -- 2 units ahead of the arm's local origin

Components
----------

Components add behaviour to entities. Attach them with :lua:meth:`entity.add`:

.. code-block:: lua

   local sphere = scn:entity("sphere")

   -- Add a mesh
   sphere:add(mesh.sphere(1))

   -- Add a lit material
   sphere.material = material.lit()

   -- Add a 3D physics body
   sphere:add(physics3d.body(physics3d.DYNAMIC))
   sphere:add(physics3d.sphere(1))

Custom Lua classes are also valid components:

.. code-block:: lua

   Rotator = class("Rotator")

   function Rotator:update(dt)
       self.entity.ry = self.entity.ry + dt * 90
   end

   local cube = scn:entity()
   cube:add(mesh.box())
   cube:add(Rotator)

The Scene Camera
----------------

Every scene needs at least one camera entity with a :lua:class:`camera` component attached:

.. code-block:: lua

   local cam = scn:entity("camera")
   cam:add(camera.perspective(60))   -- 60° field of view
   cam.z = -5                        -- Pull back 5 units

Use ``camera.rigs.orbit`` to add an interactive orbit controller that works with mouse and touch:

.. code-block:: lua

   cam:add(camera.rigs.orbit)

Lifecycle Callbacks
-------------------

Entities respond to lifecycle callbacks that mirror Codea's global callbacks. Define them as properties or override them in Lua component classes:

.. code-block:: lua

   local ent = scn:entity()

   ent.update = function(dt)
       ent.ry = ent.ry + dt * 45
   end

   ent.touched = function(touch)
       if touch.began then
           ent:destroy()
       end
       return true  -- capture the touch
   end
