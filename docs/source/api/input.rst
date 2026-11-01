input
=====

*(module)*

Module for accessing input devices such as touches, keyboard, mouse and gamepads

Touches
#######

.. lua:class:: touch

   Represents a single touch over time. Passed to the global ``touched(touch)`` function and to entity ``touched`` methods each time the touch begins, moves or ends

   .. lua:attribute:: id: number

      An id that can be used to uniquely identify the touch

      .. helptext:: get the unique identifier of this touch

   .. lua:attribute:: state: enum

      The current state of the touch, can be:

      * ``BEGAN`` - the touch began
      * ``CHANGED`` - the touch moved (``MOVING`` is the same value)
      * ``ENDED`` - the touch ended
      * ``CANCELLED`` - the touch was cancelled, usually by a gesture recognizer or the system

      .. helptext:: get the current state of this touch or gesture

   .. lua:attribute:: began: boolean

      ``true`` if the touch began with this event

      .. helptext:: check if this touch just began

   .. lua:attribute:: changed: boolean

      ``true`` if the touch moved with this event

      .. helptext:: check if this touch moved

   .. lua:attribute:: moving: boolean

      The same as ``changed``

      .. helptext:: check if this touch moved

   .. lua:attribute:: ended: boolean

      ``true`` if the touch ended with this event

      .. helptext:: check if this touch ended

   .. lua:attribute:: cancelled: boolean

      ``true`` if the touch was cancelled

      .. helptext:: check if this touch was cancelled

   .. lua:attribute:: tapCount: integer

      The number of quick taps in a row at this location, starting at 1

      .. helptext:: get the tap count of this touch

   .. lua:attribute:: type: enum 

      The type of touch, can be:

      * ``touch.direct`` - a touch resulting from direct contact with the screen
      * ``touch.indirect`` - a touch that does not result from direct contact with the screen
      * ``touch.pencil`` - a touch from Apple Pencil
      * ``touch.pointer`` - a click from a mouse or trackpad

      .. helptext:: get the type of this touch

   .. lua:attribute:: x: number

      The x position of the touch (in screen coordinates)

      .. helptext:: get the x position of this touch

   .. lua:attribute:: y: number

      The y position of the touch (in screen coordinates)

      .. helptext:: get the y position of this touch

   .. lua:attribute:: prevX: number

      The previous x position of the touch (in screen coordinates)

      .. helptext:: get the previous x position

   .. lua:attribute:: prevY: number

      The previous y position of the touch (in screen coordinates)

      .. helptext:: get the previous y position

   .. lua:attribute:: deltaX: number

      The change in x position since the previous event for this touch (in screen coordinates)

      .. helptext:: get the delta x movement

   .. lua:attribute:: deltaY: number

      The change in y position since the previous event for this touch (in screen coordinates)

      .. helptext:: get the delta y movement

   .. lua:attribute:: pos: vec2

      The position of the touch (in screen coordinates) as a vector

      .. helptext:: get the position as a vec2

   .. lua:attribute:: prevPos: vec2

      The previous position of the touch (in screen coordinates) as a vector

      .. helptext:: get the previous position as a vec2

   .. lua:attribute:: delta: vec2

      The change in position since the previous event for this touch (in screen coordinates) as a vector

      .. helptext:: get the delta movement

   .. lua:attribute:: force: number

      The amount of force being applied, where ``1`` is an average touch. Reported for Apple Pencil and on devices with 3D Touch, otherwise ``0``

      .. helptext:: get the force of this touch

   .. lua:attribute:: maxForce: number

      The maximum possible value of ``force``

      .. helptext:: get the maximum force of this touch

   .. lua:attribute:: timestamp: number  
      
      The time when this touch event occurred, in seconds since the device started

      .. helptext:: get the timestamp of this touch

   .. lua:attribute:: azimuth: number

      The direction the pencil points across the screen, in radians (only applies to pencil type touches)

      .. helptext:: get the azimuth angle of the stylus
        
   .. lua:attribute:: altitude: number

      The angle of the pencil above the screen, in radians. ``0`` is flat against the screen and ``math.pi / 2`` is perpendicular to it (only applies to pencil type touches)

      .. helptext:: get the altitude angle of the stylus

   .. lua:attribute:: radiusTolerance: number

      The amount the estimated radius can vary due to hardware tolerances

      .. helptext:: get the radius tolerance of this touch

   .. lua:attribute:: radius: number

      The estimated radius of the touch

      .. helptext:: get the radius of this touch

   .. lua:attribute:: precisePos: vec2

      The precise location of the touch (if available)

      .. helptext:: get the precise position of this touch

   .. lua:attribute:: precisePrevPos: vec2
      
      The previous precise location of the touch (if available)

      .. helptext:: get the precise previous position of this touch

   .. lua:attribute:: current: touch

      The first touch that is currently down. It keeps its last state after the touch ends, until a new touch begins. Read it as ``touch.current``

      .. helptext:: get the current primary touch

   .. lua:method:: cancel(scene)

      Cancels this touch for every entity in ``scene`` that holds it. Each of those entities receives the touch once more with the ``CANCELLED`` state

      .. helptext:: cancel this touch for a scene

      :param scene: The scene whose entities hold the touch
      :type scene: scene

   .. lua:method:: makeExclusive(entity)

      Gives this touch to ``entity`` alone. Other entities that hold the touch receive it with the ``CANCELLED`` state. Does nothing if another entity already holds it exclusively

      .. helptext:: give this touch to one entity only

      :param entity: The entity that keeps the touch
      :type entity: entity

   .. lua:attribute:: direct: const

      .. helptext:: direct touch type constant

   .. lua:attribute:: indirect: const

      .. helptext:: indirect touch type constant

   .. lua:attribute:: pencil: const

      .. helptext:: pencil touch type constant

   .. lua:attribute:: pointer: const

      .. helptext:: pointer touch type constant

