Animating Values
================

Use tweens for a transition with a destination, such as moving a panel or fading
an object. Use ``update(dt)`` for continuous simulation, and physics for motion
that must collide or respond to forces. All three can coexist when they control
different properties.

A typical tween
---------------

Keep the animated values in a table, start a tween once in response to an event,
and read those values when drawing. Choose an easing curve to control the pace
without changing the destination. Avoid restarting the same tween in ``draw()``:
it would continually reset the transition.

Keep the returned tween handle when a later interaction may cancel or replace
it. Use completion callbacks to start a dependent action, and sequences when
several transitions should run in order. The ``tween`` reference lists timing,
easing, sequencing and cancellation operations.
