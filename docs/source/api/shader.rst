:reference-overview: Writing Shaders

Shaders
========

A shader controls how geometry is transformed and how pixels are colored. Start with a material builder for surface effects; use vertex and fragment shader source when you need direct control over both stages. The checkerboard below uses texture coordinates to alternate two colors across a sprite.

.. code-block:: lua
   :caption: Drawing a Checkerboard Shader

   function setup()
      solid = shader([[
         #version 430
         #include <codea/common.glsl>
      
         layout (location = POSITION) in vec3 a_position;
         layout (location = TEXCOORD0) in vec2 a_texcoord0;
      
         out vec2 uv;
      
         void main()
         {
            gl_Position = u_modelViewProj * vec4(a_position, 1.0);
            uv = a_texcoord0;
         }
      ]],

      [[
         #version 430
         #include <codea/common.glsl>

         in vec2 uv;    
         out vec4 FragColor;

         void main()
         {
            vec2 c = floor(uv * 10);
            float d = mod(c.x + c.y, 2);
            FragColor = vec4(vec3(d), 1);
         }
      ]])
   end

   function draw()
      background(64)
      sprite(solid, WIDTH/2, HEIGHT/2, 200, 200)
   end

.. lua:class:: shader

   A special program that runs per vertex/pixel for drawing and compute operations on the GPU

   In Codea shaders can be used in various places to customise rendering including meshes, entities, sprites, backgrounds and post processing effects

   .. lua:staticmethod:: shader(vertexSource, fragmentSource)

      The simplist form of shader creation, both the vertex and fragment sources are provided directly without any additional settings

      This is useful for fairly basic shaders

      .. helptext:: create a shader from source or a shader definition

   .. lua:staticmethod:: shader(shaderDefinition)

      A more advanced form of shader creation, with many more options that can be tailored for specific use-cases

      .. helptext:: create a shader from source or a shader definition

   .. lua:staticmethod:: compute(source)

      Create a compute shader without any extra settings

      .. helptext:: create a compute shader

   .. lua:staticmethod:: read(asset)

      Read a shader asset from the filesystem

      .. helptext:: read a shader asset from the filesystem

   .. lua:method:: setOption(name, on)

      .. helptext:: set a shader option

   .. lua:method:: setImage(name, image[, mip = 0])

      Bind an image to a declared image property for compute access. Its format must match the GLSL layout qualifier (for example, image.rgba16f with layout(rgba16f)). The mip index is zero-based. Read/write access comes from the GLSL readonly/writeonly qualifiers, not an additional Lua argument.

      :param name: Name of the image property
      :type name: string
      :param image: Texture to bind
      :type image: image
      :param mip: Mipmap level to bind
      :type mip: integer

      .. helptext:: bind an image for compute access

   .. lua:method:: setBuffer(name, buffer)

      Bind a shader buffer to a declared buffer property. The Lua buffer layout must match the GLSL struct. With shader.builder():buffer{"Instance", "instances"}, the generated property is named "instancesBuffer".

      :param name: Name of the buffer property
      :type name: string
      :param buffer: Buffer to bind
      :type buffer: shader.buffer

      .. helptext:: bind a buffer to a shader property

   .. lua:method:: workgroupSize([passIndex = 0])

      Return the local workgroup dimensions declared by NUM_THREADS() or shader.builder():threads(). The optional pass index is zero-based. Divide the number of elements by these dimensions and round up to calculate dispatch counts.

      :param passIndex: Compute pass to inspect
      :type passIndex: integer
      :return: Local X, Y, and Z thread counts
      :rtype: integer, integer, integer

      .. helptext:: get the compute workgroup dimensions

   .. lua:method:: dispatch(wx, wy, wz)

      Dispatch counts workgroups, not individual invocations. Divide the buffer length by the shader workgroup size and round up; check the index against instanceCount inside the shader. This example updates a shared buffer before drawing its instances.

      .. codea-example:: Compute-driven particles
         :project: code/Modern/Shader 09 - Particles.codea

      .. helptext:: dispatch this compute shader

   .. lua:method:: dispatchIndirect(indirectBuffer, start, num)

      .. helptext:: dispatch this compute shader indirectly

   .. lua:class:: builder

      Build a surface shader by chaining commands to choose lighting, define properties, and add shader code.

      .. code-block:: lua

         checkers = shader.builder()
            :lit()
            :vec2{"size", value = vec2(10, 10)}
            :color{"colorA", value = color.black}
            :color{"colorB", value = color.white}
            :material
            [[
               vec2 uv = getUV0();
               uv = floor(uv * size);
               float c = mod(uv.x + uv.y, 2);
               material.baseColor = mix(colorA, colorB, c);
            ]]
            :build()

   .. lua:class:: buffer

      .. lua:staticmethod:: buffer(layout[, size])

         Create a GPU buffer based on a ``layout``

         ``myBuffer = shader.buffer(layout)``

         .. helptext:: create a gpu buffer with a given layout

      .. lua:method:: resize(size)

         Resize the buffer

         .. helptext:: resize the buffer

      .. lua:method:: clear()  

         Clear the buffer

         .. helptext:: clear the buffer

      .. lua:method:: append(attribute1, value1, attribute2, value2[, ...])

         Append a new element to the buffer using pairs of attributes and values

         .. helptext:: append a new element to the buffer

   .. lua:class:: indexBuffer

      .. lua:staticmethod:: indexBuffer(type[, size])

         Create a GPU index buffer (array of unsigned integers). Usually used for mesh primitive indices

         ``myBuffer = shader.indexBuffer(shader.indexBuffer.i32|i16)``
    
         Buffer type can be 32 bit (``shader.indexBuffer.i32``) or 16 bit (``shader.indexBuffer.i16``)          

         .. helptext:: create a gpu index buffer

      .. lua:method:: resize(size)

         Resize the buffer

         .. helptext:: resize the index buffer

      .. lua:method:: clear()  

         Clear the buffer

         .. helptext:: clear the index buffer

      .. lua:method:: append(i1, i2, i3, ...)

         Appends multiple elements to the buffer

         .. helptext:: append elements to the index buffer

   .. lua:class:: bufferLayout

      Represents the layout of a shader buffer, used to store arrays of structured data within a shader

      .. lua:staticmethod:: bufferLayout(definition)
      
         Create a new buffer layout using a definition table

         The buffer layout will need to match the target shader struct layout exactly in order to work with calls to ``shader:setBuffer()``

         .. code-block:: lua

            updatePosVel = shader.compute
            [[
               #version 430
               #include <codea/common.glsl>

               struct Instance
               {
                  vec4 position;
               };

               BUFFER_RW(instances, Instance, BUFFER0);

               uniform uint instanceCount;

               NUM_THREADS(64, 1, 1)
               void main()
               {
                  uint id = gl_GlobalInvocationID.x;
                  if (id < instancesCount)
                  {
                     instances[id].position = vec4(0,1,2,3);
                  }
               }
            ]]

            function setup()
               layout = shader.bufferLayout{ {shader.position, 4, shader.float} }

               buffer = shader.buffer(layout)
               for i = 1, 10000 do 
                  local posVel = vec4()
                  posVel.x = math.random(0, WIDTH)
                  posVel.y = math.random(0, HEIGHT)
                  posVel.z = math.random() * 0.5 - 0.5
                  posVel.w = math.random() * 0.5 - 0.5
                  buffer:append(shader.position, posVel)
               end
               updatePosVel:setBuffer("instancesBuffer", buffer)
               updatePosVel.instanceCount = posVel.size            
            end
            
         The buffer definition table contains is an array of tables, each one containing the following format:

         ``{attribute, count, type[, normalized]}``

         Each ``attribute`` maps to a field in the buffer struct to a specific ``type``, where ``count`` maps to scalar and vector types respectively

         Attributes

         - ``position``
         - ``normal``
         - ``tangent``
         - ``bitangent``
         - ``color0..3``
         - ``indices``
         - ``weight``
         - ``texcoord0..9``

         Types

         - ``uint8``
         - ``uint10``
         - ``int16``
         - ``half``
         - ``float``

         .. helptext:: create a buffer layout from a definition

      .. lua:attribute:: size: integer

         The current size of the buffer

         .. helptext:: get the size of this shader buffer
      
      .. lua:method:: resize(size)

         Resize the buffer to a given ``size``

         .. helptext:: resize the buffer to a given size

      .. lua:method:: clear()

         Clear the buffer

         .. helptext:: clear the buffer
      



