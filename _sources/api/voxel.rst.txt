voxel
=====

Build worlds out of blocks. A voxel world is a component, add it to an entity and fill it with blocks such as grass, stone, water and glass

.. code-block:: lua
   :caption: A small island

   function setup()
      scene.main = scene.default3d()

      -- 2 x 1 x 2 chunks, each 16 x 128 x 16 blocks
      local island = scene.main:entity("island")
      world = island:add(voxel.world, vec3(2, 1, 2))

      world:box(vec3(0, 0, 0), vec3(31, 3, 31), "Water")
      world:sphere(vec3(16, 0, 16), 10, "Sand")
      world:line(vec3(16, 11, 16), vec3(16, 14, 16), "Wood")
      world:sphere(vec3(16, 18, 16), 3, "Leaves")

      island.position = vec3(-16, -4, -16)
      scene.main.camera:add(camera.rigs.orbit).distance = 40
   end

Blocks are addressed by integer coordinates local to the world, from ``vec3(0, 0, 0)`` up to (but not including) :lua:attr:`voxel.world.size`. Each block fills the unit cube from its coordinate to its coordinate plus one. Coordinates can always be given as a ``vec3`` or as three numbers, and are rounded down to whole blocks

Blocks are named by their type: a block name (``"Stone"``), a :lua:class:`voxel.block` or ``nil`` for empty space. Any block can also be given a tint color which multiplies its texture

Changes are drawn on the next frame. The world is drawn by child entities of the world's entity (one per chunk) which use the scene's lighting and shadows

Large worlds can be generated as they are explored. :lua:meth:`voxel.world.generate` runs a function from one of your project's tabs on background threads to fill each chunk as it comes within :lua:attr:`voxel.world.viewDistance` of the camera, and unloads chunks again once they are far away

.. code-block:: lua
   :caption: Endless hills (Main tab)

   function setup()
      scene.main = scene.default3d()

      local terrain = scene.main:entity("terrain")
      world = terrain:add(voxel.world, vec3(64, 1, 64))
      world.viewDistance = 128
      world:generate(asset.Hills, "hills", { height = 12 })

      -- Look down on the middle of the world
      terrain.position = vec3(-512, -50, -512)
      scene.main.camera:add(camera.rigs.orbit).distance = 60
   end

.. code-block:: lua
   :caption: Endless hills (Hills tab)

   function hills(chunk)
      for x = chunk.x, chunk.x + chunk.width - 1 do
         for z = chunk.z, chunk.z + chunk.depth - 1 do
            local top = math.floor(40 + noise(x / 50, z / 50) * params.height)
            chunk:box(x, 0, z, x, top - 1, z, "Dirt")
            chunk:set(x, top, z, "Grass")
         end
      end
   end

Small voxel models, such as characters and props, are loaded from ``.cvox`` files (made with the Voxel Editor) or MagicaVoxel ``.vox`` files with :lua:class:`voxel.model`. Each model is drawn with a regular mesh, which any number of entities can share

.. code-block:: lua
   :caption: A row of frogs

   function setup()
      scene.main = scene.default3d()

      -- Frog.cvox from the Froggy example
      local frog = voxel.model(asset.Frog)

      -- Models are one unit per voxel, scale them down to fit the scene
      for i = 1, 3 do
         local e = scene.main:entity()
         e.mesh = frog.mesh
         e.scale = vec3(0.1, 0.1, 0.1)
         e.x = (i - 2) * 2 - 0.6
      end

      scene.main.camera:add(camera.rigs.orbit).distance = 8
   end

Worlds and models are drawn with the voxel material, a lit material that shows each block's texture and tint. Its ``roughness`` (``0.9``), ``metallic`` (``0``), ``reflectance`` (``0.2``), ``emissive`` (``0``, how brightly blocks glow in their own color) and ``occlusionStrength`` (``0.45``, how dark the corners between blocks are) can be changed through :lua:attr:`voxel.world.material` or a model entity's ``material``. Block types can give their own ``roughness``, ``metallic`` and ``emissive``, which are used in place of the material's

