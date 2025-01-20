How Codea Works
===============

Codea is primarily designed as a realtime graphical engine that uses callbacks to draw and update the screen

When you create a project you are given a basic template in ``Main.lua`` that
contains some global functions:

.. code-block:: lua

   -- Called once at the beggining
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
      if touch.began or touch.moving then
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

keyReleased(keyPress)
#####################

scroll(gesture)
###############

hover(gesture)
###############
