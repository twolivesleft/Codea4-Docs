viewer
======
      
Exposes viewer properties common to both the legacy and modern runtimes.

.. lua:module:: viewer

.. lua:class:: UIEdgeInsets

   Used by the viewer's safe area to indicate the insets for the top, left, bottom, and right of the screen.

   .. lua:attribute:: top: number

      Top value of the UIEdgeInsets

   .. lua:attribute:: left: number

      Left value of the UIEdgeInsets

   .. lua:attribute:: bottom: number

      Bottom value of the UIEdgeInsets

   .. lua:attribute:: right: number

      Right value of the UIEdgeInsets

.. lua:attribute:: mode: enum

   The display mode of the viewer. You can use this to render your games and simulations in fullscreen mode, fullscreen mode without buttons, or the standard mode. The standard mode includes a sidebar with your output and parameters, as well as buttons to control project execution.

   Values:

      * ``STANDARD``
      * ``FULLSCREEN``
      * ``FULLSCREEN_NO_BUTTONS``

.. lua:attribute:: safeArea: viewer.UIEdgeInsets
      
   A UIEdgeInsets object with the current safe area insets of the viewer, which can be accessed using ``viewer.safeArea.top``, ``viewer.safeArea.bottom``, ``viewer.safeArea.left``, and ``viewer.safeArea.right``
