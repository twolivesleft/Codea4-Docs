physics3d
=========

.. lua:module:: physics3d

.. lua:class:: world

   .. lua:staticmethod:: world()

      Create a new physics world

   .. lua:method:: body(type, x, y, z)

      Create a new rigidbody in this world

      :param type: The type of body, `STATIC`, `DYNAMIC` or `KINEMATIC`
      :type type: enum
      :param x: The initial x position of the new body
      :type x: number
      :param y: The initial y position of the new body
      :type y: number
      :param z: The initial z position of the new body
      :type z: number

      :return: The newly created body
      :rtype: physics3d.body

   .. lua:method:: step([deltaTime])

      Steps the simulation by ``deltaTime``

   .. lua:method:: draw()

      Draws a debug representation of the physics world using primitive shapes

   .. lua:method:: raycast(origin, direction, distance[, mask])

      Performs a raycast on the physics world from ``origin`` in the direction of ``direction`` for the distance of ``distance``

      The raycast itself is filtered by the optional ``mask`` parameter, a bitfield which is compared to collider categories

      :param origin: The origin of the ray
      :type origin: vec3

      :param direction: The direction of the ray
      :type direction: vec3

      :param distance: The maximum distance for the ray to travel
      :type distance: number

      :return: The raycast hit info or ``nil`` is no collider was hit
      :rtype: physics3d.rayHit

   .. lua:method:: sphereCast(origin, direction, distance, radius[, mask])

      Performs a sphere cast on the physics world from ``origin`` in the direction of ``direction`` for the distance of ``distance``

      The sphere cast itself is filtered by the optional ``mask`` parameter, a bitfield which is compared to collider categories

      :param origin: The origin of the ray
      :type origin: vec3

      :param direction: The direction of the ray
      :type direction: vec3

      :param distance: The maximum distance for the ray to travel
      :type distance: number

      :param radius: The radius of the sphere used to perform the cast
      :type distance: number

      :return: The raycast hit info or ``nil`` is no collider was hit
      :rtype: physics3d.rayHit      

   .. lua:attribute:: gravity: vec3

      The current gravity vector for this world

