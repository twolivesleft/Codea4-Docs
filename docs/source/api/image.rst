Images Overview
===============

Made of pixels and used by codea for drawing to the screen and texturing meshes

.. code-block:: lua
   :caption: Loading and drawing an image

   function setup()
      -- load an image from a builtin image asset
      img = image.read(asset.builtin.Cargo_Bot.Codea_Icon)
   end

   function draw()
      background(64)
      sprite(img, WIDTH/2, HEIGHT/2)
   end

Image
=====

.. lua:class:: image

   .. lua:staticmethod:: image(width, height, [hasMips = false, numLayers = 1, format = image.rgba, depthFormat = none])

      Create a blank 2D image (default format is `rgba`)

      The size is in points, like ``WIDTH`` and ``HEIGHT``, so the image has
      as many pixels per point as the screen: ``image(100, 100)`` is 300 by 300
      pixels on a 3x display, and draws sharply at 100 by 100. Use
      :lua:func:`image.pixel` for an image with an exact number of pixels.

      .. helptext:: create a new blank image

      :param width: The width of the image in points
      :type width: integer
      :param height: The height of the image in points
      :type height: integer
      :param hasMips: Enables mipmapping for this image
      :type hasMips: boolean
      :param numLayers: The number of layers for this image
      :type numLayers: integer
      :param format: The image format
      :type format: image format
      :param depthFormat: The image depth format
      :type depthFormat: depth format

   .. lua:staticmethod:: image.pixel(width, height, [hasMips = false, numLayers = 1, format = image.rgba, depthFormat = none])

      Create a blank 2D image of exactly ``width`` by ``height`` pixels,
      whatever the display scale. Takes the same parameters as
      :lua:func:`image`. Use it for pixel art, emulator screens and other
      images where each pixel matters.

      .. helptext:: create a new blank image in pixels

      :param width: The width of the image in pixels
      :type width: integer
      :param height: The height of the image in pixels
      :type height: integer
      :param hasMips: Enables mipmapping for this image
      :type hasMips: boolean
      :param numLayers: The number of layers for this image
      :type numLayers: integer
      :param format: The image format
      :type format: image format
      :param depthFormat: The image depth format
      :type depthFormat: depth format
      :rtype: image

      .. code-block:: lua
         :caption: A pixel-exact screen

         function setup()
             -- 160 by 144 pixels on every device
             screen = image.pixel(160, 144)
             screen.filter = image.filter.point
         end

         function draw()
             background(0)
             sprite(screen, WIDTH/2, HEIGHT/2, 160 * 2, 144 * 2)
         end

   .. lua:staticmethod:: image.cube(size)

      Create a blank cube image (6 faces with equal sized dimensions)

      :param size: The size of the image cube
      :type size: integer

      .. helptext:: create a blank cube image

   .. lua:staticmethod:: image.cube(equirect)

      Creates a cube image from a single equirect image (i.e. hdr)

      :param equirect: The source equirect image
      :type equirect: image

      .. helptext:: create a cube image from an equirect image

   .. lua:staticmethod:: image.cube(imageNX, imagePX, imageNY, imagePY, imageNZ, imagePZ)

      Creates a cube image from six source images, one for each cube face

      .. helptext:: create a cube image from six face images

   .. lua:staticmethod:: image.volume(width, height, depth, format)

      Creates a blank volume image with the given dimensions

      :param width: The width of the volume image
      :type width: integer
      :param height: The height of the volume image
      :type height: integer
      :param depth: The depth of the volume image
      :type depth: integer
      :param format: The format of the volume image
      :type format: image format

      .. helptext:: create a blank volume image

   .. lua:staticmethod:: image.read(key)

      Read an image asset from the filesystem

      :param key: The asset key to load
      :rtype: image

      .. helptext:: read an image asset from the filesystem

   .. lua:staticmethod:: image.save(key, image)

      Save an image asset to the filesystem

      :param key: The asset key to save the image to
      :type key: assetKey
      :param image: The image to save
      :type image: image

      .. helptext:: save an image asset to the filesystem

   .. lua:staticmethod:: image.dfg()

      Creates a copy of the 64 by 64 lookup image (``rgba16f``) that Codea's
      physically based lighting uses for image based lighting, for use in your
      own shaders

      :rtype: image

      .. helptext:: create the lighting lookup image

   .. lua:staticmethod:: image.symbol(name, ...)

      Create an image from an SF Symbol. Returns ``nil`` if no symbol of that
      name exists.

      A monochrome symbol is rendered **white**, so it can be recoloured at draw
      time with :lua:func:`tint`. Pass a colour to bake one in instead. Symbols
      drawn with ``image.symbol.multicolor``, ``image.symbol.hierarchical`` or
      ``image.symbol.palette`` carry their own colours — draw those with
      ``tint(255)``, since ``tint`` multiplies.

      Options may be given in any order after the name. A flag is passed as-is
      (``image.symbol.multicolor``, ``image.symbol.weight.bold``); an option that
      carries values is called with them (``image.symbol.variable(0.5)``). A bare
      number is the point size, and a colour tints a monochrome symbol.

      :param name: The SF Symbol name, e.g. ``"globe"`` or ``"cloud.sun.fill"``
      :type name: string
      :rtype: image or nil

      .. helptext:: create an image from an SF Symbol
      .. editor:: symbol

      .. code-block:: lua
         :caption: Using SF Symbols

         function setup()
             -- white by default, so tint() works
             globe = image.symbol("globe")

             -- or bake a colour in
             warning = image.symbol("exclamationmark.triangle.fill", color(255, 200, 0))

             -- the symbol's own colours
             weather = image.symbol("cloud.sun.fill", image.symbol.multicolor)

             -- a fill level from 0 to 1
             signal = image.symbol("wifi", image.symbol.variable(0.66))

             -- larger and heavier
             gauge = image.symbol("gauge", image.symbol.weight.bold, 64)
         end

         function draw()
             background(40)

             tint(255, 0, 0)
             sprite(globe, WIDTH/2, HEIGHT/2)

             tint(255)               -- do not tint a multicolour symbol
             sprite(weather, WIDTH/2, HEIGHT/2 - 100)
         end

      .. note::

         Symbol names are provided by the operating system, and Apple adds new
         symbols with each release. Browse the available names — and the version
         each was introduced in — with Apple's SF Symbols app.

   .. lua:attribute:: symbol: table

      A table containing the rendering modes for :lua:func:`image.symbol`, and the
      ``weight`` and ``scale`` sub-tables below. Options may be passed in any order
      after the symbol name.

      Flags, passed as-is:

      - ``monochrome`` - A single colour (the default), rendered white so it can be recoloured with :lua:func:`tint`
      - ``multicolor`` - The symbol's own intrinsic colours

      Options that carry values, called with them:

      - ``hierarchical(color)`` - One colour applied at several opacities, preserving the symbol's depth
      - ``palette(color, ...)`` - Two or three explicit colours, applied in order
      - ``variable(value)`` - A fill level from 0 to 1, for symbols that support variable rendering such as ``wifi``, ``speaker.wave.3.fill`` and ``battery.100``. Symbols without it ignore the value.

      .. helptext:: symbol rendering modes

   .. lua:attribute:: symbol.weight: table

      A table containing the stroke weights for :lua:func:`image.symbol`:

      - ``ultralight``
      - ``thin``
      - ``light``
      - ``regular``
      - ``medium``
      - ``semibold``
      - ``bold``
      - ``heavy``
      - ``black``

      .. helptext:: symbol stroke weights

   .. lua:attribute:: symbol.scale: table

      A table containing the symbol scales for :lua:func:`image.symbol`:

      - ``small``
      - ``medium``
      - ``large``

      .. helptext:: symbol scales

   .. lua:attribute:: width: integer

      The width of the image in points. For an image made with
      :lua:func:`image.pixel`, points and pixels are the same

      .. helptext:: get the width of this image in points

   .. lua:attribute:: height: integer

      The height of the image in points. For an image made with
      :lua:func:`image.pixel`, points and pixels are the same

      .. helptext:: get the height of this image in points

   .. lua:attribute:: depth: integer

      The depth of the image in pixels (for volume images)

      .. helptext:: get the depth of this image in pixels

   .. lua:attribute:: numLayers: integer

      The number of layers in this image

      .. helptext:: get the number of layers in this image

   .. lua:attribute:: hasMips: boolean

      Whether this image has mip mapping or not

      .. helptext:: get whether this image has mip mapping

   .. lua:attribute:: type: imageType

      The type of this image:

      - ``image.type.texture`` - a 2D image
      - ``image.type.cube`` - a cube image, created with :lua:func:`image.cube`
      - ``image.type.volume`` - a volume image, created with :lua:func:`image.volume`

      .. helptext:: get the type of this image

   .. lua:attribute:: numMips: integer

      The number of mips this image has

      .. helptext:: get the number of mips in this image

   .. lua:attribute:: sampler: samplerState

      The sampler state for this image, which determines how texels are sampled by shaders

      .. helptext:: get or set the sampler state for this image

   .. lua:attribute:: smooth: boolean

      Sets/gets whether this image has linear or nearest filtering

      .. helptext:: enable or disable smooth filtering

   .. lua:attribute:: filter: integer

      How this image is filtered when drawn larger or smaller than its size:

      - ``image.filter.point`` - nearest pixel, for pixel art
      - ``image.filter.linear`` - blends neighbouring pixels
      - ``image.filter.default`` - follows ``style.filter``, the default

      .. helptext:: get or set the filtering of this image

   .. lua:attribute:: wrap: integer

      How this image repeats when a mesh's texture coordinates go beyond 0 and 1:

      - ``image.wrap.tile`` - repeats the image
      - ``image.wrap.clamp`` - stretches the edge pixels
      - ``image.wrap.mirror`` - repeats the image, flipping every other copy
      - ``image.wrap.default`` - follows ``style.wrap``, the default

      .. helptext:: get or set how this image repeats

      .. code-block:: lua
         :caption: Tiling an image on a mesh

         function setup()
             local checker = image.pixel(2, 2)
             checker:setPixel(1, 1, color(255, 0, 0))
             checker:setPixel(2, 2, color(255, 0, 0))
             checker:setPixel(1, 2, color(255))
             checker:setPixel(2, 1, color(255))
             checker:apply()
             checker.filter = image.filter.point
             checker.wrap = image.wrap.tile

             floor = mesh()
             floor.texture = checker
             -- texture coordinates from 0 to 3 show the image 3 times each way
             floor:addRect(vec2(WIDTH/2, HEIGHT/2), vec2(300, 300), 0, vec4(0, 0, 3, 3))
         end

         function draw()
             background(40)
             floor:draw()
         end

   .. lua:attribute:: slice: image.slice

      A new :lua:class:`image.slice` covering the whole image, to configure and
      draw with ``sprite()``

      .. helptext:: get a slice of this image

   .. lua:attribute:: key: assetKey

      The asset key for this image (if it has one)

      .. helptext:: get the asset key for this image

   .. lua:method:: setPixel(x, y, color)

      Sets the colour of a pixel. ``x`` and ``y`` start at 1, from the bottom
      left corner, and are in points like :lua:attr:`width` and :lua:attr:`height`,
      so on an image made with :lua:func:`image` a point covers several pixels.
      Use :lua:func:`image.pixel` to set each pixel on its own.

      The change is made to the image's copy in memory. Call :lua:meth:`apply`
      before drawing the image or saving it.

      :param x: The x coordinate, from 1 to ``width``
      :type x: integer
      :param y: The y coordinate, from 1 to ``height``
      :type y: integer
      :param color: The colour to set
      :type color: color

      .. helptext:: set the colour of a pixel

      .. code-block:: lua
         :caption: Setting pixels

         function setup()
             img = image.pixel(4, 4)
             img:setPixel(1, 1, color(255, 0, 0))     -- bottom left
             img:setPixel(4, 4, 255, 255, 0, 255)     -- top right
             img:apply()
             img.filter = image.filter.point
         end

         function draw()
             background(40)
             sprite(img, WIDTH/2, HEIGHT/2, 200, 200)
         end

   .. lua:method:: setPixel(x, y, r, g, b, a)

      Sets the colour of a pixel from its red, green, blue and alpha values,
      from 0 to 255

      :param x: The x coordinate, from 1 to ``width``
      :type x: integer
      :param y: The y coordinate, from 1 to ``height``
      :type y: integer
      :param r: The red value
      :type r: number
      :param g: The green value
      :type g: number
      :param b: The blue value
      :type b: number
      :param a: The alpha value
      :type a: number

      .. helptext:: set the colour of a pixel from its components

   .. lua:method:: getPixel(x, y)

      Returns the red, green, blue and alpha values of a pixel, from 0 to 255.
      Coordinates are as in :lua:meth:`setPixel`.

      This reads the image's copy in memory, which holds what was set with
      :lua:meth:`setPixel`. A blank image reads as all zeros, and so does what
      was drawn into the image until :lua:meth:`readback` copies it.

      :param x: The x coordinate, from 1 to ``width``
      :type x: integer
      :param y: The y coordinate, from 1 to ``height``
      :type y: integer
      :return: The red, green, blue and alpha values
      :rtype: number, number, number, number

      .. helptext:: get the colour of a pixel

      .. code-block:: lua
         :caption: Reading a pixel

         local img = image.pixel(2, 2)
         img:setPixel(1, 1, color(255, 128, 0))
         local r, g, b, a = img:getPixel(1, 1)
         print(r, g, b, a) -- 255.0 128.0 0.0 255.0

   .. lua:method:: setValue(x, y, r, g, b, a)

      Sets a pixel from raw values, as the image stores them: 0 to 1 for most
      formats, and any value for float formats such as ``image.rgba32f``.
      Coordinates are as in :lua:meth:`setPixel`. Given a single value, sets
      red, green and blue to it, with an alpha of 1

      :param x: The x coordinate, from 1 to ``width``
      :type x: integer
      :param y: The y coordinate, from 1 to ``height``
      :type y: integer
      :param r: The red value, or the value for red, green and blue
      :type r: number
      :param g: The green value (optional)
      :type g: number
      :param b: The blue value (optional)
      :type b: number
      :param a: The alpha value (optional | default = 1)
      :type a: number

      .. helptext:: set the raw value of a pixel

   .. lua:method:: getValue(x, y)

      Returns the raw red, green, blue and alpha values of a pixel, as the
      image stores them: 0 to 1 for most formats, and any value for float
      formats. Coordinates are as in :lua:meth:`setPixel`

      :param x: The x coordinate, from 1 to ``width``
      :type x: integer
      :param y: The y coordinate, from 1 to ``height``
      :type y: integer
      :return: The red, green, blue and alpha values
      :rtype: number, number, number, number

      .. helptext:: get the raw value of a pixel

   .. lua:method:: setForEach(func)

      Sets every pixel from a function, called with the coordinates of each
      pixel, which returns its red, green, blue and alpha values as raw values,
      0 to 1 for most formats. The function must return all four. Call
      :lua:meth:`apply` afterwards to see the result

      :param func: A function taking ``x`` and ``y`` and returning ``r, g, b, a``
      :type func: function

      .. helptext:: set every pixel from a function

      .. code-block:: lua
         :caption: A gradient

         function setup()
             gradient = image.pixel(64, 64)
             gradient:setForEach(function(x, y)
                 return x / 64, y / 64, 0, 1
             end)
             gradient:apply()
         end

         function draw()
             background(40)
             sprite(gradient, WIDTH/2, HEIGHT/2, 256, 256)
         end

   .. lua:method:: apply()

      Sends the pixels set with :lua:meth:`setPixel` to the image, so that they
      show when it is drawn or saved

      .. helptext:: apply the pixels set on this image

   .. lua:method:: readback()

      Copies what was drawn into the image back to its copy in memory, so that
      :lua:meth:`getPixel` can read it. Waits until the copy is done.

      Drawing is finished at the end of a frame: read back in a later frame
      than the one that drew into the image, and for drawing done in ``setup()``,
      from the second frame on.

      .. helptext:: read back the pixels drawn into this image

   .. lua:method:: generateIrradiance(samples)

      Generates a guassian pyramid of pre-computed irradiance levels, used for image based lighting

      :param samples: The number of samples to use (optional | default = 1024)
      :type samples: integer
      :return: A new image containing the irradiance data
      :rtype: image

      .. helptext:: generate pre-computed irradiance data

   .. lua:method:: generateIrradiance(target, samples)

      Generates a guassian pyramid of pre-computed irradiance levels, used for image based lighting

      :param target: A target image to store the irradiance data
      :type target: image
      :param samples: The number of samples to use (optional | default = 1024)
      :type samples: integer
      :return: The target image containing the irradiance data
      :rtype: image

      .. helptext:: generate irradiance data into a target image

