3D Physics (Bullet 3D)
======================

3D Physics in Codea
-------------------

Codea's 3D physics system is built on the Bullet physics engine. It provides rigid body dynamics with support for forces, impulses, joints, and collision events.

3D physics can be used in two ways: standalone with ``physics3d.world``, or integrated with the scene system via entity components.

Creating Physics Worlds
-----------------------

A standalone physics world manages its own simulation loop:

.. code-block:: lua

   function setup()
       world = physics3d.world()
       world.gravity = vec3(0, -9.8, 0)

       -- Create a ground plane
       ground = world:body(physics3d.STATIC)
       ground:add(physics3d.plane(vec3(0, 1, 0), 0))

       -- Create a dynamic sphere
       ball = world:body(physics3d.DYNAMIC)
       ball:add(physics3d.sphere(0.5))
       ball.position = vec3(0, 5, 0)
   end

   function update(dt)
       world:update(dt)
   end

   function draw()
       -- Draw the ball position
       pushMatrix()
       translate(ball.position.x, ball.position.y, ball.position.z)
       sphere(0.5)
       popMatrix()
   end

Body types:

- ``physics3d.STATIC`` — does not move, acts as immovable scenery
- ``physics3d.DYNAMIC`` — moved by forces and collisions
- ``physics3d.KINEMATIC`` — moved manually via code, pushes dynamic bodies without being affected by gravity

Using Physics with Entities
---------------------------

When working with a :lua:class:`scene`, attach physics components directly to entities:

.. code-block:: lua

   function setup()
       scn = scene()

       local cam = scn:entity("camera")
       cam:add(camera.perspective(60))
       cam:add(camera.rigs.orbit)
       cam.z = -10

       -- Static ground
       local ground = scn:entity("ground")
       ground:add(mesh.plane())
       ground:add(physics3d.body(physics3d.STATIC))
       ground:add(physics3d.box(vec3(10, 0.1, 10)))
       ground.material = material.lit()

       -- Dynamic box
       local box = scn:entity("box")
       box:add(mesh.box())
       box:add(physics3d.body(physics3d.DYNAMIC))
       box:add(physics3d.box(vec3(1, 1, 1)))
       box.y = 5
       box.material = material.lit()

       scene.main = scn
   end

The scene automatically steps the physics simulation each frame.

Collision Shapes
----------------

Choose the collision shape that best matches your object's visual appearance. Simpler shapes perform better:

- ``physics3d.sphere(radius)`` — sphere
- ``physics3d.box(halfExtents)`` — axis-aligned box, parameter is half-widths as a vec3
- ``physics3d.capsule(radius, height)`` — capsule (good for characters)
- ``physics3d.cylinder(radius, height)`` — cylinder
- ``physics3d.cone(radius, height)`` — cone
- ``physics3d.plane(normal, constant)`` — infinite plane, STATIC only
- ``physics3d.hull(points)`` — convex hull around a set of points

.. code-block:: lua

   body:add(physics3d.sphere(1))
   body:add(physics3d.box(vec3(0.5, 1, 0.5)))
   body:add(physics3d.capsule(0.4, 1.8))

Collision Callbacks
-------------------

React to collisions through entity callbacks or body callbacks:

.. code-block:: lua

   local box = scn:entity()
   box:add(physics3d.body(physics3d.DYNAMIC))
   box:add(physics3d.box(vec3(1,1,1)))

   box.collisionBegan3d = function(contact)
       print("Hit something!", contact.impulse)
   end

The ``contact`` object contains ``impulse`` (force magnitude) and ``normal`` (collision normal vector).

Forces and Impulses
-------------------

Apply forces and impulses to dynamic bodies to set them in motion:

.. code-block:: lua

   local body = ent:get(physics3d.body)

   -- Continuous force (applied each frame, use in update)
   body:applyForce(vec3(0, 100, 0))

   -- Instant impulse (applied once)
   body:applyImpulse(vec3(0, 10, 0))

   -- Torque (rotational force)
   body:applyTorque(vec3(0, 5, 0))

   -- Set velocity directly
   body.linearVelocity = vec3(1, 0, 0)
   body.angularVelocity = vec3(0, 1, 0)
