lua
===

**Table Extensions**

.. lua:class:: table

   The following are extensions to the Lua table class.

   .. lua:function:: flatten(t)

      Flattens a table into a single array.

      :param t: The table to flatten
      :type t: table
      :return: A flattened array
      :rtype: table

      .. code-block:: lua

         t = {1, 2, {3, 4, {5, 6}}}
         print(table.flatten(t)) -- {1, 2, 3, 4, 5, 6}        