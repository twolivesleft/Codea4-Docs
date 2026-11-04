inspector
=========


Use the inspector to view and edit live objects while developing a project.
Call ``inspector.set(object)`` to replace its contents, or ``inspector.add(object)``
to keep several objects visible. A change in the inspector edits the object your
project already uses, so drawing and simulation can read the updated values.

Use ``push`` and ``pop`` to navigate a stack of inspector pages, and ``clear``
when the inspected objects are no longer relevant. Set up the inspector when
creating or selecting an object rather than rebuilding it on every frame.

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
