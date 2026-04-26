Math
====

2D Vectors
##########

.. lua:class:: vec2

   This type represents a 2D vector. Most mathematical operators such as equality, addition, subtraction, multiplication and division are provided, so you can use ``vec2`` data types similarly to how you use numerical types.

   :param x: Initial x value of the vector
   :type x: number
   :param y: Initial y value of the vector
   :type y: number

   :syntax:
      .. code-block:: lua

         v = vec2(1, 2)
         v = vec2(1) -- set both x and y to 1
         v = vec2() -- set both x and y to 0

   .. lua:attribute:: x: number

      The x component of this vector

      .. helptext:: get or set the x component

   .. lua:attribute:: y: number

      The y component of this vector

      .. helptext:: get or set the y component

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec2`` containing the component-wise minimum of two vectors

      :param v1: The first vector
      :type v1: vec2
      :param v2: The second vector
      :type v2: vec2
      :return: A new ``vec2`` with the minimum of each component
      :rtype: vec2

      .. helptext:: return the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec2`` containing the component-wise maximum of two vectors

      :param v1: The first vector
      :type v1: vec2
      :param v2: The second vector
      :type v2: vec2
      :return: A new ``vec2`` with the maximum of each component
      :rtype: vec2

      .. helptext:: return the component-wise maximum of two vectors

   .. lua:attribute:: length: number

      The length of this vector

      .. helptext:: get the length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

      .. helptext:: get the squared length of this vector

   .. lua:method:: normalize()

      Normalize this vector in-place

      .. helptext:: normalize this vector

   .. lua:method:: normalized() -> vec2

      Return a normalized copy of this vector

      :return: A normalized copy of this vector
      :rtype: vec2

      .. helptext:: return a normalized copy of this vector

   .. lua:method:: dot(v) -> number

      Perform a scalar dot product with another vector and return the result

      :param v: The other vector
      :type v: vec2
      :return: The scalar dot product
      :rtype: number

      .. helptext:: calculate the dot product with another vector

   .. lua:method:: distance(v) -> number

      Calculate the Euclidean distance to another vector

      :param v: The other vector
      :type v: vec2
      :return: The distance between the two vectors
      :rtype: number

      .. helptext:: calculate the distance to another vector

   .. lua:method:: distance2(v) -> number

      Calculate the squared Euclidean distance to another vector

      :param v: The other vector
      :type v: vec2
      :return: The squared distance between the two vectors
      :rtype: number

      .. helptext:: calculate the squared distance to another vector

   .. lua:method:: reflect(normal) -> vec2

      Reflect this vector about a normal

      :param normal: The normal vector to reflect about
      :type normal: vec2
      :return: The reflected vector
      :rtype: vec2

      .. helptext:: reflect this vector about a normal

   .. lua:method:: refract(normal, ior) -> vec2

      Refract this vector through a surface with a given index of refraction

      :param normal: The surface normal
      :type normal: vec2
      :param ior: The index of refraction
      :type ior: number
      :return: The refracted vector
      :rtype: vec2

      .. helptext:: refract this vector through a normal

   .. lua:method:: lerp(v, t) -> vec2

      Interpolate this vector with another by a given factor

      :param v: The target vector
      :type v: vec2
      :param t: The interpolation factor (typically between 0 and 1)
      :type t: number
      :return: The interpolated vector
      :rtype: vec2

      .. helptext:: linearly interpolate this vector with another

   .. lua:method:: abs() -> vec2

      Return a copy of this vector with component-wise absolute values

      :return: A copy with all components made positive
      :rtype: vec2

      .. helptext:: return a copy with component-wise absolute values

   .. lua:method:: unpack() -> number, number

      Unpack this vector as individual number values

      :return: The x and y components as separate values

      .. helptext:: unpack this vector as multiple numbers

   .. lua:method:: cross(v) -> number

      Compute the 2D cross product (perp dot product) with another vector

      :param v: The other vector
      :type v: vec2
      :return: The scalar cross product result
      :rtype: number

      .. helptext:: calculate the cross product with another vector

   .. lua:method:: rotate(angleRadians) -> vec2

      Rotate this vector by a given angle in radians

      :param angleRadians: The angle of rotation in radians
      :type angleRadians: number
      :return: The rotated vector
      :rtype: vec2

      .. helptext:: rotate this vector by an angle in radians

   .. lua:method:: rotate90() -> vec2

      Rotate this vector by 90 degrees

      :return: The rotated vector
      :rtype: vec2

      .. helptext:: rotate this vector by 90 degrees

   .. lua:method:: angleBetween(v) -> number

      Calculate the oriented angle between this vector and another, between -pi and pi

      :param v: The other vector
      :type v: vec2
      :return: The oriented angle in radians between -pi and pi
      :rtype: number

      .. helptext:: calculate the oriented angle between this vector and another

