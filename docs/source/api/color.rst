color
=====

*(class)*

.. lua:class:: color

   A color used by different parts of the graphics system

   .. lua:staticmethod:: color()
                         color(gray)
                         color(gray, alpha)
                         color(red, green, blue)
                         color(red, green, blue, alpha)

      Creates a new color object from the given values between 0 and 255

      .. helptext:: create a new color type
    
   .. lua:staticmethod:: fromHSV(h, s, v)
                         fromHSV(vec3)
    
      Creates a new color object from HSV values

      .. helptext:: create a color from HSV values

   .. lua:attribute:: r: number

      The red component of the color

      .. helptext:: get or set the red component
   
   .. lua:attribute:: g: number

      The green component of the color

      .. helptext:: get or set the green component

   .. lua:attribute:: b: number

      The blue component of the color

      .. helptext:: get or set the blue component

   .. lua:attribute:: a: number

      The alpha component of the color

      .. helptext:: get or set the alpha component

   .. lua:method:: linear() -> color

      Returns the color converted to linear space

      .. helptext:: convert this color to linear space
   
   .. lua:method:: gamma() -> color

      Returns the color converted to gamma space

      .. helptext:: convert this color to gamma space

   .. lua:method:: grayscale() -> number

      Returns the color converted to grayscale

      .. helptext:: convert this color to grayscale
   
   .. lua:method:: hsv() -> vec3

      Returns the color converted to HSV values

      .. helptext:: convert this color to HSV values
   
   .. lua:method:: unpack() -> number, number, number, number

      Returns the color as a tuple of 4 numbers

      .. helptext:: unpack this color as four numbers
   
   .. lua:staticmethod:: mix(a, b, t) -> color

      Linearly interpolates between two colors, performing `a * (1-t) + b * t`

      .. helptext:: linearly interpolate between two colors
   
   Predefined colors
   *****************

   .. lua:attribute:: black: const

      .. helptext:: predefined black color constant
   .. lua:attribute:: white: const

      .. helptext:: predefined white color constant
   .. lua:attribute:: clear: const

      .. helptext:: predefined clear (transparent) color constant
   .. lua:attribute:: cyan: const

      .. helptext:: predefined cyan color constant
   .. lua:attribute:: gray: const

      .. helptext:: predefined gray color constant
   .. lua:attribute:: grey: const

      .. helptext:: predefined grey color constant
   .. lua:attribute:: red: const

      .. helptext:: predefined red color constant
   .. lua:attribute:: green: const

      .. helptext:: predefined green color constant
   .. lua:attribute:: blue: const

      .. helptext:: predefined blue color constant
   .. lua:attribute:: magenta: const

      .. helptext:: predefined magenta color constant
   .. lua:attribute:: yellow: const

      .. helptext:: predefined yellow color constant

   Color operators
   ***************

   * `+` : Adds two colors together component-wise
   * `-` : Subtracts two colors component-wise
   * `*` : Multiplies a color by a scalar, or another color component-wise using their [0-1] range
   * `/` : Divides a color by a scalar
