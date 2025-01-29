pick
====

.. lua:function:: pick()

    Opens the document picker to pick a single asset and convert it to its corresponding Codea asset type.
    
    :returns: The picked asset
    :rtype: any

    .. code-block:: lua

        local pickedAsset = pick()
        if pickedAsset then
            print(pickedAsset)
        end

.. lua:class:: pick

    .. lua:staticmethod:: pick.image()

        Opens the document picker to pick an image asset.
        
        :returns: The picked image asset
        :rtype: image

        .. code-block:: lua

            myImage = pick.image()
            ...
            sprite(myImage, WIDTH/2, HEIGHT/2)

    .. lua:staticmethod:: pick.table()

        Opens the document picker to pick a json asset and convert it to a table.
        
        :returns: The picked asset converted to a table
        :rtype: table

        .. code-block:: lua
            
            myTable = pick.table()
            ...
            print(myTable["key"])

    .. lua:staticmethod:: pick.text()

        Opens the document picker to pick a text asset.
        
        :returns: The text content of the picked asset
        :rtype: string

        .. code-block:: lua

            myText = pick.text()
            ...
            text(myText, WIDTH/2, HEIGHT/2)

    .. lua:staticmethod:: pick.asset()

        Opens the document picker to pick an asset and return its asset key.
        
        :returns: The picked asset key
        :rtype: asset.key

        .. code-block:: lua

            myAssetKey = pick.asset()
            ...
            print(myAssetKey.type)

    .. lua:staticmethod:: pick.photo()

        Opens the photo picker to pick a single photo.
        
        :returns: The picked photo as an image asset
        :rtype: image

        .. code-block:: lua
            
            myPhoto = pick.photo()
            ...
            sprite(myPhoto, WIDTH/2, HEIGHT/2)

    .. lua:staticmethod:: pick.sound()

        Opens the document picker to pick a sound asset.
        
        :returns: The picked sound asset
        :rtype: sound.source

        .. code-block:: lua

            sound.play(pick.sound())

    .. lua:staticmethod:: pick.image(...)
                          pick.table(...)
                          pick.text(...)
                          pick.asset(...)
                          pick.photo(...)
                          pick.sound(...)

        Pick assets with the specified types, options and callback function.

        See ``pick(...)`` below for more information.

    .. lua:attribute:: option

        A table containing the following options:

        - :lua:attr:`multiple` - Allows multiple assets to be picked
        - :lua:attr:`decodeTable` - Decodes the picked asset as a table (only for json assets)
        - :lua:attr:`assetKey` - Returns the asset key instead of the asset content
        - :lua:attr:`image` - Picks an image asset
        - :lua:attr:`text` - Picks a text asset
        - :lua:attr:`table` - Picks a table asset
        - :lua:attr:`json` - Picks a JSON asset
        - :lua:attr:`sound` - Picks a sound asset
        - :lua:attr:`pdf` - Picks a PDF asset

.. lua:function:: pick(...)

    Pick assets with the specified types, options and callback function.

    When a callback function is provided, the function is asynchronous and the picked asset is passed to the callback function.

    .. code-block:: lua
        
        pick(pick.option.pdf, pick.option.multiple, function(pdfAssets)
            if pdfAssets then
                print("Picked " .. #pdfAssets .. " PDF assets")
            else
                print("No PDF assets picked")
            end
        })
