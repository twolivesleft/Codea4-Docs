image
=====

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

.. lua:class:: image

   .. lua:staticmethod:: image(width, height, [hasMips = false, numLayers = 1, format = image.rgba, depthFormat = none])

      Create a blank 2D image (default format is `rgba`)

      :param width: The width of the image
      :type width: integer
      :param height: The height of the image
      :type height: integer
      :param hasMips: Enables mipmapping for this image
      :type hasMips: boolean
      :param numLayers: The number of layers for this image
      :type numLayers: integer
      :param format: The image format
      :type format: image format
      :param depthFormat: The image depth format
      :type depthFormat: depth format

   .. lua:staticmethod:: image.cube(size)

      Create a blank cube image (6 faces with equal sized dimensions)

      :param size: The size of the image cube
      :type size: integer

   .. lua:staticmethod:: image.cube(equirect)

      Creates a cube image from a single equirect image (i.e. hdr)

      :param equirect: The source equirect image
      :type equirect: image

   .. lua:staticmethod:: image.cube(imageNX, imagePX, imageNY, imagePY, imageNZ, imagePZ)

      Creates a cube image from six source images, one for each cube face

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

   .. lua:staticmethod:: image.read(key)

      Read an image asset from the filesystem

      :param key: The asset key to load
      :rtype: image

   .. lua:staticmethod:: image.save(key, image)

      Save an image asset to the filesystem

      :param key: The asset key to save the image to
      :type key: assetKey
      :param image: The image to save
      :type image: image

   .. lua:attribute:: width: integer

      The width of the image in pixels

   .. lua:attribute:: height: integer

      The height of the image in pixels

   .. lua:attribute:: depth: integer

      The depth of the image in pixels (for volume images)

   .. lua:attribute:: numLayers: integer

      The number of layers in this image

   .. lua:attribute:: hasMips: boolean

      Whether this image has mip mapping or not

   .. lua:attribute:: cubeMap: boolean

      Whether this image is a cube or not

   .. lua:attribute:: numMips: integer

      The number of mips this image has

   .. lua:attribute:: sampler: samplerState

      The sampler state for this image, which determines how texels are sampled by shaders

   .. lua:attribute:: smooth: boolean

      Sets/gets whether this image has linear or nearest filtering

   .. lua:attribute:: key: assetKey

      The asset key for this image (if it has one)

   .. lua:method:: generateIrradiance(samples)

      Generates a guassian pyramid of pre-computed irradiance levels, used for image based lighting

      :param samples: The number of samples to use (optional | default = 1024)
      :type samples: integer
      :return: A new image containing the irradiance data
      :rtype: image

   .. lua:method:: generateIrradiance(target, samples)

      Generates a guassian pyramid of pre-computed irradiance levels, used for image based lighting

      :param target: A target image to store the irradiance data
      :type target: image
      :param samples: The number of samples to use (optional | default = 1024)
      :type samples: integer
      :return: The target image containing the irradiance data
      :rtype: image

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

   .. lua:attribute:: mag: filterMode

      The magnification filter, can be ``point``, ``linear`` or ``none``

   .. lua:attribute:: mip: filterMode

      The mip filter, can be ``point``, ``linear`` or ``none``

   .. lua:attribute:: u: samplerMode

      The u sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

   .. lua:attribute:: v: samplerMode

      The v sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

   .. lua:attribute:: w: samplerMode

      The w sampler mode, can be ``repeat``, ``clamp`` or ``mirror``

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
   .. lua:method:: name()      

      Gets/sets the slice name (for retrieval  in the ``atlas`` class)

   .. lua:method:: normal()

      Reset the slice to the normal drawing mode (from patch or polygon mode)

   .. lua:method:: rect(x, y, w, h)
   .. lua:method:: rect()      

      Set/gets the sub-rectangle for the slice (in pixels). Use this to draw a portion of the sliced image

   .. lua:method:: patch(left, right, top, bottom)      
   .. lua:method:: patch(margin)            

      Sets the slice to draw as a 9-patch using the supplied margins. This allows the slice to be stretched to an arbitrary size while maintaining fixed-sized borders

   .. lua:method:: padding(left, right, top, bottom)      
   .. lua:method:: padding(amount)              
   .. lua:method:: padding()            

      Sets/gets the slice padding. This allows for a larger slice to be drawn but discards empty space at the edges (useful sprites packed into an atlas that trims empty space)

   .. lua:method:: anchor(x, y)      
   .. lua:method:: anchor()      

      Sets/gets the slice anchor (also known as a pivot). The anchor is the geometric center of the slice for transformations such as rotation/scale and flipping

   .. lua:method:: rotate(angle)      
   .. lua:method:: rotate()     

      Sets/gets the sice rotation (in discrete 90 degree turns). Useful for atlas packed sprites that might be rotated to fit, or when reusing a slice at a different 90 degee angle

   .. lua:method:: flip(x, y)      
   .. lua:method:: flip()            

      Sets/gets the horizontal and vertical flip for the slice
    
   .. lua:attribute:: image: image

      The image this slice is derived from
    
   .. lua:attribute:: atlas: atlas

      The atlas this slice is part of

.. lua:class:: atlas

   A collection of ``image.slice`` objects generated from an image

   Often 2D game assets will be compiled into a single image (known as an atlas or sprite sheet) for convienience and efficiency. These can be loaded from an external text file or generated using some simple settings

   .. lua:staticmethod:: atlas(image)

      Create a new blank atlas using an existing image

   .. lua:staticmethod:: read(assetKey)

   .. lua:staticmethod:: save(assetKey, atlas)

   .. lua:method:: clear()

   .. lua:method:: setWithCellSize(cellWidth[, cellHeight, padding])

   .. lua:method:: setWithCellCount(cellColumns[, cellRows, padding])      
   

