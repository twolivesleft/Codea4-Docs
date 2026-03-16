storage
=======

Simple key/value storage.

Saving happens in the background, so your project can keep running smoothly. If you need to make sure your changes are saved right away (for example, before quitting or switching levels), call storage:flush().

Storage uses string keys (like "highScore"), and the value you save must be either boolean, number, string, or a table containing only those kinds of values. If you store nil for a given key, then that key/value pair will be removed from storage.

You can read and write values directly using property-style access (``storage.highScore = 100`` and ``print(storage.highScore)``).

The default storage is per-project. A device-wide store is available under ``storage.global``.

.. lua:module:: storage

**Basic Usage**

.. code-block:: lua

   -- Default project storage
   storage.highScore = 9001
   print(storage.highScore or 0)

   -- Missing key uses default
   print(storage.missing or 42)

   -- Remove a key
   storage.temp = nil

.. lua:function:: has(key)

   Checks if a key exists.

   .. helptext:: check if a key exists

   :param key: Key to check
   :type key: string
   :return: True if the key exists, false otherwise
   :rtype: boolean

   .. code-block:: lua

      if storage:has("playerName") then
          print("Player name saved")
      end

.. lua:function:: delete(key)

   Removes a key.

   .. helptext:: remove a key from storage

   :param key: Key to remove
   :type key: string

   .. code-block:: lua

      storage:delete("tutorialSeen")

.. lua:function:: keys()

   Returns a sorted array of all keys in the store.

   .. helptext:: get all keys in storage

   :return: Sorted list of keys
   :rtype: table

   .. code-block:: lua

      for _, key in ipairs(storage:keys()) do
          print(key)
      end

.. lua:function:: clear()

   Removes all keys from the store.

   .. helptext:: remove all keys from storage

   .. code-block:: lua

      storage:clear()

.. lua:function:: flush()

   Writes any pending changes synchronously.

   .. helptext:: write pending storage changes immediately

   .. code-block:: lua

      storage.level = 3
      storage:flush()

.. lua:function:: asset()

   Returns the underlying asset key for the storage file.

   .. helptext:: get the asset key used by this store

   :return: Asset key used for the store file
   :rtype: assetKey

   .. code-block:: lua

      print(storage:asset())

.. lua:function:: namespace(prefix)

   Returns a view of the store that prefixes all keys with ``prefix``. A ``.`` is added automatically if missing.

   .. helptext:: create a namespaced view of storage

   :param prefix: Namespace prefix (for example, ``"prefs"``)
   :type prefix: string
   :return: Namespaced storage view
   :rtype: table

   .. code-block:: lua

      local prefs = storage:namespace("prefs")
      prefs.audioMuted = true -- stored as "prefs.audioMuted"
      print(prefs.audioMuted)

.. lua:attribute:: storage.project: storage

   Default project-scoped storage (stored under ``asset``). This is the same store used by the top-level ``storage`` functions.

   .. helptext:: default project storage

.. lua:attribute:: storage.global: storage

   Default device-wide storage (stored under ``asset.documents``).

   .. helptext:: default device-wide storage

.. lua:function:: projectStore(name)

   Convenience wrapper for ``storage(name, "project")``.

   .. helptext:: create or get a named project store

   :param name: Store name
   :type name: string
   :return: Storage instance
   :rtype: table

.. lua:function:: globalStore(name)

   Convenience wrapper for ``storage(name, "global")``.

   .. helptext:: create or get a named global store

   :param name: Store name
   :type name: string
   :return: Storage instance
   :rtype: table

.. lua:currentmodule:: None

.. lua:function:: storage(name [, scope])

   Returns a named store. Stores are cached by name and scope, so repeated calls return the same store instance.

   .. helptext:: create or get a named storage object

   :param name: Store name (used to derive the file name)
   :type name: string
   :param scope: Store scope (``"project"`` or ``"global"``)
   :type scope: string
   :return: Storage instance
   :rtype: table

   .. code-block:: lua

      local settings = storage("settings")
      local globalPrefs = storage("prefs", "global")

**Usage Patterns**

.. code-block:: lua

   -- Separate storage for different systems
   local prefs = storage:namespace("prefs")
   local stats = storage:namespace("stats")

   prefs.musicEnabled = true
   stats.gamesPlayed = 12

   -- Project vs global
   local projectStore = storage.project
   local globalStore = storage.global

   projectStore.level = 3
   globalStore.unlocked = { "sword", "shield" }

**Notes**

* Keys must be strings
* Values must be (``nil``, ``boolean``, ``number``, ``string``, ``table``)
* Storage saves in the background, call storage:flush() if you need to write storage immediately (for example, before quitting)
