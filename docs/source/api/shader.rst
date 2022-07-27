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

   ``TODO``

   **Vertex Shaders**

   Each vertex within a mesh is passed to the GPU via the vertex processing stage, where various calculations can be performed to control the final appearance

   **Fragment Shaders**

   After the vertex processing stage, the fragment processing stage begins. Primtives assembled from vertices, such as triangles, are drawn on to the framebuffer in a process known as rasterization. 
   
   The fragment shader is able to calculate the final output of this stage (typically the color and/or depth of the fragment)

   **Compute Shaders**

   ``TODO``

   **Shader Definitions**

   Shader definitions are Lua tables that define all the settings of a shader. These can be used for fine-grained control over shader behaviour

   **Materials**

   Shaders can be re-used in multiple meshes/entities but will retain their current state globally. Setting properties on a shader in one place will effect rendering on all objects they are attached to

   This is where materials come in. Placing a shader within a material isntance and passing that to various objects will allow for the same shader to be used with different state (properties) as many times are needed

   **The Standard Shader**

   For convenience there is a built-in uber-shader, called the standard shader which contains a large number of shading options

   For more details see: :lua:func:`material.unlit` and :lua:func:`material.lit`

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

      Our shading models are derived from Google's amazing Filament: https://google.github.io/filament/Materials.html

      Surface shaders are created using a shader definition with a ``shadingModel`` set. A vertex and material function can then be spefified to customise the surface appearance

      .. code-block:: lua

         surface = shader
         {
            pass = 
            {       
               shadingModel = "lit",

               vertex = 
               [[
                  void materialVertex(inout MaterialVertexInputs material) 
                  {
                  }
               ]],

               material = 
               [[
                  void material(inout MaterialInputs material) 
                  {
                     prepareMaterial(material);
            
                     vec2 uv = getUV0();
                     material.metallic = 1.0;
                     material.roughness = 
                        mod(floor(uv.x * 20) + floor(uv.y * 10), 2)
                        * 0.5;
                     material.baseColor = baseColor;
                  }                
               ]]
            }
         
         }

      *Shading Models*

      The following shading models are supported:

      - ``unlit`` Basic unlit shading
      - ``lit`` Physically based lit shading model
      - ``custom`` Custom shading model

      *MaterialInputs Struct*

      The ``material`` function can set the various fields within the ``MaterialInputs`` struct to control the shading of the surface

      This ranges from diffuse surface color, metal/roughness to normal mapping, ambient occlusion and more
      
      Some are only available in specific lighting models and expect values to be within certain ranges

      .. list-table:: Material Inputs
         :widths: 25 20 10 45
         :header-rows: 1

         * - Name
           - Type
           - Models
           - Description
         * - ``baseColor``
           - ``vec4``
           - All
           - Diffuse albedo color
         * - ``metallic``
           - ``float`` [0..1]
           - Lit
           - The metalness of the surface (zero or one)
         * - ``roughness``
           - ``float`` [0..1]
           - Lit
           - Perceived smoothness (1.0) or roughness (0.0) of a surface
         * - ``reflectance``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``clearCoat``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``clearCoatRoughness``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``anisotropy``
           - ``float`` [-1..1]
           - Lit
           - 
         * - ``anisotropyDirection``
           - ``vec3`` [0..1]
           - Lit
           - 
         * - ``ambientOcclusion``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``normal``
           - ``vec3`` [0..1]
           - Lit
           - 
         * - ``bentNormal``
           - ``vec3`` [0..1]
           - Lit
           - 
         * - ``clearCoatNormal``
           - ``vec3`` [0..1]
           - Lit
           - 
         * - ``emissive``
           - ``vec4`` [0..n]
           - Lit
           - 
         * - ``postLightingColor``
           - ``vec4`` [0..1]
           - Lit
           - 
         * - ``ior``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``transmission``
           - ``float`` [0..1]
           - Lit
           - 
         * - ``absorption``
           - ``float`` [0..n]
           - Lit
           - 
         * - ``microThickness``
           - ``float`` [0..n]
           - Lit
           - 
         * - ``thickness``
           - ``float`` [0..n]
           - Lit
           - 

      **Shader Builder**

      ``TODO``

      **ShadePro (App)**

      ``TODO``
