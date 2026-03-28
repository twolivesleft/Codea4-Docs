input
=====

*(module)*

Module for accessing input devices such as touches, keyboard, mouse and gamepads

Touches
#######

.. lua:class:: touch

   Represents a single touch over time. Generated in response to touch events by the device in response to user interactions

   .. lua:attribute:: id: number

      An id that can be used to uniquely identify the touch

      .. helptext:: get the unique identifier of this touch

   .. lua:attribute:: state: enum

      The current state of the touch, can be:

      * ``BEGAN`` - the touch began this frame
      * ``MOVING`` - the touch moved this frame
      * ``ENDED`` - the touch ended this frame
      * ``CANCELLED`` - the touch was cancelled (usually by another view or gesture recognizer)

      .. helptext:: get the current state of this touch or gesture

   .. lua:attribute:: type: enum 

      The type of touch, can be:

      * ``touch.direct`` - a touch resulting from direct contact with the screen
      * ``touch.indirect`` - a touch that does not result from direct contact with the screen
      * ``touch.pencil`` - a touch resulting from the pencil
      * ``touch.pointer`` - a touch resulting from a button based device

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

      The x position delta of the touch (in screen coordinates)

      .. helptext:: get the delta x movement

   .. lua:attribute:: deltaY: number

      The y position delta of the touch (in screen coordinates)

      .. helptext:: get the delta y movement

   .. lua:attribute:: pos: vec2

      The position of the touch (in screen coordinates) as a vector

      .. helptext:: get the position as a vec2

   .. lua:attribute:: prevPos: vec2

      The previous position of the touch (in screen coordinates) as a vector

      .. helptext:: get the previous position as a vec2

   .. lua:attribute:: delta: vec2

      The position delta of the touch (in screen coordinates) as a vector

      .. helptext:: get the delta movement

   .. lua:attribute:: force: number

      The amount of force being applied (only applies to pencil type touches)

      .. helptext:: get the force of this touch

   .. lua:attribute:: maxForce: number

      The maximum amount of force that can be applied (only applies to pencil type touches)

      .. helptext:: get the maximum force of this touch

   .. lua:attribute:: timestamp: number  
      
      The time when this touch event occured (only applies to pencil type touches)

      .. helptext:: get the timestamp of this touch

   .. lua:attribute:: azimuth: number

      The azimuth angle of the pencil (only applies to pencil type touches)

      .. helptext:: get the azimuth angle of the stylus
        
   .. lua:attribute:: altitude: number

      The altitude angle of the pencil

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


   .. lua:function:: cancelTouch(scene)

      Cancels the touch of a scene

      :param scene: The scene to cancel touch to
      :type scene: scene
      
      .. helptext:: cancels the touch in a scene

Gestures
########

.. lua:class:: gesture

   Represents a single gesture event

   .. lua:attribute:: state: enum

      The current state of the gesture

      .. helptext:: get the current state of this touch or gesture

   .. lua:attribute:: location: vec2

      The location of the gesture event on the screen

      .. helptext:: get the location of this gesture

   .. lua:attribute:: translation: vec2

      The translation of the gesture event relative to its starting location

      .. helptext:: get the translation of this gesture or joint

   .. lua:attribute:: delta: vec2

      The delta of the gesture event since last update

      .. helptext:: get the delta movement

   .. lua:attribute:: pinchScale: number

      The scale of a pinch gesture relative to its starting distance

      .. helptext:: get the pinch scale of this gesture

   .. lua:attribute:: pinchDelta: number

      The delta of the pinch distance since last update

      .. helptext:: get the pinch delta of this gesture

   .. lua:attribute:: pinchVelocity: number

      The current change in pinch distance over time

      .. helptext:: get the pinch velocity of this gesture

   .. lua:attribute:: rotationAngle: number 

      The current angle of a rotation gesture relative to its' starting angle

      .. helptext:: get the rotation angle of this gesture

   .. lua:attribute:: rotationVelocity: number

      The current change in rotation angle over time

      .. helptext:: get the rotation velocity of this gesture

   .. lua:attribute:: touchCount: integer

      The current number of touches associated with this gesture
      
      .. helptext:: get the touch count for this gesture

   .. lua:attribute:: direction: enum

      The direction of the swipe
      
      .. helptext:: get the direction for this gesture

   .. lua:attribute:: left: integer

      Left direction enum
      
      .. helptext:: left direction enum

   .. lua:attribute:: right: integer

      Right direction enum
      
      .. helptext:: right direction enum
      
   .. lua:attribute:: up: integer

      Up direction enum
      
      .. helptext:: up direction enum

   .. lua:attribute:: down: integer

      Down direction enum
      
      .. helptext:: down direction enum

   .. lua:attribute:: all: integer

      All direction enum
      
      .. helptext:: all direction enum

.. lua:class:: gesture.tap

   Tap gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.tap(callback[, tapCount = 1, touchCount = 1])

      Creates and registers a new tap gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a tap gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled

