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

quat
####

.. lua:class:: quat

   .. lua:staticmethod:: quat()
                         quat(x, y, z, w)

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

.. lua:class:: mat2

.. lua:class:: mat3

.. lua:class:: mat4

.. lua:module:: bounds

.. lua:class:: aabb
