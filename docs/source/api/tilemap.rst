tilemap
=======

API for creating tile maps

Content
#######

    - ``tm.tiles`` - information on a single tile
    - ``tm.ruleset`` - information on how sprites should behavior in a tile
    - ``tm.tileset`` - collection of tiles used in the scene
    - ``tm.layer`` - the placement of tiles in the single layer
    - ``tm.tilemap`` - the grouping of tilemap layers to draw to the scene

.. lua:module:: tm

Tile
####

.. lua:class:: tile

    .. code-block:: lua
        :caption: How to use tile

        myTileset = tm.tileset()

        newTile = myTileset:tile()

        newTile:sprite(asset.dirtTile):group(7):collision(tm.collision.square)
            :ruleset(myRuleSet)

        spriteImg = newTile:sprite()
        theRuleset = newTile:ruleset()

    .. lua:attribute:: id: number

        .. helptext:: the tile's identifier

    .. lua:method:: sprite(spriteIcon)

        .. helptext:: sets the sprite of the rule
    .. lua:method:: sprite()

        Sets/gets the sprite image of the tile

        :param spriteIcon: The image that the tile contains
        :type spriteIcon: sprite
      
        No parameter:

        :return: The sprite image
        :rtype: sprite

        .. helptext:: gets the sprite of the tile

    .. lua:method:: group(groupNum)

        Sets the group of the tile

        :param groupNum: The group number the tile is from
        :type groupNum: number

        :return: self for function chaining
        :rtype: tile

        .. helptext:: sets the group of the tile

    .. lua:method:: collision(mode)

        Sets the collision mode of the tile

        :param mode: The enum of the collision
        :type mode: enum

        :return: self for function chaining
        :rtype: tile
        
        **Collision Mode Enum:**

        * ``tm.collision.none`` - no collision
        * ``tm.collision.square`` - for square collision
        * ``tm.collision.sprite`` - for sprite collision

        .. helptext:: sets the collision mode of the tile

    .. lua:method:: ruleset(theRuleset)

        .. helptext:: sets the ruleset of the tile
    .. lua:method:: ruleset()

        Sets/gets the ruleset of the tile

        :param theRuleset: The ruleset to be applied to the tile
        :type theRuleset: tm.ruleset
      
        No parameter:

        :return: The ruleset of the tile
        :rtype: tm.ruleset

        .. helptext:: gets the ruleset of the tile

Ruleset
#######

