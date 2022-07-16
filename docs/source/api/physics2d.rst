physics2d
==========

.. lua:module:: physics2d

.. lua:class:: world

   .. lua:staticmethod:: world()

      Create a new physics world

   .. lua:method:: body(type, x, y)

      Create a new rigidbody in this world

      :param type: The type of body, `STATIC`, `DYNAMIC` or `KINEMATIC`
      :type type: enum
      :param x: The initial x position of the new body
      :type x: number
      :param y: The initial y position of the new body
      :type y: number

   .. lua:method:: step(deltaTime)

   .. lua:method:: draw()

   .. lua:method:: raycast(origin, direction, distance, mask)

   .. lua:method:: overlapBox(origin, size, mask)

   .. lua:method:: queryBox(origin, size, mask)

   .. lua:method:: queryBoxAll(origin, size, mask)


   .. lua:attribute:: gravity: vec2

      The current gravity vector for this world

.. lua:class:: body

   A two dimensional rigidbody that belongs to a given physics world. Used to simulate both dynamic and static objects, responding to collisions and various queries

   .. lua:method:: circle(radius, [offsetX, offsetY])

   .. lua:method:: box(halfWidth, halfHeight, [offsetX, offsetY, rotation])

   .. lua:method:: polygon(points)

   .. lua:method:: hinge(worldSpaceAnchor)
                   hinge(otherBody, worldSpaceAnchor)
                   hinge(otherBody, localAnchor, otherLocalAnchor)

      Creates and attaches a hinge joint to this body. When no other body is provided the higne joint attaches to the world itself.

      For two body joints when one anchor is provided, it will be interpreted as a world space location, which will attach to the relative locations of both bodies. When two anchors are provided, they will be interpreted in local space and attach to those locations directly

   .. lua:method:: slider(otherBody, worldSpaceAnchor)
                   slider(otherBody, localAnchor, otherLocalAnchor)


   .. lua:method:: applyForce(impulse)

   .. lua:method:: applyTorque(torque)

   .. lua:method:: applyLinearImpulse(impulse)

   .. lua:method:: applyAngularImpulse(impulse)

   .. lua:method:: worldPoint(localPoint)

   .. lua:method:: worldVector(localVector)

   .. lua:method:: localPoint(worldPoint)

   .. lua:method:: localVector(worldVector)

   .. lua:method:: velocityAtLocalPoint(localPoint)

   .. lua:method:: velocityAtWorldPoint(worldPoint)

   .. lua:attribute:: position: vec2

      The position of this body in the simulated world

   .. lua:attribute:: mass: number

   .. lua:attribute:: inertia: number

   .. lua:attribute:: linearDamping: number

   .. lua:attribute:: angularDamping: number

   .. lua:attribute:: gravityScale: number

   .. lua:attribute:: bullet: boolean

   .. lua:attribute:: sleepingAllowed: boolean

   .. lua:attribute:: awake: boolean

   .. lua:attribute:: enabled: boolean

   .. lua:attribute:: fixedRotation: boolean

.. lua:class:: collider

.. lua:class:: circle: collider

.. lua:class:: box: collider

.. lua:class:: polygon: collider

.. lua:class:: joint

.. lua:class:: hinge: joint

.. lua:class:: slider: joint

.. lua:class:: distance: joint

.. lua:class:: pulley: joint

.. lua:class:: target: joint

.. lua:class:: gear: joint

.. lua:class:: weld: joint

.. lua:class:: friction: joint

.. lua:class:: rope: joint

.. lua:class:: motor: joint

.. lua:class:: rayHit

   .. lua:attribute:: point: vec2
   .. lua:attribute:: normal: vec2
   .. lua:attribute:: fraction: number
   .. lua:attribute:: collider: physics2d.collider

.. lua:class:: contact

   .. lua:attribute:: enabled: boolean
   .. lua:attribute:: enabled: touching
   .. lua:attribute:: friction: number
   .. lua:attribute:: restitution: number
   .. lua:attribute:: tangentSpeed: number
   .. lua:attribute:: localPoint: vec2
   .. lua:attribute:: worldPoint: vec2
   .. lua:attribute:: localNormal: vec2
   .. lua:attribute:: worldNormal: vec2
   .. lua:attribute:: body: physics2d.body
   .. lua:attribute:: otherBody: physics2d.body
   .. lua:attribute:: collider: physics2d.collider
   .. lua:attribute:: otherCollider: physics2d.collider
