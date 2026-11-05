Animating Values
================

A tween changes a value over time. Use one to slide a menu into place, fade a
label, or move an object to a destination.

Starting a tween
----------------

Keep the values in a table or object, then give the tween its destination and
duration. An easing curve changes how it speeds up or slows down.

Start a tween once, such as when a button is pressed. Starting it again in
``draw()`` would reset it every frame. Keep the returned tween if you want to
pause or cancel it later.

Use a completion callback to run code when it finishes, or a sequence to run
several tweens in order. See :doc:`/api/tween` for examples and commands.