.. lua:class:: body

   A three dimensional rigidbody that simulated within a :lua:class:`physics3d.world`. Used to simulate both dynamic and static objects, responding to physical forces, collisions and physics queries (i.e. raycast, queryBox, etc...)

   .. lua:method:: destroy()

      Destroys this body, removing it from the world in the next simluation step

   .. lua:method:: sphere(radius, [offsetX, offsetY, offsetZ])

      Creates and attaches a sphere collider to this body

      :param radius: The radius of the circle
      :type radius: number

      :param offsetX: The local x offset of the circle
      :type radius: number

      :param offsetY: The local y offset of the circle
      :type radius: number

      :param offsetZ: The local y offset of the circle
      :type radius: number

      :return: The new circle collider
      :rtype: physics3d.sphere

   .. lua:method:: box(halfWidth, halfHeight, halfDepth, [offsetX, offsetY, offsetZ])

      Creates and attaches a box collider to this body

      :param halfWidth: half width of the box
      :type radius: number

      :param halfHeight: half height of the box
      :type radius: number

      :param halfDepth: half depth of the box
      :type radius: number

      :param offsetX: The local x offset of the circle
      :type radius: number

      :param offsetY: The local y offset of the circle
      :type radius: number

      :param offsetZ: The local y offset of the circle
      :type radius: number

      :return: The new box collider
      :rtype: physics3d.box

   .. lua:method:: capsule(radius, height[, offsetX, offsetY, offsetZ])

      Creates and attaches a capsule collider to this body

      :param radius: The radius of the capsule
      :type radius: number

      :param radius: The height of the capsule
      :type radius: number

      :param offsetX: The local x offset of the circle
      :type radius: number

      :param offsetY: The local y offset of the circle
      :type radius: number

      :param offsetZ: The local y offset of the circle
      :type radius: number

      :return: The new capsule collider
      :rtype: physics3d.polygon

   .. lua:method:: mesh(mesh[, convex])

      Creates and attaches a mesh collider to this body

      :return: The new capsule collider
      :rtype: physics3d.mesh

   .. lua:method:: hinge(anchor, axis)
                   hinge(other, anchor, axis)
                   hinge(other, anchorA, axisA, anchorB, axisB)

      Creates and attaches a hinge joint to this body. When no other body is provided the hinge joint attaches to the world itself

      For two-body joints when one ``anchor`` and ``axis`` is provided, it will be interpreted as a world space location, which will attach to the relative locations of both bodies
      
      When two anchors and axes are provided (``anchorA`` / ``axisA`` and ``anchorB`` / ``axisB``) are provided, they will be interpreted in local space and attach to those locations directly

      :param other: The other body to connect to the joint
      :type other: physics3d.body

      :param anchor: The world-space anchor for one or two-body hinges
      :type anchor: vec3

      :param axis: The world-space axis for one or two-body hinges
      :type anchor: vec3

      :param anchorA: The local-space anchor for the main body
      :type anchorA: vec3

      :param axisA: The local-space axis for the main body
      :type axisA: vec3

      :param anchorB: The local-space anchor for the attached body
      :type anchorB: vec3

      :param axisB: The local-space axis for the attached body
      :type axisB: vec3

      :return: The new hinge joint
      :rtype: physics3d.hinge

   .. lua:method:: applyForce(force[, worldPoint])

      Applies a force to this body over time (non-instantanious). Ideal for physical effects such as wind, bouyancy and springs

      The optional parameter ``worldPoint`` can be used to apply forces to a specific location in world-space

      :param force: The force to apply
      :type force: vec3

      :param worldPoint: The world-space location to apply the force at
      :type worldPoint: vec3

      :param force: The force vector to apply
      :type force: vec2

   .. lua:method:: applyTorque(torque)

      :param torque: The torque vector to apply
      :type torque: vec3

   .. lua:method:: applyLinearImpulse(impulse)

      :param impulse: The linear impulse to apply
      :type impulse: vec3

   .. lua:method:: applyAngularImpulse(impulse)

      :param impulse: The angular impulse to apply
      :type impulse: vec3

   .. lua:method:: worldPoint(localPoint)

      Transforms ``localPoint`` from local space to world space in respect to this body

      :param localPoint: The local space point to transform
      :type localPoint: vec3

      :rtype: vec3

   .. lua:method:: worldVector(localVector)

      Transforms ``localVector`` from world space to local space in respect to this body

      :param localVector: The world space vector to transform
      :type localVector: vec3

      :rtype: vec3

   .. lua:method:: localPoint(worldPoint)

      Transforms ``worldPoint`` from world space to local space in respect to this body

      :param worldPoint: The world space point to transform
      :type worldPoint: vec3

      :rtype: vec3

   .. lua:method:: localVector(worldVector)

      Transforms ``worldVector`` from world space to local space in respect to this body

      :param worldVector: The world space vector to transform
      :type worldVector: vec3

      :rtype: vec3

   .. lua:method:: velocityAtLocalPoint(localPoint)

      Samples the velocity of the body at ``localPoint`` in local space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param localPoint: The local point to sample velocity from
      :type localPoint: vec3

      :rtype: vec3

   .. lua:method:: velocityAtWorldPoint(worldPoint)

      Samples the velocity of the body at ``worldPoint`` in world space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param worldPoint: The world point to sample velocity from
      :type worldPoint: vec3

      :rtype: vec3

   .. lua:attribute:: destroyed: boolean

      Flag indicating that this body has already been destroyed

   .. lua:attribute:: position: vec3

      The position of this body in the simulated world

   .. lua:attribute:: mass: number

      The mass of this body in kilograms

   .. lua:attribute:: inertia: number (readonly)

      The interial tensor in kg m^2

   .. lua:attribute:: linearDamping: number

      The amount of linear damping to apply, slowing velocity proportionally over time

   .. lua:attribute:: angularDamping: number

      The amount of linear damping to apply, slowing rotation propotionally over time

   .. lua:attribute:: sleepingAllowed: boolean

      Flag for allowing sleeping for this body

   .. lua:attribute:: awake: boolean

      Flag for the current awake state of this body, set to ``true`` to wake immediately

   .. lua:attribute:: enabled: boolean

      Flag for whether simulation is enabled

   .. lua:attribute:: constraints: bitfield 

      Flags to lock movement and rotation along each axis, using the following flags:

      * ``physics3d.freezePositionX``
      * ``physics3d.freezePositionY``
      * ``physics3d.freezePositionZ``
      * ``physics3d.freezeRotationX``
      * ``physics3d.freezeRotationY``
      * ``physics3d.freezeRotationZ``
      * ``physics3d.freezeRotation``
      * ``physics3d.freezePosition``
      * ``physics3d.freezeAll``

      These flags can also be combined, i.e. ``myBody.constraints = physics3d.freezePositionX | physics3d.freezeRotation``

   .. lua:attribute:: bullet: boolean

      Continuous physics switch for this body, used to prevent tunneling for fast moving objects

.. lua:class:: collider

   TODO

.. lua:class:: sphere: collider

   TODO

.. lua:class:: box: collider

   TODO

.. lua:class:: capsule: collider

   TODO

.. lua:class:: mesh: collider

   TODO

.. lua:class:: cylinder: collider

   TODO

.. lua:class:: cone: collider

   TODO

.. lua:class:: joint

   TODO

.. lua:class:: hinge: joint

   TODO

.. lua:class:: slider: joint

   TODO

.. lua:class:: ballSocket: joint

   TODO

.. lua:class:: coneTwist: joint

   TODO

.. lua:class:: generic: joint

   TODO

.. lua:class:: weld: joint

   TODO

.. lua:class:: rayHit

   .. lua:attribute:: point: vec3

      The world position of the raycast hit location

   .. lua:attribute:: normal: vec3

      The world normal of the raycast hit location

   .. lua:attribute:: fraction: number

      The fraction of the total ray distance travelled before a hit was detected

   .. lua:attribute:: triangleIndex: integer

      The index of the triangle hit (if we hit a mesh collider)

   .. lua:attribute:: uv: vec2

      The uv coorindate of the triangle hit (if we hit a mesh collider)

   .. lua:attribute:: barycentric: vec2

      The barycentric coorindate of the triangle hit (if we hit a mesh collider)

   .. lua:attribute:: collider: physics3d.collider

      The collider that was hit by the ray

   .. lua:attribute:: body: physics3d.body

      The body of the collider that was hit by the ray      