.. code-block:: lua
   :caption: Shiny blocks and glowing ones

   world.material.roughness = 0.6

   world.blocks:add("Gold Block", { color = color(255, 200, 80), metallic = 1, roughness = 0.25 })
   world.blocks:add("Lava", { texture = asset.builtin.Blocks.Lava, emissive = 2 })

Worlds and models can use any other material too. Shaders read the voxels they draw with these functions, which are available whenever a lit or unlit shader draws a world or model (``HAS_VOXELS`` is defined then)

- ``vec4 getVoxelColor()`` - the block's texture tinted by its color. It discards the see-through pixels of cutout blocks and premultiplies translucent colors by their alpha
- ``float getVoxelOcclusion()`` - how open the corner of the block is, from ``0`` (hemmed in by neighbouring blocks) to ``1``
- ``float getVoxelRoughness(float fallback)``, ``float getVoxelMetallic(float fallback)`` and ``float getVoxelEmissive(float fallback)`` - the block type's settings, or ``fallback`` for those it doesn't give

Cutout and translucent blocks are drawn with copies of a world's material, which follow any changes made to it

.. code-block:: lua
   :caption: Blocks with stripes

   stripes = shader.builder()
      :lit()
      :material
      [[
         #if defined(HAS_VOXELS)
         vec4 color = getVoxelColor();
         float stripe = step(0.5, fract(getWorldPosition().y * 2.0));
         color.rgb *= mix(0.4, 1.0, stripe) * mix(0.5, 1.0, getVoxelOcclusion());
         material.baseColor = color;
         material.roughness = getVoxelRoughness(0.8);
         material.metallic = getVoxelMetallic(0.0);
         material.emissive = vec4(color.rgb * getVoxelEmissive(0.0), 0.0);
         #endif
      ]]
      :build()

   world.material = material(stripes)

.. lua:module:: voxel

