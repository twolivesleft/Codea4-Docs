file
====

File operations module for working with assets and the file system. All file operations return two values: a success boolean and an error message string. On success, returns ``true, nil``. On failure, returns ``false, "error message"``.

.. lua:module:: file

.. lua:function:: copy(source, destination)

   Copies a file or folder from one location to another. When copying to an asset library (folder), the file maintains its original name in the destination. Fails if the source does not exist or if the destination already exists.

   :param source: Source file or folder to copy
   :type source: assetKey or assetLibrary
   :param destination: Destination path or folder
   :type destination: assetKey or assetLibrary
   :return: Success status and error message
   :rtype: boolean, string or nil

   .. code-block:: lua

      -- Copy a file to documents with a new name
      local ok, err = file.copy(asset.builtin.Pack.File, asset.documents .. "MyFile.png")
      if not ok then
          print("Copy failed:", err)
      end

      -- Copy a file to documents (keeps original name)
      local ok, err = file.copy(asset.builtin.Pack.File, asset.documents)

      -- Copy an entire folder
      local ok, err = file.copy(asset.builtin.Pack, asset.documents .. "MyPack")

.. lua:function:: move(source, destination)

   Moves a file or folder from one location to another. When moving to an asset library (folder), the file maintains its original name in the destination. Fails if the source does not exist or if the destination already exists.

   :param source: Source file or folder to move
   :type source: assetKey or assetLibrary
   :param destination: Destination path or folder
   :type destination: assetKey or assetLibrary
   :return: Success status and error message
   :rtype: boolean, string or nil

   .. code-block:: lua

      -- Move a file to documents with a new name
      local ok, err = file.move(asset.icloud.Pack.File, asset.documents .. "MyFile.png")
      if not ok then
          print("Move failed:", err)
      end

      -- Move a file to documents (keeps original name)
      local ok, err = file.move(asset.icloud.Pack.File, asset.documents)

      -- Move an entire folder
      local ok, err = file.move(asset.icloud.Pack, asset.documents .. "MyPack")

.. lua:function:: remove(asset)

   Removes a file or folder. Built-in folders and top-level asset packs (asset, asset.builtin, asset.documents, asset.icloud) cannot be removed. Fails if the file does not exist.

   :param asset: File or folder to remove
   :type asset: assetKey or assetLibrary
   :return: Success status and error message
   :rtype: boolean, string or nil

   .. code-block:: lua

      -- Remove a file
      local ok, err = file.remove(asset.documents.File)
      if not ok then
          print("Remove failed:", err)
      end

      -- Remove a folder and all its contents
      local ok, err = file.remove(asset.documents.SomeFolder)

.. lua:function:: mkdir(asset)

   Creates a new directory. Fails if the directory already exists or if the parent directory does not exist.

   :param asset: Path where the directory should be created
   :type asset: assetKey or assetLibrary
   :return: Success status and error message
   :rtype: boolean, string or nil

   .. code-block:: lua

      -- Create a new folder in documents
      local ok, err = file.mkdir(asset.documents .. "MyFolder")
      if not ok then
          print("Create directory failed:", err)
      end

      -- Will fail if parent doesn't exist
      local ok, err = file.mkdir(asset.documents .. "Parent/Child")
      -- First create parent, then child
      file.mkdir(asset.documents .. "Parent")
      file.mkdir(asset.documents .. "Parent/Child")

.. lua:function:: rename(asset, newName)

   Renames a file or folder within the same parent directory. This is a synonym for moving within the same parent folder to a new name. Fails if the source does not exist or a sibling with the new name already exists.

   :param asset: Source file or folder to rename
   :type asset: assetKey
   :param newName: The new name for the file or folder
   :type newName: string
   :return: Success status and error message
   :rtype: boolean, string or nil

   .. code-block:: lua

      -- Rename a file within documents
      local ok, err = file.rename(asset.documents .. "Old.png", "New.png")
      if not ok then
          print("Rename failed:", err)
      end

      -- Rename a folder within documents
      local ok, err = file.rename(asset.documents .. "OldFolder", "NewFolder")

.. lua:function:: exists(asset)

   Checks if a file or folder exists at the given path.

   :param asset: Path to check for existence
   :type asset: assetKey or assetLibrary
   :return: True if the path exists, false otherwise
   :rtype: boolean

   .. code-block:: lua

      -- Check if a configuration file exists
      if file.exists(asset.documents .. "Config.json") then
          print("Config is present")
      else
          print("Missing Config.json")
      end

      -- Check if a folder exists
      if file.exists(asset.documents .. "Screenshots") then
          print("Screenshots folder exists")
      end

**Common Error Messages**

The file operations return specific error messages for different failure conditions:

* ``"No such file or directory."`` - The source file or folder does not exist
* ``"Destination already exists. Remove it first."`` - The destination already exists and operations don't overwrite
* ``"Cannot remove built-in or top-level asset packs."`` - Attempting to remove protected system folders
* ``"Parent folder does not exist."`` - Parent directory must exist when creating folders or copying files
* ``"Cannot move item: source and destination are identical."`` - Source and destination paths are the same
* ``"A file or directory with that name already exists."`` - Directory creation failed due to existing item

**Usage Patterns**

.. code-block:: lua

   -- Helper function for error checking
   local function checkResult(ok, err, operation)
       if not ok then
           print(operation .. " failed:", err)
           return false
       end
       return true
   end

   -- Example usage with error handling
   local ok, err = file.copy(asset.Main, asset.documents .. "Backup.lua")
   if checkResult(ok, err, "Backup creation") then
       print("Backup created successfully")
   end

   -- Verify operations with file.exists
   if file.exists(asset.documents .. "Backup.lua") then
       local ok, err = file.remove(asset.documents .. "Backup.lua")
       checkResult(ok, err, "Cleanup")
   end