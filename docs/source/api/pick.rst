pick
====

Picking Assets
##############

The pick API allows bringing up the native document (or photo) picker to pick assets from the files or photo library.

By default, documents are always copied to your project's assets unless pick.option.reference is used.

Images are always copied to the project's assets and cannot be loaded as references.

.. lua:function:: pick()

    Opens the document picker to pick a single asset and convert it to its corresponding Codea asset type.

    :return: The picked asset
    :rtype: any

    .. code-block:: lua

        local pickedAsset = pick()
        if pickedAsset then
            print(pickedAsset)
        end

    .. helptext:: open the document picker to pick an asset

Picking Specific Types
######################

.. lua:staticmethod:: pick.image()

    Opens the document picker to pick an image or PDF asset.

    :return: The picked image or PDF asset
    :rtype: image

    .. code-block:: lua

        myImage = pick.image()
        ...
        sprite(myImage, WIDTH/2, HEIGHT/2)

    .. helptext:: open the document picker to pick an image

.. lua:staticmethod:: pick.table()

    Opens the document picker to pick a JSON asset and convert it to a table.

    :return: The picked asset converted to a table
    :rtype: table

    .. code-block:: lua

        myTable = pick.table()
        ...
        print(myTable["key"])

    .. helptext:: open the document picker to pick a JSON asset as table

.. lua:staticmethod:: pick.text()

    Opens the document picker to pick a text asset.

    :return: The text content of the picked asset
    :rtype: string

    .. code-block:: lua

        myText = pick.text()
        ...
        text(myText, WIDTH/2, HEIGHT/2)

    .. helptext:: open the document picker to pick a text asset

.. lua:staticmethod:: pick.asset()

    Opens the document picker to pick an asset and return its asset key.

    :return: The picked asset key
    :rtype: asset.key

    .. code-block:: lua

        myAssetKey = pick.asset()
        ...
        print(myAssetKey.type)

    .. helptext:: open the document picker to pick an asset key

.. lua:staticmethod:: pick.photo()

    Opens the photo picker to pick a single photo from the photo library.

    This is a different picker than the document picker, and only allows picking a single photo at a time.

    :return: The picked photo as an image asset
    :rtype: image

    .. code-block:: lua

        myPhoto = pick.photo()
        ...
        sprite(myPhoto, WIDTH/2, HEIGHT/2)

    .. helptext:: open the photo picker to pick a photo

.. lua:staticmethod:: pick.sound()

    Opens the document picker to pick an audio asset (sound or music).

    :return: The picked audio asset
    :rtype: sound.source

    .. code-block:: lua

        sound.play(pick.sound())

    .. helptext:: open the document picker to pick an audio asset

Advanced Usage
##############

