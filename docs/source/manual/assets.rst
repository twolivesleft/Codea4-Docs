Assets
======

Assets in Codea
---------------

Assets are files such as images, sounds, and 3D models. Use an *asset key* to tell Codea which file to load:

.. code-block:: lua

   -- Load an image from the built-in Codea assets
   myImage = readImage(asset.builtin.Cargo_Bot.Codea_Dark)

   -- Load from your own project
   myImage = readImage(asset .. "MySprite.png")

Asset Keys
----------

An asset key identifies a file or folder. For example, ``asset.myImage`` refers to an image in your project.

The main asset libraries are:

- ``asset`` — files in your current project
- ``asset.documents`` — your personal Documents folder
- ``asset.builtin`` — read-only Codea built-in assets (sprites, sounds, shaders)
- ``asset.icloud`` — iCloud Drive documents (when signed in)

You can navigate sub-folders using dot notation or the ``..`` operator:

.. code-block:: lua

   -- Dot notation (for known names)
   local key = asset.builtin.Cargo_Bot.Codea_Dark

   -- Concatenation (for dynamic names)
   local filename = "MySprite.png"
   local key = asset .. filename

   -- Combine paths
   local key = asset.documents .. "Saves/Level1.json"

Loading and Saving Assets
-------------------------

Use the standard reading functions with asset keys instead of file path strings:

.. code-block:: lua

   -- Images
   local img = readImage(asset.builtin.Cargo_Bot.Codea_Dark)
   saveImage(asset.documents .. "Screenshot.png", img)

   -- Text
   local text = readLocalData("highscore")
   saveLocalData("highscore", 1000)

   -- JSON via the pick API
   local tbl = pick.table()   -- opens document picker, returns a table

Asset keys also work with the :lua:class:`file` module for copying, moving, and deleting files.

Working with Asset Packs
------------------------

Asset packs are folders that group related files together. You can inspect what's inside a pack using ``pairs()``:

.. code-block:: lua

   -- List all built-in Cargo Bot assets
   for name, key in pairs(asset.builtin.Cargo_Bot) do
       print(name, key)
   end

You can create your own packs by creating subfolders inside your project.

Bookmarks (References)
-----------------------

When you pick a file from outside your project using ``pick.option.reference``, you receive an asset key that points to the original file. Because the file path may change between sessions, you must save a *bookmark* to reliably access it later:

.. code-block:: lua

   -- Pick a file by reference and save a bookmark
   local key = pick.asset(pick.option.reference)
   if key then
       key:saveBookmark("myConfig")
   end

   -- On a later run, restore the bookmark
   local key = assets.readBookmark("myConfig")
   if key then
       local text = read(key)
   end

Remove bookmarks when they're no longer needed with ``assets.removeBookmark("myConfig")``.

Drawing many sprites from one image
-----------------------------------

Create a ring image once in ``setup()``, then draw it in many moving positions. Try using ``image.read(asset.myImage)`` to draw your own picture instead. Passing a width without a height keeps the image proportions.

.. codea-example:: Drawing many sprites from one image
   :project: code/Modern/Basics 05 - Sprites.codea
