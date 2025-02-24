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
    
   .. lua:staticmethod:: fromHSV(h, s, v)
                         fromHSV(vec3)
    
      Creates a new color object from HSV values

   .. lua:attribute:: r: number

      The red component of the color
   
   .. lua:attribute:: g: number

      The green component of the color

   .. lua:attribute:: b: number

      The blue component of the color

   .. lua:attribute:: a: number

      The alpha component of the color

   .. lua:method:: linear() -> color

      Returns the color converted to linear space
   
   .. lua:method:: gamma() -> color

      Returns the color converted to gamma space

   .. lua:method:: grayscale() -> number

      Returns the color converted to grayscale
   
   .. lua:method:: hsv() -> vec3

      Returns the color converted to HSV values
   
   .. lua:method:: unpack() -> number, number, number, number

      Returns the color as a tuple of 4 numbers
   
   .. lua:staticmethod:: mix(a, b, t) -> color

      Linearly interpolates between two colors, performing `a * (1-t) + b * t`
   
   Predefined colors
   *****************

   .. lua:attribute:: black: const
   .. lua:attribute:: white: const
   .. lua:attribute:: clear: const
   .. lua:attribute:: cyan: const
   .. lua:attribute:: gray: const
   .. lua:attribute:: grey: const
   .. lua:attribute:: red: const
   .. lua:attribute:: green: const
   .. lua:attribute:: blue: const
   .. lua:attribute:: magenta: const
   .. lua:attribute:: yellow: const

   Color operators
   ***************

   * `+` : Adds two colors together component-wise
   * `-` : Subtracts two colors component-wise
   * `*` : Multiplies a color by a scalar, or another color component-wise using their [0-1] range
   * `/` : Divides a color by a scalar