.. lua:function:: pick(...)

    Pick assets with the specified UTType strings, options and callback function.

    The order of types, options and callback is not important, though we recommend passing the callback last for readability.

    When a callback function is provided, the function becomes asynchronous and the picked asset is passed to the callback function.

    .. code-block:: lua

        -- Pick multiple assets of type yaml or image
        pick("public.yaml", pick.option.image, pick.option.multiple, function(multipleAssets)
            print("Picked " .. #multipleAssets .. " assets")
        end)

    .. helptext:: pick assets with specified types and options

.. lua:attribute:: pick.option: table

    A table containing the following options:

    - ``text`` - Text asset
    - ``json`` - JSON asset
    - ``sound`` - Audio asset (sound or music)
    - ``pdf`` - PDF asset
    - ``image`` - Image or PDF asset, defined as ``{ "public.image", "com.adobe.pdf" }``
    - ``table`` - JSON asset converted to a table, defined as ``{ pick.option.json, pick.option.decodeTable }``
    - ``multiple`` - Enable multiple asset selection
    - ``assetKey`` - Return the asset key instead of the asset content
    - ``decodeTable`` - Decode the picked asset as a table (only for json assets)
    - ``reference`` - Do not copy the asset to the project's assets, instead reference the original file

    .. helptext:: picker options table

Picking by Reference
####################

When using ``pick.option.reference``, the picked asset is not copied to the project's assets and instead points to the original file.

This allows you to make updates to the original file.

However, you cannot store the path to the file (e.g. using your ``assetKey.path``) as the path is not guaranteed to be the same on subsequent runs.

If you need to store the path, you must save and read bookmarks using ``assetKey:saveBookmark(name)`` and ``assets.readBookmark(name)``.

Bookmarks can be removed using ``assets.removeBookmark(name)``.

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

Generating Images
#################

``pick.playground`` brings up Image Playground so you can describe an image, choose a style and pick one of the results. Like the other pickers, it waits for the user and returns the image, or returns right away when you give it a callback.

The chosen image is copied to your project's assets, like ``pick.photo``.

Image Playground needs a device with Apple Intelligence turned on. Check ``pick.playground.available`` before offering it.

.. lua:staticmethod:: pick.playground([concepts], [options], [callback])

    Opens Image Playground and returns the image the user chose, or ``nil`` if they cancelled.

    Arguments can be passed in any order. A string is used as a concept, a short description such as ``"a red panda astronaut"``. ``pick.option.assetKey`` returns the asset key instead of the image.

    :param concepts: A short description to start with
    :type concepts: string
    :param options: A table of the settings below
    :type options: table
    :param callback: Called with the chosen image. Makes the call asynchronous
    :type callback: function
    :return: The chosen image, or ``nil`` if cancelled
    :rtype: image

    ``options`` can contain:

    - ``concepts`` - a string, or a table of concepts (see below)
    - ``source`` - an ``image`` or ``asset.key`` to start from
    - ``style`` - the style selected when Image Playground opens, one of ``pick.playground.style``. Defaults to ``any`` where available
    - ``styles`` - a table of the styles the user can choose from
    - ``personalization`` - whether people from the photo library can appear, one of ``pick.playground.personalization``
    - ``variety`` - how different the results are from each other, one of ``pick.playground.variety``
    - ``strategy`` - whether to edit ``source`` or make something new from it, one of ``pick.playground.strategy``
    - ``size`` - a ``vec2``. Image Playground makes the closest size it can

    .. note::

        ``variety`` needs iOS 26.4. ``strategy``, ``size`` and the ``any`` style need iOS 27. On older versions they are ignored with a warning.

    .. code-block:: lua

        function touched(touch)
            if touch.state == ENDED and pick.playground.available then
                pick.playground("a lighthouse in a storm", function(img)
                    if img then
                        picture = img
                    end
                end)
            end
        end

    .. code-block:: lua
        :caption: Turning a photo into a sketch

        local photo = pick.photo()
        local result = pick.playground {
            source = photo,
            strategy = pick.playground.strategy.edit,
            style = pick.playground.style.sketch,
            styles = { pick.playground.style.sketch },
            size = vec2(1024, 1024),
        }

    .. helptext:: open Image Playground to generate an image

.. lua:attribute:: pick.playground.available: boolean

    ``true`` if Image Playground can be shown on this device

    .. helptext:: whether Image Playground is available

.. lua:attribute:: pick.playground.style: table

    - ``any`` - lets Image Playground choose (iOS 27)
    - ``animation`` - 3D animated look
    - ``illustration`` - flat, bold illustration
    - ``sketch`` - hand-drawn sketch
    - ``emoji`` - emoji-like look
    - ``external`` - an external provider such as ChatGPT, if the user has turned one on (iOS 26)

    .. helptext:: Image Playground styles

.. lua:attribute:: pick.playground.personalization: table

    - ``automatic`` - let Image Playground decide
    - ``enabled`` - allow people from the photo library
    - ``disabled`` - never suggest people from the photo library

    .. helptext:: Image Playground personalization settings

.. lua:attribute:: pick.playground.variety: table

    - ``automatic``, ``high``, ``low`` (iOS 26.4)

    .. helptext:: how different Image Playground results are

.. lua:attribute:: pick.playground.strategy: table

    - ``automatic`` - let Image Playground decide
    - ``edit`` - change the source image
    - ``generate`` - make a new image based on it

    Requires iOS 27

    .. helptext:: whether Image Playground edits or replaces the source

Concepts
########

A concept can be a short string, a longer piece of text, or an image.

- A string is used as it is
- A table with ``text`` and an optional ``title`` lets Image Playground pick out the key ideas from a story or a note
- An ``image`` or ``asset.key`` is used as a visual idea

.. code-block:: lua

    pick.playground {
        concepts = {
            "watercolor",
            { text = storyText, title = "The Lost Kite" },
            asset.documents.Kite,
        }
    }
