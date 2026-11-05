:reference-overview: Using Legacy Compatibility

Legacy Compatibility
====================

The modern renderer supplies compatibility globals from ``codea/legacy.lua``
so older projects can migrate gradually. These are migration helpers, not the
preferred API for new code. The wrappers do not restore the legacy renderer or
all of its behavior. Use the corresponding modern modules when updating a project.

Migrating a project
-------------------

Replace drawing-state globals with ``style`` and transforms with ``matrix``.
Use ``image.read`` and ``image.save`` for assets, ``storage`` for persistent data,
and ``time`` and ``touch`` for current frame state. Keep paired push/pop calls
balanced. Test text alignment and image filtering: the compatibility layer
translates old conventions rather than simply renaming every call.

The old ``physics`` global is a compatibility facade over ``physics2d``. It
translates numeric body/joint constants and legacy collision callbacks; new
projects should use the world, body, collider and joint APIs directly.
``CAMERA`` and ``CAMERA_DEPTH`` follow sensor images (or a placeholder until a
frame arrives). ``cameraSource`` reads or changes the sensor camera selection.

Aliases
-------

.. lua:currentmodule:: None

.. lua:function:: pushStyle()

   Compatibility wrapper for ``style.push()``.

   .. deprecated:: 4.0
      Use ``style.push()`` in modern projects.

   .. helptext:: legacy alias; use style.push()

.. lua:function:: popStyle()

   Compatibility wrapper for ``style.pop()``.

   .. deprecated:: 4.0
      Use ``style.pop()`` in modern projects.

   .. helptext:: legacy alias; use style.pop()

.. lua:function:: resetStyle()

   Compatibility wrapper for ``style.reset()``.

   .. deprecated:: 4.0
      Use ``style.reset()`` in modern projects.

   .. helptext:: legacy alias; use style.reset()

.. lua:function:: blendMode(...)

   Compatibility wrapper for ``style.blend(...)``.

   .. deprecated:: 4.0
      Use ``style.blend(...)`` in modern projects.

   .. helptext:: legacy alias; use style.blend(...)

.. lua:function:: noTint()

   Compatibility wrapper for ``style.tint(255, 255, 255, 255)``.

   .. deprecated:: 4.0
      Use ``style.tint(255, 255, 255, 255)`` in modern projects.

   .. helptext:: legacy alias; use style.tint(255, 255, 255, 255)

.. lua:function:: spriteMode(...)

   Compatibility wrapper for ``style.spriteMode(...)``.

   .. deprecated:: 4.0
      Use ``style.spriteMode(...)`` in modern projects.

   .. helptext:: legacy alias; use style.spriteMode(...)

.. lua:function:: spriteSize(...)

   Compatibility wrapper for ``image.read(assetKey).width and .height``.

   .. deprecated:: 4.0
      Use ``image.read(assetKey).width and .height`` in modern projects.

   .. helptext:: legacy alias; use image.read(assetKey).width and .height

.. lua:function:: rectMode(...)

   Compatibility wrapper for ``style.rectMode(...)``.

   .. deprecated:: 4.0
      Use ``style.rectMode(...)`` in modern projects.

   .. helptext:: legacy alias; use style.rectMode(...)

.. lua:function:: ellipseMode(...)

   Compatibility wrapper for ``style.ellipseMode(...)``.

   .. deprecated:: 4.0
      Use ``style.ellipseMode(...)`` in modern projects.

   .. helptext:: legacy alias; use style.ellipseMode(...)

.. lua:function:: lineCapMode(...)

   Compatibility wrapper for ``style.lineCap(...)``.

   .. deprecated:: 4.0
      Use ``style.lineCap(...)`` in modern projects.

   .. helptext:: legacy alias; use style.lineCap(...)