Image Formats
-------------

Here is a list of all currently available image formats

.. list-table:: Available Image Formats
   :widths: 30 20 20 10
   :header-rows: 1

   * - Name
     - Type
     - Channels
     - SRGB
   * - ``image.a8``
     - unorm
     - [8]
     - No
   * - ``image.r8``
     - unorm
     - [8]
     - Yes
   * - ``image.r8i``
     - sint
     - [8]
     - No
   * - ``image.r8u``
     - uint
     - [8]
     - No
   * - ``image.r8s``
     - snorm
     - [8]
     - No
   * - ``image.r16``
     - unorm
     - [16]
     - Yes
   * - ``image.r16i``
     - sint
     - [16]
     - No
   * - ``image.r16u``
     - uint
     - [16]
     - No
   * - ``image.r16f``
     - float
     - [16]
     - No
   * - ``image.r16s``
     - snorm
     - [16]
     - No
   * - ``image.r32i``
     - sint
     - [32]
     - No
   * - ``image.r32u``
     - uint
     - [32]
     - No
   * - ``image.r32f``
     - float
     - [32]
     - No
   * - ``image.rgb8``
     - unorm
     - [8,8,8]
     - Yes
   * - ``image.rgb8i``
     - sint
     - [8,8,8]
     - No
   * - ``image.rgb8u``
     - uint
     - [8,8,8]
     - No
   * - ``image.rgb8s``
     - snorm
     - [8,8,8]
     - No
   * - ``image.rg16``
     - unorm
     - [16,16,16]
     - Yes
   * - ``image.rg16i``
     - sint
     - [16,16,16]
     - No
   * - ``image.rg16u``
     - uint
     - [16,16,16]
     - No
   * - ``image.rg16f``
     - float
     - [16,16,16]
     - No     
   * - ``image.rg16s``
     - snorm
     - [16,16,16]
     - No
   * - ``image.rg32i``
     - sint
     - [32,32,32]
     - No
   * - ``image.rg32u``
     - uint
     - [32,32,32]
     - No     
   * - ``image.rg32f``
     - float
     - [32,32,32]
     - No
   * - ``image.rgb9e5f``
     - float
     - [9,9,9,+5]
     - No
   * - ``image.bgra8``
     - unorm
     - [8,8,8,8]
     - Yes
   * - ``image.rgba8``
     - unorm
     - [8,8,8,8]
     - Yes
   * - ``image.rgba8i``
     - sint
     - [8,8,8,8]
     - No
   * - ``image.rgba8u``
     - uint
     - [8,8,8,8]
     - No
   * - ``image.rgba8u``
     - sint
     - [8,8,8,8]
     - No
   * - ``image.rgba8s``
     - snorm
     - [8,8,8,8]
     - No
   * - ``image.rgba16``
     - unorm
     - [16,16,16,16]
     - No
   * - ``image.rgba16i``
     - sint
     - [16,16,16,16]
     - No
   * - ``image.rgba16u``
     - uint
     - [16,16,16,16]
     - No
   * - ``image.rgba16f``
     - float
     - [16,16,16,16]
     - No
   * - ``image.rgba16s``
     - snorm
     - [16,16,16,16]
     - No
   * - ``image.rgba32i``
     - sint
     - [32,32,32,32]
     - No
   * - ``image.rgba32u``
     - uint
     - [32,32,32,32]
     - No
   * - ``image.rgba32f``
     - float
     - [32,32,32,32]
     - No
   * - ``image.r5g6b5``
     - n/a
     - [5,6,5]
     - No
   * - ``image.rgba4``
     - n/a
     - [4,4,4,4]
     - No
   * - ``image.rgb5a1``
     - n/a
     - [5,5,5,1]
     - No
   * - ``image.rgb10a2``
     - n/a
     - [10,10,10,2]
     - No
   * - ``image.rg11b10f``
     - float
     - [32,32,32,32]
     - No
   * - ``image.d16``
     - uint
     - [16]
     - No
   * - ``image.d24``
     - uint
     - [24]
     - n/a
   * - ``image.d24s8``
     - depth/stencil
     - [24,8]
     - n/a
   * - ``image.d32``
     - uint
     - [32]
     - n/a
   * - ``image.d16f``
     - uint
     - [16]
     - n/a
   * - ``image.d24f``
     - uint
     - [24]
     - n/a
   * - ``image.d32f``
     - float
     - [32]
     - n/a
   * - ``image.d0s8``
     - stencil
     - [8]
     - n/a

