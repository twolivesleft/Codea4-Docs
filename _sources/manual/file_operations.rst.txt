File Operations
===============

Working with Files in Codea
----------------------------

Codea provides a comprehensive file operations API through the :lua:mod:`file` module that allows you to manage assets, create directories, and organize your project files. Unlike traditional file APIs, Codea's file operations are designed around the asset system and return status values rather than throwing exceptions.

All file operations return two values: a success boolean and an error message string. On success, operations return ``true, nil``. On failure, they return ``false, "error message"``. This pattern allows for robust error handling and makes it easy to build reliable applications.

Basic File Operations
---------------------

The file module provides five core operations: copying, moving, removing, creating directories, and renaming files. These operations work with both individual files and entire folders.

**Copying Files**

The :lua:func:`file.copy` function duplicates files and folders from one location to another:

.. code-block:: lua

   -- Copy a file with a new name
   local ok, err = file.copy(asset.Main, asset.documents .. "MainBackup.lua")
   if not ok then
       print("Copy failed:", err)
   end

   -- Copy a file to a directory (keeps original name)
   file.copy(asset.builtin.Platformer_Art.Player_01, asset.documents)

When copying to an asset library (a folder), the file automatically maintains its original filename in the destination.

**Moving and Renaming Files**

Files can be moved between locations using :lua:func:`file.move`, or renamed within the same directory using :lua:func:`file.rename`:

.. code-block:: lua

   -- Move a file to a new location
   file.move(asset.documents .. "OldLocation.lua", asset.documents .. "NewLocation.lua")

   -- Rename a file within the same directory
   file.rename(asset.documents .. "OldName.lua", "NewName.lua")

**Creating Directories**

New directories are created with :lua:func:`file.mkdir`. The parent directory must exist before creating subdirectories:

.. code-block:: lua

   -- Create a screenshots directory
   file.mkdir(asset.documents .. "Screenshots")

   -- Create nested directories (parent must exist first)
   file.mkdir(asset.documents .. "Projects")
   file.mkdir(asset.documents .. "Projects/GameData")

**Removing Files and Directories**

The :lua:func:`file.remove` function deletes both files and directories:

.. code-block:: lua

   -- Remove a single file
   file.remove(asset.documents .. "TempFile.txt")

   -- Remove a directory and all its contents
   file.remove(asset.documents .. "TempFolder")

Asset System Integration
------------------------

Codea's file operations are tightly integrated with the asset system, allowing you to work with files across different asset locations:

- **asset** - Your current project files
- **asset.documents** - User documents folder
- **asset.builtin** - Built-in Codea assets (read-only)
- **asset.icloud** - iCloud documents (when available)

.. code-block:: lua

   -- Copy from builtin assets to your project
   file.copy(asset.builtin.Planet_Cute.Heart, asset .. "Heart.png")

   -- Organize project files
   file.mkdir(asset .. "Images")
   file.move(asset .. "Heart.png", asset .. "Images/Heart.png")

The asset system automatically handles path resolution and ensures operations work correctly across different storage locations.

Error Handling Patterns
------------------------

Robust applications should always check the return values from file operations. Here are some common patterns:

**Simple Error Checking**

.. code-block:: lua

   local ok, err = file.copy(source, destination)
   if not ok then
       print("Operation failed:", err)
       return
   end
   -- Continue with success case

**Helper Function Pattern**

.. code-block:: lua

   local function safeFileOp(operation, ...)
       local ok, err = operation(...)
       if not ok then
           error("File operation failed: " .. tostring(err))
       end
       return true
   end

   -- Usage
   safeFileOp(file.copy, asset.Main, asset.documents .. "Backup.lua")
   safeFileOp(file.mkdir, asset.documents .. "NewFolder")

**Conditional Operations**

.. code-block:: lua

   -- Only create directory if it doesn't exist
   if not file.exists(asset.documents .. "Cache") then
       local ok, err = file.mkdir(asset.documents .. "Cache")
       if not ok then
           print("Failed to create cache directory:", err)
       end
   end

   -- Safe cleanup - remove only if exists
   if file.exists(asset.documents .. "TempFile.txt") then
       file.remove(asset.documents .. "TempFile.txt")
   end

Working with Folders
---------------------

File operations can work with entire folders, making it easy to organize and restructure your project assets:

.. code-block:: lua

   -- Copy an entire asset pack to documents
   file.copy(asset.builtin.Space_Art, asset.documents .. "SpaceAssets")

   -- Reorganize project structure
   file.mkdir(asset .. "Source")
   file.mkdir(asset .. "Assets")

   -- Move Lua files to Source folder
   for _, fileName in ipairs({"Main.lua", "Game.lua", "Menu.lua"}) do
       if file.exists(asset .. fileName) then
           file.move(asset .. fileName, asset .. "Source/" .. fileName)
       end
   end

When copying folders, the entire directory structure is preserved, including all subdirectories and files.

Security and Limitations
-------------------------

The file system has built-in protections to prevent accidental damage to system files:

**Protected Locations**

- Top-level asset packs (``asset``, ``asset.builtin``, ``asset.documents``, ``asset.icloud``) cannot be removed
- Built-in assets are read-only and cannot be modified
- Operations that would overwrite existing files fail by default

**Common Error Conditions**

- ``"No such file or directory."`` - Source doesn't exist
- ``"Destination already exists. Remove it first."`` - Target already exists
- ``"Cannot remove built-in or top-level asset packs."`` - Protected location
- ``"Parent folder does not exist."`` - Directory structure issue

**Best Practices**

- Always check if files exist before operating on them with :lua:func:`file.exists`
- Use descriptive error messages when operations fail
- Clean up temporary files and directories when done
- Test file operations during development to ensure they work as expected

.. code-block:: lua

   -- Example: Safe project backup function
   function backupProject()
       local timestamp = os.date("%Y%m%d_%H%M%S")
       local backupDir = asset.documents .. "Backups/Project_" .. timestamp

       -- Create backup directory
       local ok, err = file.mkdir(asset.documents .. "Backups")
       if not ok and not string.find(err, "already exists") then
           print("Failed to create backup folder:", err)
           return false
       end

       ok, err = file.mkdir(backupDir)
       if not ok then
           print("Failed to create timestamped backup:", err)
           return false
       end

       -- Copy all project files
       ok, err = file.copy(asset, backupDir)
       if not ok then
           print("Failed to backup project:", err)
           return false
       end

       print("Project backed up to:", backupDir)
       return true
   end

See :doc:`/api/file` for the complete API reference with detailed function descriptions and parameters.