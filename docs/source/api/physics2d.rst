physics2d
==========

.. lua:module:: physics2d

Simulation
##########

.. lua:class:: world

   .. lua:staticmethod:: world()

      Create a new physics world

      .. helptext:: create a new 2D physics world

   .. lua:method:: body(type, x, y)

      Create a new rigidbody in this world

      :param type: The type of body, `STATIC`, `DYNAMIC` or `KINEMATIC`
      :type type: enum
      :param x: The initial x position of the new body
      :type x: number
      :param y: The initial y position of the new body
      :type y: number

      .. helptext:: create a new rigidbody in this world

   .. lua:method:: step([deltaTime])

      Steps the simulation by ``deltaTime``

      .. helptext:: step the physics simulation

   .. lua:method:: draw()

      Draws a debug representation of the physics world using primitive shapes

      .. helptext:: draw a debug representation of the physics world

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

      .. helptext:: perform a raycast in this physics world

   .. lua:method:: overlapBox(origin, size[, mask])

      .. helptext:: check if a box overlaps any collider

   .. lua:method:: queryBox(origin, size[, mask])

      .. helptext:: query colliders overlapping a box

   .. lua:method:: queryBoxAll(origin, size[, mask])

      .. helptext:: query all colliders overlapping a box


   .. lua:attribute:: gravity: vec2

      The current gravity vector for this world

      .. helptext:: get or set the 2D physics gravity vector

