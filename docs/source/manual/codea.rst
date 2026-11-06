How Codea Works
===============

Codea calls functions in your project to draw the screen and respond to touches, keys, and other events.

A new project starts with a ``Main.lua`` tab containing these functions:

.. code-block:: lua

   -- Called once at the beginning
   function setup()
      x = WIDTH/2
      y = HEIGHT/2
   end

   -- Called every frame
   function draw()
      background(128)
      style.push().fill(color.red).stroke(255).strokeWidth(5)
      ellipse(x, y, 100, 100)
   end

   -- Called when a touch is detected or updated
   function touched(touch)
      if touch.began or touch.changed then
         x = touch.x
         y = touch.y
      end
   end

Press Play to run the project. Codea calls ``setup()`` once, then ``draw()`` each frame. It calls ``touched(touch)`` as touches begin, move, and end, including mouse clicks and drags.

setup()
-------

Use ``setup()`` to load images, create objects, and set starting values before the first frame.

draw()
------

Use ``draw()`` to draw the screen and move objects each frame.

touched(touch)
--------------

Use ``touched(touch)`` to respond to taps and drags. The ``touch`` value tells you the position and whether the touch began, moved, or ended.

Additional Events
-----------------

update(dt)
##########

Use ``update(dt)`` to keep movement and game logic separate from drawing. ``dt`` is the time in seconds since the last frame, also available as ``time.delta``.

fixedUpdate(dt)
###############

Use ``fixedUpdate(dt)`` for physics or other simulations that need evenly spaced time steps. Codea calls it a fixed number of times per second, independently of drawing. ``dt`` is the same as :lua:`time.fixedDelta`.

keyPressed(keyPress)
####################

Called when a key on a hardware keyboard goes down. ``keyPress.keyCode`` identifies the key and ``keyPress.characters`` holds the text it typed. It is not called while a user interface text field has focus

.. code-block:: lua

   function keyPressed(keyPress)
      if keyPress.keyCode == key.space then
         print("space")
      else
         print("typed", keyPress.characters)
      end
   end

keyReleased(keyPress)
#####################

Called when a key on a hardware keyboard comes back up. It receives the same kind of ``keyPress`` as ``keyPressed()``

.. code-block:: lua

   function keyReleased(keyPress)
      if keyPress.keyCode == key.space then
         print("space released")
      end
   end

scroll(gesture)
###############

Called when the user scrolls with a trackpad or mouse wheel. ``gesture.delta`` is the scroll movement since the last call and ``gesture.location`` is the pointer position

.. code-block:: lua

   function scroll(gesture)
      y = y + gesture.delta.y
   end

hover(gesture)
###############

Called when a mouse or trackpad pointer moves over the viewer with no button held. ``gesture.location`` is the pointer position

.. code-block:: lua

   function hover(gesture)
      x = gesture.location.x
      y = gesture.location.y
   end

Learning Lua by changing a program
----------------------------------

This project introduces strings, variables, ``nil``, and ``if/elseif/else``. Read the comments and watch the console output. Try changing ``foo`` to choose a different branch.

.. codea-example:: Learning Lua by changing a program
   :project: code/Modern/Basics 01 - Hello Lua.codea
