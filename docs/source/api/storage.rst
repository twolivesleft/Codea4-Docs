storage
=======

Simple key/value storage backed by JSON and the built-in ``string.read`` / ``string.save`` functions. The default storage is per-project (stored under ``asset``). A device-wide store is available under ``storage.global`` (stored under ``asset.documents``).

All writes are immediate. Keys must be strings, and values must be JSON-encodable (``nil``, ``boolean``, ``number``, ``string``, ``table``).

.. lua:module:: storage

.. lua:function:: get(key [, default])

   Gets a value for a key, returning ``default`` if the key does not exist.

   :param key: Key to read
   :type key: string
   :param default: Value to return when key is missing
   :type default: any
   :return: Stored value or default
   :rtype: any

   .. code-block:: lua

      -- Default project storage
      storage:set("highScore", 9001)
      print(storage:get("highScore", 0))

      -- Missing key uses default
      print(storage:get("missing", 42))

.. lua:function:: set(key, value)

   Sets a key to a value. Passing ``nil`` deletes the key.

   :param key: Key to write
   :type key: string
   :param value: Value to store (JSON-encodable)
   :type value: any
   :return: True on success, false on failure
   :rtype: boolean

   .. code-block:: lua

      storage:set("musicEnabled", true)
      storage:set("volume", 0.8)
      storage:set("temp", nil) -- deletes the key

.. lua:function:: has(key)

   Checks if a key exists.

   :param key: Key to check
   :type key: string
   :return: True if the key exists, false otherwise
   :rtype: boolean

   .. code-block:: lua

      if storage:has("playerName") then
          print("Player name saved")
      end

.. lua:function:: delete(key)

   Removes a key. This is a synonym for ``set(key, nil)``.

   :param key: Key to remove
   :type key: string
   :return: True on success, false on failure
   :rtype: boolean

   .. code-block:: lua

      storage:delete("tutorialSeen")

.. lua:function:: keys()

   Returns a sorted array of all keys in the store.

   :return: Sorted list of keys
   :rtype: table

   .. code-block:: lua

      for _, key in ipairs(storage:keys()) do
          print(key)
      end

.. lua:function:: clear()

   Removes all keys from the store.

   :return: True on success, false on failure
   :rtype: boolean

   .. code-block:: lua

      storage:clear()

.. lua:function:: key()

   Returns the underlying asset key for the storage file.

   :return: Asset key used for the store file
   :rtype: assetKey

   .. code-block:: lua

      print(storage:key())

.. lua:function:: namespace(prefix)

   Returns a view of the store that prefixes all keys with ``prefix``. A ``.`` is added automatically if missing.

   :param prefix: Namespace prefix (for example, ``"prefs"``)
   :type prefix: string
   :return: Namespaced storage view
   :rtype: table

   .. code-block:: lua

      local prefs = storage:namespace("prefs")
      prefs:set("audioMuted", true) -- stored as "prefs.audioMuted"
      print(prefs:get("audioMuted"))

.. lua:attribute:: storage.project: storage

   Default project-scoped storage (stored under ``asset``). This is the same store used by the top-level ``storage`` functions.

.. lua:attribute:: storage.global: storage

   Default device-wide storage (stored under ``asset.documents``).

.. lua:function:: store(name [, opts])

   Returns a named store. Stores are cached by name and scope, so repeated calls return the same store instance.

   :param name: Store name (used to derive the file name)
   :type name: string
   :param opts: Options table
   :type opts: table
   :return: Storage instance
   :rtype: table

   **Options**

   * ``scope``: ``"project"`` (default) or ``"global"``

   .. code-block:: lua

      local settings = storage.store("settings")
      local globalPrefs = storage.store("prefs", { scope = "global" })

.. lua:function:: projectStore(name)

   Convenience wrapper for ``storage.store(name, { scope = "project" })``.

   :param name: Store name
   :type name: string
   :return: Storage instance
   :rtype: table

.. lua:function:: globalStore(name)

   Convenience wrapper for ``storage.store(name, { scope = "global" })``.

   :param name: Store name
   :type name: string
   :return: Storage instance
   :rtype: table

**Usage Patterns**

.. code-block:: lua

   -- Separate storage for different systems
   local prefs = storage:namespace("prefs")
   local stats = storage:namespace("stats")

   prefs:set("musicEnabled", true)
   stats:set("gamesPlayed", 12)

   -- Project vs global
   local projectStore = storage.project
   local globalStore = storage.global

   projectStore:set("level", 3)
   globalStore:set("unlocked", { "sword", "shield" })

**Notes**

* Keys must be strings
* Values must be JSON-encodable
* Writes are immediate