.. lua:class:: body

   A two dimensional rigidbody that simulated within a :lua:class:`physics2d.world`. Used to simulate both dynamic and static objects, responding to physical forces, collisions and physics queries (i.e. raycast, queryBox, etc...)

   .. lua:method:: destroy()

      Destroys this body, removing it from the world in the next simluation step

      .. helptext:: destroy this body

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

      .. helptext:: attach a circle collider to this body

   .. lua:method:: box(halfWidth, halfHeight, [offsetX, offsetY, rotation])

      Creates and attaches a box collider to this body

      :return: The new box collider
      :rtype: physics2d.box

      .. helptext:: attach a box collider to this body

   .. lua:method:: polygon(points)

      Creates and attaches a polygon collider to this body

      :return: The new polygon collider
      :rtype: physics2d.polygon

      .. helptext:: attach a polygon collider to this body

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

      .. helptext:: attach a hinge joint to this body

   .. lua:method:: slider(anchor, axis)
                   slider(other, anchor, axis)
                   slider(other, anchorA, anchorB, axis)

      Creates and attaches a slider joint to this body. When no other body is provided the slider joint attaches to the world itself

      :return: The new slider joint
      :rtype: physics2d.slider

      .. helptext:: attach a slider joint to this body

   .. lua:method:: distance(anchorA, anchorB)
                   distance(other, anchorA, anchorB)
                   distance(other, anchorA, anchorB)

      Creates and attaches a distance joint to this body. When no other body is provided the distance joint attaches to the world itself.

      For two-body joints when one anchor is provided, it will be interpreted as a world space location, which will attach to the relative locations of both bodies. When two anchors are provided, they will be interpreted in local space and attach to those locations directly

      :return: The new distance joint
      :rtype: physics2d.distance

      .. helptext:: attach a distance joint to this body

   .. lua:method:: applyForce(force)

      Applies a force to this body over time (non-instantanious). Ideal for physical effects such as wind, bouyancy and springs

      :param force: The force vector to apply
      :type force: vec2

      .. helptext:: apply a continuous force to this body

   .. lua:method:: applyTorque(torque)

      :param torque: The torque vector to apply
      :type torque: number

      .. helptext:: apply a torque to this body

   .. lua:method:: applyLinearImpulse(impulse)

      :param impulse: The linear impulse to apply
      :type impulse: vec2

      .. helptext:: apply a linear impulse to this body

   .. lua:method:: applyAngularImpulse(impulse)

      :param impulse: The angular impulse to apply
      :type impulse: number

      .. helptext:: apply an angular impulse to this body

   .. lua:method:: worldPoint(localPoint)

      Transforms ``localPoint`` from local space to world space in respect to this body

      :param localPoint: The local space point to transform
      :type localPoint: vec2

      :rtype: vec2

      .. helptext:: transform a local point to world space

   .. lua:method:: worldVector(localVector)

      Transforms ``localVector`` from world space to local space in respect to this body

      :param localVector: The world space vector to transform
      :type localVector: vec2

      :rtype: vec2

      .. helptext:: transform a local vector to world space

   .. lua:method:: localPoint(worldPoint)

      Transforms ``worldPoint`` from world space to local space in respect to this body

      :param worldPoint: The world space point to transform
      :type worldPoint: vec2

      :rtype: vec2

      .. helptext:: transform a world point to local space

   .. lua:method:: localVector(worldVector)

      Transforms ``worldVector`` from world space to local space in respect to this body

      :param worldVector: The world space vector to transform
      :type worldVector: vec2

      :rtype: vec2

      .. helptext:: transform a world vector to local space

   .. lua:method:: velocityAtLocalPoint(localPoint)

      Samples the velocity of the body at ``localPoint`` in local space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param localPoint: The local point to sample velocity from
      :type localPoint: vec2

      :rtype: vec2

      .. helptext:: sample the body velocity at a local point

   .. lua:method:: velocityAtWorldPoint(worldPoint)

      Samples the velocity of the body at ``worldPoint`` in world space

      Useful for determining velocity on a body at a specific location for calculating effects, sounds and damage during collisions

      :param worldPoint: The world point to sample velocity from
      :type worldPoint: vec2

      :rtype: vec2

      .. helptext:: sample the body velocity at a world point

   .. lua:attribute:: destroyed: boolean

      Flag indicating that this body has already been destroyed

      .. helptext:: get whether this body or collider is destroyed

   .. lua:attribute:: position: vec2

      The position of this body in the simulated world

      .. helptext:: get or set the position of this body

   .. lua:attribute:: mass: number (readonly)

      The mass of this body in kilograms

      .. helptext:: get the mass of this body

   .. lua:attribute:: inertia: number

      The interial tensor in kg m^2

      .. helptext:: get or set the inertia of this body

   .. lua:attribute:: linearVelocity: vec2

      The linear velocity of the body

      .. helptext:: get or set the linear velocity

   .. lua:attribute:: angularVelocity: number

      The angular velocity of the body

      .. helptext:: get or set the angular velocity

   .. lua:attribute:: linearDamping: number

      The amount of linear damping to apply, slowing velocity proportionally over time

      .. helptext:: get or set the linear damping

   .. lua:attribute:: angularDamping: number

      The amount of linear damping to apply, slowing rotation propotionally over time

      .. helptext:: get or set the angular damping

   .. lua:attribute:: gravityScale: number

      The scale factor to apply to global gravity, settings 0 will disable gravity

      .. helptext:: get or set the gravity scale

   .. lua:attribute:: bullet: boolean

      Continuous physics switch for this body, used to prevent tunneling for fast moving objects

      .. helptext:: get or set whether bullet mode is enabled

   .. lua:attribute:: sleepingAllowed: boolean

      Flag for allowing sleeping for this body

      .. helptext:: get or set whether sleeping is allowed

   .. lua:attribute:: awake: boolean

      Flag for the current awake state of this body, set to ``true`` to wake immediately

      .. helptext:: get or set whether this body is awake

   .. lua:attribute:: enabled: boolean

      Flag for whether simulation is enabled

      .. helptext:: get or set whether this body or joint is enabled

   .. lua:attribute:: fixedRotation: boolean

      Flag for fixed rotation state, set to ``false`` to disable rotation

      .. helptext:: get or set whether rotation is fixed

   .. lua:attribute:: onCollisionBegan: function<physics2d.contact>

      A callback for when a collision with this body begins, with more information provided by the supplied :lua:class:`physics2d.contact` object

      .. helptext:: callback invoked when collision begins

   .. lua:attribute:: onCollisionEnded: function<physics2d.contact>

      A callback for when a collision with this body ends, with more information provided by the supplied :lua:class:`physics2d.contact` object

      .. helptext:: callback invoked when collision ends

   .. lua:attribute:: onPreSolve: function<physics2d.contact>

      A callback for when a collision with this body is about to be solved, allowing for some :lua:class:`physics2d.contact` parameters to be modified

      See: https://box2d.org/documentation/classb2_contact_listener.html

      .. helptext:: callback invoked before collision is resolved

   .. lua:attribute:: onPostSolve: function<physics2d.contact>

      A callback for when a collision with this body has been solved, allowing for some :lua:class:`physics2d.contact` information to be used for other purposes

      See: https://box2d.org/documentation/classb2_contact_listener.html

      .. helptext:: callback invoked after collision is resolved

