math types
==========

.. lua:class:: vec2

   .. lua:staticmethod:: vec2(x)
                         vec2(x, y)

      Create a new ``vec2`` by setting both values at once or each one individually

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec2`` containing the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec2`` containing the component-wise maximum two vectors

   .. lua:method:: normalize()

      Normalize this vector

   .. lua:method:: normalized()

      Return a normalized copy of this vector

   .. lua:method:: dot(v)

      Perform a scalar dot product with another vector and return the result

   .. lua:method:: distance(v)

      Calculate the distance (i.e. L1 norm) to another vector

   .. lua:method:: distance2(v)

      Calculate the squared distance (i.e. L2 norm) to another vector

   .. lua:method:: reflect(normal)

      Reflect this vector about another

   .. lua:method:: refract(normal, ior)

      Refract this vector though another with a given index or refraction

   .. lua:method:: lerp(v, t)

      Interpolate this vector with another by the a given factor (typically between 0 and 1)

   .. lua:method:: abs()

      Return a copy of this vector with component-wise absolute values

   .. lua:method:: unpack() -> x, y

      Unpack this vector as multiple number values

   .. lua:attribute:: length: number

      The length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

.. lua:class:: vec3

.. lua:class:: vec4

.. lua:class:: mat2

.. lua:class:: mat3

.. lua:class:: mat4

.. lua:class:: quat

.. lua:module:: bounds

.. lua:class:: aabb
