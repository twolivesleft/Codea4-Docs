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

   .. code-block:: lua
      
      myShader = shader(vsh, fsh)

      myMesh.shader = myShader

      myMaterial = material(shader)

      sprite(myShader, x, y, w, h)

      background(myShader)

   *WARNING: Shaders live very close to the hardware and are much more likely to cause crashes or graphical corruption when things go wrong, you have been warned ;)*

   **Graphics Pipeline**

   **Vertex Shaders**

   **Fragment Shaders**

   **Compute Shaders**

   **Shader Definitions**

   **Materials**
   

   .. lua:staticmethod:: shader(vertexSource, fragmentSource)

      The simplist form of shader creation, both the vertex and fragment sources are provided directly without any additional settings

      This is useful for fairly basic shaders

   .. lua:staticmethod:: shader(shaderDefinition)

      A more advanced form of shader creation, with many more options that can be tailored for specific use-cases

      **Basic Shader Definition**

      .. code-block:: lua

         shdr = shader
         {
            properties = 
            {
               {name, type, value, ...}
            },

            options = 
            {
               NAME = {default, options}
            },

            passes = 
            {
               pass = 
               {       
                  vertex = 
                  [[
                     ...
                  ]],

                  fragment = 
                  [[
                     ...
                  ]]
               }
            }
         }

      **Surface Shaders**

      Surface shaders provide support for advanced shading models, where only the surface attributes need to be specified

      *Shading Models*

      - ``unlit``
      - ``lit``
      - ``custom``