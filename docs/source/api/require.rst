:reference-overview: Importing Lua Code

Importing Code
==============

Use ``require()`` with an asset key to reuse Lua code from another file or project.

Importing a Codea Project
-------------------------

For Codea project asset keys, all Lua files except Main.lua are imported by default, including the global variables and functions.

``require.option.loadMain`` can be used to import Main.lua.
``require.option.noImport`` can be used to prevent importing global variables and functions.

Importing a Lua File
--------------------

For single Lua file asset keys, only the specified file is imported, including its global variables and functions by default.

``require.option.noImport`` can be used to prevent importing global variables and functions.

Import Functions
----------------

.. lua:function:: require(assetKey, ...)

    Import a single file from the specified asset key.

    :param assetKey: The asset key of the file to import
    :type assetKey: assetKey
    :return: Value returned by the imported file, if any
    :rtype: any

    .. code-block:: lua

        require(asset.documents.MyLibrary, require.option.noImport, require.option.loadMain)

        myFeature = require(asset.documents.MyOtherLibrary.MyFeature, require.option.noImport)

        require(asset.documents.MyOtherLibrary.MyOtherFeature)

   .. helptext:: import a Lua file from an asset key
   .. editor:: import

.. lua:class:: require

    .. lua:attribute:: option

        - ``loadMain`` - When used with a Codea project, load Main.lua
        - ``noImport`` - Do not import global variables and functions

       .. helptext:: an option value for require