.. lua:class:: gesture.pan

   Pan gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.pan(callback[, minTouches = 1, maxTouches = 1, trackpadSupport = false])

      Creates and registers a new pan gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a pan gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled


.. lua:class:: gesture.pinch

   Pinch gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.pinch(callback)

      Creates and registers a new pinch gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a pinch gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer

      .. helptext:: whether the gesture recognizer is enabled


.. lua:class:: gesture.rotation

   Rotation gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.rotation(callback)
      
      Creates and registers a new rotation gesture recognizer that will call ``callback(gesture)`` when recognized

      .. helptext:: create a rotation gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer
      
      .. helptext:: whether the gesture recognizer is enabled

.. lua:class:: gesture.swipe

   Swipe gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.swipe(callback[, swipeDirection = gesture.all, touchCount = 1])

      Creates and registers a new swipe gesture recognizer that will call ``callback(gesture)`` when recognized

      :return: The gestures in this order (left, right, up, down). But if a direction is not included then it is ingored
      :rtype: gesture.swipe, gesture.swipe, gesture.swipe, gesture.swipe 
      
      .. helptext:: create a swipe gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer
      
      .. helptext:: whether the gesture recognizer is enabled

.. lua:class:: gesture.longPress

   Rotation gesture recognizer (using system gesture recognizer for implementation)

   .. lua:staticmethod:: gesture.longPress(callback[, tapCount = 0, touchCount = 1, allowableMovement = 10, minimumPressDuration = 0.5])
      
      Creates and registers a new long press gesture recognizer that will call ``callback(gesture)`` when recognized
      
      .. helptext:: create a long press gesture recognizer

   .. lua:attribute:: enabled: boolean

      Enables/disables this gesture recognizer
      
      .. helptext:: whether the gesture recognizer is enabled

Keyboard
########

.. lua:module:: key

.. lua:function:: pressing(keyCode)

   Queries whether the key is currently being pressed this frame

   .. helptext:: check if a key is currently pressed

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Is the key being pressed this frame
   :rtype: boolean

.. lua:function:: wasPressed(keyCode)

   Queries whether the key is was pressed down this frame

   .. helptext:: check if a key was pressed this frame

   :param keyCode: The keyCode to query
   :type keyCode: constant
   :return: Was the key pressed down this frame
   :rtype: boolean

.. lua:function:: wasReleased(keyCode)

   Queries whether the supplied key code was released this frame

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

   Use `key.pressing(keyCode)` to query individual keys such as `key.leftAlt`.

.. lua:function:: modifiersPressed(modifiers)

   Queries whether the supplied key modifiers are currently pressed

   .. helptext:: check if keyboard modifiers are pressed

   :param modifiers: The key modifiers to query as a bit field
   :type modifiers: constant
   :return: Are the key modifiers currently pressed
   :rtype: boolean

Constants - Key Codes
*********************

.. lua:attribute:: leftAlt: const

   .. helptext:: left alt key constant
.. lua:attribute:: rightAlt: const

   .. helptext:: right alt key constant
.. lua:attribute:: alt: const

   .. helptext:: alt key constant
.. lua:attribute:: leftCtrl: const

   .. helptext:: left ctrl key constant
.. lua:attribute:: rightCtrl: const

   .. helptext:: right ctrl key constant
.. lua:attribute:: ctrl: const

   .. helptext:: ctrl key constant
.. lua:attribute:: leftCmd: const

   .. helptext:: left command key constant
.. lua:attribute:: rightCmd: const

   .. helptext:: right command key constant
.. lua:attribute:: cmd: const

   .. helptext:: command key constant
.. lua:attribute:: leftShift: const

   .. helptext:: left shift key constant
.. lua:attribute:: rightShift: const

   .. helptext:: right shift key constant
.. lua:attribute:: shift: const

   .. helptext:: shift key constant
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

   .. lua:attribute:: all: table<gamepad>

      A list of all currently connected gamepads

      .. helptext:: get all connected gamepads

   .. lua:attribute:: current: gamepad

      The current main active gamepad (or nil if none connected)

      .. helptext:: get the current active gamepad

   .. lua:attribute:: virtual: gamepad.virtualGamepad

      Gets or creates a virtual gamepad which will substitute on-screen controls if no controller is currently connected

      .. helptext:: get the virtual gamepad

   .. lua:attribute:: connected: function(gamepad)

      Callback for when a gamepad is connected

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

      .. helptext:: get the battery level of the gamepad

   .. lua:attribute:: batteryState: const

      .. helptext:: get the battery state of the gamepad

   .. lua:attribute:: light: color

      .. helptext:: get or set the gamepad light color

   .. lua:class:: button

      .. lua:attribute:: pressing: boolean

         .. helptext:: get whether this button is being pressed

      .. lua:attribute:: pressed: boolean

         .. helptext:: get whether this button was just pressed

      .. lua:attribute:: released: boolean

         .. helptext:: get whether this button was just released

      .. lua:attribute:: value: number

         .. helptext:: get the analog value of this button

      .. lua:attribute:: touching: boolean

         .. helptext:: get whether the touchpad is being touched

   .. lua:class:: directionalPad

      .. lua:attribute:: pressing: boolean

         .. helptext:: get whether this button is being pressed

      .. lua:attribute:: dir: vec2

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
########