Constants - Touch State
***********************

.. lua:currentmodule:: None

.. lua:attribute:: BEGAN: const

   .. symbol:: const
      :group: touch-state

   .. helptext:: touch began state constant

.. lua:attribute:: CHANGED: const

   .. symbol:: const
      :group: touch-state

   .. helptext:: touch moved state constant

.. lua:attribute:: MOVING: const

   The same value as ``CHANGED``

   .. symbol:: const
      :group: touch-state

   .. helptext:: touch moved state constant

.. lua:attribute:: ENDED: const

   .. symbol:: const
      :group: touch-state

   .. helptext:: touch ended state constant

.. lua:attribute:: CANCELLED: const

   .. symbol:: const
      :group: touch-state

   .. helptext:: touch cancelled state constant

Gestures
########

.. lua:class:: gesture

   Represents a single gesture event. Passed to gesture recognizer callbacks and to the global ``hover(gesture)`` and ``scroll(gesture)`` functions. Each kind of gesture fills in only the fields that apply to it:

   * tap - ``location``
   * pan and scroll - ``location``, ``translation``, ``delta`` and ``touchCount``
   * pinch - ``location``, ``pinchScale``, ``pinchDelta`` and ``pinchVelocity``
   * rotation - ``location``, ``rotationAngle`` and ``rotationVelocity``
   * hover - ``location``

   .. lua:attribute:: state: enum

      The current state of the gesture, using the same constants as touches:

      * ``BEGAN`` - the gesture was recognized
      * ``CHANGED`` - the gesture moved or changed
      * ``ENDED`` - the gesture finished or was cancelled

      A tap reports ``ENDED`` once it is recognized.

      .. helptext:: get the current state of this touch or gesture

   .. lua:attribute:: location: vec2

      The location of the gesture event on the screen

      .. helptext:: get the location of this gesture

   .. lua:attribute:: translation: vec2

      The translation of the gesture event relative to its starting location, with positive ``y`` pointing up

      .. helptext:: get the translation of this gesture or joint

   .. lua:attribute:: delta: vec2

      The delta of the gesture event since last update

      .. helptext:: get the delta movement

   .. lua:attribute:: pinchScale: number

      The scale of a pinch gesture relative to its starting distance

      .. helptext:: get the pinch scale of this gesture

   .. lua:attribute:: pinchDelta: number

      The ratio of the pinch scale to its value at the last update. Multiply a size by it to follow the pinch

      .. helptext:: get the pinch delta of this gesture

   .. lua:attribute:: pinchVelocity: number

      The rate of change of the pinch scale, in scale factor per second

      .. helptext:: get the pinch velocity of this gesture

   .. lua:attribute:: rotationAngle: number 

      The change in angle of a rotation gesture since the last update, in degrees. Positive values are counter-clockwise, the same direction as ``rotate()``.

      .. helptext:: get the rotation angle of this gesture

   .. lua:attribute:: rotationVelocity: number

      The rate of change of the rotation angle, in degrees per second

      .. helptext:: get the rotation velocity of this gesture

   .. lua:attribute:: touchCount: integer

      The current number of touches associated with this gesture

      .. helptext:: get the touch count for this gesture

