How Codea Works
===============

Codea is primarily designed as a graphical engine that updates in realtime
typically as fast as the screen can be updated on any given device

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

Each of these functions are called by Codea for specific reasons, such as
`setup()` being called when the project begins running, while draw is called
every time the screen is about to be redrawn

The `touched(touch)` callback is called in reponse to the screen being touched
(on iOS) or a mouse press (on Mac OS)

setup()
-------

draw()
------

touched(touch)
--------------
