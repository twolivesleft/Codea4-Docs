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

   .. lua::staticmethod:: default3d()

      Creates the default 3D scene containing a perspective camera, directional light and HDR environment

      :rtype: scene

   .. lua::staticmethod:: default2d()

      Creates the default 2D scene containing an orthographic camera

      :rtype: scene

   .. lua::staticmethod:: read(key)

      Loads and returns a scene with the supplied asset key

      :rtype: scene

   .. lua::staticmethod:: save(key, scene)

      Saves the supplied scene at the given asset key location

   .. lua:attribute:: world2d: physics2d.world

      Gets the scene's 2D physics world, providing access to various physics functions and properties such as :lua:meth:`physics2d.world.applyForce`

   .. lua:attribute:: world3d: physics3d.world

      Gets the scene's 3D physics world, providing access to various physics functions and properties such as :lua:meth:`physics3d.world.applyForce`

   .. lua:attribute:: sky

      Sets the sky visuals, which will depend on the type used:

      - :lua:class:`asset.key` - Use an image pointed to by a given asset key
      - :lua:class:`image` - Use an image directly (assumed to be a cube image)
      - :lua:class:`color` - Use a solid color

   .. lua:attribute:: camera : entity

      :returns: The scene's camera entity (if it exists)
      :rtype: entity

   .. lua:attribute:: sun : entity

      :returns: The scene's sun entity (if it exists)
      :rtype: entity

   .. lua:method:: entity([name])

      Creates a new blank :lua:class:`entity` with an optional name

      :rtype: entity

   .. lua:method:: findEntity(name)

      :rtype: entity

   .. lua:method:: entities([activeOnly = true])

      Returns a table containing all root entities

      :param activeOnly: When set, returns only active root entities
      :rtype: table<entity>

   .. lua:method:: index(name) [metamethod]

      Returns the root entity with the given name (if it exists)

      :rtype: entity

   .. lua:method:: draw()

      Immediately draws the scene to the current context. When autoUpdate is enabled, ``update(dt)`` will be called as well

      If set as ``scene.main`` this will be called automatically right before the global ``draw()`` function

   .. lua:method:: update(deltaTime)

      Updates the scene, called automatically when ``draw()`` is called but can also be called manutally if needed