3D Vectors
##########

.. lua:class:: vec3

   .. lua:staticmethod:: vec3(x)
                         vec3(x, y, z)

      Create a new ``vec3`` by setting all components to the same value, or each one individually

      :param x: The x component (also used for y and z when called with a single argument)
      :type x: number
      :param y: The y component
      :type y: number
      :param z: The z component
      :type z: number

      .. helptext:: create a new vec3

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec3`` containing the component-wise minimum of two vectors

      :param v1: The first vector
      :type v1: vec3
      :param v2: The second vector
      :type v2: vec3
      :return: A new ``vec3`` with the minimum of each component
      :rtype: vec3

      .. helptext:: return the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec3`` containing the component-wise maximum of two vectors

      :param v1: The first vector
      :type v1: vec3
      :param v2: The second vector
      :type v2: vec3
      :return: A new ``vec3`` with the maximum of each component
      :rtype: vec3

      .. helptext:: return the component-wise maximum of two vectors

   .. lua:attribute:: x: number

      The x component of this vector

      .. helptext:: get or set the x component

   .. lua:attribute:: y: number

      The y component of this vector

      .. helptext:: get or set the y component

   .. lua:attribute:: z: number

      The z component of this vector

      .. helptext:: get or set the z component

   .. lua:attribute:: length: number

      The length of this vector

      .. helptext:: get the length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

      .. helptext:: get the squared length of this vector

   .. lua:method:: normalize()

      Normalize this vector in-place

      .. helptext:: normalize this vector

   .. lua:method:: normalized() -> vec3

      Return a normalized copy of this vector

      :return: A normalized copy of this vector
      :rtype: vec3

      .. helptext:: return a normalized copy of this vector

   .. lua:method:: dot(v) -> number

      Perform a scalar dot product with another vector and return the result

      :param v: The other vector
      :type v: vec3
      :return: The scalar dot product
      :rtype: number

      .. helptext:: calculate the dot product with another vector

   .. lua:method:: cross(v) -> vec3

      Perform a cross product with another ``vec3`` and return the result

      :param v: The other vector
      :type v: vec3
      :return: A vector perpendicular to both input vectors
      :rtype: vec3

      .. helptext:: calculate the cross product with another vector

   .. lua:method:: distance(v) -> number

      Calculate the Euclidean distance to another vector

      :param v: The other vector
      :type v: vec3
      :return: The distance between the two vectors
      :rtype: number

      .. helptext:: calculate the distance to another vector

   .. lua:method:: distance2(v) -> number

      Calculate the squared Euclidean distance to another vector

      :param v: The other vector
      :type v: vec3
      :return: The squared distance between the two vectors
      :rtype: number

      .. helptext:: calculate the squared distance to another vector

   .. lua:method:: reflect(normal) -> vec3

      Reflect this vector about a normal

      :param normal: The normal vector to reflect about
      :type normal: vec3
      :return: The reflected vector
      :rtype: vec3

      .. helptext:: reflect this vector about a normal

   .. lua:method:: refract(normal, ior) -> vec3

      Refract this vector through a surface with a given index of refraction

      :param normal: The surface normal
      :type normal: vec3
      :param ior: The index of refraction
      :type ior: number
      :return: The refracted vector
      :rtype: vec3

      .. helptext:: refract this vector through a normal

   .. lua:method:: lerp(v, t) -> vec3

      Interpolate this vector with another by a given factor

      :param v: The target vector
      :type v: vec3
      :param t: The interpolation factor (typically between 0 and 1)
      :type t: number
      :return: The interpolated vector
      :rtype: vec3

      .. helptext:: linearly interpolate this vector with another

   .. lua:method:: abs() -> vec3

      Return a copy of this vector with component-wise absolute values

      :return: A copy with all components made positive
      :rtype: vec3

      .. helptext:: return a copy with component-wise absolute values

   .. lua:method:: unpack() -> number, number, number

      Unpack this vector as individual number values

      :return: The x, y and z components as separate values

      .. helptext:: unpack this vector as multiple numbers

4D Vectors
##########

