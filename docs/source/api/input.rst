input
=====

*(module)*

Module for accessing input devices such as touches, keyboard, mouse and gamepads

Touches
#######

.. lua:class:: touch

   Represents a single touch over time. Generated in response to touch events by the device in response to user interactions

   .. attribute:: id: number

      An id that can be used to uniquely identify the touch

   .. attribute:: state: enum

      The current state of the touch, can be:

      * ``BEGAN`` - the touch began this frame
      * ``MOVING`` - the touch moved this frame
      * ``ENDED`` - the touch ended this frame
      * ``CANCELLED`` - the touch was cancelled (usually by another view or gesture recognizer)

   .. attribute:: type: enum 

      The type of touch, can be:

      * ``touch.direct`` - a touch resulting from direct contact with the screen
      * ``touch.indirect`` - a touch that does not result from direct contact with the screen
      * ``touch.pencil`` - a touch resulting from the pencil
      * ``touch.pointer`` - a touch resulting from a button based device

   .. attribute:: x: number

      The x position of the touch (in screen coordinates)

   .. attribute:: y: number

      The y position of the touch (in screen coordinates)

   .. attribute:: prevX: number

      The previous x position of the touch (in screen coordinates)

   .. attribute:: prevY: number

      The previous y position of the touch (in screen coordinates)

   .. attribute:: deltaX: number

      The x position delta of the touch (in screen coordinates)

   .. attribute:: deltaY: number

      The y position delta of the touch (in screen coordinates)

   .. attribute:: pos: vec2

      The position of the touch (in screen coordinates) as a vector

   .. attribute:: prevPos: vec2

      The previous position of the touch (in screen coordinates) as a vector

   .. attribute:: delta: number

      The position delta of the touch (in screen coordinates) as a vector

   .. attribute:: force: number

      The amount of force being applied (only applies to pencil type touches)

   .. attribute:: maxForce: number

      The maximum amount of force that can be applied (only applies to pencil type touches)

   .. attribute:: timestamp: number  
      
      The time when this touch event occured (only applies to pencil type touches)

   .. attribute:: azimuth: number

      The azimuth angle of the pencil (only applies to pencil type touches)
        
   .. attribute:: altitude: number

      The altitude angle of the pencil

   .. attribute:: radiusTolerance: number

      The amount the estimated radius can vary due to hardware tolerances

   .. attribute:: radius: number

      The estimated radius of the touch

   .. attribute:: precisePos: vec2

      The precise location of the touch (if available)

   .. attribute:: precisePrevPos: vec2
      
      The previous precise location of the touch (if available)

Gestures
########

.. lua:class:: gesture

   Represents a single gesture event

   .. lua:attribute:: state: enum

      The current state of the gesture

   .. lua:attribute:: location: vec2

      The location of the gesture event on the screen

   .. lua:attribute:: translation: vec2

      The translation of the gesture event relative to its starting location

   .. lua:attribute:: delta: vec2

      The delta of the gesture event since last update

   .. lua:attribute:: pinchScale: number

      The scale of a pinch gesture relative to its starting distance

   .. lua:attribute:: pinchDelta: number

      The delta of the pinch distance since last update

   .. lua:attribute:: pinchVelocity: number

      The current change in pinch distance over time

   .. lua:attribute:: rotationAngle: number 

      The current angle of a rotation gesture relative to its' starting angle

   .. lua:attribute:: rotationVelocity: number

      The current change in rotation angle over time

   .. lua:attribute:: touchCount: integer

      The current number of touches associated with this gesture

.. lua:class:: gesture.tap

   Tap gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.tap(callback[, minTouches = 1, maxTouches = 1])

      Creates and registers a new tap gesture recognizer that will call ``callback(gesture)`` when recognized

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

.. lua:class:: gesture.pan

   Pan gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.pan(callback[, minTouches = 1, maxTouches = 1])

      Creates and registers a new pan gesture recognizer that will call ``callback(gesture)`` when recognized

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer


