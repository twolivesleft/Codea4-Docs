shader
======

.. code-block:: lua
   :caption: Checkers Shader :3

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

   .. lua:staticmethod:: shader(shaderDefinition)

      A more advanced form of shader creation, with many more options that can be tailored for specific use-cases

   .. lua:staticmethod:: compute(source)

      Create a compute shader without any extra settings

   .. lua:staticmethod:: read(asset)

      Read a shader asset from the filesystem

   .. lua:method:: setOption(name, on)

   .. lua:method:: dispatch(wx, wy, wz)

   .. lua:method:: dispatchIndirect(indirectBuffer, start, num)

   .. lua:class:: builder

      Shader Builder is a fluent syntax built on top of the surface shaders system for quick and convenient shader experimentation

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
               float c = mod(uv.x + ux.y, 2);
               material.baseColor = mix(colorA, colorB, c);
            ]]
            :build()

   .. lua:class:: buffer

      .. lua:staticmethod:: buffer(layout[, size])

         .. code-block:: lua

            shader.buffer()

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

               float rand(vec2 co)
               {
                  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
               }

               NUM_THREADS(64, 1, 1)
               void main()
               {
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
               updatePosVel:setBuffer(buffer, "instances", shader.readwrite)
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

      .. lua:attribute:: size: integer

         The current size of the buffer
      
      .. lua:method:: resize(size)

         Resize the buffer to a given ``size``

      .. lua:method:: clear()

         Clear the buffer
      



