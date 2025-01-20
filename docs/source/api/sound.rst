sound
=====

.. lua:module:: sound

The sound module provides a way to play and manage sound effects and background music

.. lua:attribute:: SOUND_COIN: const

   Procedural coin sound preset (SFXR)

.. lua:attribute:: SOUND_LASER: const

   Procedural laser sound preset (SFXR)

.. lua:attribute:: SOUND_EXPLOSION: const

   Procedural explosion sound preset (SFXR)

.. lua:attribute:: SOUND_POWERUP: const

   Procedural powerup sound preset (SFXR)

.. lua:attribute:: SOUND_HURT: const

   Procedural hurt sound preset (SFXR)

.. lua:attribute:: SOUND_JUMP: const

   Procedural jump sound preset (SFXR)

.. lua:attribute:: SOUND_BLIP: const

   Procedural blip sound preset (SFXR)

.. lua:staticmethod:: play(preset[, seed])

   Plays a preset procedural SFXR sound effect using a given ``preset`` and optional ``seed``

   :rtype: sound.instance

.. lua:staticmethod:: play(source[, volume = 1, pitch = 1, pan = 0, paused = false])

   Plays a ``sound.source`` in 2D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   :rtype: sound.instance

.. lua:staticmethod:: play(assetKey[, volume = 1, pitch = 1, pan = 0, paused = false])

   Plays a sound using an asset key in 2D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

.. lua:staticmethod:: play3d(source[, volume = 1, pitch = 1, paused = false])   

   Plays a ``sound.source`` in 3D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   :rtype: sound.instance

.. lua:staticmethod:: play3d(assetKey[, volume = 1, pitch = 1, paused = false])   

   Plays a sound using an asset key in 3D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   :rtype: sound.instance

.. lua:staticmethod:: playBackground(source[, volume = 1, pitch = 1, paused = false])   

   Plays a ``sound.source`` in the background (no spatialisation), returning an active `sound.instance` object that can be adjusted, paused/resumed and stopped

   :rtype: sound.instance

.. lua:staticmethod:: playBackground(assetKey[, volume = 1, pitch = 1, paused = false])   

   Plays an ``asset.key`` in the background (no spatialisation), returning an active `sound.instance` object that can be adjusted, paused/resumed and stopped

   :rtype: sound.instance

.. lua:staticmethod:: read(assetKey)

   Reads a ``sound.source`` using an ``asset.key`` from the filesystem

   Supported formats are - ``wav``, ``ogg``, ``mp3``, ``flac``

   :rtype: sound.source
   
.. lua:staticmethod:: generator(table)      

.. lua:class:: source

   A source of sound data to be used with ``sound.play``

   .. lua:attribute:: volume: number

      Adjusts the default volume of sounds played with this sound source

   .. lua:attribute:: loop: boolean

      Adjusts the default looping state of sounds played with this sound source

   .. lua:attribute:: length: number [readonly]

      Gets the length of this sound source (in seconds)

.. lua:class:: instance

   An instance of a playing sound from ``sound.play`` and associated methods

   Sound instances can be used to monitor and adjust sounds while playing

   .. lua:attribute:: volume: number

      Adjusts the volume of the sound instance

   .. lua:attribute:: pitch: number

      Adjusts the pitch of the sounds (increases/decreases play speed)

   .. lua:attribute:: loop: boolean

      The looping state of the sound instance. When set to true the sound instance will continuously loop

   .. lua:attribute:: paused: number

      Set the paused state of the sound instance

   .. lua:attribute:: time: number

      Get/set the current time of the sound instances play head (in seconds)

   .. lua:method:: stop

      Stop the sound instance from playing