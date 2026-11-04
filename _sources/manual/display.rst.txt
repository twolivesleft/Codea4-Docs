Display and Interaction
=======================

Build the content first, then decide how people control it. Use ``viewer`` for
presentation and display settings, ``inspector`` for development controls, and
``ui`` for controls that belong to a scene. Device properties and hinge state
help adapt the experience to the current screen and pose.

Choose a coordinate system
--------------------------

Use ``WIDTH`` and ``HEIGHT`` each frame rather than saving launch dimensions.
Leave room for safe areas when placing controls near screen edges. A scene UI
can move with its parent entity; screen overlays should use the viewer's current
size. Test resizing and rotation as well as the initial layout.

Debug before designing controls
-------------------------------

Expose values through the inspector while tuning a project. Once the interaction
works, replace development-only controls with scene UI or input callbacks.
Keep the state in your project and let controls edit that state; drawing should
read it rather than recreate controls every frame.

Read ``viewer`` for display and presentation APIs, ``ui`` for scene controls,
``inspector`` for development controls, and ``device`` and ``hinge`` for the
current hardware context.