.. lua:class:: gesture.tap

   Tap gesture recognizer (using system gesture recognizer for implementation). The recognizer is removed when it is garbage collected, so keep a reference to it

   .. lua:staticmethod:: gesture.tap(callback[, tapCount = 1, touchCount = 1])

      Creates and registers a new tap gesture recognizer that will call ``callback(gesture)`` when recognized

      :param callback: The function to call with the gesture
      :type callback: function
      :param tapCount: The number of taps required, such as ``2`` for a double tap
      :type tapCount: integer
      :param touchCount: The number of fingers required
      :type touchCount: integer

      .. helptext:: create a tap gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled

   .. lua:attribute:: group: integer [default = 0]

      Recognizers that share the same non-zero group can recognize at the same time. A recognizer in group ``0`` does not run alongside others

      .. helptext:: set the group for simultaneous recognition

.. lua:class:: gesture.pan

   Pan gesture recognizer (using system gesture recognizer for implementation). The recognizer is removed when it is garbage collected, so keep a reference to it

   .. lua:staticmethod:: gesture.pan(callback[, minTouches = 1, maxTouches = 1, trackpad = false])

      Creates and registers a new pan gesture recognizer that will call ``callback(gesture)`` as the pan begins, moves and ends

      :param callback: The function to call with the gesture
      :type callback: function
      :param minTouches: The fewest fingers that can perform the pan
      :type minTouches: integer
      :param maxTouches: The most fingers that can perform the pan
      :type maxTouches: integer
      :param trackpad: Also recognize two finger trackpad scrolling as a pan
      :type trackpad: boolean

      .. helptext:: create a pan gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled

   .. lua:attribute:: group: integer [default = 0]

      Recognizers that share the same non-zero group can recognize at the same time. A recognizer in group ``0`` does not run alongside others

      .. helptext:: set the group for simultaneous recognition


.. lua:class:: gesture.pinch

   Pinch gesture recognizer (using system gesture recognizer for implementation). The recognizer is removed when it is garbage collected, so keep a reference to it

   .. lua:staticmethod:: gesture.pinch(callback)

      Creates and registers a new pinch gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a pinch gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled

   .. lua:attribute:: group: integer [default = 0]

      Recognizers that share the same non-zero group can recognize at the same time. A recognizer in group ``0`` does not run alongside others

      .. helptext:: set the group for simultaneous recognition


.. lua:class:: gesture.rotation

   Rotation gesture recognizer (using system gesture recognizer for implementation). The recognizer is removed when it is garbage collected, so keep a reference to it

   .. lua:staticmethod:: gesture.rotation(callback)
      
      Creates and registers a new rotation gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a rotation gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled

   .. lua:attribute:: group: integer [default = 0]

      Recognizers that share the same non-zero group can recognize at the same time. A recognizer in group ``0`` does not run alongside others

      .. helptext:: set the group for simultaneous recognition


Keyboard
########

.. lua:module:: key

Functions and constants for reading a hardware keyboard. Key events also call the global ``keyPressed(press)`` and ``keyReleased(press)`` functions, except while a user interface text field has focus

.. lua:function:: pressing(keyCode)

   Queries whether the key is currently held down

   .. helptext:: check if a key is currently pressed

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Is the key held down
   :rtype: boolean

.. lua:function:: wasPressed(keyCode)

   Queries whether the key went down since the previous frame

   .. helptext:: check if a key was pressed this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key pressed down this frame
   :rtype: boolean

.. lua:function:: wasReleased(keyCode)

   Queries whether the key came up since the previous frame

   .. helptext:: check if a key was released this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key released this frame
   :rtype: boolean

.. lua:function:: modifiers()

   Queries the current key modifiers as a bit field, which is composed of the following bit mask constants:

   .. helptext:: get the current keyboard modifiers

   - :lua:attr:`key.alt`
   - :lua:attr:`key.ctrl`
   - :lua:attr:`key.cmd`
   - :lua:attr:`key.shift`

   Use ``key.pressing(keyCode)`` to query individual keys such as ``key.leftAlt``.

   :return: The modifiers currently held
   :rtype: integer

