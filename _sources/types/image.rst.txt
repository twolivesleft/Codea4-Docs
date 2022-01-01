image
=====

Represents an image, used by codea for drawing to the screen and texturing meshes

.. code-block:: lua
   :linenos:
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

   .. lua:staticmethod:: image(width, height, hasMips = false, numLayers = 1, format = image.rgba, depthFormat = none): image

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

   .. lua:staticmethod:: image.cube(size): image

      Cube a blank cube image (6 faces with equal sized dimensions)

      :param size: The size of the image cube
      :type size: integer

   .. lua:staticmethod:: image.cube(equirect): image

      Creates a cube image from a single equirect image (i.e. hdr)

      :param equirect: The source equirect image
      :type equirect: image

   .. lua:staticmethod:: image.cube(imageNX, imagePX, imageNY, imagePY, imageNZ, imagePZ): image

      Creates a cube image from six source images, one for each cube face

   .. lua:staticmethod:: image.volume(width, height, depth, format): image

      Creates a blank volume image with the given dimensions

      :param width: The width of the volume image
      :type width: integer
      :param height: The height of the volume image
      :type height: integer
      :param depth: The depth of the volume image
      :type depth: integer
      :param format: The format of the volume image
      :type format: image format

   .. lua:staticmethod:: read(key): image

      :param key: The asset key to load

   .. lua:staticmethod:: save(key, image): image

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

Sprites and Atlases
-------------------

.. lua:class:: atlas


.. lua:class:: sprite.slice
