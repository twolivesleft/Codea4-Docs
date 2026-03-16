tween
=====

Procedurally animate values over time, otherwise known as tweening

.. code-block:: lua
   :caption: Tweening a value

   function setup()    
      p = vec2(0, HEIGHT/2)
      tween(p):to{x = WIDTH}:time(5)
   end

   function draw()
      background(40, 40, 50)

      style.strokeWidth(5)    
      ellipse(p, 50)    
   end

.. lua:class:: tween

   .. lua:staticmethod:: tween(target)

      Create a new tween for a given target

      Tweens are constructed using a fluent syntax via the ``to{}`` method

      Each call to ``to{}`` will construct a tween segment, which can be customised (duration, easing function, callbacks, looping, etc...)

      The tween can also be paused, resumed, restarted, cancelled and destroyed

      :param target: The target to tween
      :type target: table | usertype

      .. helptext:: tween a value or values to a given target

   .. lua:attribute:: duration: number

      The total duration of the tween in seconds

      .. helptext:: get or set the duration of this tween

   .. lua:attribute:: progress: number

      The current progress of the tween in seconds

      .. helptext:: get or set the progress of this tween
   
   .. lua:attribute:: target: object

      The target object being tweened

      .. helptext:: get or set the target object of this tween

   .. lua:method:: to(keyValuePairs)

      Creates a new tweening segement, each key is animated to the corresponding value
      
      Multiple tweening segments can be created one after another, but the same set of keys and values should be used for all of them

      :param keyValuePairs: The key value pairs to be tweened
      :type keyValuePairs: table

      .. helptext:: add a tweening segment with target values

   .. lua:method:: time(duration)

      Sets The duration of the current tweening segment (created via ``to{}``)

      :param duration: The amount of time to take in seconds
      :type keyValuePairs: number

      .. helptext:: set the duration of the current tween segment

   .. lua:method:: ease(easeType)

      Sets the easing type for the current tweening segment (created via ``to{}``)

      :param easeType: The easing function to use
      :type easeType: constant

      .. helptext:: set the easing function for the current tween segment

   .. lua:method:: loop(count)

      Sets the loop count for the current tweening segment (created via ``to{}``). Using `nil` for the count will result in an infinite number of loops

      :param count: The number of times to loop
      :type easeType: integer

      .. helptext:: set the loop count for the current tween segment

   .. lua:method:: pingpong(count)

      Sets the current tweening segment (created via ``to{}``) to ping-pong. Using `nil` for the count will result in an infinite number of ping-pongs

      :param count: The number of times to ping-pong
      :type easeType: integer

      .. helptext:: set the current tween segment to ping-pong

   .. lua:method:: relative()

      Sets the current tweening segment (created via ``to{}``) to be relative

      Relative tweens will apply values additively from their initial state

      .. helptext:: set the current tween segment to use relative values

   .. lua:method:: unscaled()

      Sets the current tweening segment (created via ``to{}``) to used unscaled time

      Unscaled tweens will not be effected by ``time.scale``

      .. helptext:: set the current tween segment to use unscaled time

   .. lua:method:: onStep(callback)

      Sets a callback for each time the tween is stepped (advanced once per frame)

      :param callback: The number of times to ping-pong
      :type callback: function

      .. helptext:: set a callback for each tween step

   .. lua:method:: onStep(callback)

      Sets a callback for each time the tween is stepped (advanced once per frame)

      :param callback: The callback function
      :type callback: function

      .. helptext:: set a callback for each tween step

   .. lua:method:: onSeek(callback)

      Sets a callback for each time the tween seeks

      :param callback: The callback function
      :type callback: function

      .. helptext:: set a callback for each tween seek

   .. lua:method:: onComplete(callback)

      Sets a callback for each time the tween completes

      :param callback: The callback function
      :type callback: function

      .. helptext:: set a callback for when the tween completes

   .. lua:method:: seek(percent)

      Seeks the tween to a specific normalized time (percentage of duration)

      :param percent: The normalized time in the tween to seek to
      :type percent: number

      .. helptext:: seek the tween to a normalized time

   .. lua:method:: pause()

      Pauses the tween

      .. helptext:: pause the tween

   .. lua:method:: play()

      Plays/resumes the tween

      .. helptext:: play or resume the tween

   .. lua:method:: restart()

      Restarts the tween from the beginning

      .. helptext:: restart the tween from the beginning

   .. lua:method:: cancel()

      Cancels and destroys the tween (this still counts as the tween completing)

      .. helptext:: cancel and destroy the tween

   .. lua:method:: dontDestroy()

      Prevent the tween from being automatically destroyed when complete

      This is useful if you plan to reuse the tween using ``restart()``

      .. helptext:: prevent the tween from being destroyed when complete

Easing Functions
----------------

Here is a list of all easing functions

.. list-table:: Easing Functions
   :widths: 30
   :header-rows: 1

   * - Name
   * - ``backIn``
   * - ``backOut``
   * - ``backInOut``
   * - ``bounceIn``
   * - ``bounceOut``
   * - ``bounceInOut``
   * - ``circularIn``
   * - ``circularOut``
   * - ``circularInOut``
   * - ``cubicIn``
   * - ``cubicOut``
   * - ``cubicInOut``
   * - ``quarticIn``
   * - ``quarticOut``
   * - ``quarticInOut``
   * - ``quinticIn``
   * - ``quinticOut``
   * - ``quinticInOut``
   * - ``sinusoidalIn``
   * - ``sinusoidalOut``
   * - ``sinusoidalInOut``
   * - ``elasticIn``
   * - ``elasticOut``
   * - ``elasticInOut``
   * - ``punch``