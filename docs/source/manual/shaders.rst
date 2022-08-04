Shaders and Materials
=====================

A special program that runs per vertex/pixel for drawing and compute operations on the GPU

Codea shaders are written in GLSL (GL shading language)

In Codea shaders can be used in various places to customise rendering including meshes, entities, sprites, backgrounds and post processing effects

.. code-block:: lua

   myShader = shader(vsh, fsh)

   myMesh.shader = myShader

   myMaterial = material(shader)

   myMesh.material = myMaterial

   sprite(myShader, x, y, w, h)

   background(myShader)

.

   WARNING: Shaders live very close to the hardware and are much more likely to cause crashes or graphical corruption when things go wrong, you have been warned ;)

Graphics Pipeline
-----------------

``TODO``

Vertex Shaders
--------------

Each vertex within a mesh is passed to the GPU via the vertex processing stage, where various calculations can be performed to control the final appearance

Fragment Shaders
----------------

After the vertex processing stage, the fragment processing stage begins. Primtives assembled from vertices, such as triangles, are drawn on to the framebuffer in a process known as rasterization. 

The fragment shader is able to calculate the final output of this stage (typically the color and/or depth of the fragment)

Compute Shaders
---------------

Compute shaders bypass the normal rasterisation stage, useful for more general purpose computations

More info: https://www.khronos.org/opengl/wiki/Compute_Shader

.. code-block:: lua
   
   myComputeShader = shader.compute
   [[
      #version 430
      #include <codea/common.glsl>

      NUM_THREADS(1, 1, 1)
      void main()
      {
      }
   ]]

Threading Model
^^^^^^^^^^^^^^^

Workgroups
""""""""""

``NUM_THREADS(x, y, z)``

``gl_GlobalInvocationID``

Dispatch
""""""""

``TODO``

Image Properties
^^^^^^^^^^^^^^^^

``TODO``

Buffers
^^^^^^^

Also known as SSBOs (Shader Storage Buffer Objects)

``TODO``


Shader Definitions
------------------

Shader definitions are Lua tables that define all the settings of a shader. These can be used for fine-grained control over shader behaviour

Anatomy of a Shader Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A shader definition is broken into several parts:

* options - enable and disable specific parts of a shader
* properties - values passed into the shader (via uniforms)
* passes - one ore more passes that contain shader code and settings

   NOTE: shaders can either have an array of ``passes`` or a single ``pass``

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

Properties
""""""""""

Each property is a Lua table with the following form: 

``{<name>, <type>, <value>, ...}``

``<name>`` a string identifier for the property, this should be treated like a lua identifier (starts with an underscore or letter, followed by a sequence of alphanumeric characters and underscores and no spaces or funny symbols)

The property name directly links to a shader uniform in one or more passes

``<type>`` is a string containing the type of property, corresponding to a GLSL uniform type

.. list-table:: Property Types
   :widths: 50 50
   :header-rows: 1

   * - Type Name
     - GLSL type
   * - ``"float"``
     - ``float``
   * - ``"bool"``
     - ``bool``
   * - ``"vec2"``
     - ``vec2``
   * - ``"vec3"``
     - ``vec3``
   * - ``"vec4"``
     - ``vec4``
   * - ``"texture"``
     - ``sampler2D``

``<value>`` is the initial value of the property

Additional property settings are available, such as

- ``color = true``
- ``range = {low, high}``
- ``onSet = function(...) end``

Options
"""""""

Options let you conditionally enable/disable chunks of shader code via the shader macro preprocessor (i.e. ``#if`` and ``#ifdef``). This is useful when creating optional features and uber shaders where expensive operations can be skipped if not currently in use

``<name> = {<default>, ...}``

Options can be linked to specific properties or based complex conditions

``TODO``

Passes
""""""

``TODO``

Materials
---------

Shaders can be re-used in multiple meshes/entities but will retain their current state globally. Setting properties on a shader in one place will effect rendering on all objects they are attached to

This is where materials come in. Placing a shader within a material isntance and passing that to various objects will allow for the same shader to be used with different state (properties) as many times are needed

The Standard Shader
-------------------

For convenience there is a built-in uber-shader, called the standard shader which contains a large number of shading options

For more details see: :lua:func:`material.unlit` and :lua:func:`material.lit`

Surface Shaders
^^^^^^^^^^^^^^^

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

Shading Models
""""""""""""""

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

Shade Pro Integration
^^^^^^^^^^^^^^^^^^^^^

``TODO``

Shader Builder
^^^^^^^^^^^^^^
