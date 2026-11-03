Shaders and Materials
=====================

Shaders are programs that run on the GPU. Use a material shader to change how a surface looks, or a compute shader to update an image or many particle positions in parallel. The projects below move from reusable material chunks to complete GPU simulations.

Codea shaders are written in GLSL (GL shading language)

In Codea shaders can be used in various places to customise rendering including meshes, entities, sprites, backgrounds and post processing effects

.. code-block:: lua

   myShader = shader(vsh, fsh)

   myMesh.shader = myShader

   myMaterial = material(shader)

   myMesh.material = myMaterial

   sprite(myShader, x, y, w, h)

   background(myShader)

Start with shader.builder() for materials. Use an explicit shader definition when you need a compute pass or control over vertex and fragment stages.

Graphics Pipeline
-----------------

A mesh supplies vertices and indices. The vertex shader transforms each vertex, then the GPU assembles triangles and interpolates values across them. The fragment shader produces a color for each covered pixel. Materials combine these shader programs with values such as colors and textures. Compute shaders run separately and can prepare images or buffers that later drawing commands consume.

Vertex Shaders
--------------

Each vertex within a mesh is passed to the GPU via the vertex processing stage, where various calculations can be performed to control the final appearance

Fragment Shaders
----------------

After the vertex processing stage, the fragment processing stage begins. Primitives assembled from vertices, such as triangles, are drawn on to the framebuffer in a process known as rasterization.

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

``NUM_THREADS(x, y, z)`` declares the number of threads in each workgroup. ``gl_GlobalInvocationID`` identifies a thread across the entire dispatch. Threads in a workgroup can share memory and synchronize with barriers; independent workgroups must not rely on execution order.

Dispatch
""""""""

Call shader:workgroupSize() to read the local thread dimensions, then divide your image dimensions or buffer length by those sizes and round up. shader:dispatch() takes the number of workgroups. Test gl_GlobalInvocationID against the actual data dimensions inside the shader so extra invocations do not access past the end.

Image Properties
^^^^^^^^^^^^^^^^

Declare an image2D property and bind an image with shader:setImage(). Use image.pixel(width, height, ...) for a simulation grid: image() uses display-scaled dimensions, whereas compute invocation IDs address physical texels. The GLSL layout format must match the image format, such as rgba16f. Use readonly for a previous state and writeonly for a next state. A simulation that reads neighbors needs two images: swap them after each dispatch, as in Reaction Diffusion below.

Buffers
^^^^^^^

Also known as SSBOs (Shader Storage Buffer Objects)

A shader.buffer holds structured data shared by compute and drawing shaders. Define a matching bufferLayout on the Lua side and a struct in GLSL. The Particles project stores one vec4 per instance: position in xy and velocity in zw. Its compute shader updates the data and its vertex shader reads it using gl_InstanceID.


Shader Definitions
------------------

Shader definitions are Lua tables that define all the settings of a shader. These can be used for fine-grained control over shader behaviour

Anatomy of a Shader Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A shader definition is broken into several parts:

* options - enable and disable specific parts of a shader
* properties - values passed into the shader (via uniforms)
* passes - one or more passes that contain shader code and settings

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

A mesh supplies vertices and indices. The vertex shader transforms each vertex, then the GPU assembles triangles and interpolates values across them. The fragment shader produces a color for each covered pixel. Materials combine these shader programs with values such as colors and textures. Compute shaders run separately and can prepare images or buffers that later drawing commands consume.

Passes
""""""

A mesh supplies vertices and indices. The vertex shader transforms each vertex, then the GPU assembles triangles and interpolates values across them. The fragment shader produces a color for each covered pixel. Materials combine these shader programs with values such as colors and textures. Compute shaders run separately and can prepare images or buffers that later drawing commands consume.

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

A mesh supplies vertices and indices. The vertex shader transforms each vertex, then the GPU assembles triangles and interpolates values across them. The fragment shader produces a color for each covered pixel. Materials combine these shader programs with values such as colors and textures. Compute shaders run separately and can prepare images or buffers that later drawing commands consume.

Shader Builder
^^^^^^^^^^^^^^

Simulating a grid with compute shaders
--------------------------------------

Drag across the grid to paint. The **Controls** panel selects the material, brush size, and whether the brush creates a continuing source. One texture holds the current state and another receives the next state; swapping them after dispatch avoids reading partially updated neighbors. The mesh displays that state using the bundled rock, water, and lava images.

.. codea-example:: Simulating a grid with compute shaders
   :project: code/Modern/Shader 06 - Sand Sim.codea

Composing reusable shader chunks
--------------------------------

Orbit the sphere to inspect its raymarched marble and animated rim highlight. The ground combines a checkerboard, normal map, and moving cloud shadow. shader.chunk() packages reusable declarations and GLSL; shader.builder():add() combines them into a material. Start with the checkerboard chunk before experimenting with the more involved marble function.

.. codea-example:: Composing reusable shader chunks
   :project: code/Modern/Shader 07 - Materials.codea

Updating neighboring pixels safely
----------------------------------

Touch the image to seed a reaction-diffusion pattern. Each compute dispatch reads the previous texture and writes a separate next texture, then swaps them. Neighbor reads clamp to the image boundary. The two-tab project separates input and display from the simulation class. Try changing feed and kill rates in ReactionDiffusion.lua to explore different patterns.

.. codea-example:: Updating neighboring pixels safely
   :project: code/Modern/Shader 08 - Reaction Diffusion.codea

.. literalinclude:: /code/Modern/Shader 08 - Reaction Diffusion.codea/ReactionDiffusion.lua
   :language: lua
   :caption: ReactionDiffusion.lua — simulation, texture swapping, and visualization

Sharing a GPU buffer between compute and drawing
------------------------------------------------

Ten thousand particles share one instance buffer. A compute shader changes position and velocity, then an instanced mesh reads that same buffer to draw every particle. Touch to move the selected attractor and use the parameters to adjust its range and strength. The compute shader checks instanceCount because the last workgroup can contain unused threads.

.. codea-example:: Sharing a GPU buffer between compute and drawing
   :project: code/Modern/Shader 09 - Particles.codea

Animating instanced grass on terrain
------------------------------------

Orbit the terrain and use the parameters to change wind, blade shape, and colors. Terrain.lua creates a height map; Grass.lua uses it to place instances and bends their vertices using wind noise. Increase density gradually: doubling density creates four times as many blades. The project bundles the grass mesh and textures, and does not require the camera sensor.

.. codea-example:: Animating instanced grass on terrain
   :project: code/Modern/Shader 10 - Grass.codea

.. literalinclude:: /code/Modern/Shader 10 - Grass.codea/Terrain.lua
   :language: lua
   :caption: Terrain.lua — generating and displaying the height map

.. literalinclude:: /code/Modern/Shader 10 - Grass.codea/Grass.lua
   :language: lua
   :caption: Grass.lua — placing and animating instances
