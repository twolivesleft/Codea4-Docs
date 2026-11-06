Sound
=====

.. lua:module:: sound

The sound module provides a way to play and manage sound effects and background music

.. lua:staticmethod:: play(preset[, seed])

   Plays a preset procedural SFXR sound effect using a given ``preset`` and optional ``seed``

   .. helptext:: play a sound or procedural preset in 2D

   :rtype: sound.instance

.. lua:staticmethod:: play(source[, volume = 1, pitch = 1, pan = 0, paused = false])

   Plays a ``sound.source`` in 2D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play a sound or procedural preset in 2D

   :rtype: sound.instance

.. lua:staticmethod:: play(assetKey[, volume = 1, pitch = 1, pan = 0, paused = false])

   Plays a sound using an asset key in 2D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play a sound or procedural preset in 2D

.. lua:staticmethod:: play3d(source[, volume = 1, pitch = 1, paused = false])   

   Plays a ``sound.source`` in 3D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play a sound in 3D

   :rtype: sound.instance

.. lua:staticmethod:: play3d(assetKey[, volume = 1, pitch = 1, paused = false])   

   Plays a sound using an asset key in 3D, returning an active ``sound.instance`` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play a sound in 3D

   :rtype: sound.instance

.. lua:staticmethod:: playBackground(source[, volume = 1, pitch = 1, paused = false])   

   Plays a ``sound.source`` in the background (no spatialisation), returning an active `sound.instance` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play background audio

   :rtype: sound.instance

.. lua:staticmethod:: playBackground(assetKey[, volume = 1, pitch = 1, paused = false])   

   Plays an ``asset.key`` in the background (no spatialisation), returning an active `sound.instance` object that can be adjusted, paused/resumed and stopped

   .. helptext:: play background audio

   :rtype: sound.instance

.. lua:staticmethod:: read(assetKey)

   Reads a ``sound.source`` using an ``asset.key`` from the filesystem

   .. helptext:: load a sound from an asset

   Supported formats are - ``wav``, ``ogg``, ``mp3``, ``flac``

   :rtype: sound.source
   
.. lua:staticmethod:: generator(table)

   .. helptext:: create a procedural sound generator

.. lua:staticmethod:: stream([options])

   Creates a stream. ``options`` is a table with any of these fields

   - ``sampleRate`` - samples per second of each channel, from 8000 to 192000 (default 48000)
   - ``channels`` - 1 for mono or 2 for stereo (default 1)
   - ``capacity`` - seconds of audio the stream can hold, up to 10 (default 0.25)

   .. helptext:: create a sound stream

   :param options: sample rate, channel count and capacity
   :type options: table
   :rtype: sound.stream