.. lua:class:: gesture.pinch

   Pinch gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.pinch(callback)

      Creates and registers a new pinch gesture recognizer that will call ``callback(gesture)`` when recognized

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer


.. lua:class:: gesture.rotation

   Rotation gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.rotation(callback)
      
      Creates and registers a new rotation gesture recognizer that will call ``callback(gesture)`` when recognized

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer


Keyboard
########

.. lua:module:: key

.. lua:function:: pressing(keyCode)

   Queries whether the key is currently being pressed this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Is the key being pressed this frame
   :rtype: boolean

.. lua:function:: wasPressed(keyCode)

   Queries whether the key is was pressed down this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key pressed down this frame
   :rtype: boolean

.. lua:function:: wasReleased(keyCode)

   Queries whether the supplied key code was released this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key released this frame
   :rtype: boolean

.. lua:function:: modifiers()

   Queries the current key modifiers as a bit field, which is composed of the following bit mask constants:

   - :lua:attr:`key.alt`
   - :lua:attr:`key.ctrl`
   - :lua:attr:`key.cmd`
   - :lua:attr:`key.shift`

   Use `key.pressing(keyCode)` to query individual keys such as `key.leftAlt`.

.. lua:function:: modifiersPressed(modifiers)

   Queries whether the supplied key modifiers are currently pressed

   :param modifiers: The key modifiers to query as a bit field
   :type modifiers: constant
   :return: Are the key modifiers currently pressed
   :rtype: boolean

Constants - Key Codes
*********************

.. lua:attribute:: leftAlt: const
.. lua:attribute:: rightAlt: const
.. lua:attribute:: alt: const
.. lua:attribute:: leftCtrl: const
.. lua:attribute:: rightCtrl: const
.. lua:attribute:: ctrl: const
.. lua:attribute:: leftCmd: const
.. lua:attribute:: rightCmd: const
.. lua:attribute:: cmd: const
.. lua:attribute:: leftShift: const
.. lua:attribute:: rightShift: const
.. lua:attribute:: shift: const
.. lua:attribute:: esc: const
.. lua:attribute:: return: const
.. lua:attribute:: tab: const
.. lua:attribute:: space: const
.. lua:attribute:: backspace: const
.. lua:attribute:: up: const
.. lua:attribute:: down: const
.. lua:attribute:: left: const
.. lua:attribute:: right: const
.. lua:attribute:: insert: const
.. lua:attribute:: delete: const
.. lua:attribute:: home: const
.. lua:attribute:: end: const
.. lua:attribute:: pageup: const
.. lua:attribute:: pagedown: const
.. lua:attribute:: print: const
.. lua:attribute:: plus: const
.. lua:attribute:: minus: const
.. lua:attribute:: leftbracket: const
.. lua:attribute:: rightbracket: const
.. lua:attribute:: semicolon: const
.. lua:attribute:: quote: const
.. lua:attribute:: comma: const
.. lua:attribute:: period: const
.. lua:attribute:: slash: const
.. lua:attribute:: backslash: const
.. lua:attribute:: tilde: const
.. lua:attribute:: f1: const
.. lua:attribute:: f2: const
.. lua:attribute:: f3: const
.. lua:attribute:: f4: const
.. lua:attribute:: f5: const
.. lua:attribute:: f6: const
.. lua:attribute:: f7: const
.. lua:attribute:: f8: const
.. lua:attribute:: f9: const
.. lua:attribute:: f10: const
.. lua:attribute:: f11: const
.. lua:attribute:: f12: const
.. lua:attribute:: numpad0: const
.. lua:attribute:: numpad1: const
.. lua:attribute:: numpad2: const
.. lua:attribute:: numpad3: const
.. lua:attribute:: numpad4: const
.. lua:attribute:: numpad5: const
.. lua:attribute:: numpad6: const
.. lua:attribute:: numpad7: const
.. lua:attribute:: numpad8: const
.. lua:attribute:: numpad9: const
.. lua:attribute:: num0: const
.. lua:attribute:: num1: const
.. lua:attribute:: num2: const
.. lua:attribute:: num3: const
.. lua:attribute:: num4: const
.. lua:attribute:: num5: const
.. lua:attribute:: num6: const
.. lua:attribute:: num7: const
.. lua:attribute:: num8: const
.. lua:attribute:: num9: const
.. lua:attribute:: a: const
.. lua:attribute:: b: const
.. lua:attribute:: c: const
.. lua:attribute:: d: const
.. lua:attribute:: e: const
.. lua:attribute:: f: const
.. lua:attribute:: g: const
.. lua:attribute:: h: const
.. lua:attribute:: i: const
.. lua:attribute:: j: const
.. lua:attribute:: k: const
.. lua:attribute:: l: const
.. lua:attribute:: m: const
.. lua:attribute:: n: const
.. lua:attribute:: o: const
.. lua:attribute:: p: const
.. lua:attribute:: q: const
.. lua:attribute:: r: const
.. lua:attribute:: s: const
.. lua:attribute:: t: const
.. lua:attribute:: u: const
.. lua:attribute:: v: const
.. lua:attribute:: w: const
.. lua:attribute:: x: const
.. lua:attribute:: y: const
.. lua:attribute:: z: const