.. lua:function:: noSmooth(...)

   Compatibility wrapper for ``style.noSmooth() and style.filter(image.filter.point)``.

   .. deprecated:: 4.0
      Use ``style.noSmooth() and style.filter(image.filter.point)`` in modern projects.

   .. helptext:: legacy alias; use style.noSmooth() and style.filter(image.filter.point)

.. lua:function:: smooth(...)

   Compatibility wrapper for ``style.smooth() and style.filter(image.filter.linear)``.

   .. deprecated:: 4.0
      Use ``style.smooth() and style.filter(image.filter.linear)`` in modern projects.

   .. helptext:: legacy alias; use style.smooth() and style.filter(image.filter.linear)

.. lua:function:: pushMatrix()

   Compatibility wrapper for ``matrix.push()``.

   .. deprecated:: 4.0
      Use ``matrix.push()`` in modern projects.

   .. helptext:: legacy alias; use matrix.push()

.. lua:function:: popMatrix()

   Compatibility wrapper for ``matrix.pop()``.

   .. deprecated:: 4.0
      Use ``matrix.pop()`` in modern projects.

   .. helptext:: legacy alias; use matrix.pop()

.. lua:function:: resetMatrix()

   Compatibility wrapper for ``matrix.reset()``.

   .. deprecated:: 4.0
      Use ``matrix.reset()`` in modern projects.

   .. helptext:: legacy alias; use matrix.reset()

.. lua:function:: modelMatrix(...)

   Compatibility wrapper for ``matrix.model(...)``.

   .. deprecated:: 4.0
      Use ``matrix.model(...)`` in modern projects.

   .. helptext:: legacy alias; use matrix.model(...)

.. lua:function:: fontMetrics(...)

   Compatibility wrapper for ``font.metrics(...)``.

   .. deprecated:: 4.0
      Use ``font.metrics(...)`` in modern projects.

   .. helptext:: legacy alias; use font.metrics(...)

.. lua:function:: readImage(...)

   Compatibility wrapper for ``image.read(...)``.

   .. deprecated:: 4.0
      Use ``image.read(...)`` in modern projects.

   .. helptext:: legacy alias; use image.read(...)

.. lua:function:: saveImage(...)

   Compatibility wrapper for ``image.save(...)``.

   .. deprecated:: 4.0
      Use ``image.save(...)`` in modern projects.

   .. helptext:: legacy alias; use image.save(...)

.. lua:function:: triangulate(...)

   Compatibility wrapper for ``mesh.triangulate(...)``.

   .. deprecated:: 4.0
      Use ``mesh.triangulate(...)`` in modern projects.

   .. helptext:: legacy alias; use mesh.triangulate(...)

.. lua:function:: setContext(...)

   Compatibility wrapper for ``context.push(image) and context.pop()``.

   .. deprecated:: 4.0
      Use ``context.push(image) and context.pop()`` in modern projects.

   .. helptext:: legacy alias; use context.push(image) and context.pop()

.. lua:function:: soundBufferSize(...)

   Unsupported compatibility stub. Returns ``0, 0``; it does not configure audio.

   .. deprecated:: 4.0
      Use the modern ``sound`` module; there is no buffer-size equivalent.

   .. helptext:: unsupported legacy audio buffer stub

   :rtype: number, number

.. lua:function:: readLocalData(key, defaultValue)

   Compatibility storage operation using ``storage.global:namespace("__legacy.local." .. asset.name):get(tostring(key), defaultValue)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:namespace("__legacy.local." .. asset.name):get(tostring(key), defaultValue)``.

   .. helptext:: legacy local storage read

.. lua:function:: saveLocalData(key, value)

   Compatibility storage operation using ``storage.global:namespace("__legacy.local." .. asset.name):set(tostring(key), value)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:namespace("__legacy.local." .. asset.name):set(tostring(key), value)``.

   .. helptext:: legacy local storage save

.. lua:function:: listLocalData()

   Compatibility storage operation using ``storage.global:namespace("__legacy.local." .. asset.name):keys()``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:namespace("__legacy.local." .. asset.name):keys()``.

   .. helptext:: legacy local storage list

