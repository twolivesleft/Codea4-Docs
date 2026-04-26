Input
=====

Input in Codea
--------------

Codea provides a unified input system that handles touch, mouse, keyboard, and device motion across iOS and macOS. The main entry point is the :lua:mod:`input` module, which exposes current input state each frame.

All input state is sampled once per frame at the start of ``draw()``. You can read it synchronously without callbacks.

Touches
-------

Touches represent screen contacts (fingers on iOS, mouse clicks on macOS). Use ``input.touches`` to get all current active touches:

.. code-block:: lua

   function draw()
       background(40)

       for id, touch in pairs(input.touches) do
           fill(255, 100, 100)
           circle(touch.x, touch.y, 30)
       end
   end

Each touch object provides:

- ``touch.x``, ``touch.y`` — current position
- ``touch.prevX``, ``touch.prevY`` — previous frame position
- ``touch.deltaX``, ``touch.deltaY`` — movement since last frame
- ``touch.began``, ``touch.moving``, ``touch.ended`` — phase booleans
- ``touch.tapCount`` — number of taps

For callback-based touch handling, define the global ``touched(touch)`` function or set ``entity.touched`` on an entity:

.. code-block:: lua

   function touched(touch)
       if touch.began then
           print("Touch started at", touch.x, touch.y)
       end
   end

Key Presses
-----------

Read keyboard state via ``input.key``:

.. code-block:: lua

   function draw()
       if input.key.w or input.key.up then
           player.y = player.y + speed * DeltaTime
       end
       if input.key.s or input.key.down then
           player.y = player.y - speed * DeltaTime
       end
   end

Check if any key is pressed with ``input.key.pressed`` (returns true while any key is held). Special key names include ``space``, ``return``, ``backspace``, ``up``, ``down``, ``left``, ``right``, ``shift``, ``ctrl``, ``alt``, and ``cmd``.

For text input, read the current text from ``input.keyboard.text`` and clear it each frame:

.. code-block:: lua

   local inputBuffer = ""

   function draw()
       if #input.keyboard.text > 0 then
           inputBuffer = inputBuffer .. input.keyboard.text
           input.keyboard.text = ""
       end
   end

Trackpad
--------

On macOS, the trackpad provides precise cursor input. Use ``input.mouse`` to read mouse / trackpad state:

.. code-block:: lua

   function draw()
       -- Cursor position
       local x, y = input.mouse.x, input.mouse.y

       -- Button state
       if input.mouse.left then
           -- left button held
       end

       -- Scroll delta
       local scrollY = input.mouse.scroll.y
   end

Hover
-----

Detect when the pointer hovers over a region without clicking:

.. code-block:: lua

   function draw()
       local hovered = input.mouse.x > 50 and input.mouse.x < 150
                    and input.mouse.y > 50 and input.mouse.y < 150

       fill(hovered and color.yellow or color.white)
       rect(50, 50, 100, 100)
   end

Entity-based input systems (with ``entity.hitTest = true``) automatically handle spatial hover and touch testing using attached collider shapes, removing the need for manual bounds checks.
