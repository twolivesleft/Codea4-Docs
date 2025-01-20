viewer
======
      
Exposes viewer properties common to both the legacy and modern runtimes.

.. lua:module:: viewer

.. lua:attribute:: mode: enum

   The display mode of the viewer. You can use this to render your games and simulations in fullscreen mode, fullscreen mode without buttons, or the standard mode. The standard mode includes a sidebar with your output and parameters, as well as buttons to control project execution.

   .. helptext:: STANDARD or FULLSCREEN
   
   Values:

      * ``STANDARD``
      * ``FULLSCREEN``
      * ``FULLSCREEN_NO_BUTTONS``

.. lua:attribute:: safeArea: table
   
   A UIEdgeInsets object with the current safe area insets of the viewer, which can be accessed using ``viewer.safeArea.top``, ``viewer.safeArea.bottom``, ``viewer.safeArea.left``, and ``viewer.safeArea.right``

   .. helptext:: safe area insets of the viewer
   
   :param number top: The top inset of the safe area.
   :param number bottom: The bottom inset of the safe area.
   :param number left: The left inset of the safe area.
   :param number right: The right inset of the safe area.