.. lua:class:: world

   A fixed size grid of blocks, divided into chunks

   Create a world by adding it to an entity with ``entity:add(voxel.world, sizeInChunks[, chunkSize])``. The world is made of ``sizeInChunks`` chunks, each ``chunkSize`` blocks in size (``vec3(16, 128, 16)`` by default). It starts out empty, with the standard blocks available in :lua:attr:`voxel.world.blocks`

   Moving, rotating or scaling the entity moves, rotates or scales the world

   .. code-block:: lua

      local terrain = scene.main:entity("terrain")
      world = terrain:add(voxel.world, vec3(4, 1, 4))

      -- Smaller chunks for a 32 x 32 x 32 world
      world = terrain:add(voxel.world, vec3(2, 2, 2), vec3(16, 16, 16))

      -- Get the world back from its entity later
      world = terrain:get(voxel.world)

   .. lua:attribute:: size: vec3 [readonly]

      The size of the world in blocks

      .. helptext:: size of the world in blocks

   .. lua:attribute:: chunkSize: vec3 [readonly]

      The size of each chunk in blocks

      .. helptext:: size of each chunk in blocks

   .. lua:attribute:: blocks: voxel.blocks [readonly]

      The block types that can be used in this world

      .. helptext:: block types available in this world

   .. lua:method:: get(coord)

      Gets the block at a coordinate

      .. code-block:: lua

         local block, tint = world:get(10, 4, 10)
         if block then
            print(block.name)
         end

      :param coord: The coordinate of the block (or ``x, y, z``)
      :type coord: vec3
      :return: The block type and its tint, or ``nil`` if the block is empty or outside of the world
      :rtype: voxel.block, color

      .. helptext:: get the block at a coordinate

   .. lua:method:: set(coord, block[, tint])

      Sets the block at a coordinate. Coordinates outside of the world are ignored

      .. code-block:: lua

         world:set(10, 4, 10, "Stone")
         world:set(vec3(10, 5, 10), "Solid", color(255, 0, 0))
         world:set(10, 4, 10, nil) -- remove a block

      :param coord: The coordinate of the block (or ``x, y, z``)
      :type coord: vec3
      :param block: The block name, block type or ``nil`` for empty
      :type block: string
      :param tint: A color to multiply the block's texture by
      :type tint: color

      .. helptext:: set the block at a coordinate

   .. lua:method:: box(min, max, block[, tint])

      Fills every block between two corners, including the corners themselves

      .. code-block:: lua

         -- A 10 x 1 x 10 floor of grass
         world:box(vec3(0, 0, 0), vec3(9, 0, 9), "Grass")

      :param min: One corner of the box (or ``x, y, z``)
      :type min: vec3
      :param max: The opposite corner of the box (or ``x, y, z``)
      :type max: vec3
      :param block: The block name, block type or ``nil`` for empty
      :type block: string
      :param tint: A color to multiply the block's texture by
      :type tint: color

      .. helptext:: fill a box of blocks

   .. lua:method:: sphere(center, radius, block[, tint])

      Fills every block within ``radius`` blocks of ``center``

      .. code-block:: lua

         world:sphere(vec3(16, 8, 16), 6, "Stone")
         world:sphere(vec3(16, 8, 16), 4, nil) -- hollow it out

      :param center: The center of the sphere (or ``x, y, z``)
      :type center: vec3
      :param radius: The radius of the sphere in blocks
      :type radius: number
      :param block: The block name, block type or ``nil`` for empty
      :type block: string
      :param tint: A color to multiply the block's texture by
      :type tint: color

      .. helptext:: fill a sphere of blocks

   .. lua:method:: line(start, end, block[, tint])

      Fills a line of blocks from ``start`` to ``end``, including both ends

      .. code-block:: lua

         world:line(vec3(0, 10, 0), vec3(20, 15, 8), "Planks")

      :param start: The first block of the line (or ``x, y, z``)
      :type start: vec3
      :param end: The last block of the line (or ``x, y, z``)
      :type end: vec3
      :param block: The block name, block type or ``nil`` for empty
      :type block: string
      :param tint: A color to multiply the block's texture by
      :type tint: color

      .. helptext:: fill a line of blocks

   .. lua:attribute:: viewDistance: number

      How far (in blocks) from the :lua:attr:`voxel.world.focus` chunks are generated and drawn when the world has a generator. Chunks a little further away than this are unloaded. Defaults to ``128``

      .. helptext:: distance chunks are generated and drawn within

   .. lua:attribute:: focus: vec3

      The point (in scene space) that chunks are generated around, such as the position of a player. When ``nil`` (the default) the scene's camera is used

      .. helptext:: point that chunks are generated around

   .. lua:attribute:: loading: boolean [readonly]

      ``true`` while chunks within the view distance are still being generated or built, useful for showing a loading screen

      .. helptext:: whether nearby chunks are still loading

   .. lua:attribute:: material: material

      The material blocks are drawn with, the voxel material unless it's changed. Cutout and translucent blocks are drawn with copies of it, which follow any changes made to it. Set it to ``nil`` to go back to a new voxel material

      .. code-block:: lua

         world.material.roughness = 0.4

      .. helptext:: material blocks are drawn with

   .. lua:method:: generate(tab, functionName[, params])

      Fills the world using a generator function as chunks come within :lua:attr:`voxel.world.viewDistance` of the :lua:attr:`voxel.world.focus`. Chunks that move out of range are unloaded, unless they have been changed since they were generated. Calling ``generate`` again replaces the generator and starts generating from scratch

      The function is called with a :lua:class:`voxel.chunk` to fill, on background threads so the game keeps running smoothly while the world is generated. Each thread runs the code from ``tab`` in its own Lua environment, so the function can use the code in that tab, the standard ``math``, ``string`` and ``table`` libraries, ``noise``, ``hash``, ``color`` and ``print``, but not globals or functions from your other tabs. Anything else it needs is passed in through ``params``, which is copied and available to the generator as the global ``params``

      ``math.random`` is seeded for each chunk from its position (and ``params.seed`` when it is set), so a world generates the same way every time

      ``hash(x[, y[, z]])`` gives a number from ``0`` up to ``1`` for a position, which is always the same for that position (and ``params.seed``), whichever chunk asks for it. Neighbouring chunks can use it to agree on things that cross the edges between them, where ``math.random`` would give each chunk different numbers. Coordinates are rounded down to whole numbers, and neighbouring positions give unrelated numbers (use ``noise`` for numbers that change smoothly). Give it an extra coordinate for more than one number at a position

      .. code-block:: lua

         -- One tree in some 16 x 16 block cells, placed the same way by every chunk that asks
         function treeIn(cx, cz)
            if hash(cx, cz, 0) > 0.4 then return nil end
            local x = cx * 16 + math.floor(hash(cx, cz, 1) * 16)
            local z = cz * 16 + math.floor(hash(cx, cz, 2) * 16)
            return x, z
         end

      Blocks can only be changed in chunks that have been generated, changes elsewhere are ignored

      .. code-block:: lua

         world:generate(asset.Generation, "generateTerrain", {
            seed = 42,
            rivers = true
         })

      :param tab: The project tab containing the generator, such as ``asset.Generation``
      :type tab: asset
      :param functionName: The name of the function in that tab to call for each chunk
      :type functionName: string
      :param params: Values for the generator. Only numbers, strings, booleans and tables of these can be passed
      :type params: table

      .. helptext:: generate chunks as they come into view

   .. lua:method:: clear()

      Removes every block from the world, and stops generating

      .. helptext:: remove every block

   .. lua:method:: place(model, origin, block)

      Copies a :lua:class:`voxel.model` into the world as blocks of one type, each tinted with its voxel's color. The model's voxel ``(0, 0, 0)`` goes at ``origin``, and its empty voxels leave the world as it is. Placing with a ``nil`` block removes the blocks the model covers instead

      .. code-block:: lua

         local house = voxel.model(asset.House)
         world:place(house, vec3(40, 20, 12), "Planks")

      :param model: The model to place
      :type model: voxel.model
      :param origin: Where the model's first voxel goes (or ``x, y, z``)
      :type origin: vec3
      :param block: The block name or :lua:class:`voxel.block` to build the model from, or ``nil`` to remove blocks
      :type block: string

      .. helptext:: build a model into the world

   .. lua:method:: save(asset)

      Saves the world's blocks to a ``.cvox`` file

      A generated world only saves the chunks that have been changed since they were generated, as its generator can make the rest again. This keeps saves small, even for very large worlds

      .. code-block:: lua

         world:save(asset.documents .. "MyWorld.cvox")

      :param asset: Where to save the world, ending in ``.cvox``
      :type asset: asset

      .. helptext:: save the world's blocks to a file

   .. lua:method:: load(asset)

      Replaces the world's blocks with those in a file saved by :lua:meth:`voxel.world.save`

      Blocks are matched to the world's block types by name. A block type the world doesn't have yet is added without a texture, and can be given one afterwards with :lua:meth:`voxel.blocks.add`. The world must have the same chunk size as the one that was saved. Chunks beyond the world's size are left out

      To load a generated world, call :lua:meth:`voxel.world.generate` first and then ``load``. Chunks in the file replace the generated ones, and the generator goes on making the rest

      .. code-block:: lua

         world:generate(asset.Generation, "generateTerrain", { seed = 42 })
         world:load(asset.documents.MyWorld)

      :param asset: The ``.cvox`` file to load
      :type asset: asset

      .. helptext:: load the world's blocks from a file

   .. lua:method:: raycast(origin, direction[, distance = 1000])

      Finds the first block along a ray. The ray is in scene space (the same space as :lua:meth:`camera.screenToRay`), so it works however the world's entity is moved, rotated or scaled

      .. code-block:: lua

         function touched(touch)
            if touch.ended then
               local origin, dir = scene.main.camera:get(camera):screenToRay(touch.x, touch.y)
               local hit = world:raycast(origin, dir)
               if hit then
                  -- Place a block on the face that was touched
                  world:set(hit.coord + hit.normal, "Glass")
               end
            end
         end

      :param origin: The start of the ray
      :type origin: vec3
      :param direction: The direction of the ray
      :type direction: vec3
      :param distance: The maximum distance to search
      :type distance: number
      :return: The block that was hit, or ``nil`` if no block was found
      :rtype: voxel.hit

      .. helptext:: find the first block along a ray

