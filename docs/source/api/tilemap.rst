tilemap
=======

Api for creating tile maps

**It Contains**
    - ``tm.tiles`` - infomation on a single tile
    - ``tm.ruleset`` - infomation on how sprites should behavior in a tile
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

    .. lua:method:: sprite([spriteIcon])

        Set/Get the sprite image of the tile

        :param spriteIcon: The image that the tile contains
        :type spriteIcon: sprite
      
        No parameter:

        :return: The sprite image
        :rtype: sprite

    .. lua:method:: group(groupNum)

        Set the sprite image of the tile

        :param groupNum: The group number the tile is from
        :type groupNum: number

        :return: self for function chaining
        :rtype: tile

    .. lua:method:: collision(mode)

        Set the collision mode of the tile

        :param mode: The enum of the collision
        :type mode: enum

        :return: self for function chaining
        :rtype: tile

        **Collision Mode Enum:**

        * ``tm.collision.none`` - no collision
        * ``tm.collision.square`` - for square collision
        * ``tm.collision.sprite`` - for sprite collision

    .. lua:method:: ruleset([theRuleset])

        Set/Get the ruleset of the tile

        :param theRuleset: The ruleset to be applied to the tile
        :type theRuleset: tm.ruleset
      
        No parameter:

        :return: The ruleset of the tile
        :rtype: tm.ruleset

Ruleset
#######

.. lua:class:: ruleset

    A ruleset is a object to allows the user to determine how the same tiles should a aranged using certain rules.
    Having a ruleset simplify the creation of tilemap as common patterns can be set as a rule

    .. lua:method:: rule()

        Creates a rule in the ruleset and select it. Following ruleset functions will apply to this rule.

        :return: self for function chaining. 
        :rtype: ruleset

    .. lua:method:: [index] (ruleNum)

        Select the rule in the ruleset. Following ruleset functions will apply to this rule.

        :param ruleNum: the index of the rule in the ruleset
        :type ruleNum: integer

        :return: self for function chaining
        :rtype: ruleset

    **Below happens to rule created above**

    .. lua:method:: sprite([spriteIcon])

        Set/Get the sprite image of the rule

        :param spriteIcon: The image that the rule contains
        :type spriteIcon: sprite
      
        No parameter:

        :return: One sprite image for regular and a table for `random`
        :rtype: sprite or table<sprite>

    .. lua:method:: random([spriteList])

        Set the sprite that will be randomly selected (good for dirt tiles)

        :param spriteList: The images that the rule contains
        :type spriteList: table<sprite>
      
        :return: self for function chaining
        :rtype: ruleset

    .. lua:method:: area(row1,... , rowX)

        Set the tile area rule to determine with sprite should be display in the correct spot. The rows must be a old number 3 - 7. Rows and cols should be the same length

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

    .. lua:method:: rotate([shouldRotate])

        Rotates the rule's tile

        :param shouldRotate: Whether the sprite should be rotated
        :type shouldRotate: boolean

        :return: self for function chaining
        :rtype: ruleset

    .. lua:method:: flip([flipX, flipY])

        Flips the rule's tile

        :param flipX: flip sprite horizontally
        :type flipX: boolean
        :param flipY: flip sprite vertically
        :type flipY: boolean

        :return: self for function chaining
        :rtype: ruleset

    .. lua:method:: collision(mode)

        Set the collision mode of the rule's tile

        :param mode: The enum of the collision
        :type mode: enum

        :return: self for function chaining
        :rtype: tile

    .. lua:method:: delete()

        Deletes the currently selected rule from the ruleset

        :return: self for function chaining
        :rtype: tile

    .. lua:method:: clear()

        Clears all rules from the ruleset

        :return: self for function chaining
        :rtype: tile

    .. lua:attribute:: count: number

        Gets the number of rules in ruleset

    
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

    .. lua:method:: [index] (tileId)

        Select tile from tileset using its id

        :param tileId: The id of the tile.
        :type tileId: integer

        :return: Selected tile
        :rtype: tile

    .. lua:method:: [index] (tileName)

        Select tile from tileset using its name

        :param tileName: The name of the tile.
        :type tileName: string

        :return: Selected tile
        :rtype: tile

    .. lua:method:: clear()

        Clears all tiles from the tileset

        :return: self for function chaining
        :rtype: tile

    .. lua:attribute:: count: number

        Gets the number of rules in ruleset

