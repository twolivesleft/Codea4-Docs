How Codea Works
===============

Codea is primarily designed as a realtime graphical engine that uses callbacks to draw and update the screen.

In this reference, **Run Example** opens a complete project in a dismissible viewer.
Use **Show code** to inspect longer examples. Projects with adjustable parameters
show a **Controls** button; changes there update the running project. Close the
controls to return to the canvas, then use **Done** to return to the documentation.

When you create a project you are given a basic template in ``Main.lua`` that
contains some global functions:

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

Each of these functions are called by Codea in response to specific events, such as
``setup()`` being called when the project begins running, while ``draw()`` is called
every time the screen is about to be redrawn

The ``touched(touch)`` callback is called in reponse to the screen being touched
(on iOS) or a mouse press (on MacOS)

setup()
-------

This function is called exactly once, right before the first frame is about to be drawn and is an ideal spot to put your initialisation code, setting everything up for when ``draw()`` will be called!

draw()
------

This is the meat and potatoes of any Codea app, where you will do the majority of your update and drawing logic

touched(touch)
--------------

This is your primary source of interaction with users

Additional Events
-----------------

update(dt)
##########

As an alternative to doing your update logic in ``draw()`` you can also use ``update(dt)``, where ``dt`` is the amount of delta time since last frame (also available in time.delta)

fixedUpdate(dt)
###############

A special update function that is called a fixed number of times per second regardless of the current framerate, ideal for physics calculations and simulations that require a stable stepping rate. The delta time value passed in is the same as :lua:`time.fixedDelta`

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

Start with setup(), which runs once, and draw(), which runs every frame. The commented project walks through strings, local and global variables, nil, and if/elseif/else. Its print output appears in Codea's console; this viewer also displays a greeting on the canvas. Try changing foo to choose a different branch.

.. codea-example:: Learning Lua by changing a program
   :project: code/Modern/Basics 01 - Hello Lua.codea