.. lua:function:: modifiersPressed(modifiers)

   Queries whether all of the supplied key modifiers are currently held. Combine masks with ``|``, as in ``key.modifiersPressed(key.cmd | key.shift)``

   .. helptext:: check if keyboard modifiers are pressed

   :param modifiers: The key modifiers to query as a bit field
   :type modifiers: constant
   :return: Are the key modifiers currently pressed
   :rtype: boolean

.. lua:class:: press

   A single key event, passed to the global ``keyPressed(press)`` and ``keyReleased(press)`` functions

   .. lua:attribute:: keyCode: const

      The key, as one of the ``key`` key code constants such as ``key.a`` or ``key.space``

      .. helptext:: get the key code of this key press

   .. lua:attribute:: modifierFlags: integer

      The modifiers held during this key event, as a bit field of ``key.alt``, ``key.ctrl``, ``key.cmd`` and ``key.shift``

      .. helptext:: get the modifiers held for this key press

   .. lua:attribute:: characters: string

      The text produced by the key, taking modifiers such as shift into account

      .. helptext:: get the text typed by this key press

Constants - Modifiers
*********************

These are bit masks for :lua:func:`key.modifiers`, :lua:func:`key.modifiersPressed` and ``press.modifierFlags``. Each one covers both the left and right key. They are not key codes, so use ``key.leftAlt`` and similar with :lua:func:`key.pressing`

.. lua:attribute:: alt: const

   .. helptext:: alt modifier mask
.. lua:attribute:: ctrl: const

   .. helptext:: ctrl modifier mask
.. lua:attribute:: cmd: const

   .. helptext:: command modifier mask
.. lua:attribute:: shift: const

   .. helptext:: shift modifier mask

Constants - Key Codes
*********************

.. lua:attribute:: leftAlt: const

   .. helptext:: left alt key constant
.. lua:attribute:: rightAlt: const

   .. helptext:: right alt key constant
.. lua:attribute:: leftCtrl: const

   .. helptext:: left ctrl key constant
.. lua:attribute:: rightCtrl: const

   .. helptext:: right ctrl key constant
.. lua:attribute:: leftCmd: const

   .. helptext:: left command key constant
.. lua:attribute:: rightCmd: const

   .. helptext:: right command key constant
.. lua:attribute:: leftShift: const

   .. helptext:: left shift key constant
.. lua:attribute:: rightShift: const

   .. helptext:: right shift key constant
.. lua:attribute:: esc: const

   .. helptext:: escape key constant
.. lua:attribute:: enter: const

   The return key

   .. helptext:: enter key constant
   
.. lua:attribute:: tab: const

   .. helptext:: tab key constant
.. lua:attribute:: space: const

   .. helptext:: space key constant
.. lua:attribute:: backspace: const

   .. helptext:: backspace key constant
.. lua:attribute:: up: const

   .. helptext:: up arrow key constant
.. lua:attribute:: down: const

   .. helptext:: down arrow key constant
.. lua:attribute:: left: const

   .. helptext:: left arrow key constant
.. lua:attribute:: right: const

   .. helptext:: right arrow key constant
.. lua:attribute:: insert: const

   .. helptext:: insert key constant
.. lua:attribute:: delete: const

   .. helptext:: delete key constant
.. lua:attribute:: home: const

   .. helptext:: home key constant
.. lua:attribute:: end: const

   .. helptext:: end key constant
.. lua:attribute:: pageup: const

   .. helptext:: page up key constant
.. lua:attribute:: pagedown: const

   .. helptext:: page down key constant
.. lua:attribute:: print: const

   .. helptext:: print key constant
.. lua:attribute:: plus: const

   .. helptext:: plus key constant
.. lua:attribute:: minus: const

   .. helptext:: minus key constant
.. lua:attribute:: leftbracket: const

   .. helptext:: left bracket key constant
.. lua:attribute:: rightbracket: const

   .. helptext:: right bracket key constant
.. lua:attribute:: semicolon: const

   .. helptext:: semicolon key constant
.. lua:attribute:: quote: const

   .. helptext:: quote key constant
.. lua:attribute:: comma: const

   .. helptext:: comma key constant
.. lua:attribute:: period: const

   .. helptext:: period key constant
.. lua:attribute:: slash: const

   .. helptext:: forward slash key constant