Sampler State / Mipmapping
--------------------------

The sampler state of an image is used to control texel sampling

The ``mag`` property controls magnification, i.e. when the image texels are larger than 1 pixel in size

The ``min`` property controls minification, i.e. when the image texels are smaller than 1 pixel in size

The ``mip`` property controls how mipmapping is handled, ``linear`` will blend between mip levels linearly, while ``point`` will map clamp to the nearest mip level and ``none`` disables mipmapping entirely

.. lua:class:: samplerState

   .. lua:attribute:: min: filterMode

      The minification filter, can be ``point``, ``linear`` or ``none``

      .. helptext:: get or set the minification filter mode

   .. lua:attribute:: mag: filterMode

      The magnification filter, can be ``point``, ``linear`` or ``none``

      .. helptext:: get or set the magnification filter mode

   .. lua:attribute:: mip: filterMode

      The mip filter, can be ``point``, ``linear`` or ``none``

      .. helptext:: get or set the mip filter mode

   .. lua:attribute:: u: samplerMode

      The u sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

      .. helptext:: get or set the u sampler wrap mode

   .. lua:attribute:: v: samplerMode

      The v sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

      .. helptext:: get or set the v sampler wrap mode

   .. lua:attribute:: w: samplerMode

      The w sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

      .. helptext:: get or set the w sampler wrap mode

