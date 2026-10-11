Microphone
==========

Tracks the volume and pitch of sound coming into the device microphone.

The first call to ``mic.start`` asks the user for permission to use the microphone. While the microphone is running, other sounds keep playing through the speaker.

.. lua:module:: mic

.. lua:function:: start()

   Start tracking input from the device microphone

   .. helptext:: start tracking the microphone

   .. code-block:: lua

      function setup()
          mic.start()
      end

      function draw()
          background(40)
          text(string.format("%.2f Hz", mic.frequency), WIDTH/2, HEIGHT/2)
      end

.. lua:function:: stop()

   Stop tracking input from the device microphone. The microphone also stops automatically when the project exits

   .. helptext:: stop tracking the microphone

.. lua:attribute:: amplitude: number [readonly]

   The volume of sound coming into the microphone. Silence is close to ``0``, and a loud, full-scale sound reaches about ``2``

   Returns ``0`` when the microphone is not running

   .. helptext:: volume of the microphone input

.. lua:attribute:: frequency: number [readonly]

   The pitch of sound coming into the microphone, in hertz. Keeps its last value when the input goes quiet or has no clear pitch

   Returns ``0`` when the microphone is not running

   .. helptext:: pitch of the microphone input in hertz

.. lua:currentmodule:: None
