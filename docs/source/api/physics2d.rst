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

   .. lua:method:: step([deltaTime])

      Steps the simulation by ``deltaTime``

   .. lua:method:: draw()

      Draws a debug representation of the physics world using primitive shapes

   .. lua:method:: raycast(origin, direction, distance[, mask])

      Performs a raycast on the physics world from ``origin`` in the direction of ``direction`` for the distance of ``distance``

      The raycast itself is filtered by the optional ``mask`` parameter, a bitfield which is compared to collider categories

      :param origin: The origin of the ray
      :type origin: vec2

      :param direction: The direction of the ray
      :type direction: vec2

      :param distance: The maximum distance for the ray to travel
      :type distance: number

      :return: The raycast hit info or nil is no collider was hit
      :rtype: physics2d.rayHit

   .. lua:method:: overlapBox(origin, size[, mask])

   .. lua:method:: queryBox(origin, size[, mask])

   .. lua:method:: queryBoxAll(origin, size[, mask])


   .. lua:attribute:: gravity: vec2

      The current gravity vector for this world

.. lua:class:: body

   A two dimensional rigidbody that simulated within a :lua:class:`physics2d.world`. Used to simulate both dynamic and static objects, responding to physical forces, collisions and physics queries (i.e. raycast, queryBox, etc...)

   .. lua:method:: destroy()

      Destroys this body, removing it from the world in the next simluation step

   .. lua:method:: circle(radius, [offsetX, offsetY])

      Creates and attaches a circle collider to this body

      :param radius: The radius of the circle
      :type radius: number

      :param radius: The local x offset of the circle
      :type radius: number

      :param radius: The local y offset of the circle
      :type radius: number

      :return: The new circle collider
      :rtype: physics2d.circle

   .. lua:method:: box(halfWidth, halfHeight, [offsetX, offsetY, rotation])

      Creates and attaches a box collider to this body

      :return: The new box collider
      :rtype: physics2d.box

   .. lua:method:: polygon(points)

      Creates and attaches a polygon collider to this body

      :return: The new polygon collider
      :rtype: physics2d.polygon

   .. lua:method:: hinge(anchor)
                   hinge(other, anchor)
                   hinge(other, anchorA, anchorB)

      Creates and attaches a hinge joint to this body. When no other body is provided the hinge joint attaches to the world itself

      For two-body joints when one ``anchor`` is provided, it will be interpreted as a world space location, which will attach to the relative locations of both bodies. When two anchors (``anchorA`` and ``anchorB``) are provided, they will be interpreted in local space and attach to those locations directly

      :param other: The other body to connect to the joint
      :type other: physics2d.body

      :param anchor: The world-space anchor for one or two-body hinges
      :type anchor: vec2

      :param anchorA: The local-space anchor for the main body
      :type anchorA: vec2

      :param anchorB: The local-space anchor for the attached body
      :type anchorB: vec2

      :return: The new hinge joint
      :rtype: physics2d.hinge

   .. lua:method:: slider(anchor, axis)
                   slider(other, anchor, axis)
                   slider(other, anchorA, anchorB, axis)

      Creates and attaches a slider joint to this body. When no other body is provided the slider joint attaches to the world itself

      :return: The new slider joint
      :rtype: physics2d.slider

   .. lua:method:: distance(anchorA, anchorB)
                   distance(other, anchorA, anchorB)
                   distance(other, anchorA, anchorB)

      Creates and attaches a distance joint to this body. When no other body is provided the distance joint attaches to the world itself.

      For two-body joints when one anchor is provided, it will be interpreted as a world space location, which will attach to the relative locations of both bodies. When two anchors are provided, they will be interpreted in local space and attach to those locations directly

      :return: The new distance joint
      :rtype: physics2d.distance

   .. lua:method:: applyForce(force)

      Applies a force to this body over time (non-instantanious). Ideal for physical effects such as wind, bouyancy and springs

      :param force: The force vector to apply
      :type force: vec2

   .. lua:method:: applyTorque(torque)

      :param torque: The torque vector to apply
      :type torque: number

   .. lua:method:: applyLinearImpulse(impulse)

      :param impulse: The linear impulse to apply
      :type impulse: vec2

   .. lua:method:: applyAngularImpulse(impulse)

      :param impulse: The angular impulse to apply
      :type impulse: number

   .. lua:method:: worldPoint(localPoint)

      Transforms ``localPoint`` from local space to world space in respect to this body

      :param localPoint: The local space point to transform
      :type localPoint: vec2

      :rtype: vec2

   .. lua:method:: worldVector(localVector)

      Transforms ``localVector`` from world space to local space in respect to this body

      :param localVector: The world space vector to transform
      :type localVector: vec2

      :rtype: vec2

   .. lua:method:: localPoint(worldPoint)

      Transforms ``worldPoint`` from world space to local space in respect to this body

      :param worldPoint: The world space point to transform
      :type worldPoint: vec2

      :rtype: vec2

   .. lua:method:: localVector(worldVector)

      Transforms ``worldVector`` from world space to local space in respect to this body

      :param worldVector: The world space vector to transform
      :type worldVector: vec2

      :rtype: vec2

   .. lua:method:: velocityAtLocalPoint(localPoint)

      Samples the velocity of the body at ``localPoint`` in local space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param localPoint: The local point to sample velocity from
      :type localPoint: vec2

      :rtype: vec2

   .. lua:method:: velocityAtWorldPoint(worldPoint)

      Samples the velocity of the body at ``worldPoint`` in world space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param worldPoint: The world point to sample velocity from
      :type worldPoint: vec2

      :rtype: vec2

   .. lua:attribute:: destroyed: boolean

      Flag indicating that this body has already been destroyed

   .. lua:attribute:: position: vec2

      The position of this body in the simulated world

   .. lua:attribute:: mass: number (readonly)

      The mass of this body in kilograms

   .. lua:attribute:: inertia: number

      The interial tensor in kg m^2

   .. lua:attribute:: linearDamping: number

      The amount of linear damping to apply, slowing velocity proportionally over time

   .. lua:attribute:: angularDamping: number

      The amount of linear damping to apply, slowing rotation propotionally over time

   .. lua:attribute:: gravityScale: number

      The scale factor to apply to global gravity, settings 0 will disable gravity

   .. lua:attribute:: bullet: boolean

      Continuous physics switch for this body, used to prevent tunneling for fast moving objects

   .. lua:attribute:: sleepingAllowed: boolean

      Flag for allowing sleeping for this body

   .. lua:attribute:: awake: boolean

      Flag for the current awake state of this body, set to ``true`` to wake immediately

   .. lua:attribute:: enabled: boolean

      Flag for whether simulation is enabled

   .. lua:attribute:: fixedRotation: boolean

      Flag for fixed rotation state, set to ``false`` to disable rotation

   .. lua:attribute:: onCollisionBegan: function<physics2d.contact>

      A callback for when a collision with this body begins, with more information provided by the supplied :lua:class:`physics2d.contact` object

   .. lua:attribute:: onCollisionEnded: function<physics2d.contact>

      A callback for when a collision with this body ends, with more information provided by the supplied :lua:class:`physics2d.contact` object

   .. lua:attribute:: onPreSolve: function<physics2d.contact>

      A callback for when a collision with this body is about to be solved, allowing for some :lua:class:`physics2d.contact` parameters to be modified

      See: https://box2d.org/documentation/classb2_contact_listener.html

   .. lua:attribute:: onPostSolve: function<physics2d.contact>

      A callback for when a collision with this body has been solved, allowing for some :lua:class:`physics2d.contact` information to be used for other purposes

      See: https://box2d.org/documentation/classb2_contact_listener.html

