Input
=====

Input in Codea
--------------

Codea delivers input in two ways. Callbacks such as ``touched(touch)`` and ``keyPressed(press)`` are global functions that Codea calls when something happens. State such as ``key.pressing(key.space)``, ``mouse.x`` and ``gamepad.current`` can be read at any time, so you can also poll input from ``draw()``.

Touch and keyboard events are delivered before ``draw()`` runs, so the state you read in ``draw()`` is up to date for that frame.

Touches
-------

Define a global ``touched(touch)`` function to receive touches. It is called each time a touch changes: when a finger goes down, every time it moves, and when it lifts. On a Mac, or an iPad with a mouse or trackpad, a click arrives as a touch of type ``touch.pointer``.

.. code-block:: lua

   local touches = {}

   function touched(touch)
       if touch.ended or touch.cancelled then
           touches[touch.id] = nil
       else
           touches[touch.id] = touch.pos
       end
   end

   function draw()
       background(40)
       style.fill(255, 100, 100)
       for id, pos in pairs(touches) do
           ellipse(pos.x, pos.y, 60, 60)
       end
   end

Each touch provides:

- ``touch.id``, a number that stays the same for the life of the touch
- ``touch.x``, ``touch.y`` and ``touch.pos``, the current position
- ``touch.prevX``, ``touch.prevY`` and ``touch.prevPos``, the position at the previous event
- ``touch.deltaX``, ``touch.deltaY`` and ``touch.delta``, the movement since the previous event
- ``touch.began``, ``touch.changed``, ``touch.ended`` and ``touch.cancelled``, which are true in the matching phase (``touch.moving`` is the same as ``touch.changed``)
- ``touch.state``, the phase as one of ``BEGAN``, ``CHANGED``, ``ENDED`` or ``CANCELLED`` (``MOVING`` is the same value as ``CHANGED``)
- ``touch.tapCount``, the number of quick taps in a row
- ``touch.type``, one of ``touch.direct``, ``touch.indirect``, ``touch.pencil`` or ``touch.pointer``

Positions are in screen coordinates with the origin at the bottom left. Apple Pencil touches also report ``force``, ``maxForce``, ``azimuth``, ``altitude``, ``precisePos`` and ``precisePrevPos``.

To poll instead of using the callback, read ``touch.current``. It holds the first touch that is down, and keeps its last state after it ends.

.. code-block:: lua

   function draw()
       background(40)
       local t = touch.current
       if t.began or t.changed then
           style.fill(255)
           ellipse(t.x, t.y, 80, 80)
       end
   end

Touching Entities
-----------------

Entities in ``scene.main`` receive touches through a ``touched`` method. Return ``true`` when the touch begins to keep receiving it until it ends. A touch kept by an entity is not passed to the global ``touched`` function.

.. code-block:: lua

   function setup()
       scn = scene()
       scene.main = scn

       local e = scn:entity()
       function e:touched(touch)
           if touch.began then
               print("began", touch.x, touch.y)
           elseif touch.ended then
               print("ended")
           end
           return true
       end
   end

Without hit testing, every entity with a ``touched`` method is offered every new touch. Set ``entity.hitTest = true`` to offer it only touches that land on its 2D or 3D physics body, as seen by the scene's camera. For a 3D body the method also receives the raycast hit as a second argument.

Inside a callback, ``touch:makeExclusive(entity)`` gives a touch to that entity alone, and ``touch:cancel(scene)`` ends it for every entity in the scene that holds it.

Gestures
--------

Gesture recognizers use the system's tap, pan, pinch and rotation recognizers and call a function with a :lua:class:`gesture` when they fire. Keep a reference to each recognizer you create. It stops working once it is garbage collected.

.. code-block:: lua

   function setup()
       zoom = 1
       offset = vec2(0, 0)

       pinch = gesture.pinch(function(g)
           zoom = zoom * g.pinchDelta
       end)

       pan = gesture.pan(function(g)
           offset = offset + g.delta
       end, 2, 2)

       doubleTap = gesture.tap(function(g)
           zoom = 1
           offset = vec2(0, 0)
       end, 2)
   end

   function draw()
       background(40)
       style.fill(100, 180, 255)
       local size = 120 * zoom
       rect(WIDTH/2 + offset.x - size/2, HEIGHT/2 + offset.y - size/2, size, size)
   end

A two finger pan moves the square, a pinch scales it, and a double tap resets it. By default a touch is handled by one recognizer at a time. Give recognizers the same non-zero ``group`` to let them run together, for example ``pinch.group = 1`` and ``pan.group = 1``.

Keyboard
--------

Hardware keyboards are supported on iPhone, iPad and Mac. There is no on-screen keyboard API.

Read key state from ``draw()`` with the :lua:mod:`key` functions. ``key.pressing`` is true while a key is held. ``key.wasPressed`` and ``key.wasReleased`` are true only in the frame where the key went down or came up.