.. lua:class:: vec4

   .. lua:staticmethod:: vec4(x)
                         vec4(x, y, z, w)

      Create a new ``vec4`` by setting all components to the same value, or each one individually

      :param x: The x component (also used for y, z and w when called with a single argument)
      :type x: number
      :param y: The y component
      :type y: number
      :param z: The z component
      :type z: number
      :param w: The w component
      :type w: number

      .. helptext:: create a new vec4

   .. lua:staticmethod:: min(v1, v2)

      Return a ``vec4`` containing the component-wise minimum of two vectors

      :param v1: The first vector
      :type v1: vec4
      :param v2: The second vector
      :type v2: vec4
      :return: A new ``vec4`` with the minimum of each component
      :rtype: vec4

      .. helptext:: return the component-wise minimum of two vectors

   .. lua:staticmethod:: max(v1, v2)

      Return a ``vec4`` containing the component-wise maximum of two vectors

      :param v1: The first vector
      :type v1: vec4
      :param v2: The second vector
      :type v2: vec4
      :return: A new ``vec4`` with the maximum of each component
      :rtype: vec4

      .. helptext:: return the component-wise maximum of two vectors

   .. lua:attribute:: x: number

      The x component of this vector

      .. helptext:: get or set the x component

   .. lua:attribute:: y: number

      The y component of this vector

      .. helptext:: get or set the y component

   .. lua:attribute:: z: number

      The z component of this vector

      .. helptext:: get or set the z component

   .. lua:attribute:: w: number

      The w component of this vector

      .. helptext:: get or set the w component

   .. lua:attribute:: length: number

      The length of this vector

      .. helptext:: get the length of this vector

   .. lua:attribute:: length2: number

      The squared length of this vector

      .. helptext:: get the squared length of this vector

   .. lua:method:: normalize()

      Normalize this vector in-place

      .. helptext:: normalize this vector

   .. lua:method:: normalized() -> vec4

      Return a normalized copy of this vector

      :return: A normalized copy of this vector
      :rtype: vec4

      .. helptext:: return a normalized copy of this vector

   .. lua:method:: dot(v) -> number

      Perform a scalar dot product with another vector and return the result

      :param v: The other vector
      :type v: vec4
      :return: The scalar dot product
      :rtype: number

      .. helptext:: calculate the dot product with another vector

   .. lua:method:: distance(v) -> number

      Calculate the Euclidean distance to another vector

      :param v: The other vector
      :type v: vec4
      :return: The distance between the two vectors
      :rtype: number

      .. helptext:: calculate the distance to another vector

   .. lua:method:: distance2(v) -> number

      Calculate the squared Euclidean distance to another vector

      :param v: The other vector
      :type v: vec4
      :return: The squared distance between the two vectors
      :rtype: number

      .. helptext:: calculate the squared distance to another vector

   .. lua:method:: reflect(normal) -> vec4

      Reflect this vector about a normal

      :param normal: The normal vector to reflect about
      :type normal: vec4
      :return: The reflected vector
      :rtype: vec4

      .. helptext:: reflect this vector about a normal

   .. lua:method:: refract(normal, ior) -> vec4

      Refract this vector through a surface with a given index of refraction

      :param normal: The surface normal
      :type normal: vec4
      :param ior: The index of refraction
      :type ior: number
      :return: The refracted vector
      :rtype: vec4

      .. helptext:: refract this vector through a normal

   .. lua:method:: lerp(v, t) -> vec4

      Interpolate this vector with another by a given factor

      :param v: The target vector
      :type v: vec4
      :param t: The interpolation factor (typically between 0 and 1)
      :type t: number
      :return: The interpolated vector
      :rtype: vec4

      .. helptext:: linearly interpolate this vector with another

   .. lua:method:: abs() -> vec4

      Return a copy of this vector with component-wise absolute values

      :return: A copy with all components made positive
      :rtype: vec4

      .. helptext:: return a copy with component-wise absolute values

   .. lua:method:: unpack() -> number, number, number, number

      Unpack this vector as individual number values

      :return: The x, y, z and w components as separate values

      .. helptext:: unpack this vector as multiple numbers

Vector Swizzling
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


Quaternions
###########