.. lua:attribute:: backslash: const

   .. helptext:: backslash key constant
.. lua:attribute:: nonUSBackslash: const

   .. helptext:: non-US backslash key constant
.. lua:attribute:: tilde: const

   .. helptext:: tilde key constant
.. lua:attribute:: f1: const

   .. helptext:: F1 key constant
.. lua:attribute:: f2: const

   .. helptext:: F2 key constant
.. lua:attribute:: f3: const

   .. helptext:: F3 key constant
.. lua:attribute:: f4: const

   .. helptext:: F4 key constant
.. lua:attribute:: f5: const

   .. helptext:: F5 key constant
.. lua:attribute:: f6: const

   .. helptext:: F6 key constant
.. lua:attribute:: f7: const

   .. helptext:: F7 key constant
.. lua:attribute:: f8: const

   .. helptext:: F8 key constant
.. lua:attribute:: f9: const

   .. helptext:: F9 key constant
.. lua:attribute:: f10: const

   .. helptext:: F10 key constant
.. lua:attribute:: f11: const

   .. helptext:: F11 key constant
.. lua:attribute:: f12: const

   .. helptext:: F12 key constant
.. lua:attribute:: numpad0: const

   .. helptext:: numpad 0 key constant
.. lua:attribute:: numpad1: const

   .. helptext:: numpad 1 key constant
.. lua:attribute:: numpad2: const

   .. helptext:: numpad 2 key constant
.. lua:attribute:: numpad3: const

   .. helptext:: numpad 3 key constant
.. lua:attribute:: numpad4: const

   .. helptext:: numpad 4 key constant
.. lua:attribute:: numpad5: const

   .. helptext:: numpad 5 key constant
.. lua:attribute:: numpad6: const

   .. helptext:: numpad 6 key constant
.. lua:attribute:: numpad7: const

   .. helptext:: numpad 7 key constant
.. lua:attribute:: numpad8: const

   .. helptext:: numpad 8 key constant
.. lua:attribute:: numpad9: const

   .. helptext:: numpad 9 key constant
.. lua:attribute:: num0: const

   .. helptext:: 0 number key constant
.. lua:attribute:: num1: const

   .. helptext:: 1 number key constant
.. lua:attribute:: num2: const

   .. helptext:: 2 number key constant
.. lua:attribute:: num3: const

   .. helptext:: 3 number key constant
.. lua:attribute:: num4: const

   .. helptext:: 4 number key constant
.. lua:attribute:: num5: const

   .. helptext:: 5 number key constant
.. lua:attribute:: num6: const

   .. helptext:: 6 number key constant
.. lua:attribute:: num7: const

   .. helptext:: 7 number key constant
.. lua:attribute:: num8: const

   .. helptext:: 8 number key constant
.. lua:attribute:: num9: const

   .. helptext:: 9 number key constant
.. lua:attribute:: a: const

   .. helptext:: A key constant
.. lua:attribute:: b: const

   .. helptext:: B key constant
.. lua:attribute:: c: const

   .. helptext:: C key constant
.. lua:attribute:: d: const

   .. helptext:: D key constant
.. lua:attribute:: e: const

   .. helptext:: E key constant
.. lua:attribute:: f: const

   .. helptext:: F key constant
.. lua:attribute:: g: const

   .. helptext:: G key constant
.. lua:attribute:: h: const

   .. helptext:: H key constant
.. lua:attribute:: i: const

   .. helptext:: I key constant
.. lua:attribute:: j: const

   .. helptext:: J key constant
.. lua:attribute:: k: const

   .. helptext:: K key constant
.. lua:attribute:: l: const

   .. helptext:: L key constant
.. lua:attribute:: m: const

   .. helptext:: M key constant
.. lua:attribute:: n: const

   .. helptext:: N key constant
.. lua:attribute:: o: const

   .. helptext:: O key constant
.. lua:attribute:: p: const

   .. helptext:: P key constant
.. lua:attribute:: q: const

   .. helptext:: Q key constant
.. lua:attribute:: r: const

   .. helptext:: R key constant
.. lua:attribute:: s: const

   .. helptext:: S key constant
.. lua:attribute:: t: const

   .. helptext:: T key constant
.. lua:attribute:: u: const

   .. helptext:: U key constant
.. lua:attribute:: v: const

   .. helptext:: V key constant
