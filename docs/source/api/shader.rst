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

   .. lua:class:: shader.builder

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

      