Tilemap
#######

.. lua:class:: tilemap

    .. code-block:: lua
        :caption: How to create a tilemap

        myTileset = tm.tileset()

        myTilemap = tm.tilemap(myTileset)

    .. lua:method:: layer(layerName)

        Creates layer in the tilemap

        :param layerName: Name of the layer in this tilemap
        :type layerName: string

        :return: The newly created layer
        :rtype: layer

    .. lua:method:: [index] (layerName)

        Select layer from tilemap using its name

        :param layerName: The name of the layer
        :type layerName: string

        :return: Selected layer
        :rtype: layer

    .. lua:method:: draw()

        Draw all the layers of the tilemap

    .. lua:attribute:: world2d: world2d

        Gets/sets the physics world.

    .. lua:attribute:: tileset: tileset

        Gets/sets the tileset.

Layer
#####

.. lua:class:: layer

    .. code-block:: lua
        :caption: How to create a layer

        myTileset = tm.tileset()

        myTilemap = tm.tilemap(myTileset)

        layer1 = myTilemap:layer("layer1")

    .. lua:attribute:: id: number

    .. lua:attribute:: id: name

    .. lua:attribute:: offset: vec3
        
        Adjust the position of tilemap drawing

    .. lua:method:: origin()

        Position of bottom left tile

        :return: The x, y, and z of the origin
        :rtype: number, number, number

    .. lua:method:: size()

        Size of the tilemap from min position to max position

        :return: The x, y, and z of the size
        :rtype: number, number, number

    .. lua:method:: clear()

        Clears all tiles from the layer

    .. lua:method:: get(xPos, yPos)

        Get the tileID at this position

        :param xPos: The x position of the tile
        :type xPos: number (integer)
        :param yPos: The y position of the tile
        :type yPos: number (integer)

        :return: The tileId at that position along with it's tileset
        :rtype: number, tileset

        `If tile position does not exist then returns` ``tile.invalidID`` 

    .. lua:method:: set(xPos, yPos, tileID|theTile)

        set the tile at this position

        :param xPos: The x position of the tile
        :type xPos: number (integer)
        :param yPos: The y position of the tile
        :type yPos: number (integer)
        :param tileID|theTile: Can take in a tileID or the tile itself
        :type tileID|theTile: number | tile
    
    .. lua:method:: draw()

        Draw this layer

    .. lua:method:: fill(xPos, yPos, tileID|theTile)

        Fills the tilemap with this tile

        :param tileID|theTile: Can take in a tileID or the tile itself
        :type tileID|theTile: number | tile

    .. lua:method:: resize(xSize, ySize)

        Resizes the layer to a new size

        :param xSize: The new width of the layer
        :type xSize: number
        :param ySize: The new height of the layer
        :type ySize: number

    .. lua:method:: visit(callback)

        Goes through all the position of the the layers and calls this function. The callback function's input takes x, y, z, and tileID (the tile at that position)

        :param callback: The function that will be call each position: function(x, y, z, tileID, tileset)
        :type callback:  function(number, number, number, number, tileset)

    .. lua:method:: worldToTile(xPos, yPos)

        Get the tile position from the world's position

        :param xPos: The x position of the world
        :type xPos: number (integer)
        :param yPos: The y position of the world
        :type yPos: number (integer)

        :return: returns the tile position from world space
        :rtype: number, number
    
    .. lua:method:: tileToWorld(xPos, yPos)

        Get the world position from the tiles's position

        :param xPos: The x position of the tile in layer
        :type xPos: number (integer)
        :param yPos: The y position of the tile in layer
        :type yPos: number (integer)

        :return: returns the world position from tile space
        :rtype: number, number

    .. lua:method:: bounds()

        :return: returns bounds of the layer
        :rtype: bounds.aabb