.. lua:class:: hit

   The result of :lua:meth:`voxel.world.raycast`

   .. lua:attribute:: coord: vec3

      The coordinate of the block that was hit

   .. lua:attribute:: normal: vec3

      The direction of the face that was hit, such as ``vec3(0, 1, 0)`` for the top of a block. ``coord + normal`` is the empty space in front of that face. ``vec3(0, 0, 0)`` when the ray starts inside a block

   .. lua:attribute:: block: voxel.block

      The type of block that was hit

   .. lua:attribute:: color: color

      The tint of the block that was hit

   .. lua:attribute:: point: vec3

      The point where the ray hit the block, in scene space

   .. lua:attribute:: distance: number

      The distance from the ray's origin to ``point``

.. lua:class:: chunk

   A chunk of the world being filled by a generator function (see :lua:meth:`voxel.world.generate`). Coordinates are world block coordinates, the same as :lua:meth:`voxel.world.set`, and anything outside of the chunk is ignored. Blocks are given by name or id, or ``nil`` for empty, and can be followed by a tint color like the world's own functions. Coordinates are given as numbers, as ``vec3`` isn't available to generators

   .. code-block:: lua

      function generateTerrain(chunk)
         -- A layer of stone at the bottom of every chunk
         chunk:box(chunk.x, 0, chunk.z, chunk.x + chunk.width - 1, 3, chunk.z + chunk.depth - 1, "Stone")
      end

   .. lua:attribute:: x: integer [readonly]

      The x coordinate of the first block in the chunk

   .. lua:attribute:: y: integer [readonly]

      The y coordinate of the first block in the chunk

   .. lua:attribute:: z: integer [readonly]

      The z coordinate of the first block in the chunk

   .. lua:attribute:: width: integer [readonly]

      The size of the chunk along the x axis

   .. lua:attribute:: height: integer [readonly]

      The size of the chunk along the y axis

   .. lua:attribute:: depth: integer [readonly]

      The size of the chunk along the z axis

   .. lua:method:: get(x, y, z)

      Gets the name and tint of a block in the chunk

      :return: The block name and its tint, or ``nil`` if the block is empty or outside of the chunk
      :rtype: string, color

   .. lua:method:: set(x, y, z, block[, tint])

      Sets a block in the chunk

      :param block: The block name or id, or ``nil`` for empty
      :type block: string
      :param tint: A color to tint the block with
      :type tint: color

   .. lua:method:: box(x1, y1, z1, x2, y2, z2, block[, tint])

      Fills every block between two corners, including the corners themselves

      :param block: The block name or id, or ``nil`` for empty
      :type block: string
      :param tint: A color to tint the blocks with
      :type tint: color

   .. lua:method:: sphere(x, y, z, radius, block[, tint])

      Fills every block within ``radius`` blocks of a center block

      :param block: The block name or id, or ``nil`` for empty
      :type block: string
      :param tint: A color to tint the blocks with
      :type tint: color

   .. lua:method:: line(x1, y1, z1, x2, y2, z2, block[, tint])

      Fills a line of blocks between two blocks, including the ends

      :param block: The block name or id, or ``nil`` for empty
      :type block: string
      :param tint: A color to tint the blocks with
      :type tint: color