Collision
#########

.. lua:class:: collider

   A two dimensional collider that attaches to a `physics2d.body`, detects and reacts to collisions

   .. lua:method:: destroy()

      Destroys this collider, removing it in the next simluation step

      .. helptext:: destroy this collider

   .. lua:attribute:: destroyed: boolean

      Flag indicating that this collider has already been destroyed

      .. helptext:: get whether this body or collider is destroyed

   .. lua:attribute:: friction: number

      The coefficient of friction for this collider

      .. helptext:: get or set the friction coefficient

   .. lua:attribute:: density: number

      The density of this collider

      .. helptext:: get or set the density

   .. lua:attribute:: restitution: number

      The coefficient of restitution for this collider

      .. helptext:: get or set the restitution coefficient

   .. lua:attribute:: sensor: boolean

      Flag turning this collider into a sensor. Sensors do not physically collide with object bodies but will still report collision detection via callbacks

      .. helptext:: get or set whether this collider is a sensor

   .. lua:attribute:: category: integer (bitfield)

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

      .. helptext:: get or set the collision category bitfield

   .. lua:attribute:: mask: integer (bitfield)

      The mask determines what categories this collider will pass collision filtering. If the mask bits are set for at least one category of a potential collision partner then a collision will be possible 

      .. helptext:: get or set the collision mask bitfield

   .. lua:attribute:: group: integer

      The group index is used for another extra layer of collision filtering. If two colliders have the same group and are positive, they will always collide, and if they are both negative then they will never collide

      .. helptext:: get or set the collision group

   .. lua:attribute:: body: physics2d.body

      The body this collider belongs to
      
      .. helptext:: get the body this collider belongs to

   .. lua:method:: collide(otherCollider)

      Checks the collision between this collider and another collider, and returns information about the collision.

      :param otherCollider: The other collider to collide with
      :type otherCollider: collider

      :return: ``didCollide[, point, normal, penetration]`` - `didCollide` is whether the collision happened
      :rtype: boolean[, vec2, vec2, number]
      
      .. helptext:: check for a collision with another collider

   .. lua:method:: overlap(otherCollider)

      Checks if the collider overlaps with another collider.

      :param otherCollider: The other collider to overlap with
      :type otherCollider: collider

      :return: Checks whether the two colliders are overlapping
      :rtype: boolean
      
      .. helptext:: check for an overlap with another collider

.. lua:class:: circle: collider

   .. lua:attribute:: radius: number

      .. helptext:: get or set the radius
   .. lua:attribute:: center: vec2

      .. helptext:: get or set the center point

.. lua:class:: box: collider

   .. lua:attribute:: center: vec2

      .. helptext:: get or set the center point
   .. lua:attribute:: size: vec2

      .. helptext:: get or set the size
   .. lua:attribute:: angle: number

      .. helptext:: get or set the angle

.. lua:class:: polygon: collider

   .. lua:attribute:: points: table<vec2>

      .. helptext:: get or set the polygon points