.. lua:class:: collider

   .. lua:method:: destroy()

   .. lua:attribute:: destroyed: boolean
   .. lua:attribute:: friction: number
   .. lua:attribute:: density: number
   .. lua:attribute:: restitution: number
   .. lua:attribute:: sensor: boolean
   .. lua:attribute:: catgeory: integer (bitfield)
   .. lua:attribute:: mask: integer (bitfield)
   .. lua:attribute:: group: integer
   .. lua:attribute:: body: physics2d.body

.. lua:class:: circle: collider

   .. lua:attribute:: radius: number
   .. lua:attribute:: center: vec2

.. lua:class:: box: collider

   .. lua:attribute:: center: vec2
   .. lua:attribute:: size: vec2
   .. lua:attribute:: angle: number

.. lua:class:: polygon: collider

   .. lua:attribute:: points: table<vec2>

.. lua:class:: joint

   .. lua:method:: destroy()

   .. lua:method:: getReactionForce(invDt)
   .. lua:method:: getReactionTorque(invDt)

   .. lua:attribute:: enabled: boolean
   .. lua:attribute:: destroyed: boolean
   .. lua:attribute:: collideConnected: boolean
   .. lua:attribute:: anchorA: vec2
   .. lua:attribute:: anchorB: vec2
   .. lua:attribute:: localAnchorA: vec2
   .. lua:attribute:: localAnchorB: vec2
   .. lua:attribute:: other: physics2d.body