.. lua:class:: blocks

   The block types available to a world. Every world starts with the standard blocks below, which use textures from the builtin ``Blocks`` asset pack

   ``Grass``, ``Dirt``, ``Sand``, ``Stone``, ``Gravel``, ``Snow``, ``Ice``, ``Bedrock``, ``Water``, ``Glass``, ``Glass Frame``, ``Red Brick``, ``Brick``, ``Coal Ore``, ``Gold Ore``, ``Diamond Ore``, ``Redstone Ore``, ``Planks``, ``Wood``, ``Leaves``, ``Crafting Table`` and ``Solid`` (plain white, use it with a tint)

   Block types can be looked up by name, ``world.blocks.Stone`` or ``world.blocks["Glass Frame"]``

   .. lua:method:: add(name[, definition])

      Adds a new block type, or changes the existing type with the same name. The definition table can contain:

      - ``texture`` - an image asset used for every face, or a table of assets by face
      - ``color`` - a tint for every face, or a table of colors by face
      - ``translucent`` - ``true`` for blended blocks like water and glass. Faces between translucent blocks of the same type are hidden
      - ``cutout`` - ``true`` for blocks with see-through holes like leaves, where pixels with less than half alpha are not drawn
      - ``roughness`` and ``metallic`` - from ``0`` to ``1``, used in place of the world material's
      - ``emissive`` - how brightly the block glows in its own color, from ``0`` to ``8``, used in place of the world material's

      Faces are named ``all``, ``sides``, ``top``, ``bottom``, ``north``, ``south``, ``east`` and ``west`` (most specific wins). Blocks without a texture are plain white, tinted by their color

      Any other values in the definition become custom properties of the block type

      .. code-block:: lua

         world.blocks:add("Cactus", {
            texture = {
               sides = asset.builtin.Blocks.Cactus_Side,
               top = asset.builtin.Blocks.Cactus_Top,
               bottom = asset.builtin.Blocks.Cactus_Inside
            },
            canDig = true
         })

         world.blocks:add("Tinted Glass", {
            texture = asset.builtin.Blocks.Glass,
            color = color(120, 200, 255, 160),
            translucent = true
         })

      :param name: The name of the block type
      :type name: string
      :param definition: How the block looks, along with any custom properties
      :type definition: table
      :return: The block type
      :rtype: voxel.block

      .. helptext:: add a new block type

   .. lua:method:: get(name)

      Gets a block type by name or id

      :param name: The name or id of the block type
      :type name: string
      :return: The block type, or ``nil`` if there isn't one
      :rtype: voxel.block

      .. helptext:: get a block type by name

   .. lua:method:: all()

      Gets every block type, in the order they were added

      .. code-block:: lua

         for i, block in ipairs(world.blocks:all()) do
            print(i, block.name)
         end

      :return: A list of block types
      :rtype: table<voxel.block>

      .. helptext:: get every block type

   .. lua:method:: clear()

      Removes every block type, including the standard blocks. Blocks already in the world using a removed type are no longer drawn

      .. helptext:: remove every block type