.. code-block:: lua

   function setup()
       pos = vec2(WIDTH/2, HEIGHT/2)
   end

   function draw()
       background(40)
       local speed = 300 * time.delta
       if key.pressing(key.left) then pos.x = pos.x - speed end
       if key.pressing(key.right) then pos.x = pos.x + speed end
       if key.pressing(key.up) then pos.y = pos.y + speed end
       if key.pressing(key.down) then pos.y = pos.y - speed end
       if key.wasPressed(key.space) then print("jump") end

       style.fill(255)
       ellipse(pos.x, pos.y, 60, 60)
   end

To react to each key as it happens, define ``keyPressed(press)`` and ``keyReleased(press)``. The :lua:class:`key.press` passed in holds the ``keyCode``, the ``modifierFlags`` held at the time, and the ``characters`` the key typed. Collect ``characters`` to read typed text:

.. code-block:: lua

   local typed = ""

   function keyPressed(press)
       if press.keyCode == key.backspace then
           typed = typed:sub(1, -2)
       elseif press.characters:match("^[%g ]$") then
           typed = typed .. press.characters
       end
   end

   function draw()
       background(40)
       style.fill(255)
       text(typed, WIDTH/2, HEIGHT/2)
   end

``keyPressed`` and ``keyReleased`` are not called while a user interface text field has focus.

Modifier keys are reported as a bit field. ``key.modifiersPressed(key.cmd)`` is true while either Command key is held. Combine masks with ``|`` to require several at once:

.. code-block:: lua

   function keyPressed(press)
       if press.keyCode == key.s and key.modifiersPressed(key.cmd | key.shift) then
           print("save as")
       end
   end

Mouse and Trackpad
------------------

On a Mac, or an iPad with a mouse or trackpad, the global ``mouse`` holds the pointer state. ``mouse.active`` is true while a mouse or trackpad is connected.

.. code-block:: lua

   function draw()
       background(40)
       if mouse.left.pressed then
           style.fill(255, 200, 0)
       else
           style.fill(255)
       end
       ellipse(mouse.x, mouse.y, 40, 40)
   end

``mouse.x`` and ``mouse.y`` follow the pointer while it hovers and while a button is held. ``mouse.delta`` and ``mouse.scroll`` hold the movement and scrolling since the last frame. Set ``mouse.visible = false`` to hide the system pointer over the viewer.

Two callbacks report pointer activity. ``hover(gesture)`` is called as the pointer moves over the viewer with no button held, and ``scroll(gesture)`` is called for trackpad and scroll wheel scrolling. Both receive a :lua:class:`gesture` whose ``location`` is the pointer position. For ``scroll``, ``gesture.delta`` is the scroll movement since the previous call, with positive ``y`` meaning up.

.. code-block:: lua

   local scrollY = 0
   local hoverX, hoverY = 0, 0

   function scroll(gesture)
       scrollY = scrollY + gesture.delta.y
   end

   function hover(gesture)
       hoverX, hoverY = gesture.location.x, gesture.location.y
   end

   function draw()
       background(40)
       style.fill(255)
       ellipse(hoverX, hoverY + scrollY, 40, 40)
   end

Gamepads
--------

Game controllers connected to the device are listed in ``gamepad.all``. ``gamepad.current`` is the controller used most recently, or ``nil`` if none is connected.

.. code-block:: lua

   function setup()
       pos = vec2(WIDTH/2, HEIGHT/2)
       gamepad.connected = function(pad)
           print("connected", pad.vendorName)
       end
   end

   function draw()
       background(40)
       local pad = gamepad.current
       if pad then
           pos = pos + pad.leftStick.dir * 300 * time.delta
           if pad.a.pressed then print("A") end
       end
       style.fill(255)
       ellipse(pos.x, pos.y, 60, 60)
   end

Controllers already connected when the project starts are in ``gamepad.all`` but do not trigger ``gamepad.connected``.

Each button has ``pressing``, which is true while it is held, ``pressed`` and ``released``, which are true only in the frame it changed, and an analog ``value``. Sticks, the directional pad and the touchpad surface report a ``dir`` vector along with ``x``, ``y``, ``left``, ``right``, ``up`` and ``down``.

``gamepad.virtual`` returns an on-screen gamepad with a stick at the bottom left and an ``A`` button at the bottom right, controlled by touch. While a controller is connected it is hidden and mirrors that controller, so a project can read the same buttons either way:

.. code-block:: lua

   function setup()
       pad = gamepad.virtual
       pos = vec2(WIDTH/2, HEIGHT/2)
   end

   function draw()
       background(40)
       pos = pos + pad.leftStick.dir * 300 * time.delta
       if pad.a.pressed then print("A") end
       style.fill(255)
       ellipse(pos.x, pos.y, 60, 60)
   end