Slices and Atlases
-------------------

.. lua:class:: image.slice

   A configurable slice of an image. Use with ``sprite()`` for drawing a portion of an sprite sheet image for more efficient 2D rendering (as opposed to a large number of independ images)

   Create slices using an existing image via the ``image.slice`` property. Slices can be configured using a fluent syntax, allowing for rotation, flipping and 9-patch stretching among other things

   .. code-block:: lua
      :caption: Creating slices

      function setup()
         button = image.read(asset.builtin.UI.Grey_Button_10)

         -- create a stretchable 9-patch of the original image
         buttonSlice = button.slice:patch(10)
      end

      function draw()
         sprite(buttonSlice, WIDTH/2, HEIGHT/2, 100, 50)
      end

   .. lua:method:: name(name)

      .. helptext:: set the slice name
   .. lua:method:: name()      

      Gets/sets the slice name (for retrieval  in the ``atlas`` class)

      .. helptext:: get the slice name

   .. lua:method:: normal()

      Reset the slice to the normal drawing mode (from patch or polygon mode)

      .. helptext:: reset the slice to normal drawing mode

   .. lua:method:: rect(x, y, w, h)

      .. helptext:: set the slice sub-rectangle
   .. lua:method:: rect()      

      Set/gets the sub-rectangle for the slice (in pixels). Use this to draw a portion of the sliced image

      .. helptext:: get the slice sub-rectangle

   .. lua:method:: patch(left, right, top, bottom)      

      .. helptext:: set the slice as a 9-patch with margins
   .. lua:method:: patch(margin)            

      Sets the slice to draw as a 9-patch using the supplied margins. This allows the slice to be stretched to an arbitrary size while maintaining fixed-sized borders

      .. helptext:: set the slice as a 9-patch with a uniform margin

   .. lua:method:: padding(left, right, top, bottom)      

      .. helptext:: set the slice padding
   .. lua:method:: padding(amount)              

      .. helptext:: set the slice padding uniformly
   .. lua:method:: padding()            

      Sets/gets the slice padding. This allows for a larger slice to be drawn but discards empty space at the edges (useful sprites packed into an atlas that trims empty space)

      .. helptext:: get the slice padding

   .. lua:method:: anchor(x, y)      

      .. helptext:: set the slice anchor
   .. lua:method:: anchor()      

      Sets/gets the slice anchor (also known as a pivot). The anchor is the geometric center of the slice for transformations such as rotation/scale and flipping

      .. helptext:: get the slice anchor

   .. lua:method:: rotate(angle)      

      .. helptext:: set the slice rotation
   .. lua:method:: rotate()     

      Sets/gets the sice rotation (in discrete 90 degree turns). Useful for atlas packed sprites that might be rotated to fit, or when reusing a slice at a different 90 degee angle

      .. helptext:: get the slice rotation

   .. lua:method:: flip(x, y)      

      .. helptext:: set the slice horizontal and vertical flip
   .. lua:method:: flip()            

      Sets/gets the horizontal and vertical flip for the slice

      .. helptext:: get the slice flip
    
   .. lua:attribute:: image: image

      The image this slice is derived from

      .. helptext:: get the source image for this slice
    
   .. lua:attribute:: atlas: atlas

      The atlas this slice is part of

      .. helptext:: get the atlas this slice is part of

.. lua:class:: atlas

   A collection of ``image.slice`` objects generated from an image

   Often 2D game assets will be compiled into a single image (known as an atlas or sprite sheet) for convienience and efficiency. These can be loaded from an external text file or generated using some simple settings

   .. lua:staticmethod:: atlas(image)

      Create a new blank atlas using an existing image

      .. helptext:: create a new blank atlas from an image

   .. lua:staticmethod:: read(assetKey)

      .. helptext:: read an atlas from an asset key

   .. lua:staticmethod:: save(assetKey, atlas)

      .. helptext:: save an atlas to an asset key

   .. lua:method:: clear()

      .. helptext:: clear all slices from this atlas

   .. lua:method:: setWithCellSize(cellWidth[, cellHeight, padding])

      .. helptext:: generate slices using cell size

   .. lua:method:: setWithCellCount(cellColumns[, cellRows, padding])      

      .. helptext:: generate slices using cell count
   
