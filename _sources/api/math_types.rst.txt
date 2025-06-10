math types
==========

vec2
####

.. lua:class:: vec2

   .. lua:staticmethod:: vec2(x)
                         vec2(x, y)

      Create a new ``vec2`` by setting both values at once or each one individually

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec2`` containing the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec2`` containing the component-wise maximum two vectors

   .. lua:attribute:: x: number

      The x component of this vector

   .. lua:attribute:: y: number

      The y component of this vector

   .. lua:attribute:: length: number

      The length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

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
   
   .. lua:method:: cross(v)

      Perform a cross product with another vec2 and return the result
   
   .. lua:method:: rotate(angleRadians)

      Rotate this vector by a given angle in radians
   
   .. lua:method:: rotate90()

      Rotate this vector by 90 degrees
   
   .. lua:method:: angleBetween(v)

      Calculate the oriented angle between this vector and another, between -pi and pi

vec3
####

.. lua:class:: vec3

   .. lua:staticmethod:: vec3(x)
                         vec3(x, y, z)

      Create a new ``vec3`` by setting all values at once or each one individually

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec3`` containing the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec3`` containing the component-wise maximum two vectors

   .. lua:attribute:: x: number

      The x component of this vector

   .. lua:attribute:: y: number

      The y component of this vector

   .. lua:attribute:: z: number

      The z component of this vector

   .. lua:attribute:: length: number

      The length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

   .. lua:method:: normalize()

      Normalize this vector

   .. lua:method:: normalized()

      Return a normalized copy of this vector

   .. lua:method:: dot(v)

      Perform a scalar dot product with another vector and return the result

   .. lua:method:: cross(v)

      Perform a cross product with another vec3 and return the result

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

   .. lua:method:: unpack() -> x, y, z

      Unpack this vector as multiple number values

vec4
####

.. lua:class:: vec4

   .. lua:staticmethod:: vec4(x)
                         vec4(x, y, z, w)

      Create a new ``vec4`` by setting all values at once or each one individually

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec4`` containing the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec4`` containing the component-wise maximum two vectors

   .. lua:attribute:: x: number

      The x component of this vector

   .. lua:attribute:: y: number

      The y component of this vector

   .. lua:attribute:: z: number

      The z component of this vector

   .. lua:attribute:: w: number

      The w component of this vector

   .. lua:attribute:: length: number

      The length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

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

   .. lua:method:: unpack() -> x, y, z, w

      Unpack this vector as multiple number values

vector swizzling
################

``vec2``, ``vec3`` and ``vec4`` support swizzling, which allows you to access and manipulate their components in a variety of ways

.. code-block:: lua

   v1 = vec4(1, 2, 3, 4)
   v2 = vec3(5, 6, 7)

   -- Reading
   print(v1.wzyx)      -- prints '(4.0, 3.0, 2.0, 1.0)'
   print(v1.zzz)       -- prints '(3.0, 3.0, 3.0)'
   print(v2.xz)        -- prints '(5.0, 7.0)'

   -- Writing
   v1.yx = vec2(5, 6)  -- v1 is now '(6.0, 5.0, 3.0, 4.0)'
   v1.xyz = v2.yzx     -- v1 is now '(6.0, 7.0, 5.0, 4.0)'

   

quat
####