.. lua:class:: quat

   .. lua:staticmethod:: quat()
                         quat(w, x, y, z)

      Create a new ``quat``

      :param w: The scalar (real) component
      :type w: number
      :param x: The x imaginary component
      :type x: number
      :param y: The y imaginary component
      :type y: number
      :param z: The z imaginary component
      :type z: number

      .. helptext:: create a new quaternion

   .. lua:staticmethod:: lookRotation(forward, up)

      Create a rotation that points in the ``forward`` direction, oriented using ``up``

      :param forward: The forward direction
      :type forward: vec3
      :param up: The up direction used for orientation
      :type up: vec3
      :return: A ``quat`` that points in the ``forward`` direction
      :rtype: quat

      .. helptext:: create a rotation looking in a forward direction

   .. lua:staticmethod:: fromToRotation(from, to)

      Create a rotation that rotates from one direction to another

      :param from: The direction to rotate from
      :type from: vec3
      :param to: The direction to rotate to
      :type to: vec3
      :return: A ``quat`` containing the relative rotation from ``from`` to ``to``
      :rtype: quat

      .. helptext:: create a rotation from one direction to another

   .. lua:staticmethod:: angleAxis(angle, axis)

      Create a rotation of ``angle`` degrees around an ``axis``

      :param angle: The amount of rotation in degrees
      :type angle: number
      :param axis: The axis of rotation
      :type axis: vec3
      :return: A new ``quat`` representing the rotation
      :rtype: quat

      .. helptext:: create a rotation from an angle and axis

   .. lua:staticmethod:: eulerAngles(x, y, z)

      Create a rotation from euler angles (yaw, pitch, roll) in degrees

      :param x: The amount of rotation about the x axis (pitch) in degrees
      :type x: number
      :param y: The amount of rotation about the y axis (yaw) in degrees
      :type y: number
      :param z: The amount of rotation about the z axis (roll) in degrees
      :type z: number
      :return: A new ``quat`` representing the combined rotation
      :rtype: quat

      .. helptext:: create a rotation from euler angles

   .. lua:attribute:: x: number

      The x imaginary component

      .. helptext:: get or set the x component

   .. lua:attribute:: y: number

      The y imaginary component

      .. helptext:: get or set the y component

   .. lua:attribute:: z: number

      The z imaginary component

      .. helptext:: get or set the z component

   .. lua:attribute:: w: number

      The scalar (real) component

      .. helptext:: get or set the w component

   .. lua:attribute:: angles: vec3

      A set of euler angles (in degrees) that produces the same rotation as this quaternion

      *Note: euler angles derived from a quaternion are ambiguous and should not be relied upon for smooth interpolation*

      .. helptext:: get the euler angles of this quaternion

   .. lua:method:: slerp(q, t) -> quat

      Spherically interpolate between this quaternion and another

      :param q: The target quaternion
      :type q: quat
      :param t: The interpolation amount (between 0 and 1)
      :type t: number
      :return: A new ``quat`` spherically interpolated from this to ``q`` by ``t``
      :rtype: quat

      .. helptext:: spherically interpolate this quaternion with another

   .. lua:method:: conjugate() -> quat

      Return the conjugate of this quaternion

      :return: A new ``quat`` containing the conjugate (inverse rotation)
      :rtype: quat

      .. helptext:: return the conjugate of this quaternion

   .. lua:method:: normalize()

      Normalize this quaternion in-place

      .. helptext:: normalize this quaternion

   .. lua:method:: normalized() -> quat

      Return a normalized copy of this quaternion

      :return: A normalized copy of this quaternion
      :rtype: quat

      .. helptext:: return a normalized copy of this quaternion

2x2 Matrix
##########