.. lua:attribute:: w: const

   .. helptext:: W key constant
.. lua:attribute:: x: const

   .. helptext:: X key constant
.. lua:attribute:: y: const

   .. helptext:: Y key constant
.. lua:attribute:: z: const

   .. helptext:: Z key constant

Gamepad
#######

.. lua:currentmodule:: None

.. lua:class:: gamepad

   A game controller. Read ``gamepad.all``, ``gamepad.current`` and ``gamepad.virtual`` to get one

   .. lua:attribute:: all: table<gamepad>

      A list of all currently connected gamepads

      .. helptext:: get all connected gamepads

   .. lua:attribute:: current: gamepad

      The most recently used gamepad, or ``nil`` if none is connected

      .. helptext:: get the current active gamepad

   .. lua:attribute:: virtual: gamepad.virtualGamepad

      Gets the on-screen gamepad, creating it on first use. It shows a stick at the bottom left and an ``A`` button at the bottom right, controlled by touch. While a controller is connected it is hidden and mirrors ``gamepad.current``

      .. helptext:: get the virtual gamepad

   .. lua:attribute:: connected: function(gamepad)

      Callback for when a gamepad is connected. Gamepads that are already connected when the project starts are listed in ``gamepad.all`` and do not trigger it

      .. helptext:: callback invoked when a gamepad connects

   .. lua:attribute:: disconnected: function(gamepad)

      Callback for when a gamepad is disconnected

      .. helptext:: callback invoked when a gamepad disconnects

   .. lua:attribute:: leftShoulder: gamepad.button

      The left shoulder button

      .. helptext:: get the left shoulder button

   .. lua:attribute:: rightShoulder: gamepad.button

      The right shoulder button

      .. helptext:: get the right shoulder button

   .. lua:attribute:: leftTrigger: gamepad.button

      The left trigger

      .. helptext:: get the left trigger button

   .. lua:attribute:: rightTrigger: gamepad.button

      The right trigger

      .. helptext:: get the right trigger button

   .. lua:attribute:: dpad: gamepad.directionalPad

      The directional pad

      .. helptext:: get the directional pad

   .. lua:attribute:: leftStick: gamepad.directionalPad

      .. helptext:: get the left analog stick

   .. lua:attribute:: rightStick: gamepad.directionalPad

      .. helptext:: get the right analog stick

   .. lua:attribute:: leftStickButton: gamepad.button

      .. helptext:: get the left stick click button

   .. lua:attribute:: rightStickButton: gamepad.button

      .. helptext:: get the right stick click button

   .. lua:attribute:: a: gamepad.button

      .. helptext:: get the a button

   .. lua:attribute:: b: gamepad.button

      .. helptext:: get the b button

   .. lua:attribute:: x: gamepad.button

      .. helptext:: get the x button

   .. lua:attribute:: y: gamepad.button

      .. helptext:: get the y button

   .. lua:attribute:: home: gamepad.button

      .. helptext:: get the home button

   .. lua:attribute:: menu: gamepad.button

      .. helptext:: get the menu button

   .. lua:attribute:: options: gamepad.button

      .. helptext:: get the options button

   .. lua:attribute:: touchpadButton: gamepad.button

      .. helptext:: get the touchpad button

   .. lua:attribute:: touchpadSurface: gamepad.directionalPad

      .. helptext:: get the touchpad surface

   .. lua:attribute:: batteryLevel: number

      The battery charge, from ``0`` to ``1``

      .. helptext:: get the battery level of the gamepad

   .. lua:attribute:: batteryState: const

      The battery state, one of ``gamepad.charging``, ``gamepad.discharging``, ``gamepad.full`` or ``gamepad.unknown``

      .. helptext:: get the battery state of the gamepad

   .. lua:attribute:: light: color

      The color of the controller's light, on controllers that have one

      .. helptext:: get or set the gamepad light color

   .. lua:attribute:: playerIndex: const

      The player number shown on the controller, one of ``gamepad.unset``, ``gamepad.player1``, ``gamepad.player2``, ``gamepad.player3`` or ``gamepad.player4``

      .. helptext:: get or set the player index of the gamepad

   .. lua:attribute:: vendorName: string

      The name of the controller as reported by its maker

      .. helptext:: get the vendor name of the gamepad

   .. lua:attribute:: unset: const

      .. helptext:: no player index constant

   .. lua:attribute:: player1: const

      .. helptext:: player 1 index constant

   .. lua:attribute:: player2: const

      .. helptext:: player 2 index constant

   .. lua:attribute:: player3: const

      .. helptext:: player 3 index constant

   .. lua:attribute:: player4: const

      .. helptext:: player 4 index constant

   .. lua:attribute:: charging: const

      .. helptext:: battery charging state constant

   .. lua:attribute:: discharging: const

      .. helptext:: battery discharging state constant

   .. lua:attribute:: full: const

      .. helptext:: battery full state constant

   .. lua:attribute:: unknown: const

      .. helptext:: battery unknown state constant

   .. lua:class:: button

      A button or trigger on a gamepad

      .. lua:attribute:: pressing: boolean

         ``true`` while the button is held down

         .. helptext:: get whether this button is being pressed

      .. lua:attribute:: pressed: boolean

         ``true`` only in the frame the button went down

         .. helptext:: get whether this button was just pressed

      .. lua:attribute:: released: boolean

         ``true`` only in the frame the button came up

         .. helptext:: get whether this button was just released

      .. lua:attribute:: value: number

         How far the button is pressed, from ``0`` to ``1``. Triggers report values in between

         .. helptext:: get the analog value of this button

      .. lua:attribute:: touching: boolean

         ``true`` while a finger rests on the button, on controllers that can sense it

         .. helptext:: get whether the touchpad is being touched

   .. lua:class:: directionalPad

      A stick, directional pad or touchpad surface on a gamepad

      .. lua:attribute:: dir: vec2

         The direction, with each axis from ``-1`` to ``1``

         .. helptext:: get the direction as a vec2

      .. lua:attribute:: x: number

         .. helptext:: get the x value of the directional pad

      .. lua:attribute:: y: number

         .. helptext:: get the y value of the directional pad

      .. lua:attribute:: left: boolean

         .. helptext:: get if the directional pad is moved left

      .. lua:attribute:: right: boolean

         .. helptext:: get if the directional pad is moved right

      .. lua:attribute:: up: boolean

         .. helptext:: get if the directional pad is moved up

      .. lua:attribute:: down: boolean

         .. helptext:: get if the directional pad is moved down