.. lua:currentmodule:: None

.. lua:class:: mouse

   .. lua:attribute:: active: boolean

      Is there a mouse active
      
      .. helptext:: checks if a mouse is active

   .. lua:attribute:: connected: function(mouse)

      Callback for when a mouse is connected
      
      .. helptext:: sets a callback to call when a mouse is connected

   .. lua:attribute:: disconnected: function(mouse)

      Callback for when a mouse is disconnected
      
      .. helptext:: sets a callback to call when a mouse is disconnected

   .. lua:attribute:: left: mouse.button
   
      .. helptext:: gets the left mouse button

   .. lua:attribute:: middle: mouse.button
   
      .. helptext:: gets the middle mouse button

   .. lua:attribute:: right: mouse.button
   
      .. helptext:: gets the right mouse button

   .. lua:attribute:: scroll: vec2
   
      .. helptext:: gets the mouse scoll value
      
   .. lua:attribute:: x: number
   
      .. helptext:: gets the x position of the mouse
   
   .. lua:attribute:: y: number
   
      .. helptext:: gets the y position of the mouse

   .. lua:attribute:: pos: vec2

      Return a vec2 of both the x and y position
      
      .. helptext:: gets the position of the mouse

   .. lua:attribute:: dx: number
   
      .. helptext:: gets the delta X of the mouse
   
   .. lua:attribute:: dy: number
   
      .. helptext:: gets the delta Y of the mouse

   .. lua:attribute:: deltaX: number
   
      .. helptext:: gets the delta X of the mouse
   
   .. lua:attribute:: deltaY: number
   
      .. helptext:: gets the delta Y of the mouse

   .. lua:attribute:: delta: vec2

      Return a vec2 of both dx and dy
      
      .. helptext:: gets the delta of the mouse

   .. lua:attribute:: visible: boolean

      Sets whether the mouse is visible or hidden
      
      .. helptext:: set the visibility of the mouse

   .. lua:class:: button

      .. lua:attribute:: pressing: boolean
      
         .. helptext:: get whether this button is being pressed

      .. lua:attribute:: pressed: 
      
         .. helptext:: get whether this button was just pressed

      .. lua:attribute:: released: boolean
      
         .. helptext:: get whether this button was just released

      .. lua:attribute:: value: number
      
         .. helptext:: get the analog value of this button

      .. lua:attribute:: touching: boolean
      
         .. helptext:: get whether the touchpad is being touched

.. lua:module:: mouse

.. lua:function:: default()

   Changes the mouse back to its default style
   
   .. helptext:: sets the mouse style to default

.. lua:function:: path(polygon1, polygon...) 

   Turns the mouse style to a path (allows multiple polygons for unique shapes)

   :param polygon1: Table that represents point of the mouse shape (offset from the mouse)
   :type polygon1: table<vec2>
   :param polygon...: for more polygons
   :type polygon...: table<vec2>
   
   .. helptext:: sets the mouse style to a path

.. lua:function:: rect(pos, size [, roundedRadius = 0]) 

   Turns the mouse style to a rectangle 

   :param pos: Represents the positions of the rectangle from the mouse
   :type pos: vec2
   :param size: Represents the size of the rectangle
   :type size: vec2
   :param roundedRadius: Radius of the rectangle
   :type roundedRadius: number
   
   .. helptext:: sets the mouse style to roundable rectangle

.. lua:currentmodule:: None

**Global Mouse Funcitons**

.. lua:method:: mousePressed(mouseName)

      Function for when the mouse is pressed

      :param mouseName: return the name of the mouse being selected ("left", "right", "middle") 
      :type mouseName: string
      
      .. helptext:: function that is called when the mouse has been pressed

.. lua:method:: mouseReleased(mouseName)

      Function for when the mouse is released

      :param mouseName: return the name of the mouse being selected ("left", "right", "middle") 
      :type mouseName: string
      
      .. helptext:: function that is called when the mouse has been released

.. lua:method:: mouseChanged(mouseName, changeState)

      Function for when the mouse has been changed

      :param mouseName: Returns the name of the mouse being selected ("left", "right", "middle") 
      :type mouseName: string
      :param changeState: Inputs true if the mouse was pressed or false if the mouse was released
      :type wasPressed: boolean
      
      .. helptext:: function that is called when the mouse has been changed

.. lua:method:: mouseMoved(deltaX, deltaY)

      Function for when the mouse has been moved

      :param deltaX: The delta x of the mouse
      :type deltaX: number
      :param deltaY: The delta y of the mouse
      :type deltaY: number
      
      .. helptext:: function that is called when the mouse has been moved
