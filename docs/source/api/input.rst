input
=====

*(module)*

Module for accessing input devices such as touches, keyboard, mouse and gamepads

Touches
#######

Gestures
########

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

   - :lua:attr:`key.leftAlt`
   - :lua:attr:`key.rightAlt`
   - :lua:attr:`key.alt`
   - :lua:attr:`key.leftCtrl`
   - :lua:attr:`key.rightCtrl`
   - :lua:attr:`key.ctrl`
   - :lua:attr:`key.leftCmd`
   - :lua:attr:`key.rightCmd`
   - :lua:attr:`key.cmd`

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key released this frame
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

.. lua:module:: nil

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

   .. lua:attribute:: buttonA: gamepad.button

   .. lua:attribute:: buttonB: gamepad.button

   .. lua:attribute:: buttonX: gamepad.button

   .. lua:attribute:: buttonY: gamepad.button

   .. lua:attribute:: home: gamepad.button

   .. lua:attribute:: menu: gamepad.button

   .. lua:attribute:: options: gamepad.button

   .. lua:attribute:: touchpadButton: gamepad.button

   .. lua:attribute:: touchpadSurface: gamepad.directionalPad

   .. lua:attribute:: touchpadSurface: gamepad.directionalPad

   .. lua:attribute:: batteryLevel: number

   .. lua:attribute:: batteryState: const

   .. lua:attribute:: light: color

.. lua:class:: gamepad.button

   .. lua:attribute:: pressing: boolean

   .. lua:attribute:: pressed: boolean

   .. lua:attribute:: released: boolean

   .. lua:attribute:: value: number

   .. lua:attribute:: touching: boolean

.. lua:class:: gamepad.directionalPad

   .. lua:attribute:: pressing: boolean

   .. lua:attribute:: dir: vec2

   .. lua:attribute:: x: number

   .. lua:attribute:: y: number

   .. lua:attribute:: left: boolean

   .. lua:attribute:: right: boolean

   .. lua:attribute:: up: boolean

   .. lua:attribute:: down: boolean