.. lua:class:: quat

   .. lua:staticmethod:: quat()
                         quat(w, x, y, z)

      Create a new ``quat``

   .. lua:staticmethod:: lookRotation(forward, up)

      :return: A ``quat`` that points in the ``forward`` direction using ``up`` to orient it correctly

   .. lua:staticmethod:: fromToRotate(from, to)

      :param from: The direction to rotate from
      :type from: vec3
      :param to: The direction to rotate to
      :type to: vec3
      :return: a ``quat`` containing a relative rotation between the ``from`` and ``to`` vectors

   .. lua:staticmethod:: angleAxis(angle, axis)

      :param angle: The amount of rotation in degrees
      :type angle: number
      :param axis: The axis of rotation
      :type axis: vec3
      :return: a new ``quat`` containing a rotation defined by ``angle`` (in degrees) rotated about the ``axis`` vector

   .. lua:staticmethod:: eulerAngles(x, y, z)

      :param x: The amount of rotation about the x axis (yaw) in degrees
      :type x: number
      :param y: The amount of rotation about the y axis (pitch) in degrees
      :type y: number
      :param z: The amount of rotation about the z axis (roll) in degrees
      :type z: number
      :return: a new ``quat`` containing a rotation defined by 3 euler angles (i.e. yaw, pitch roll) in radians

   .. lua:attribute:: x: number

      The x component of this vector

   .. lua:attribute:: y: number

      The y component of this vector

   .. lua:attribute:: z: number

      The z component of this vector

   .. lua:attribute:: w: number

      The w component of this vector

   .. lua:attribute:: angles: vec3

      A set of euler angles (in degrees) that generates the same rotation as this quaternion

      *Please note that the potential euler angles from any given quaternion are ambiguous and should not be relied upon for smooth or consistent rotations especially when interpolating them*

   .. lua:method:: slerp(q, t)

      :param q: The other quaternion to slerp to
      :param t: The amount of interpolation (from 0 to 1)
      :return: a new ``quat`` that is spherically interpolated from this quaternion to ``q`` via ``t`` (between 0 and 1)

   .. lua:method:: conjugate()

      :return: a new ``quat`` containing the conjugate of this quaternion

   .. lua:method:: normalize()

      Normalizes this quaternion

   .. lua:method:: normalized()

      :return: a normalized copy of this quaternion

mat2
####

.. lua:class:: mat2

   A simple 2x2 matrix

   Each entry can be accessed via an index as well

   .. code-block:: lua

      m = mat2(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat2()
                         mat2(s)
                         mat2(v1, v2)
                         mat2(m11, m12, m21, m22)

      Create a new ``mat2``, default, diagonals, 2 ``vec2`` objects or all 4 entries

   .. lua:method:: inverse()

      :return: the inverse of this matrix

   .. lua:method:: transpose()

      :return: the transpose of this matrix

   .. lua:method:: determinant()

      :return: the determinant of this matrix

   .. lua:method:: row(index)

      :return: the row at a given ``index`` (starting at 1)
      :rtype: vec2

   .. lua:method:: column(index)

      :return: the column at a given ``index`` (starting at 1)
      :rtype: vec2


mat3
####

.. lua:class:: mat3

   A simple 3x3 matrix

   Each entry can be accessed via an index as well

   .. code-block:: lua

      m = mat3(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat3()
                         mat3(s)
                         mat3(v1, v2, v3)
                         mat3(m11, m12, m31, ..., m33)

      Create a new ``mat3``, default, diagonals, 3 ``vec3`` objects or all 9 entries

   .. lua:method:: inverse()

      :return: the inverse of this matrix

   .. lua:method:: transpose()

      :return: the transpose of this matrix

   .. lua:method:: determinant()

      :return: the determinant of this matrix

   .. lua:method:: row(index)

      :return: the row at a given ``index`` (starting at 1)
      :rtype: vec3

   .. lua:method:: column(index)

      :return: the column at a given ``index`` (starting at 1)
      :rtype: vec3


mat4
####

.. lua:class:: mat4

   A simple 4x4 matrix, typically used for 3D homogonous transformations

   Each entry can be accessed via an index as well

   .. code-block:: lua

      m = mat4(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat4()
                         mat4(s)
                         mat4(v1, v2, v3, v4)
                         mat4(m11, m12, m31, m41, ..., m44)

      Create a new ``mat4``, default, diagonals, 4 ``vec4`` objects or all 16 entries

   .. lua:staticmethod:: lookAt(eye, center, up)

   .. lua:staticmethod:: lookAt(matrix, eye, center, up)

   .. lua:staticmethod:: orbit(origin, distance, x, y)

   .. lua:staticmethod:: orbit(matrix, origin, distance, x, y)

   .. lua:staticmethod:: ortho(left, right, top, bottom, [near, far])

   .. lua:staticmethod:: perspective(fovy, aspect, near, far)

   .. lua:staticmethod:: rotate(angle, axis)

   .. lua:staticmethod:: rotate(matrix, angle, axis)

   .. lua:method:: inverse()

      :return: the inverse of this matrix

   .. lua:method:: transpose()

      :return: the transpose of this matrix

   .. lua:method:: determinant()

      :return: the determinant of this matrix

   .. lua:method:: row(index)

      :return: the row at a given ``index`` (starting at 1)
      :rtype: vec3

   .. lua:method:: column(index)

      :return: the column at a given ``index`` (starting at 1)
      :rtype: vec3

aabb
####

.. lua:module:: bounds

.. lua:class:: aabb
