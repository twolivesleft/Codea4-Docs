:reference-overview: Saving Project Data

Storage
=======

Use ``storage`` to keep settings, high scores, and progress between runs. Read and write values by name, such as ``storage.highScore``. Values belong to the current project by default; ``storage.project`` refers to the same store.

**Load a default, then save when something changes**

Read saved values in ``setup()``, choosing a default if nothing is saved yet. Save when a value changes. Here, ``recordScore(score)`` saves the high score at the end of a game:

.. code-block:: lua

   function setup()
       highScore = storage.highScore or 0
   end

   function recordScore(score)
       highScore = math.max(highScore, score)
       storage.highScore = highScore
   end

**Group related values with namespaces**

A namespace groups related keys in the same store. Here, ``prefs.musicEnabled`` uses the key ``"prefs.musicEnabled"``. Check for ``nil`` when choosing a default so a saved ``false`` value is kept:

.. code-block:: lua

   local prefs = storage:namespace("prefs")
   if prefs.musicEnabled == nil then
       prefs.musicEnabled = true -- default only on first use
   end

   local stats = storage:namespace("stats")
   -- Call this when a game finishes, not every frame.
   function recordGamePlayed()
       stats.gamesPlayed = (stats.gamesPlayed or 0) + 1
   end

**Choose project-local or shared data**

Use the default store for one project’s progress. Use ``storage.global`` to share values across projects on the same device. These values do not sync between devices:

.. code-block:: lua

   -- Private to this project
   storage.level = 3

   -- Shared by projects using this namespace on this device
   local sharedPrefs = storage.global:namespace("myGames")
   sharedPrefs.theme = "dark"

**Supported values and saving**

Values can be booleans, numbers, strings, or tables containing those kinds of values. Assign ``nil`` to delete a key, for example ``storage.temp = nil``. Use assets and files for images or other file contents.

Writes are saved in the background. Call ``storage:flush()`` when you need pending changes written before continuing. For a different store, flush that store, such as ``storage.global:flush()``; there is no need to flush every frame.

.. lua:module:: storage

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
