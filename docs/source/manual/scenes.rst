Scenes
======

Scenes in Codea
---------------

A :lua:class:`scene` holds the objects in a 2D or 3D world. Each object is an :lua:class:`entity`; add components such as a mesh, camera, light, or physics body to give it an appearance or behavior.

Codea draws and updates the scene for you, including its physics simulation.

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

Create a scene with ``scene()`` and assign it to ``scene.main`` to draw and update it each frame.

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

Give an entity an ``update()`` function to move it each frame, or a ``touched()`` function to respond to touches. You can also define these functions in a Lua component:

.. code-block:: lua

   local ent = scn:entity()

   function ent:update(dt)
       self.ry = self.ry + dt * 45
   end

   function ent:touched(touch)
       if touch.began then
           self:destroy()
       end
       return true  -- capture the touch
   end
