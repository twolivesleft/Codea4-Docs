Sound
=====

Sound in Codea
--------------

Use :lua:mod:`sound` to play music and audio files or create your own sound effects.

Playing Audio Files
-------------------

Play a file from the project or built-in assets with ``sound.play``:

.. code-block:: lua

   -- Play a built-in sound
   sound.play(asset.builtin.A_Spaceship.Laser_Shoot)

   -- Play a project sound and control it
   local src = sound.play(asset .. "music.mp3", { loop = true, volume = 0.5 })

``sound.play`` returns a ``sound.source`` that lets you control the audio after it starts:

.. code-block:: lua

   local src = sound.play(asset .. "music.mp3", { loop = true })

   -- Pause and resume
   src:pause()
   src:play()

   -- Adjust volume and pitch at runtime
   src.volume = 0.3
   src.pitch = 1.2

   -- Stop completely
   src:stop()

Loading vs Playing
------------------

For sounds you play frequently (like a gun shot), load the source once in ``setup()`` and call ``play()`` on it:

.. code-block:: lua

   function setup()
       shootSound = sound.load(asset.builtin.A_Spaceship.Laser_Shoot)
   end

   function draw()
       if input.key.space then
           shootSound:play()
       end
   end

Loading once avoids decoding the same audio each time you play it.

Procedural Sound
----------------

Create a sound effect without an audio file using ``sound.synthesize``:

.. code-block:: lua

   -- A retro blip sound
   local blip = sound.synthesize({
       wave = SINE,
       startFreq = 440,
       endFreq = 880,
       sustainTime = 0.1,
       decayTime = 0.05,
       volume = 0.8
   })
   blip:play()

Parameters let you shape the sound's frequency envelope, waveform, and timing.

Background Music
----------------

For longer music tracks, use ``sound.play`` with ``{ loop = true }``. Keep a reference to stop or fade it:

.. code-block:: lua

   function setup()
       music = sound.play(asset .. "background.mp3", { loop = true, volume = 0.4 })
   end

   function cleanup()
       if music then
           music:stop()
       end
   end