.. lua:class:: contact

   Represents physical contact between two colliders during a collision

   .. lua:attribute:: enabled: boolean

      Whether the contact is currently enabled, which can be set to false within the :lua:attr:`physics2d.body.onPreSolve` callback

      Useful for one way platforms (checking collision normals and conditionally disabling them)

      .. helptext:: get or set whether this body or joint is enabled

   .. lua:attribute:: touching: boolean

      Where the contact is currently touching (in some cases this may be false during collision resolution substeps)

      .. helptext:: get whether these bodies are touching

   .. lua:attribute:: friction: number

      The friction of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

      .. helptext:: get or set the friction coefficient

   .. lua:attribute:: restitution: number

      The restitution of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

      .. helptext:: get or set the restitution coefficient

   .. lua:attribute:: tangentSpeed: number

      The tangent of this contact, which can be modified within the :lua:attr:`physics2d.body.onPreSolve` callback

      Useful for creating things like conveyor belts which have a moving surface while remaining stationary

      .. helptext:: get or set the tangent speed

   .. lua:attribute:: localPoint: vec2

      The local position of the contact point (averaged from the manifold)

      .. helptext:: get the local contact point

   .. lua:attribute:: worldPoint: vec2

      The world position of the contact point (averaged from the manifold)

      .. helptext:: get the world contact point

   .. lua:attribute:: localNormal: vec2

      The local normal of the contact point (averaged from the manifold)

      .. helptext:: get the local contact normal

   .. lua:attribute:: worldNormal: vec2

      The world normal of the contact point (averaged from the manifold)

      .. helptext:: get the world contact normal

   .. lua:attribute:: body: physics2d.body

      The first body in this contact (the body receiving the callback)

      .. helptext:: get the body this collider belongs to

   .. lua:attribute:: otherBody: physics2d.body

      The second body involved in this collision contact

      .. helptext:: get the other body in the contact

   .. lua:attribute:: collider: physics2d.collider

      The first collider in this contact (attached to the body recieving the callback)

      .. helptext:: get the collider in the contact

   .. lua:attribute:: otherCollider: physics2d.collider

      The second collider involved in this collision contact
      
      .. helptext:: get the other collider in the contact

   .. lua:attribute:: entity: entity

      The first entity in this contact (the entity receiving the callback)
      
      .. helptext:: get the entity in the contact

   .. lua:attribute:: otherEntity: entity

      The second entity involved in this collision contact
      
      .. helptext:: get the other entity in the contact

.. lua:class:: rayHit

   .. lua:attribute:: point: vec2

      The world position of the raycast hit location

      .. helptext:: get the contact or raycast hit point

   .. lua:attribute:: normal: vec2

      The world normal of the raycast hit location

      .. helptext:: get the contact or raycast hit normal

   .. lua:attribute:: fraction: number

      The fraction of the total ray distance travelled before a hit was detected

      .. helptext:: get the raycast hit fraction

   .. lua:attribute:: collider: physics2d.collider

      The collider that was hit by the ray

      .. helptext:: get the collider in the contact

   .. lua:attribute:: body: physics2d.body

      The body of the collider that was hit by the ray   

      .. helptext:: get the body this collider belongs to

Constraints
###########

.. lua:class:: joint

   The base class of physical constraints between two bodies (i.e. joints)

   .. lua:method:: destroy()

      Destroys this joint, removing it in the next simluation step

      .. helptext:: destroy this joint

   .. lua:method:: getReactionForce(invDt)

      Gets the reaction force applied to this joint in the previous frame to keep the constraint satisfied

      Call with `1/physicsTimestep` to get accurate results

      :param invDt: The inverse timestep
      :type number:

      .. helptext:: get the reaction force applied to this joint

   .. lua:method:: getReactionTorque(invDt)

      Gets the reaction torque applied to this joint in the previous frame to keep the constraint satisfied

      Call with `1/physicsTimestep` to get accurate results

      :param invDt: The inverse timestep
      :type number:

      .. helptext:: get the reaction torque applied to this joint

   .. lua:attribute:: enabled: boolean

      Enable/disable this joint

      .. helptext:: get or set whether this joint is enabled

   .. lua:attribute:: destroyed: boolean

      Flag set to true if this joint has already been destroyed

      .. helptext:: get whether this joint is destroyed

   .. lua:attribute:: collideConnected: boolean

      When enabled bodies connected by a joint will collide with each other. Disabled by default

      .. helptext:: get or set whether connected bodies collide

   .. lua:attribute:: anchorA: vec2

      The anchor point for the first body in world space

      .. helptext:: get or set anchor point A in world space

   .. lua:attribute:: anchorB: vec2

      The anchor point for the second (attached) body in world space

      .. helptext:: get or set anchor point B in world space

   .. lua:attribute:: localAnchorA: vec2

      The anchor point for the first body in local space

      .. helptext:: get or set local anchor point A

   .. lua:attribute:: localAnchorB: vec2

      The anchor point for the second (attached) body in local space

      .. helptext:: get or set local anchor point B

   .. lua:attribute:: other: physics2d.body

      The other physics body attached to this joint

      .. helptext:: get the other body connected by this joint

