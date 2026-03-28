scene
=====

.. lua:class:: scene

   A high level scene structure used that integrates object hierarchy, rendering, input, physics and serialisation to simplify and streamline games and simulations

   .. lua:classattribute:: main: scene
      
      Sets the main Codea scene, which will be automatically drawn, updated and handle touch events

      .. code-block:: lua

         function setup()
            scene.main = scene.default3d()
         end

   .. lua:staticmethod:: scene.default3d([name])

      Creates the default 3D scene containing a perspective camera, directional light and HDR environment, with an optional name

      .. helptext:: create a default 3D scene

      :rtype: scene

   .. lua:staticmethod:: scene.default2d([name])

      Creates the default 2D scene containing an orthographic camera, with an optional name

      .. helptext:: create a default 2D scene

      :rtype: scene

   .. lua:staticmethod:: scene.read(key)

      Loads and returns a scene with the supplied asset key

      .. helptext:: load a scene from an asset

      :rtype: scene

   .. lua:staticmethod:: scene.save(key, scene)

      Saves the supplied scene at the given asset key location

      .. helptext:: save a scene to an asset

   .. lua:attribute:: name: string

      Gets or sets a name for this scene

      .. helptext:: name of the scene

   .. lua:attribute:: world2d: physics2d.world

      Gets the scene's 2D physics world, providing access to various physics functions and properties such as :lua:meth:`physics2d.world.applyForce`

      .. helptext:: 2D physics world of the scene

   .. lua:attribute:: world3d: physics3d.world

      Gets the scene's 3D physics world, providing access to various physics functions and properties such as :lua:meth:`physics3d.world.applyForce`
      
      .. helptext:: 3D physics world of the scene

   .. lua:attribute:: physics2d: physics2d.settings

      Gets the scene's 2D physics settings, providing access to various physics functions and properties such as :lua:meth:`physics2d.settings.debugDraw` 
      
      .. helptext:: 2D physics settings of the scene

   .. lua:attribute:: physics3d: physics3d.settings

      Gets the scene's 3D physics settings, providing access to various physics functions and properties such as :lua:meth:`physics3d.settings.debugDraw`
      
      .. helptext:: 2D physics settings of the scene

   .. lua:attribute:: time: time.settings

      Gets the scene's time settings, providing access to various time functions and properties such as :lua:meth:`time.settings.autoUpdate`
      
      .. helptext:: time settings of the scene

   .. lua:attribute:: sky

      Sets the sky visuals, which will depend on the type used:

      - :lua:class:`asset.key` - Use an image pointed to by a given asset key
      - :lua:class:`image` - Use an image directly (assumed to be a cube image)
      - :lua:class:`color` - Use a solid color

      .. helptext:: sky background of the scene

   .. lua:attribute:: skyBlur : number

      The blur strength of the skybox

      .. helptext:: blur strength of the skybox

   .. lua:attribute:: skyExposure : number

      The brightness of the skybox

      .. helptext:: brightness of the skybox

   .. lua:attribute:: camera : entity

      :return: The scene's camera entity (if it exists)
      :rtype: entity

      .. helptext:: camera entity of the scene

   .. lua:attribute:: sun : entity

      :return: The scene's sun entity (if it exists)
      :rtype: entity

      .. helptext:: sun entity of the scene

   .. lua:attribute:: canvas : ui.canvas

      :return: The main UI canvas of the scene
      :rtype: ui.canvas

      .. helptext:: main UI canvas of the scene

   .. lua:attribute:: pixelsPerUnit : number

      The amount of pixels that are in a grid unit

      .. helptext:: pixels per world unit

   .. lua:method:: entity([name])

      Creates a new blank :lua:class:`entity` with an optional name

      .. helptext:: create a new entity

      :rtype: entity

   .. lua:method:: findEntity(name)

      .. helptext:: find an entity by name

      :rtype: entity

   .. lua:method:: entities([includeFlag = scene.DEFAULT])

      Returns a table containing entities in the scene

      :param includeFlag: Flag to include certain entities.
      :rtype: table<entity>

      * ``scene.DEFAULT`` - only active entities *not including the children*
      * ``scene.INACTIVE`` - include inactive entities
      * ``scene.CHILDREN`` - include all the children and sub childrens of the entities
      * ``scene.ALL`` - include all entities in the scene: ``scene.INACTIVE | scene.CHILDREN``

      .. code-block:: lua
         :caption: Getting all the entities

         scen = scene.default2d("test")

         enti = scen:entity("enti")
         childEnti = enti:child("childEnti")

         otherEnti = scen:entity("otherEnti")
         otherEnti.active = false

         -- include only enti (you could input scene.DEFAULT in parameter for same result)
         entityList1 = scen:entities()

         -- include only enti and childEnti
         entityList2 = scen:entities(scene.CHILDREN)

         -- include only enti and otherEnti (no children included)
         entityList2 = scen:entities(scene.INACTIVE)

         -- loop over all entities in the scene (can use scene.ALL instead)
         scen:forEach(function(currentEnti)
            print(currentEnti.name)
         end, scene.INACTIVE | scene.CHILDREN)
         
      .. helptext:: get the root entities in the scene

      
   .. lua:method:: forEach(loopFunction, [includeFlag = scene.DEFAULT])

      Inputs a callback to that is called while looping over entities in the scene

      :param loopFunction: Function to loop over
      :type loopFunction: function(entity)
      :param includeFlag: Flag to include certain entities.
      
      .. helptext:: loops over entities in the scene using a function

   .. lua:method:: index(name) [metamethod]

      Returns the root entity with the given name (if it exists)

      .. helptext:: get a root entity by name

      :rtype: entity

   .. lua:method:: draw()

      Immediately draws the scene to the current context. When autoUpdate is enabled, ``update(dt)`` will be called as well

      .. helptext:: draw the scene

      If set as ``scene.main`` this will be called automatically right before the global ``draw()`` function

   .. lua:method:: update(deltaTime)

      Updates the scene, called automatically when ``draw()`` is called but can also be called manutally if needed

      .. helptext:: update the scene