.. lua:class:: hinge: joint

   .. lua:attribute:: referenceAngle: number
   .. lua:attribute:: angle: number
   .. lua:attribute:: speed: number
   .. lua:attribute:: useMotor: boolean
   .. lua:attribute:: maxTorque: number
   .. lua:attribute:: motorSpeed: number
   .. lua:attribute:: useLimit: number
   .. lua:attribute:: lowerLimit: number
   .. lua:attribute:: upperLimit: number

.. lua:class:: slider: joint

   .. lua:attribute:: referenceAngle: number
   .. lua:attribute:: translation: number
   .. lua:attribute:: speed: number
   .. lua:attribute:: useMotor: boolean
   .. lua:attribute:: maxForce: number
   .. lua:attribute:: motorSpeed: number
   .. lua:attribute:: useLimit: number
   .. lua:attribute:: lowerLimit: number
   .. lua:attribute:: upperLimit: number

.. lua:class:: distance: joint

   .. lua:attribute:: length: number
   .. lua:attribute:: currentLength: number
   .. lua:attribute:: stiffness: number
   .. lua:attribute:: damping: number
   .. lua:attribute:: minLength: number
   .. lua:attribute:: maxLength: number

.. lua:class:: pulley: joint

   *Not implemented yet*

.. lua:class:: target: joint

   *Not implemented yet*

.. lua:class:: gear: joint

   *Not implemented yet*

.. lua:class:: weld: joint

   *Not implemented yet*

.. lua:class:: friction: joint

   *Not implemented yet*

.. lua:class:: rope: joint

   *Not implemented yet*

.. lua:class:: motor: joint

   *Not implemented yet*

.. lua:class:: rayHit

   .. lua:attribute:: point: vec2

      The world position of the raycast hit location

   .. lua:attribute:: normal: vec2

      The world normal of the raycast hit location

   .. lua:attribute:: fraction: number

      The fraction of the total ray distance travelled before a hit was detected

   .. lua:attribute:: collider: physics2d.collider

      The collider that was hit by the ray

.. lua:class:: contact

   .. lua:attribute:: enabled: boolean

      Whether the contact is currently enabled, which can be set to false within the :lua:attr:`physics2d.body.onPreSolve` callback

      Useful for one way platforms (checking collision normals and conditionally disabling them)

   .. lua:attribute:: touching: boolean

      Where the contact is currently touching (in some cases this may be false during collision resolution substeps)

   .. lua:attribute:: friction: number

      The friction of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

   .. lua:attribute:: restitution: number

      The restitution of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

   .. lua:attribute:: tangentSpeed: number

      The tangent of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

      Useful for creating things like conveyor belts which have a moving surface while remaining stationary

   .. lua:attribute:: localPoint: vec2

      The local position of the contact point (averaged from the manifold)

   .. lua:attribute:: worldPoint: vec2

      The world position of the contact point (averaged from the manifold)

   .. lua:attribute:: localNormal: vec2

      The local normal of the contact point (averaged from the manifold)

   .. lua:attribute:: worldNormal: vec2

      The world normal of the contact point (averaged from the manifold)

   .. lua:attribute:: body: physics2d.body

      The first body in this contact (the body receiving the callback)

   .. lua:attribute:: otherBody: physics2d.body

      The second body involved in this collision contact

   .. lua:attribute:: collider: physics2d.collider

      The first collider in this contact (attached to the body recieving the callback)

   .. lua:attribute:: otherCollider: physics2d.collider

      The second collider involved in this collision contact
