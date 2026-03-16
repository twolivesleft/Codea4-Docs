entity
======

.. lua:class:: entity

   A scene entity, created using :lua:meth:`scene.entity` that exists as part of the scene hierarchy. Entity behaviour and visuals are customised by addings various types of components or assets, such as :lua:class:`sprite.slice`, :lua:class:`camera` and :lua:class:`mesh`

   There are shortcut properties to attach some common components, while others are built-in (such as transforms, names and relationships)

   **General**

   .. lua:attribute:: active: boolean

      The active state of this entity, when inactive an entity will not be rendered, simulate physics or respond to automatic callbacks

      .. collapse:: Example

         .. literalinclude:: /code/Example_entity_active.codea/Main.lua
            :language: lua

      .. helptext:: get or set the active state of this entity

   .. lua:attribute:: activeInHierarchy: boolean [readonly]

      The computed active in hierarchy state of this entity. Only ``true`` when all parents up to the root are active as well

      .. helptext:: get the computed active state in the hierarchy

   .. lua:attribute:: valid: boolean

      Checks the validity of this entity. When an entity is destroyed it is invalid and can no longer be used. non-valid entities will raise errors when calling functions or accessing properties

      .. helptext:: get whether this entity is valid

   .. lua:attribute:: id: integer

      A read-only identifier unique to the entity

      .. helptext:: get the unique identifier of this entity

   .. lua:attribute:: name: string

      The name of the entity, useful when referring to the entity later using the :lua:class:`scene` and :lua:class:`entity` indexers

      .. code-block:: lua

         scene.main = scene()
         scene.main:entity("ball") -- create a new entity named 'ball'
         print(scene.main.ball) -- retrieve the entity named 'ball'

      .. helptext:: get or set the name of this entity

   **Lifecycle**

   .. lua:method:: destroy([delay])

      Marks this entity for destruction in the next :lua:meth:`scene.update`, or after a ``delay`` (in seconds), further access to this entity after destruction will result in errors

      .. collapse:: Example

         .. literalinclude:: /code/Example_entity_destroy.codea/Main.lua
            :language: lua

      .. helptext:: mark this entity for destruction

   **Components**

   .. lua:method:: add(component, ...)

      Adds a component to this entity, there are several types of objects that can act as entities

      - Lua classes/components
         - Anything you can dream of...
      - built-in classes
         - ``camera.rigs.orbit``
         - ``camera.rigs.canvas``
         - ``physics3d.grabber``
      - assets
         - ``mesh``
         - ``image`` / ``image.slice``

      .. code-block:: lua

         scene.main = scene()
         local sphere = scene.main:entity()
         sphere:add(mesh.sphere(1)) -- Add a sphere mesh to the entity         

         -- Add an orbit rig to the camera (supersedes OrbitViewer from Craft)
         scene.camera:add(camera.rigs.orbit)

         -- Hypothetical day-night cycle Lua component for making the same orbit the planet
         scene.sun:add(DayNightCycle, 60)

      *Note on Lua classes/components*

         When calling ``entity:add(component, ...)`` with a Lua class, all parameters will be forwarded to the ``created(...)`` event after the component's construction, allowing for customised initialisation

      .. helptext:: add a component to this entity

   .. lua:method:: remove(component)

      Removes a given component type from this entity

      .. code-block:: lua

         scene.main = scene()
         local sphere = scene.main:entity()
         sphere:add(mesh.sphere(1)) -- add a sphere mesh to the entity         
         sphere:remove(mesh) -- remove the sphere mesh

      .. helptext:: remove a component from this entity


   .. lua:method:: has(component)

      Checks if a component type is attached to this entity

      .. code-block:: lua

         scene.main = scene()
         local sphere = scene.main:entity()
         sphere:add(mesh.sphere(1)) -- add a sphere mesh to the entity         
         print(sphere:has(mesh)) -- prints 'true'

      .. helptext:: check if a component is attached to this entity


   .. lua:method:: get(component)

      Retrieves a component type attached to this entity

      .. code-block:: lua
         
         scene.main = scene()
         local sphere = scene.main:entity()
         sphere:add(mesh.sphere(1)) -- add a sphere mesh to the entity         
         print(sphere:get(mesh)) -- prints the mesh description

      .. helptext:: get a component attached to this entity

   .. lua:attribute:: components: table<component>

      Retrieves a list of all components attached to this entity

      .. helptext:: get all components attached to this entity

   .. lua:method:: dispatch(name, ...)

      Calls the method ``name`` on this entity (including any custom methods) and any attached custom lua components. Additional arguments will be passed to the method as well

      :param name: The name of the method to call
      :type: string

      .. helptext:: dispatch a method call to this entity and its components

   **Relationships**

   .. lua:attribute:: parent: entity

      The parent of this entity or ``nil`` if it is a root entity

      .. helptext:: get or set the parent of this entity

   .. lua:attribute:: root: entity

      The root parent entity in the scene heirarchy (or self if this entity has no parent)

      .. helptext:: get the root entity in the hierarchy

   .. lua:attribute:: children: table<entity>

      A list of all immediate children of this entity

      .. helptext:: get all immediate children of this entity

   .. lua:attribute:: childCount: integer

      The number of children that this entity possesses

      .. helptext:: get the number of children of this entity

   .. lua:attribute:: depth: integer

      The depth of this entity in the hierarchy (roots have a depth of 0)

      .. helptext:: get the depth of this entity in the hierarchy

   .. lua:method:: index(name) [metamethod]

      Retrieves children with the supplied name using the property syntax (i.e. ``myEntity.theChildName``)

      *Note that this will not work if the child name is an existing property or method name in the entity class*

      .. helptext:: retrieve a child by name using property syntax

   .. lua:method:: child(name)

      Creates a new child entity of this entity

      .. helptext:: create a new child entity

   .. lua:method:: findChild(name)

      :return: Finds the child named ``name`` or ``nil`` if it does not exist

      .. helptext:: find a child entity by name

   .. lua:method:: childAt(index)

      :return: The child entity at a given index (between 1..childCount) or ``nil`` if an invalid index is supplied

      .. helptext:: get the child entity at a given index

   .. lua:method:: moveBefore(entity)

      Rearranges this entity to appear before the supplied ``entity`` in the transform hierarchy

      *Note this may result in an entity's parent changing to make it the sibling or another entity*

      .. helptext:: move this entity before another in the hierarchy

   .. lua:method:: moveAfter(entity)

      Rearranges this entity to appear after the supplied ``entity`` in the transform hierarchy

      *Note this may result in an entity's parent changing to make it the sibling or another entity*

      .. helptext:: move this entity after another in the hierarchy

   **Transform**

   .. lua:attribute:: position: vec3

      The position of the entity in local 3D space

      .. helptext:: get or set the local position of this entity

   .. lua:attribute:: worldPosition: vec3

      The position of the entity in global 3D space

      .. helptext:: get or set the world position of this entity

   .. lua:attribute:: scale: vec3

      The scale of the entity in local 3D space

      .. helptext:: get or set the scale of this entity

   .. lua:attribute:: uniformScale: number

      The uniform scale of the entity in local 3D space

      .. helptext:: get or set the uniform local scale of this entity

   .. lua:attribute:: rotation: quat

      The rotation of the entity in local 3D space

      .. helptext:: get or set the local rotation of this entity

   .. lua:attribute:: worldRotation: quat

      The rotation of the entity in world 3D space

      .. helptext:: get or set the world rotation of this entity

   .. lua:attribute:: eulerRotation: vec3

      The euler rotation of the entity in local 3D space (in degrees)

      .. helptext:: get or set the local euler rotation in degrees

   .. lua:attribute:: x: number

      The x position of the entity in local 3D space

      .. helptext:: get or set the local x position

   .. lua:attribute:: y: number

      The y position of the entity in local 3D space

      .. helptext:: get or set the local y position

   .. lua:attribute:: z: number

      The z position of the entity in local 3D space

      .. helptext:: get or set the local z position

   .. lua:attribute:: sx: number

      The x scale of the entity in local 3D space

      .. helptext:: get or set the local x scale

   .. lua:attribute:: sy: number

      The y scale of the entity in local 3D space

      .. helptext:: get or set the local y scale

   .. lua:attribute:: sz: number

      The z scale of the entity in local 3D space

      .. helptext:: get or set the local z scale

   .. lua:attribute:: rx: number

      The euler rotation around the local x axis of the entity in degrees

      .. helptext:: get or set the local x euler rotation in degrees

   .. lua:attribute:: ry: number

      The euler rotation around the local y axis of the entity in degrees

      .. helptext:: get or set the local y euler rotation in degrees

   .. lua:attribute:: rz: number

      The euler rotation around the local z axis of the entity in degrees

      .. helptext:: get or set the local z euler rotation in degrees

   .. lua:attribute:: forward: number

      The positive z axis of this entity's coordinate space transformed into world space

      .. helptext:: get the forward direction in world space

   .. lua:attribute:: right: number

      The positive x axis of this entity's coordinate space transformed into world space

      .. helptext:: get the right direction in world space

   .. lua:attribute:: up: number

      The positive y axis of this entity's coordinate space transformed into world space

      .. helptext:: get the up direction in world space

   .. lua:method:: transformPoint(localPoint)

      Transform a point from local to world space

      :param localPoint: The point to transform
      :type localPoint: vec3

      .. helptext:: transform a point from local to world space

   .. lua:method:: inverseTransformPoint(worldPoint)

      Transform a point from world to local space

      :param worldPoint: The point to transform
      :type worldPoint: vec3

      .. helptext:: transform a point from world to local space

   .. lua:method:: transformDirection(localDir)

      Transform a vector from local to world space

      :param localDir: The vector to transform
      :type localDir: vec3

      .. helptext:: transform a direction from local to world space

   .. lua:method:: inverseTransformDirection(worldDir)

      Transform a vector from world to local space

      :param worldDir: The vector to transform
      :type worldDir: vec3

      .. helptext:: transform a direction from world to local space

   .. lua:method:: translate(x, y[, z])

      Moves the entity by the provided translation vector in local space

      Also supports ``vec2`` and ``vec3`` parameters

      .. helptext:: translate this entity in local space

   **Sprite Properties**

   .. lua:attribute:: sprite: image.slice

      The sprite (``image.slice``) attached to this entity. This will be drawn at the entities' transform within the scene

      .. helptext:: draw a sprite or image

   .. lua:attribute:: color: color

      The tint color to use

      .. helptext:: create a new color type

   .. lua:attribute:: visible: boolean

      Sets/gets whether the entity should be drawn or not

      .. helptext:: get or set whether this entity is visible

   .. lua:attribute:: flipX: boolean

      Flips the sprite on the x-axis

      .. helptext:: get or set whether the sprite is flipped on x

   .. lua:attribute:: flipY: boolean

      Flips the sprite on the y-axis

      .. helptext:: get or set whether the sprite is flipped on y

   **Mesh Properties**

   .. lua:attribute:: mesh: mesh

      The mesh attached to this entity. This will be drawn the entities' transform within the scene

      .. helptext:: create a new mesh

   .. lua:attribute:: material: material

      The material attached to this entity (used in conjunction with meshes/sprites)

      .. helptext:: get or set the material attached to this entity

   **UI Properties / Methods**

   .. lua:attribute:: size: vec2

      The size of the UI element

      .. helptext:: get or set the size of the UI element

   .. lua:attribute:: anchorX: enum

      The horizontal anchoring of this UI element within its parent coordinate system

      Values:

      * ``LEFT``
      * ``CENTER``
      * ``RIGHT``
      * ``STRETCH``

      .. helptext:: get or set the horizontal anchor of this UI element

   .. lua:attribute:: anchorY: enum

      The vertical anchoring of this UI element within its parent coordinate system

      Values:
      
      * ``TOP``
      * ``MIDDLE``
      * ``BOTTOM``
      * ``STRETCH``      

      .. helptext:: get or set the vertical anchor of this UI element

   .. lua:attribute:: pivot: vec2

      The pivot point, representing the center of the UI element (in normalized coordinates)

      .. helptext:: get or set the pivot point of this UI element

   .. lua:attribute:: clip: boolean

      When enabled, clips drawing to within the bounds of the UI element

      .. helptext:: get or set whether clipping is enabled

   **Physics2D Properties**

   .. lua:attribute:: body2d: physics2d.body

      The attached 2D physics body (if there is one)

      .. helptext:: get the attached 2D physics body

   .. lua:attribute:: collider2d: physics2d.collider

      The first attached 2D physics collider (if there is one)

      .. helptext:: get the first attached 2D physics collider

   .. lua:attribute:: colliders2d: table<physics2d.collider>

      All attached 2D physics colliders

      .. helptext:: get all attached 2D physics colliders

   .. lua:attribute:: joints2d: table<physics2d.joint>

      All attached 2D physics joints

      .. helptext:: get all attached 2D physics joints

   **Physics3D Properties**

   .. lua:attribute:: body3d: physics3d.body

      The attached 3D physics body (if there is one)

      .. helptext:: get the attached 3D physics body

   .. lua:attribute:: collider3d: physics3d.collider

      The first attached 3D physics collider (if there is one)

      .. helptext:: get the first attached 3D physics collider

   .. lua:attribute:: colliders3d: table<physics3d.collider>

      All attached 3D physics colliders

      .. helptext:: get all attached 3D physics colliders

   .. lua:attribute:: joints3d: table<physics3d.joint>

      All attached 3D physics joints

      .. helptext:: get all attached 3D physics joints

   **Lifecycle Callbacks**

   A series of handy callbacks that can be set which will be invoked automatically by scene systems

   .. lua:attribute:: created: function

      Callback for the `created(...)` event, which is called right after a Lua component is created, and forwards all parameters passed from the ``entity:add(component, ...)`` function

      .. code-block:: lua

         SelfDestructor = class('SelfDestructor')

         -- Called when created but no parameters are forwarded here
         function SelfDestructor:init()
         end
         
         -- Use for custom component initialization, all parameters forwarded to here
         function SelfDestructor:created(delay)            
            print("I will self destruct in ", delay, " seconds")
            self.entity:destroy(delay)
         end

         ...

         local ent = main.scene:entity()
         ent:add(SelfDestructor, 3) -- prints "I will self destruct in 3 seconds"

      .. helptext:: callback invoked when this entity is created

   .. lua:attribute:: destroyed: function

      Callback for the `destroyed()` event, which is called right before the entity is destroyed

      .. helptext:: callback invoked before this entity is destroyed

   **Physics Callbacks**

   .. lua:attribute:: collisionBegan2d: function

      Callback for the ``collisionBegan2d(contact)`` event, which is called when a collision occurs with a `physics2d.body` attached to this entity

      .. helptext:: callback invoked when a 2D collision begins

   .. lua:attribute:: collisionBegan3d: function

      Callback for the ``collisionBegan3d(contact)`` event, which is called when a collision occurs with a `physics3d.body` attached to this entity

      .. helptext:: callback invoked when a 3D collision begins

   **Simulation Callbacks**

   .. lua:attribute:: update: function

      Callback for the ``update(dt)`` event, which is called on all active entities once per frame. The ``dt`` parameter passes the delta time of the enclosing scene for this frame

      .. helptext:: callback invoked once per frame

   .. lua:attribute:: fixedUpdate: function

      Callback for the ``fixedUpdate(dt)`` event, which is called on all active entities once per fixed update (called a fixed number of times per second). The ``dt`` parameter passes the fixed delta time of the enclosing scene

      .. helptext:: callback invoked once per fixed update


   **Interaction Callbacks**

   .. lua:attribute:: touched: function

      Callback for the ``touched(touch)`` event, which is called whenever a touch occurs (in response to user interaction)

      During the ``BEGAN`` phase of an incomming touch, returning true from this function will capture the touch for all subsequent events, otherwise the touch will be `lost`

      .. helptext:: callback invoked when a touch event occurs

   .. lua:attribute:: hitTest: boolean [default = false]

      Enables hit testing for the ``touched(touch)`` event, which will filter touches based on collision checks using attached physics components on the main camera

      .. helptext:: enable hit testing for touch events