Mouse
#####

.. lua:module:: mouse

The pointer state on a Mac, or an iPad with a mouse or trackpad. The global ``hover(gesture)`` and ``scroll(gesture)`` functions are also called for pointer movement and scrolling

.. lua:attribute:: x: number

   The current horizontal position of the pointer in screen coordinates. Updated while the pointer hovers over the viewer and while a button is held

   .. helptext:: x position of the mouse

.. lua:attribute:: y: number

   The current vertical position of the pointer in screen coordinates. Updated while the pointer hovers over the viewer and while a button is held

   .. helptext:: y position of the mouse

.. lua:attribute:: pos: vec2

   The current position of the pointer as a ``vec2``

   .. helptext:: position of the mouse

.. lua:attribute:: dx: number

   The horizontal movement of the pointer since the last frame

   .. helptext:: change in x since the last frame

.. lua:attribute:: dy: number

   The vertical movement of the pointer since the last frame

   .. helptext:: change in y since the last frame

.. lua:attribute:: delta: vec2

   The movement of the pointer since the last frame as a ``vec2``

   .. helptext:: change in position since the last frame

.. lua:attribute:: scroll: vec2

   The scroll wheel or trackpad scroll amount this frame

   .. helptext:: scroll amount this frame

.. lua:attribute:: left: mouse.button

   The left mouse button. Trackpad clicks also count as the left button

   .. helptext:: left mouse button

.. lua:attribute:: middle: mouse.button

   The middle mouse button

   .. helptext:: middle mouse button

.. lua:attribute:: right: mouse.button

   The right mouse button

   .. helptext:: right mouse button

.. lua:attribute:: active: boolean

   Whether a mouse or trackpad is currently connected

   .. helptext:: whether a mouse is connected

.. lua:attribute:: visible: boolean

   Gets or sets the visibility of the system pointer cursor

   .. helptext:: show or hide the mouse cursor

.. lua:class:: button

   .. visibility:: private

   Represents a single mouse button

   .. lua:attribute:: pressed: boolean

      Whether this button is currently held down

      .. helptext:: button is being pressed

   .. lua:attribute:: value: number

      The analog value of this button in the range 0.0 to 1.0

      .. helptext:: analog value of this button
