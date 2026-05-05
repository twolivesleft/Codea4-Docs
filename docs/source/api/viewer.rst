viewer
======

Controls the Codea viewer and exposes display mode, runtime, presentation, and screen layout state.

.. lua:module:: viewer

.. lua:attribute:: mode: enum

   Changes the display mode of the viewer. Use this to render your games and simulations in fullscreen mode, fullscreen mode without buttons, or standard mode. Standard mode includes the sidebar with output and parameters, plus controls for project execution.

   .. helptext:: current viewer display mode

   :syntax:

      .. code-block:: lua

         viewer.mode = STANDARD
         viewer.mode = FULLSCREEN
         viewer.mode = FULLSCREEN_NO_BUTTONS

.. lua:attribute:: framerate: number

   Sets the preferred framerate of the viewer. You can set this to ``0``, ``15``, ``30``, ``60`` or ``120``. The value ``0`` uses the maximum framerate of your device.

   Note that this sets the preferred framerate. If the framerate cannot be maintained, it may drop below your preferred setting to the next lower value.

   .. helptext:: preferred viewer framerate

   :syntax:

      .. code-block:: lua

         viewer.framerate = 30

.. lua:attribute:: pointerLocked: boolean

   Setting this property to ``true`` indicates the renderer's preference to lock the pointer, although the system may not honor the request. For the system to consider locking the pointer, the viewer must be running fullscreen on your device.

   .. helptext:: whether pointer locking is desired

   :syntax:

      .. code-block:: lua

         viewer.pointerLocked = true

.. lua:attribute:: runtime: number [readonly]

   The active runtime type, either ``LEGACY`` or ``MODERN``.

   .. helptext:: current runtime type

   :syntax:

      .. code-block:: lua

         if viewer.runtime == viewer.MODERN then
             style.strokeWidth(5)
         end

.. lua:attribute:: safeArea: table

   A table specifying the current safe area insets of the viewer. Use these values to avoid rendering important visible or interactive content under system interface areas.

   .. helptext:: safe area insets of the viewer

   :param number top: The top inset of the safe area.
   :param number left: The left inset of the safe area.
   :param number bottom: The bottom inset of the safe area.
   :param number right: The right inset of the safe area.

   :syntax:

      .. code-block:: lua

         print(viewer.safeArea.bottom)

.. lua:attribute:: uniformResizing: boolean

   Controls whether the viewer preserves a uniform resizing behavior when the view changes size. This is only supported on platforms where the viewer is resizable.

   .. helptext:: use uniform viewer resizing

.. lua:function:: resize(width, height)

   Resizes the viewer to the specified width and height. This is only supported on platforms where the viewer is resizable.

   .. helptext:: resize the viewer

   :param width: The new viewer width.
   :type width: number
   :param height: The new viewer height.
   :type height: number

   :syntax:

      .. code-block:: lua

         viewer.resize(800, 600)

.. lua:attribute:: paused: boolean

   A boolean value that indicates whether the viewer is paused.

   .. helptext:: paused state of the viewer

.. lua:attribute:: displayStats: boolean

   Controls whether runtime statistics are displayed in the viewer.

   .. helptext:: show viewer statistics

.. lua:attribute:: drawOnRequest: boolean

   Controls whether the viewer draws only when a redraw is requested.

   .. helptext:: draw only when requested

.. lua:attribute:: showWarnings: boolean

   Determines whether warnings should be displayed in the viewer. For example, warnings will be printed when using deprecated Codea APIs.

   .. helptext:: show viewer warnings

.. lua:function:: close()

   Closes the viewer and returns to the editor. Calling ``viewer.close()`` is functionally the same as pressing the on-screen Back button.

   .. helptext:: close the viewer

   :syntax:

      .. code-block:: lua

         viewer.close()

.. lua:function:: restart()

   Restarts the viewer, starting your project again. Calling ``viewer.restart()`` is functionally the same as pressing the on-screen Restart button.

   .. helptext:: restart the viewer

   :syntax:

      .. code-block:: lua

         viewer.restart()

.. lua:function:: snapshot()

   Captures the rendered contents of the viewer and returns them as an ``image``. This captures the rendered scene and does not include the sidebar UI.

   .. helptext:: capture the viewer as an image

   :return: The rendered viewer contents.
   :rtype: image

   :syntax:

      .. code-block:: lua

         local img = viewer.snapshot()

.. lua:function:: alert(message[, title])

   Shows a system alert. The ``message`` parameter specifies the message to display. The optional ``title`` parameter provides the title of the alert. If no title is specified, ``"Alert"`` is used.

   .. helptext:: show a system alert

   :param message: Message to display.
   :type message: string
   :param title: Alert title.
   :type title: string

   :syntax:

      .. code-block:: lua

         viewer.alert("Hello World")
         viewer.alert("Hello World", "Title")

.. lua:function:: share(data)

   Shows a system share view for an image, string, or table of shareable items. This allows you to share content to a third-party service, save it to your device, or copy it to the pasteboard.

   .. helptext:: share viewer content

   :param data: Content to share.
   :type data: image | string | table

   :syntax:

      .. code-block:: lua

         viewer.share(viewer.snapshot())

.. lua:attribute:: isPresenting: boolean [readonly]

   Returns whether the viewer is presenting an alert, share sheet, or another view that obscures the viewer.

   .. helptext:: whether the viewer is presenting another view

   :syntax:

      .. code-block:: lua

         if not viewer.isPresenting then
             viewer.alert("Ready")
         end

.. lua:currentmodule:: None

.. lua:attribute:: STANDARD: const

   Standard display mode. The output and parameters panes are visible, and the Back, Pause, Play and Reset buttons are shown.

   .. helptext:: standard viewer mode

   .. symbol:: const
      :group: viewer-mode      

.. lua:attribute:: FULLSCREEN: const

   Fullscreen display mode. An exit fullscreen button remains visible.

   .. helptext:: fullscreen viewer mode

   .. symbol:: const
      :group: viewer-mode      

.. lua:attribute:: FULLSCREEN_NO_BUTTONS: const

   Fullscreen display mode with all buttons hidden. Use ``viewer.close()`` if your project needs an explicit way to leave the viewer.

   .. helptext:: fullscreen viewer mode without buttons

   .. symbol:: const
      :group: viewer-mode      

.. lua:attribute:: LEGACY: const

   Legacy runtime identifier.

   .. helptext:: legacy renderer

   .. symbol:: const
      :group: viewer-type

.. lua:attribute:: MODERN: const

   Modern runtime identifier.

   .. helptext:: modern renderer

   .. symbol:: const
      :group: viewer-type
