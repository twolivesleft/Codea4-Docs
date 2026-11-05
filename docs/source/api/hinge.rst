:reference-overview: Responding to Hinge Changes

Hinge
=====

Read ``hinge.angle`` to get the fold angle on supported devices, or define ``hingeChanged`` to respond as the device folds.

The angle is ``nil`` when no reading is available. Choose a fallback before using it in calculations, such as ``local angle = hinge.angle or 0``.

.. lua:module:: hinge

.. lua:attribute:: angle: number | nil [readonly]

   The hinge angle, in degrees. The value may be ``nil`` if no hinge angle is available yet or the device is not supported.

   .. helptext:: current hinge angle in degrees, or nil when unavailable

   :syntax:

      .. code-block:: lua

         local angle = hinge.angle
         if angle ~= nil then
             local radians = math.rad(angle)
         end

.. lua:currentmodule:: None

.. lua:function:: hingeChanged(current, previous)

   Use this global function to receive changes to the hinge angle. Codea calls it before drawing with the new and previous angles in degrees.

   ``previous`` is ``nil`` for the first reading and when readings resume after being unavailable. ``current`` is ``nil`` when hinge input becomes unavailable. The function is not called while both values are ``nil``.

   In draw-on-request mode, a hinge change causes Codea to draw a frame and call this function.

   .. helptext:: called before drawing when the hinge angle changes

   :param current: The new angle in degrees, or ``nil`` when unavailable.
   :type current: number | nil
   :param previous: The previous angle in degrees, or ``nil`` if none was available.
   :type previous: number | nil

   :syntax:

      .. code-block:: lua

         function hingeChanged(current, previous)
             if current == nil then
                 print("Hinge input unavailable")
             elseif previous == nil then
                 print("Hinge angle:", current)
             else
                 print("Hinge angle change:", current - previous)
             end
         end