.. lua:class:: hinge: joint

   A hinge type joint, pinning the bodies together at the respective anchor points, while allowing for free rotation with optional motor and angular limits

   .. lua:attribute:: referenceAngle: number

      The initial relative angle of the two connected bodies

      .. helptext:: get or set the reference angle

   .. lua:attribute:: angle: number

      The current angle (in degrees) between the two connected bodies relative to the reference angle

      .. helptext:: get or set the angle

   .. lua:attribute:: speed: number

      The current angular speed of the joint (in degrees per second)

      .. helptext:: get or set the motor speed

   .. lua:attribute:: useMotor: boolean

      Enable/disables the joint motor (off by default)

      .. helptext:: get or set whether the motor is enabled

   .. lua:attribute:: maxTorque: number

      The maximum amount of torque to apply use the motor

      .. helptext:: get or set the maximum motor torque

   .. lua:attribute:: motorSpeed: number

      The target speed of the motor

      .. helptext:: get or set the motor speed

   .. lua:attribute:: useLimit: number

      Enables/disables angular joint limits (off by default)

      .. helptext:: get or set whether limits are enabled

   .. lua:attribute:: lowerLimit: number

      The lower angular rotation limit in degrees (when limits are enabled)

      .. helptext:: get or set the lower joint limit

   .. lua:attribute:: upperLimit: number

      The upper angular rotation limit in degrees (when limits are enabled)

      .. helptext:: get or set the upper joint limit

.. lua:class:: slider: joint

   A sliding (prismatic) joint allowing for translation along a single axis

   .. lua:attribute:: referenceAngle: number

      The initial relative angle of the two connected bodies

      .. helptext:: get or set the reference angle

   .. lua:attribute:: translation: number

      The current relative translation between the two bodies along the constained axis

      .. helptext:: get the joint translation

   .. lua:attribute:: speed: number

      The current relative speed between the two bodies along the constrained axis

      .. helptext:: get or set the motor speed

   .. lua:attribute:: useMotor: boolean

      Enable/disables the joint motor (off by default)

      .. helptext:: get or set whether the motor is enabled

   .. lua:attribute:: maxForce: number
      
      The maximum amount of force to apply use the motor

      .. helptext:: get or set the maximum motor force

   .. lua:attribute:: motorSpeed: number

      The target speed of the motor

      .. helptext:: get or set the motor speed

   .. lua:attribute:: useLimit: number

      Enables/disables linear joint limits (off by default)

      .. helptext:: get or set whether limits are enabled

   .. lua:attribute:: lowerLimit: number

      The lower linear translation limit in meters (when limits are enabled)

      .. helptext:: get or set the lower joint limit

   .. lua:attribute:: upperLimit: number

      The upper linear translation limit in meters (when limits are enabled)

      .. helptext:: get or set the upper joint limit

.. lua:class:: distance: joint

   A distance based joint constraint with spring-like properties and distance based limits

   .. lua:attribute:: length: number

      .. helptext:: get or set the rope length
   .. lua:attribute:: currentLength: number

      .. helptext:: get the current rope length
   .. lua:attribute:: stiffness: number

      .. helptext:: get or set the spring stiffness
   .. lua:attribute:: damping: number

      .. helptext:: get or set the spring damping
   .. lua:attribute:: minLength: number

      .. helptext:: get or set the minimum rope length
   .. lua:attribute:: maxLength: number

      .. helptext:: get or set the maximum rope length

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

Settings
########

.. lua:class:: settings

   .. lua:attribute:: debugDraw: boolean

      Draws physics objects in the scene.

   .. lua:attribute:: gravity: vec2
      
      Changes the gravity of the physics world.

   .. lua:attribute:: velocityIterations: number

   .. lua:attribute:: positionIterations: number

   .. lua:attribute:: paused: boolean

      Get or set whether the physics simulation is currently paused. 