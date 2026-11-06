:reference-overview: Inspecting Objects

Inspector
=========


Use the inspector to change an object’s values while your project runs. Call
``inspector.set(object)`` to show it, or ``inspector.add(object)`` to add it
alongside other objects. Changes take effect in your project immediately.

Use ``push`` and ``pop`` to move between inspector pages, and ``clear`` to remove
the contents. Add objects once when creating or selecting them.

.. lua:module:: inspector

.. lua:staticmethod:: set(object)

   Displays any viewable/editable properties and actions for ``object``

   .. helptext:: replace the inspector contents

.. lua:staticmethod:: add(object)

   Appends ``object``'s data to the inspector

   .. helptext:: add an object to the inspector

.. lua:staticmethod:: push(object)

   Pushes a new page onto the inspector stack and adds ``object`` to it

   .. helptext:: push a new inspector page

.. lua:staticmethod:: pop()   

   .. helptext:: pop the current inspector page

.. lua:staticmethod:: clear()      

   .. helptext:: clear the inspector