.. lua:class:: ruleset

        A ruleset is an object to determine how the same tiles should arrange using certain rules.

    .. lua:method:: rule()

        Creates a rule in the ruleset and selects it. Following ruleset functions will apply to this rule.

        :return: self for function chaining. 
        :rtype: ruleset

        .. helptext:: creates a rule in the ruleset

    .. lua:method:: [index] (ruleNum)

        Select the rule in the ruleset. Following ruleset functions will apply to this rule.

        :param ruleNum: the index of the rule in the ruleset
        :type ruleNum: integer

        :return: self for function chaining
        :rtype: ruleset

        .. helptext:: creates a rule in the ruleset

    **Below happens to rule created above**

    .. lua:method:: sprite(spriteIcon)

        .. helptext:: sets the sprite image of the rule

    .. lua:method:: sprite()

        Sets/gets the sprite image of the rule

        :param spriteIcon: The image that the rule contains
        :type spriteIcon: sprite
      
        No parameter:

        :return: One sprite image for regular and a table for `random`
        :rtype: sprite or table<sprite>

        .. helptext:: gets the sprite image of the rule

    .. lua:method:: random(spriteList)

        Sets the sprites that will be randomly selected

        :param spriteList: The images that the rule contains
        :type spriteList: table<sprite>
      
        :return: self for function chaining
        :rtype: ruleset

        .. helptext:: sets the sprites that will be randomly selected

    .. lua:method:: area(row1,... , rowX)

        Sets the tile area rule to determine which sprite should be displayed in the correct spot. 

        .. note:: The rows must be an odd number from 3 to 7. Rows and columns should be the same length

        :param rowX: The layout of the tile (sprite) with other tiles 
        :type spriteList: string

        * ``@`` - center tile
        * ` ` - ignore tile (empty space)
        * ``=`` - this tile
        * ``x`` - not this tile
        * ``g`` - tiles of the same group

        .. code-block:: lua
            :caption: How to use area

            local wallRules = tm.ruleset()

            wallRules:rule():sprite(setImgAtlas.c4r2)
            :area(" = ",
                  "=@x",
                  " = ")

      
        :return: self for function chaining
        :rtype: ruleset

        .. helptext:: sets the tile area rule to determine which sprite should be displayed

    .. lua:method:: rotate(shouldRotate)

        .. helptext:: sets the rotation of the rule's tile

    .. lua:method:: rotate()

        Rotates the rule's tile

        :param shouldRotate: Whether the sprite should be rotated
        :type shouldRotate: boolean

        :return: self for function chaining
        :rtype: ruleset

        .. helptext:: gets the rotation of the rule's tile

    .. lua:method:: flip(flipX, flipY)

        .. helptext:: sets the flip of the rule

    .. lua:method:: flip()

        Flips the rule's tile

        :param flipX: flip sprite horizontally
        :type flipX: boolean
        :param flipY: flip sprite vertically
        :type flipY: boolean

        :return: self for function chaining
        :rtype: ruleset

        .. helptext:: gets the flip of the rule

    .. lua:method:: collision(mode)

        Sets the collision mode of the rule's tile

        :param mode: The enum of the collision
        :type mode: enum

        :return: self for function chaining
        :rtype: tile

        .. helptext:: sets the collision mode of the rule's tile

    .. lua:method:: delete()

        Deletes the currently selected rule from the ruleset

        :return: self for function chaining
        :rtype: tile

        .. helptext:: deletes the currently selected rule from the ruleset

    .. lua:method:: clear()

        Clears all rules from the ruleset

        :return: self for function chaining
        :rtype: tile

        .. helptext:: clears the ruleset

    .. lua:attribute:: count: number

        Gets the number of rules in ruleset

        .. helptext:: the amount of rules
    
Tileset
#######

.. lua:class:: tileset

    .. code-block:: lua
        :caption: How to created tileset

        myTileset = tm.tileset()

        newTile = myTileset:tile("dirt")
        newTile2 = myTileset["dirt"] -- get the tile from the tileset by name
        newTile3 = myTileset[newTile.id] -- get the tile from the tileset by its id

    .. lua:method:: tile(tileName)

        Creates a tile in the tileset

        :param tileName: Name of the tile in the tileset
        :type tileName: string

        :return: The newly created tile
        :rtype: tile

        .. helptext:: create a tile in the tileset

    .. lua:method:: [index] (tileId)

        Selects a tile from tileset using its id

        :param tileId: The id of the tile.
        :type tileId: integer

        :return: Selected tile
        :rtype: tile

        .. helptext:: selects a tile from tileset using its id

    .. lua:method:: [index] (tileName)

        Select tile from tileset using its name

        :param tileName: The name of the tile.
        :type tileName: string

        :return: Selected tile
        :rtype: tile

        .. helptext:: selects a tile from tileset using its name

    .. lua:method:: clear()

        Clears all tiles from the tileset

        :return: self for function chaining
        :rtype: tile

        .. helptext:: clears the tileset

    .. lua:attribute:: count: number

        Gets the number of rules in ruleset

        .. helptext:: the amount of tiles in the tileset

Tilemap
#######

.. lua:class:: tilemap

    .. code-block:: lua
        :caption: How to create a tilemap

        myTileset = tm.tileset()

        myTilemap = tm.tilemap(myTileset)

    .. lua:method:: layer(layerName)

        Creates a layer in the tilemap

        :param layerName: Name of the layer in this tilemap
        :type layerName: string

        :return: The newly created layer
        :rtype: layer

        .. helptext:: creates a layer in the tilemap

    .. lua:method:: [index] (layerName)

        Gets a layer from tilemap using its name

        :param layerName: The name of the layer
        :type layerName: string

        :return: Selected layer
        :rtype: layer

        .. helptext:: gets a layer from tilemap using its name

    .. lua:method:: draw()

        Draws all the layers of the tilemap

        .. helptext:: draws all the layers of the tilemap

    .. lua:attribute:: world2d: world2d

        Gets/sets the physics world.

        .. helptext:: gets/sets the physics world.

    .. lua:attribute:: tileset: tileset

        Gets/sets the tileset.

        .. helptext:: Gets/sets the physics world.

