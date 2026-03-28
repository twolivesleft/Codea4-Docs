inspector
=========

*(module)*

Module for viewing and manipulating objects in the sidebar inspector, an advanced alternative to parameters

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