.. lua:class:: mat2

   A simple 2x2 matrix. Individual entries can be accessed via a 1-based index

   .. code-block:: lua

      m = mat2(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat2()
                         mat2(s)
                         mat2(v1, v2)
                         mat2(m11, m12, m21, m22)

      Create a new ``mat2``: default (identity), diagonal scalar, two ``vec2`` columns, or all 4 entries

      :param s: Diagonal scalar value
      :type s: number
      :param v1: First column vector
      :type v1: vec2
      :param v2: Second column vector
      :type v2: vec2

      .. helptext:: create a new 2x2 matrix

   .. lua:method:: inverse() -> mat2

      Return the inverse of this matrix

      :return: The inverse of this matrix
      :rtype: mat2

      .. helptext:: return the inverse of this matrix

   .. lua:method:: transpose() -> mat2

      Return the transpose of this matrix

      :return: The transpose of this matrix
      :rtype: mat2

      .. helptext:: return the transpose of this matrix

   .. lua:method:: determinant() -> number

      Return the determinant of this matrix

      :return: The determinant
      :rtype: number

      .. helptext:: return the determinant of this matrix

   .. lua:method:: row(index) -> vec2

      Return the row at a given index

      :param index: The 1-based row index
      :type index: number
      :return: The row at the given index
      :rtype: vec2

      .. helptext:: return the row at the given index

   .. lua:method:: column(index) -> vec2

      Return the column at a given index

      :param index: The 1-based column index
      :type index: number
      :return: The column at the given index
      :rtype: vec2

      .. helptext:: return the column at the given index


3x3 Matrix
##########

.. lua:class:: mat3

   A simple 3x3 matrix. Individual entries can be accessed via a 1-based index

   .. code-block:: lua

      m = mat3(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat3()
                         mat3(s)
                         mat3(v1, v2, v3)
                         mat3(m11, m12, m31, ..., m33)

      Create a new ``mat3``: default (identity), diagonal scalar, three ``vec3`` columns, or all 9 entries

      :param s: Diagonal scalar value
      :type s: number
      :param v1: First column vector
      :type v1: vec3
      :param v2: Second column vector
      :type v2: vec3
      :param v3: Third column vector
      :type v3: vec3

      .. helptext:: create a new 3x3 matrix

   .. lua:method:: inverse() -> mat3

      Return the inverse of this matrix

      :return: The inverse of this matrix
      :rtype: mat3

      .. helptext:: return the inverse of this matrix

   .. lua:method:: transpose() -> mat3

      Return the transpose of this matrix

      :return: The transpose of this matrix
      :rtype: mat3

      .. helptext:: return the transpose of this matrix

   .. lua:method:: determinant() -> number

      Return the determinant of this matrix

      :return: The determinant
      :rtype: number

      .. helptext:: return the determinant of this matrix

   .. lua:method:: row(index) -> vec3

      Return the row at a given index

      :param index: The 1-based row index
      :type index: number
      :return: The row at the given index
      :rtype: vec3

      .. helptext:: return the row at the given index

   .. lua:method:: column(index) -> vec3

      Return the column at a given index

      :param index: The 1-based column index
      :type index: number
      :return: The column at the given index
      :rtype: vec3

      .. helptext:: return the column at the given index


4x4 Matrix
##########

.. lua:class:: mat4

   A 4x4 matrix typically used for 3D homogeneous transformations. Individual entries can be accessed via a 1-based index

   .. code-block:: lua

      m = mat4(1) -- init with diagonals set to 1
      print(m[1]) -- prints '1.0'

   .. lua:staticmethod:: mat4()
                         mat4(s)
                         mat4(v1, v2, v3, v4)
                         mat4(m11, m12, m31, m41, ..., m44)

      Create a new ``mat4``: default (identity), diagonal scalar, four ``vec4`` columns, or all 16 entries

      :param s: Diagonal scalar value
      :type s: number
      :param v1: First column vector
      :type v1: vec4
      :param v2: Second column vector
      :type v2: vec4
      :param v3: Third column vector
      :type v3: vec4
      :param v4: Fourth column vector
      :type v4: vec4

      .. helptext:: create a new 4x4 matrix

   .. lua:staticmethod:: lookAt(eye, center, up)

      Create a look-at view matrix

      :param eye: The position of the camera
      :type eye: vec3
      :param center: The point to look at
      :type center: vec3
      :param up: The up direction
      :type up: vec3
      :return: A view matrix looking from ``eye`` toward ``center``
      :rtype: mat4

      .. helptext:: create a look-at view matrix

   .. lua:staticmethod:: lookAt(matrix, eye, center, up)

      Apply a look-at transform to an existing matrix

      :param matrix: The matrix to apply the transform to
      :type matrix: mat4
      :param eye: The position of the camera
      :type eye: vec3
      :param center: The point to look at
      :type center: vec3
      :param up: The up direction
      :type up: vec3
      :return: The transformed matrix
      :rtype: mat4

      .. helptext:: apply a look-at transform to a matrix

   .. lua:staticmethod:: orbit(origin, distance, x, y)

      Create an orbit view matrix centered on a point

      :param origin: The point to orbit around
      :type origin: vec3
      :param distance: The distance from the origin
      :type distance: number
      :param x: The horizontal orbit angle in degrees
      :type x: number
      :param y: The vertical orbit angle in degrees
      :type y: number
      :return: An orbit view matrix
      :rtype: mat4

      .. helptext:: create an orbit view matrix

   .. lua:staticmethod:: orbit(matrix, origin, distance, x, y)

      Apply an orbit transform to an existing matrix

      :param matrix: The matrix to apply the transform to
      :type matrix: mat4
      :param origin: The point to orbit around
      :type origin: vec3
      :param distance: The distance from the origin
      :type distance: number
      :param x: The horizontal orbit angle in degrees
      :type x: number
      :param y: The vertical orbit angle in degrees
      :type y: number
      :return: The transformed matrix
      :rtype: mat4

      .. helptext:: apply an orbit transform to a matrix

   .. lua:staticmethod:: ortho(left, right, top, bottom, [near, far])

      Create an orthographic projection matrix

      :param left: The left clipping plane
      :type left: number
      :param right: The right clipping plane
      :type right: number
      :param top: The top clipping plane
      :type top: number
      :param bottom: The bottom clipping plane
      :type bottom: number
      :param near: The near clipping plane (optional)
      :type near: number
      :param far: The far clipping plane (optional)
      :type far: number
      :return: An orthographic projection matrix
      :rtype: mat4

      .. helptext:: setup an orthographic view

   .. lua:staticmethod:: perspective(fovy, aspect, near, far)

      Create a perspective projection matrix

      :param fovy: The vertical field of view in degrees
      :type fovy: number
      :param aspect: The aspect ratio (width / height)
      :type aspect: number
      :param near: The near clipping plane distance
      :type near: number
      :param far: The far clipping plane distance
      :type far: number
      :return: A perspective projection matrix
      :rtype: mat4

      .. helptext:: setup a perspective view

   .. lua:staticmethod:: rotate(angle, axis)

      Create a rotation matrix

      :param angle: The rotation angle in degrees
      :type angle: number
      :param axis: The axis of rotation
      :type axis: vec3
      :return: A rotation matrix
      :rtype: mat4

      .. helptext:: rotate the current transform

   .. lua:staticmethod:: rotate(matrix, angle, axis)

      Apply a rotation transform to an existing matrix

      :param matrix: The matrix to rotate
      :type matrix: mat4
      :param angle: The rotation angle in degrees
      :type angle: number
      :param axis: The axis of rotation
      :type axis: vec3
      :return: The rotated matrix
      :rtype: mat4

      .. helptext:: rotate a matrix by an angle and axis

   .. lua:method:: inverse() -> mat4

      Return the inverse of this matrix

      :return: The inverse of this matrix
      :rtype: mat4

      .. helptext:: return the inverse of this matrix

   .. lua:method:: transpose() -> mat4

      Return the transpose of this matrix

      :return: The transpose of this matrix
      :rtype: mat4

      .. helptext:: return the transpose of this matrix

   .. lua:method:: determinant() -> number

      Return the determinant of this matrix

      :return: The determinant
      :rtype: number

      .. helptext:: return the determinant of this matrix

   .. lua:method:: row(index) -> vec4

      Return the row at a given index

      :param index: The 1-based row index
      :type index: number
      :return: The row at the given index
      :rtype: vec4

      .. helptext:: return the row at the given index

   .. lua:method:: column(index) -> vec4

      Return the column at a given index

      :param index: The 1-based column index
      :type index: number
      :return: The column at the given index
      :rtype: vec4

      .. helptext:: return the column at the given index

Axis-Aligned Bounding Box (AABB)
################################

.. lua:module:: bounds

.. lua:class:: aabb

   An axis-aligned bounding box defined by minimum and maximum corner points

   :param min: The minimum corner of the bounding box
   :type min: vec3
   :param max: The maximum corner of the bounding box
   :type max: vec3

   :syntax:
      .. code-block:: lua

         b = bounds.aabb(vec3(-1, -1, -1), vec3(1, 1, 1))

   .. lua:attribute:: min: vec3

      The minimum corner of this bounding box

      .. helptext:: get or set the minimum corner

   .. lua:attribute:: max: vec3

      The maximum corner of this bounding box

      .. helptext:: get or set the maximum corner

   .. lua:attribute:: size: vec3

      The size (width, height, depth) of this bounding box

      .. helptext:: get the size of this bounding box

   .. lua:attribute:: center: vec3

      The center point of this bounding box

      .. helptext:: get the center of this bounding box

   .. lua:method:: set(min, max)

      Set the minimum and maximum corners of this bounding box

      :param min: The new minimum corner
      :type min: vec3
      :param max: The new maximum corner
      :type max: vec3

      .. helptext:: set the min and max corners of this bounding box

   .. lua:method:: translate(offset)

      Translate this bounding box by an offset

      :param offset: The translation offset
      :type offset: vec3

      .. helptext:: translate this bounding box by an offset