Layer
#####

.. lua:class:: layer

    .. code-block:: lua
        :caption: How to create a layer

        myTileset = tm.tileset()

        myTilemap = tm.tilemap(myTileset)

        layer1 = myTilemap:layer("layer1")

    .. lua:attribute:: id: number

        .. helptext:: the layer's identifier

    .. lua:attribute:: name: string

        .. helptext:: the layer's name

    .. lua:attribute:: offset: vec3
        
        Adjusts the position of tilemap

        .. helptext:: adjusts the position of tilemap

    .. lua:method:: origin()

        Position of bottom left tile

        :return: The x, y, and z of the origin
        :rtype: number, number, number

        .. helptext:: position of bottom left tile

    .. lua:method:: size()

        Size of the tilemap

        :return: The x, y, and z of the size
        :rtype: number, number, number

        .. helptext:: size of the tilemap

    .. lua:method:: clear()

        Clears all tiles from the layer

        .. helptext:: clears the layer

    .. lua:method:: get(xPos, yPos)

        Gets the tileID at this position

        :param xPos: The x position of the tile
        :type xPos: number (integer)
        :param yPos: The y position of the tile
        :type yPos: number (integer)

        :return: The tileId at that position along with it's tileset
        :rtype: number, tileset

        .. note:: If tile position does not exist then returns 0 

        .. helptext:: gets the tile id at this position

    .. lua:method:: set(xPos, yPos, tileID|theTile)

        Sets the tile at this position

        :param xPos: The x position of the tile
        :type xPos: number (integer)
        :param yPos: The y position of the tile
        :type yPos: number (integer)
        :param tileID|theTile: Can take in a tileID or the tile itself
        :type tileID|theTile: number | tile

        .. helptext:: gets the tile id at this position
    
    .. lua:method:: draw()

        Draws this layer

        .. helptext:: draws this layer

    .. lua:method:: fill(xPos, yPos, tileID|theTile)

        Fills the tilemap with this tile

        :param tileID|theTile: Can take in a tileID or the tile itself
        :type tileID|theTile: number | tile

        .. helptext:: fills the tilemap with this tile

    .. lua:method:: resize(xSize, ySize)

        Resizes the layer to a new size

        :param xSize: The new width of the layer
        :type xSize: number
        :param ySize: The new height of the layer
        :type ySize: number

        .. helptext:: resizes the layer to the new size

    .. lua:method:: visit(callback)

        Iterates through all the positions of the the layers and calls this function. The callback function's input takes x, y, z, and tileID (the tile at that position)

        :param callback: The function that will be call each position: function(x, y, z, tileID, tileset)
        :type callback:  function(number, number, number, number, tileset)

        .. helptext:: iterates over all the positions of the the layers

    .. lua:method:: worldToTile(xPos, yPos)

        Gets the tile position from the world's position

        :param xPos: The x position of the world
        :type xPos: number (integer)
        :param yPos: The y position of the world
        :type yPos: number (integer)

        :return: returns the tile position from world space
        :rtype: number, number

        .. helptext:: gets the tile position from the world's position
    
    .. lua:method:: tileToWorld(xPos, yPos)

        Gets the world position from the tiles's position

        :param xPos: The x position of the tile in layer
        :type xPos: number (integer)
        :param yPos: The y position of the tile in layer
        :type yPos: number (integer)

        :return: returns the world position from tile space
        :rtype: number, number

        .. helptext:: gets the world position from the tiles's position

    .. lua:method:: bounds()

        :return: returns bounds of the layer
        :rtype: bounds.aabb

        .. helptext:: the bound of the layer