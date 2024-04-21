physics2d
==========

.. lua:module:: physics2d

Simulation
**********

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

      :param offsetX: The local x offset of the circle
      :type radius: number

      :param offsetY: The local y offset of the circle
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

Collision
*********

.. lua:class:: collider

   A two dimensional collider that attaches to a `physics2d.body`, detects and reacts to collisions

   .. lua:method:: destroy()

      Destroys this collider, removing it in the next simluation step

   .. lua:attribute:: destroyed: boolean

      Flag indicating that this collider has already been destroyed

   .. lua:attribute:: friction: number

      The coefficient of friction for this collider

   .. lua:attribute:: density: number

      The density of this collider

   .. lua:attribute:: restitution: number

      The coefficient of restitution for this collider

   .. lua:attribute:: sensor: boolean

      Flag turning this collider into a sensor. Sensors do not physically collide with object bodies but will still report collision detection via callbacks

   .. lua:attribute:: catgeory: integer (bitfield)

      The category for this collider. Categories are used to filter collisions based on their ``mask`` bits

      .. code-block:: lua         
         :caption: Example

         PLAYER_CAT = 0x1 -- set bit 1
         ENEMY_CAT = 0x2 -- set bit 2
         ITEM_CAT = 0x4 -- set bit 3

         -- Players can collider with enemies and items
         playerCollider.category = PLAYER_CAT
         playerCollider.mask = ENEMY_CAT | ITEM_CAT

         -- Enemies only collider with players
         enemyCollider.category = ENEMY_CAT
         enemyCollider.mask = PLAYER_CAT

         -- Items only collider with players
         itemCollider.category = ITEM_CAT
         itemCollider.mask = PLAYER_CAT

   .. lua:attribute:: mask: integer (bitfield)

      The mask determines what categories this collider will pass collision filtering. If the mask bits are set for at least one category of a potential collision partner then a collision will be possible 

   .. lua:attribute:: group: integer

      The group index is used for another extra layer of collision filtering. If two colliders have the same group and are positive, they will always collider, and if they are both negative then they will never collide

   .. lua:attribute:: body: physics2d.body

      The body this collider belongs to

.. lua:class:: circle: collider

   .. lua:attribute:: radius: number
   .. lua:attribute:: center: vec2

.. lua:class:: box: collider

   .. lua:attribute:: center: vec2
   .. lua:attribute:: size: vec2
   .. lua:attribute:: angle: number

.. lua:class:: polygon: collider

   .. lua:attribute:: points: table<vec2>

.. lua:class:: contact

   Represents physical contact between two colliders during a collision

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

.. lua:class:: rayHit

   .. lua:attribute:: point: vec2

      The world position of the raycast hit location

   .. lua:attribute:: normal: vec2

      The world normal of the raycast hit location

   .. lua:attribute:: fraction: number

      The fraction of the total ray distance travelled before a hit was detected

   .. lua:attribute:: collider: physics2d.collider

      The collider that was hit by the ray

   .. lua:attribute:: body: physics2d.body

      The body of the collider that was hit by the ray   

Constraints
***********

.. lua:class:: joint

   The base class of physical constraints between two bodies (i.e. joints)

   .. lua:method:: destroy()

      Destroys this joint, removing it in the next simluation step

   .. lua:method:: getReactionForce(invDt)

      Gets the reaction force applied to this joint in the previous frame to keep the constraint satisfied

      Call with `1/physicsTimestep` to get accurate results

      :param invDt: The inverse timestep
      :type number:

   .. lua:method:: getReactionTorque(invDt)

      Gets the reaction torque applied to this joint in the previous frame to keep the constraint satisfied

      Call with `1/physicsTimestep` to get accurate results

      :param invDt: The inverse timestep
      :type number:

   .. lua:attribute:: enabled: boolean

      Enable/disable this joint

   .. lua:attribute:: destroyed: boolean

      Flag set to true if this joint has already been destroyed

   .. lua:attribute:: collideConnected: boolean

      When enabled bodies connected by a joint will collide with each other. Disabled by default

   .. lua:attribute:: anchorA: vec2

      The anchor point for the first body in world space

   .. lua:attribute:: anchorB: vec2

      The anchor point for the second (attached) body in world space

   .. lua:attribute:: localAnchorA: vec2

      The anchor point for the first body in local space

   .. lua:attribute:: localAnchorB: vec2

      The anchor point for the second (attached) body in local space

   .. lua:attribute:: other: physics2d.body

      The other physics body attached to this joint

.. lua:class:: hinge: joint

   A hinge type joint, pinning the bodies together at the respective anchor points, while allowing for free rotation with optional motor and angular limits

   .. lua:attribute:: referenceAngle: number

      The initial relative angle of the two connected bodies

   .. lua:attribute:: angle: number

      The current angle (in degrees) between the two connected bodies relative to the reference angle

   .. lua:attribute:: speed: number

      The current angular speed of the joint (in degrees per second)

   .. lua:attribute:: useMotor: boolean

      Enable/disables the joint motor (off by default)

   .. lua:attribute:: maxTorque: number

      The maximum amount of torque to apply use the motor

   .. lua:attribute:: motorSpeed: number

      The target speed of the motor

   .. lua:attribute:: useLimit: number

      Enables/disables angular joint limits (off by default)

   .. lua:attribute:: lowerLimit: number

      The lower angular rotation limit in degrees (when limits are enabled)

   .. lua:attribute:: upperLimit: number

      The upper angular rotation limit in degrees (when limits are enabled)

.. lua:class:: slider: joint

   A sliding (prismatic) joint allowing for translation along a single axis

   .. lua:attribute:: referenceAngle: number

      The initial relative angle of the two connected bodies

   .. lua:attribute:: translation: number

      The current relative translation between the two bodies along the constained axis

   .. lua:attribute:: speed: number

      The current relative speed between the two bodies along the constrained axis

   .. lua:attribute:: useMotor: boolean

      Enable/disables the joint motor (off by default)

   .. lua:attribute:: maxForce: number
      
      The maximum amount of force to apply use the motor

   .. lua:attribute:: motorSpeed: number

      The target speed of the motor

   .. lua:attribute:: useLimit: number

      Enables/disables linear joint limits (off by default)

   .. lua:attribute:: lowerLimit: number

      The lower linear translation limit in meters (when limits are enabled)

   .. lua:attribute:: upperLimit: number

      The upper linear translation limit in meters (when limits are enabled)

.. lua:class:: distance: joint

   A distance based joint constraint with spring-like properties and distance based limits

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