Gamepad
#######

.. lua:currentmodule:: None

.. lua:class:: gamepad

   .. lua:attribute:: all: table<gamepad>

      A list of all currently connected gamepads

   .. lua:attribute:: current: gamepad

      The current main active gamepad (or nil if none connected)

   .. lua:attribute:: virtual: gamepad.virtualGamepad

      Gets or creates a virtual gamepad which will substitute on-screen controls if no controller is currently connected

   .. lua:attribute:: connected: function(gamepad)

      Callback for when a gamepad is connected

   .. lua:attribute:: disconnected: function(gamepad)

      Callback for when a gamepad is disconnected

   .. lua:attribute:: leftShoulder: gamepad.button

      The left shoulder button

   .. lua:attribute:: rightShoulder: gamepad.button

      The right shoulder button

   .. lua:attribute:: leftTrigger: gamepad.button

      The left trigger

   .. lua:attribute:: rightTrigger: gamepad.button

      The right trigger

   .. lua:attribute:: dpad: gamepad.directionalPad

   .. lua:attribute:: leftStick: gamepad.directionalPad

   .. lua:attribute:: rightStick: gamepad.directionalPad

   .. lua:attribute:: leftStickButton: gamepad.button

   .. lua:attribute:: rightStickButton: gamepad.button

   .. lua:attribute:: a: gamepad.button

   .. lua:attribute:: b: gamepad.button

   .. lua:attribute:: x: gamepad.button

   .. lua:attribute:: y: gamepad.button

   .. lua:attribute:: home: gamepad.button

   .. lua:attribute:: menu: gamepad.button

   .. lua:attribute:: options: gamepad.button

   .. lua:attribute:: touchpadButton: gamepad.button

   .. lua:attribute:: touchpadSurface: gamepad.directionalPad

   .. lua:attribute:: touchpadSurface: gamepad.directionalPad

   .. lua:attribute:: batteryLevel: number

   .. lua:attribute:: batteryState: const

   .. lua:attribute:: light: color

   .. lua:class:: button

      .. lua:attribute:: pressing: boolean

      .. lua:attribute:: pressed: boolean

      .. lua:attribute:: released: boolean

      .. lua:attribute:: value: number

      .. lua:attribute:: touching: boolean

   .. lua:class:: directionalPad

      .. lua:attribute:: pressing: boolean

      .. lua:attribute:: dir: vec2

      .. lua:attribute:: x: number

      .. lua:attribute:: y: number

      .. lua:attribute:: left: boolean

      .. lua:attribute:: right: boolean

      .. lua:attribute:: up: boolean

      .. lua:attribute:: down: boolean