.. lua:class:: block

   A type of block, such as ``Grass`` or ``Water``

   Custom values can be stored on a block type, either in its definition or by setting them directly

   .. code-block:: lua

      world.blocks.Bedrock.canDig = false

      local hit = world:raycast(origin, dir)
      if hit and hit.block.canDig ~= false then
         world:set(hit.coord, nil)
      end

   .. lua:attribute:: name: string [readonly]

      The name of this block type

      .. helptext:: name of the block type

   .. lua:attribute:: id: integer [readonly]

      A number identifying this block type within its world

      .. helptext:: id of the block type

   .. lua:attribute:: translucent: boolean [readonly]

      Whether this block type is blended, like water and glass

      .. helptext:: whether the block type is blended

   .. lua:attribute:: cutout: boolean [readonly]

      Whether this block type has see-through holes, like leaves

      .. helptext:: whether the block type has see-through holes

   .. lua:attribute:: roughness: number

      The roughness of this block type, from ``0`` to ``1``, or ``nil`` to use the world material's

      .. helptext:: roughness of the block type

   .. lua:attribute:: metallic: number

      How metallic this block type is, from ``0`` to ``1``, or ``nil`` to use the world material's

      .. helptext:: how metallic the block type is

   .. lua:attribute:: emissive: number

      How brightly this block type glows in its own color, from ``0`` to ``8``, or ``nil`` to use the world material's

      .. helptext:: how brightly the block type glows