.. lua:function:: clearLocalData()

   Compatibility storage operation using ``storage.global:namespace("__legacy.local." .. asset.name):clear()``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:namespace("__legacy.local." .. asset.name):clear()``.

   .. helptext:: legacy local storage clear

.. lua:function:: readProjectData(key, defaultValue)

   Compatibility storage operation using ``storage.project:get("__legacy.project." .. tostring(key), defaultValue)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.project:get("__legacy.project." .. tostring(key), defaultValue)``.

   .. helptext:: legacy project storage read

.. lua:function:: saveProjectData(key, value)

   Compatibility storage operation using ``storage.project:set("__legacy.project." .. tostring(key), value)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.project:set("__legacy.project." .. tostring(key), value)``.

   .. helptext:: legacy project storage save

.. lua:function:: listProjectData()

   Returns sorted keys from ``storage.project`` beginning with ``__legacy.project.``,
   with that prefix removed. Other modern storage keys are excluded.

   .. deprecated:: 4.0
      Use ``storage.project:keys()`` and filter the legacy prefix when migrating existing data.

   .. helptext:: list legacy project storage keys

.. lua:function:: clearProjectData()

   Deletes only ``storage.project`` keys beginning with ``__legacy.project.``.
   Other modern project data is retained.

   .. deprecated:: 4.0
      Use ``storage.project:set(key, nil)`` for each legacy-prefixed key. Clearing
      the entire modern store would also delete unrelated data.

   .. helptext:: delete legacy project storage keys

.. lua:function:: readGlobalData(key, defaultValue)

   Compatibility storage operation using ``storage.global:get("__legacy.global." .. tostring(key), defaultValue)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:get("__legacy.global." .. tostring(key), defaultValue)``.

   .. helptext:: legacy global storage read

.. lua:function:: saveGlobalData(key, value)

   Compatibility storage operation using ``storage.global:set("__legacy.global." .. tostring(key), value)``.
   Saving ``nil`` deletes a key. Local data uses a namespace based on the project name.

   .. deprecated:: 4.0
      Use ``storage.global:set("__legacy.global." .. tostring(key), value)``.

   .. helptext:: legacy global storage save

.. lua:function:: listGlobalData()

   Returns sorted keys from ``storage.global`` beginning with ``__legacy.global.``,
   with that prefix removed. Other modern storage keys are excluded.

   .. deprecated:: 4.0
      Use ``storage.global:keys()`` and filter the legacy prefix when migrating existing data.

   .. helptext:: list legacy global storage keys

.. lua:attribute:: DeltaTime: number

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``time.delta (or time.fixedDelta in fixedUpdate)``.

   .. helptext:: legacy value; use time.delta (or time.fixedDelta in fixedUpdate)

.. lua:attribute:: ElapsedTime: number

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``time.elapsed``.

   .. helptext:: legacy value; use time.elapsed

.. lua:attribute:: CurrentTouch: touch

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``touch.current``.

   .. helptext:: legacy value; use touch.current

.. lua:attribute:: CAMERA: image

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``sensor.cameraColor``.

   .. helptext:: legacy value; use sensor.cameraColor

.. lua:attribute:: CAMERA_DEPTH: image

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``sensor.cameraDepth``.

   .. helptext:: legacy value; use sensor.cameraDepth

.. lua:attribute:: physics: table

   Legacy compatibility value.

   .. deprecated:: 4.0
      Use ``physics2d``.

   .. helptext:: legacy value; use physics2d


.. lua:function:: cameraSource([source])

   With no argument, returns ``sensor.cameraSource``. With an argument, sets
   ``sensor.cameraSource`` and ensures the legacy camera image placeholder exists.

   .. deprecated:: 4.0
      Read or assign ``sensor.cameraSource`` directly.

   .. helptext:: legacy sensor camera selection
