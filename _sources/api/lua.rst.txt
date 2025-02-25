lua
===

**Global Functions**

.. lua:function:: typeof(o)

   Returns a user-friendly string representation of the type of the object.

   :param o: The object to check
   :type o: any
   :return: The type of the object
   :rtype: string

   .. code-block:: lua

      SomeClass = class("SomeClass")
      c = SomeClass(10)
      print(typeof(SomeClass)) -- prints "class"
      print(typeof(c)) -- prints "SomeClass"
      print(typeof("Hello World!")) -- prints "string"
      print(typeof(5)) -- prints "number"
      print(typeof(vec3(1, 2, 3))) -- prints "vec3"
      print(typeof(mat3(1, 2, 3, 4, 5, 6, 7, 8, 9))) -- prints "mat3"
      print(typeof(quat(1, 2, 3, 4))) -- prints "quat"
      print(typeof(color(255, 0, 0, 255))) -- prints "color"
      print(typeof(image(100, 100))) -- prints "image"
      print(typeof(scene.default3d())) -- prints "scene"
      print(typeof(asset.builtin.Cargo_Bot.Claw_Arm)) -- prints "assetKey"

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
