pick
====

The pick API allows bringing up the native document (or photo) picker to pick assets from the files or photo library.

By default, documents are always copied to your project's assets unless pick.option.reference is used.

Images are always copied to the project's assets and cannot be loaded as references.

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

        Opens the document picker to pick an image or PDF asset.
        
        :returns: The picked image or PDF asset
        :rtype: image

        .. code-block:: lua

            myImage = pick.image()
            ...
            sprite(myImage, WIDTH/2, HEIGHT/2)

    .. lua:staticmethod:: pick.table()

        Opens the document picker to pick a JSON asset and convert it to a table.
        
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

        Opens the photo picker to pick a single photo from the photo library.

        This is a different picker than the document picker, and only allows picking a single photo at a time.
        
        :returns: The picked photo as an image asset
        :rtype: image

        .. code-block:: lua
            
            myPhoto = pick.photo()
            ...
            sprite(myPhoto, WIDTH/2, HEIGHT/2)

    .. lua:staticmethod:: pick.sound()

        Opens the document picker to pick an audio asset (sound or music).
        
        :returns: The picked audio asset
        :rtype: sound.source

        .. code-block:: lua

            sound.play(pick.sound())

    .. lua:staticmethod:: pick.image(...)
                          pick.table(...)
                          pick.text(...)
                          pick.asset(...)
                          pick.photo(...)
                          pick.sound(...)

        Pick assets with the specified UTType strings, options and callback function.

        See ``pick(...)`` below for more information.

    .. lua:attribute:: option

        A table containing the following options:

        - ``text`` - Text asset
        - ``json`` - JSON asset
        - ``sound`` - Audio asset (sound or music)
        - ``pdf`` - PDF asset
        - ``image`` - Image or PDF asset, defined as { "public.image", "com.adobe.pdf" }
        - ``table`` - JSON asset converted to a table, defined as { pick.option.json, pick.option.decodeTable }
        - ``multiple`` - Enable multiple asset selection
        - ``assetKey`` - Return the asset key instead of the asset content
        - ``decodeTable`` - Decode the picked asset as a table (only for json assets)
        - ``reference`` - Do not copy the asset to the project's assets, instead reference the original file

.. lua:function:: pick(...)

    Pick assets with the specified UTType strings, options and callback function.

    The order of types, options and callback is not important, though we recommend passing the callback last for readability.

    When a callback function is provided, the function becomes asynchronous and the picked asset is passed to the callback function.

    .. code-block:: lua
        
        -- Pick multiple assets of type yaml or image
        pick("public.yaml", pick.option.image, pick.option.multiple, function(multipleAssets)
            print("Picked " .. #multipleAssets .. " assets")
        })

pick.option.reference
---------------------

When using pick.option.reference, the picked asset is not copied to the project's assets and instead points to the original file.

This allows you to make updates to the original file.

However, you cannot store the path to the file (e.g. using your ``assetKey.path``) as the path is not guaranteed to be the same on subsequent runs.

If you need to store the path, you must save and read bookmarks using ``assetKey:saveBookmark(name)`` and ``assets.readBookmark(name)``.

Bookmarks can be removed using ``assets.removeBookmark(name)``.

.. collapse:: Pick a reference and store a bookmark

    .. code-block:: lua

        local assetKey = pick.asset(pick.option.reference)
        if assetKey then
            assetKey:saveBookmark("myBookmark")
        end

        -- On subsequent runs, read the bookmark
        local assetKey = assets.readBookmark("myBookmark")
        if assetKey then
            print(assetKey.path)
        end