.. lua:class:: model

   A small grid of colored voxels drawn as a single mesh, for things like characters, vehicles and props

   Load a model from a ``.cvox`` or MagicaVoxel ``.vox`` file with ``voxel.model(asset.Name)``, or make an empty one with ``voxel.model(size)``. Voxels are addressed by integer coordinates from ``vec3(0, 0, 0)`` up to (but not including) :lua:attr:`voxel.model.size`, and each one is either empty or filled with a color

   .. code-block:: lua

      car = voxel.model(asset.Car)

      -- An empty model with a red voxel in its corner
      gem = voxel.model(vec3(8, 8, 8))
      gem:set(0, 0, 0, color(255, 0, 0))

   MagicaVoxel scenes with several objects are combined into one model, using their positions and rotations. Hidden objects and layers are left out, and MagicaVoxel's z-up axes are turned to match Codea's y-up

   .. helptext:: a small model made of colored voxels

   .. lua:attribute:: size: vec3 [readonly]

      The size of the model in voxels

      .. helptext:: size of the model in voxels

   .. lua:attribute:: mesh: mesh [readonly]

      A mesh that draws the model, with one unit per voxel and its origin at the corner of voxel ``(0, 0, 0)``. Faces between neighbouring voxels are left out and corners are shaded by ambient occlusion, like a :lua:class:`voxel.world`. It's drawn with a new voxel material, or any other material given to its entity

      The same mesh is returned until the model changes, so it can be shared by many entities. Changing a voxel makes a new mesh the next time this is read, entities already using the old mesh keep showing it

      .. code-block:: lua

         local tree = scene.main:entity()
         tree.mesh = treeModel.mesh

         -- Centered on the entity, standing on its origin
         local bounds = treeModel.mesh.bounds
         tree.position = -vec3(bounds.center.x, bounds.min.y, bounds.center.z)

      .. helptext:: mesh that draws the model

   .. lua:method:: get(coord)

      Gets the color of a voxel

      :param coord: The coordinate of the voxel (or ``x, y, z``)
      :type coord: vec3
      :return: The voxel's color, or ``nil`` if it is empty or outside of the model
      :rtype: color

      .. helptext:: get the color of a voxel

   .. lua:method:: set(coord, color)

      Sets the color of a voxel, or empties it. Coordinates outside of the model are ignored

      .. code-block:: lua

         model:set(2, 0, 3, color(255, 200, 0))
         model:set(2, 0, 3, nil) -- remove a voxel

      :param coord: The coordinate of the voxel (or ``x, y, z``)
      :type coord: vec3
      :param color: The voxel's color, or ``nil`` for empty
      :type color: color

      .. helptext:: set the color of a voxel

   .. lua:method:: copy()

      Makes a copy of the model. Changing either one leaves the other as it is, which makes copies useful for undo in an editor. The copy shares the model's :lua:attr:`voxel.model.mesh` until one of them changes, so a copy made after the mesh is read can be shown again without being meshed

      .. code-block:: lua

         -- After each edit
         table.insert(undoSteps, model:copy())

      :return: A new model with the same size and voxels
      :rtype: voxel.model

      .. helptext:: make a copy of the model

   .. lua:method:: assign(other)

      Replaces the model's size and voxels with another model's, leaving the other model as it is. Entities keep showing the old mesh until they're given :lua:attr:`voxel.model.mesh` again

      .. code-block:: lua

         -- Undo, back to the previous step
         table.remove(undoSteps)
         model:assign(undoSteps[#undoSteps])
         entity.mesh = model.mesh

      :param other: The model to copy from
      :type other: voxel.model

      .. helptext:: replace the model with another model's voxels

   .. lua:method:: save(asset)

      Saves the model to a file. The file's extension picks the format: ``.cvox`` for the Voxel Editor, or ``.vox`` for MagicaVoxel. MagicaVoxel files can hold at most 255 different colors and 256 voxels in each dimension, larger or more colorful models can be saved as ``.cvox``

      .. code-block:: lua

         gem:save(asset.documents .. "Gem.vox")

      :param asset: Where to save the model, ending in ``.cvox`` or ``.vox``
      :type asset: asset

      .. helptext:: save the model to a file

.. lua:currentmodule:: None