.. lua:class:: stream

   A sound source that plays samples pushed to it from Lua, for synthesizers, music players and emulators

   Create one with ``sound.stream{ sampleRate, channels, capacity }`` and play it with ``sound.play`` like any other ``sound.source``. Push more samples every frame to keep it playing. Audio is heard a short time after it is pushed: the frames already queued, plus the audio output, which holds two buffers of 2048 frames at 44.1 kHz on iOS (46 ms each) and two of 4096 frames on Android (93 ms each). Audio is taken a whole output buffer at a time, so keep enough queued to cover one buffer and a slow frame: around 200 ms, or ``underruns`` will grow

   Playing a stream again stops the instance already playing it

   .. code-block:: lua

      function setup()
          out = sound.stream{ sampleRate = 48000, channels = 1 }
          sound.play(out)
          samples, phase = {}, 0
      end

      function draw()
          -- Keep about 200 ms of a 440 Hz tone queued
          local frames = math.max(0, 9600 - out.queued)
          for i = 1, frames do
              samples[i] = 0.3 * math.sin(phase)
              phase = phase + 2 * math.pi * 440 / 48000
          end
          out:push(samples, frames)
      end

   .. helptext:: play samples pushed from Lua

   .. lua:method:: push(samples[, count])

      Adds samples to the end of the stream and returns the number of frames taken. A frame is one sample for each channel, and stereo samples alternate left and right

      ``samples`` is either a table of numbers from -1 to 1, of which the first ``count`` are taken (default ``#samples``), or a string of signed 16-bit little-endian samples, as made by ``string.pack("<i2", sample)``. Reusing one table every frame is the fastest way to push many samples

      When the stream is full, only what fits is taken, so compare the result with the frames you pushed

      .. helptext:: add samples to play

      :param samples: samples to add
      :type samples: table or string
      :param count: number of samples to take from a table
      :type count: number
      :rtype: number

   .. lua:method:: clear()

      Removes every sample waiting to be played

      .. helptext:: drop queued samples

   .. lua:attribute:: queued: number [readonly]

      The number of frames pushed and not played yet

      .. helptext:: frames waiting to play

   .. lua:attribute:: capacity: number [readonly]

      The number of frames the stream can hold

      .. helptext:: most frames the stream holds

   .. lua:attribute:: underruns: number [readonly]

      The number of times playback has run out of samples. Each gap counts once, and playback resumes as soon as more samples are pushed

      .. helptext:: times the stream ran dry

   .. lua:attribute:: sampleRate: number [readonly]

      The sample rate the stream was created with

      .. helptext:: samples per second

   .. lua:attribute:: channels: number [readonly]

      The number of channels the stream was created with

      .. helptext:: 1 for mono, 2 for stereo

.. lua:class:: source

   A source of sound data to be used with ``sound.play``

   .. lua:attribute:: volume: number

      Adjusts the default volume of sounds played with this sound source

      .. helptext:: default playback volume

   .. lua:attribute:: loop: boolean

      Adjusts the default looping state of sounds played with this sound source

      .. helptext:: default looping state

   .. lua:attribute:: length: number [readonly]

      Gets the length of this sound source (in seconds)

      .. helptext:: length of the sound in seconds

.. lua:class:: instance

   An instance of a playing sound from ``sound.play`` and associated methods

   Sound instances can be used to monitor and adjust sounds while playing

   .. lua:attribute:: volume: number

      Adjusts the volume of the sound instance

      .. helptext:: current playback volume

   .. lua:attribute:: pitch: number

      Adjusts the pitch of the sounds (increases/decreases play speed)

      .. helptext:: current playback pitch

   .. lua:attribute:: loop: boolean

      The looping state of the sound instance. When set to true the sound instance will continuously loop

      .. helptext:: whether the sound loops

   .. lua:attribute:: paused: number

      Set the paused state of the sound instance

      .. helptext:: whether the sound is paused

   .. lua:attribute:: time: number

      Get/set the current time of the sound instances play head (in seconds)

      .. helptext:: current playback time

   .. lua:method:: stop

      Stop the sound instance from playing

      .. helptext:: stop the sound

.. lua:currentmodule:: None

.. lua:attribute:: SOUND_COIN: const

   Procedural coin sound preset (SFXR)

   .. helptext:: coin sound effect constant

.. lua:attribute:: SOUND_LASER: const

   Procedural laser sound preset (SFXR)

   .. helptext:: laser sound effect constant

.. lua:attribute:: SOUND_EXPLOSION: const

   Procedural explosion sound preset (SFXR)

   .. helptext:: explosion sound effect constant

.. lua:attribute:: SOUND_POWERUP: const

   Procedural powerup sound preset (SFXR)

   .. helptext:: power-up sound effect constant

.. lua:attribute:: SOUND_HURT: const

   Procedural hurt sound preset (SFXR)

   .. helptext:: hurt sound effect constant

.. lua:attribute:: SOUND_JUMP: const

   Procedural jump sound preset (SFXR)

   .. helptext:: jump sound effect constant

.. lua:attribute:: SOUND_BLIP: const

   Procedural blip sound preset (SFXR)

   .. helptext:: blip sound effect constant