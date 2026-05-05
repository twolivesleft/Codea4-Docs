2D Physics (Box2D)
==================

2D Physics in Codea
-------------------

Codea's 2D physics system is built on Box2D. It simulates rigid body dynamics with forces, joints, sensors, and collision callbacks in the XY plane.

2D physics can be used standalone with ``physics2d.world``, or integrated with the scene system using entity components.

Creating Physics Worlds
-----------------------

A standalone 2D physics world lets you manage the simulation and draw using the immediate mode API:

.. code-block:: lua

   function setup()
       world = physics2d.world()
       world.gravity = vec2(0, -9.8)

       -- Static ground
       ground = world:body(physics2d.STATIC)
       ground:add(physics2d.box(WIDTH, 20))
       ground.position = vec2(WIDTH/2, 10)

       -- Dynamic circle
       ball = world:body(physics2d.DYNAMIC)
       ball:add(physics2d.circle(20))
       ball.position = vec2(WIDTH/2, HEIGHT/2)
   end

   function update(dt)
       world:update(dt)
   end

   function draw()
       background(40, 40, 50)
       fill(255, 100, 100)
       circle(ball.position.x, ball.position.y, 20)
   end

Body types:

- ``physics2d.STATIC`` — immovable, acts as ground or walls
- ``physics2d.DYNAMIC`` — moved by forces and gravity
- ``physics2d.KINEMATIC`` — moved manually, pushes dynamic bodies

Using Physics with Entities
---------------------------

Attach 2D physics components to scene entities for automatic simulation:

.. code-block:: lua

   function setup()
       scn = scene()

       -- Set up a 2D canvas camera
       local cam = scn:entity("camera")
       cam:add(camera.rigs.canvas)

       -- Ground
       local ground = scn:entity("ground")
       ground:add(physics2d.body(physics2d.STATIC))
       ground:add(physics2d.box(400, 20))
       ground.position = vec3(WIDTH/2, 10, 0)

       -- Ball
       local ball = scn:entity("ball")
       ball.sprite = asset.builtin.Blocks.Yellow_Circle
       ball:add(physics2d.body(physics2d.DYNAMIC))
       ball:add(physics2d.circle(32))
       ball.position = vec3(WIDTH/2, HEIGHT/2, 0)

       scene.main = scn
   end

Collision Shapes
----------------

- ``physics2d.circle(radius)`` — circular collider
- ``physics2d.box(width, height)`` — rectangular collider
- ``physics2d.polygon(vertices)`` — arbitrary convex polygon, vertices as a table of vec2
- ``physics2d.chain(vertices, loop)`` — open or closed chain of line segments (STATIC only)
- ``physics2d.edge(start, end)`` — single line segment (STATIC only)

Collision Callbacks
-------------------

React to collisions through entity callbacks:

.. code-block:: lua

   local ball = scn:entity()
   ball:add(physics2d.body(physics2d.DYNAMIC))
   ball:add(physics2d.circle(20))

   ball.collisionBegan2d = function(contact)
       print("Collision with impulse:", contact.normalImpulse)
   end

Sensors
-------

Sensors detect overlaps without generating collision responses:

.. code-block:: lua

   local trigger = scn:entity("trigger")
   trigger:add(physics2d.body(physics2d.STATIC))
   local col = trigger:add(physics2d.circle(50))
   col.isSensor = true

   trigger.collisionBegan2d = function(contact)
       print("Something entered the trigger zone")
   end

Forces and Impulses
-------------------

Control dynamic bodies with forces and impulses:

.. code-block:: lua

   local body = ent:get(physics2d.body)

   -- Push upward continuously (apply in update)
   body:applyForce(vec2(0, 500))

   -- Instant kick
   body:applyImpulse(vec2(100, 0))

   -- Set velocity directly
   body.linearVelocity = vec2(5, 0)
