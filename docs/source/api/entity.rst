entity
======

.. lua:class:: entity

   A scene entity, created using :lua:meth:`scene.entity` that exists as part of the scene hierarchy. Entity behaviour and visuals are customised by addings various types of components or assets, such as :lua:class:`sprite.slice`, :lua:class:`camera` and :lua:class:`mesh`

   There are shortcut properties to attach some common components, while others are built-in (such as transforms, names and relationships)

   *General*

   .. lua:attribute:: active: boolean

      The active state of this entity, when inactive an entity will not be rendered, simulate physics or respond to automatic callbacks

   .. lua:attribute:: activeInHierarchy: boolean [readonly]

      The computed active in hierarchy state of this entity. Only ``true`` when all parents up to the root are active as well

   .. lua:attribute:: name: string

      The name of the entity, useful when referring to the entity later using the :lua:class:`scene` and :lua:class:`entity` indexers

      .. code-block:: lua

         scene.main = scene()
         scene.main:entity("ball") -- create a new entity named 'ball'
         print(scene.main.ball) -- retrieve the entity named 'ball'

   *Lifecycle*

   .. lua:method:: destroy()

      Marks this entity for destruction in the next :lua:meth:`scene.update`, further access to this entity after destruction will result in errors

   *Components*

   .. lua:method:: add(component, ...)

      Adds a component to this entity, there are several types of objects that can act as entities

      - built-in classes:
      - user-defined classes:
      - assets:

   .. lua:method:: remove(component)

      Removes a given component type from this entity

   .. lua:method:: has(component)

      Checks if a component type is attached to this entity

   .. lua:method:: get(component)

      Retrieves a component type attached to this etntity

   .. lua:attribute:: components: table<component>

      Retrieves a list of all components attached to this entity

   *Relationships*

   .. lua:attribute:: parent: entity

      The parent of this entity or ``nil`` if it is a root entity

   .. lua:attribute:: root: entity

      The root parent entity in the scene heirarchy (or self if this entity has no parent)

   .. lua:attribute:: children: table<entity>

      A list of all immediate children of this entity

   .. lua:attribute:: childCount: integer

      The number of children that this entity possesses

   .. lua:method:: index(name)

      Retrieves children with the supplied name using the property syntax (i.e. ``myEntity.theChildName``)

      *Note that this will not work if the child name is an existing property or method name in the entity class*

   .. lua:method:: child(name)

      Creates a new child entity of this entity

   .. lua:method:: findChild(name)

      :return: Finds the child named ``name`` or ``nil`` if it does not exist

   .. lua:method:: childAt(index)

      :return: The child entity at a given index (between 1..childCount) or ``nil`` if an invalid index is supplied

   .. lua:method:: moveBefore(entity)

      Rearranges this entity to appear before the supplied ``entity`` in the transform hierarchy

      *Note this may result in an entity's parent changing to make it the sibling or another entity*

   .. lua:method:: moveAfter(entity)

      Rearranges this entity to appear after the supplied ``entity`` in the transform hierarchy

      *Note this may result in an entity's parent changing to make it the sibling or another entity*

   *Transform*

   .. lua:attribute:: position: vec3

      The position of the entity in local 3D space

   .. lua:attribute:: worldPosition: vec3

      The position of the entity in global 3D space

   .. lua:attribute:: scale: vec3

      The scale of the entity in local 3D space

   .. lua:attribute:: uniformScale: number

      The uniform scale of the entity in local 3D space

   .. lua:attribute:: rotation: quat

      The rotation of the entity in local 3D space

   .. lua:attribute:: worldRotation: quat

      The rotation of the entity in world 3D space

   .. lua:attribute:: eulerRotation: vec3

      The euler rotation of the entity in local 3D space (in degrees)

   .. lua:attribute:: x: number

      The x position of the entity in local 3D space

   .. lua:attribute:: y: number

      The y position of the entity in local 3D space

   .. lua:attribute:: z: number

      The z position of the entity in local 3D space

   .. lua:attribute:: sx: number

      The x scale of the entity in local 3D space

   .. lua:attribute:: sy: number

      The y scale of the entity in local 3D space

   .. lua:attribute:: sz: number

      The z scale of the entity in local 3D space

   .. lua:attribute:: forward: number

      The positive z axis of this entity's coordinate space transformed into world space

   .. lua:attribute:: right: number

      The positive x axis of this entity's coordinate space transformed into world space

   .. lua:attribute:: up: number

      The positive y axis of this entity's coordinate space transformed into world space

   *Sprite Properties*

   .. lua:attribute:: sprite: sprite.slice

   .. lua:attribute:: color: color

   .. lua:attribute:: flipX: boolean

   .. lua:attribute:: flipY: boolean

   *Mesh Properties*

   .. lua:attribute:: mesh: mesh

   .. lua:attribute:: material: material

   *Physics2D Properties*

   .. lua:attribute:: body2d: physics2d.body

   .. lua:attribute:: collider2d: physics2d.collider

   .. lua:attribute:: colliders2d: table<physics2d.collider>

   .. lua:attribute:: joints2d: table<physics2d.joint>

   *Physics3D Properties*

   .. lua:attribute:: body3d: physics3d.body

   .. lua:attribute:: collider3d: physics3d.collider

   .. lua:attribute:: colliders3d: table<physics3d.collider>

   .. lua:attribute:: joints3d: table<physics3d.joint>

   *Callbacks*

   A series of handy callbacks that can be set which will be invoked automatically by the scene systems

   .. lua:attribute:: update: function

      Callback for the ``update(dt)`` event, which is called on all active entities once per frame. The ``dt`` parameter passes the delta time of the enclosing scene for this frame

   .. lua:attribute:: fixedUpdate: function

      Callback for the ``fixedUpdate(dt)`` event, which is called on all active entities once per fixed update (called a fixed number of times per second). The ``dt`` parameter passes the fixed delta time of the enclosing scene

   .. lua:attribute:: touched: function

      Callback for the ``touched(touch)`` event, which is called whenever a touch occurs (in response to user interaction)

      During the ``BEGAN`` phase of an incomming touch, returning true from this function will capture the touch for all subsequent events, otherwise the touch will be `lost`

   .. lua:attribute:: destroyed: function

      Callback for the `destroyed()` event, which is called right before the entity is destroyed

   .. lua:attribute:: hitTest: boolean [default = false]

      Enables hit testing for the ``touched(touch)`` event, which will filter touches based on collision checks using attached physics components on the main camera

      Use this to use colliders to filter interactions automatically
