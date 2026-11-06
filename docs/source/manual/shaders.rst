Shaders and Materials
=====================

Shaders run on the graphics processor (GPU). Use them to change a surface’s color, texture, or shape, or to update many pixels or particles at once.

Codea shaders are written in GLSL. You can use them with meshes, sprites, backgrounds, and camera effects.

.. code-block:: lua

   myShader = shader(vsh, fsh)

   myMesh.shader = myShader

   myMaterial = material(shader)

   myMesh.material = myMaterial

   sprite(myShader, x, y, w, h)

   background(myShader)

Start with ``shader.builder()`` to create a material. Use a shader definition when you need a compute shader or direct control over vertex and fragment shaders.

Graphics Pipeline
-----------------

Drawing a mesh has two main stages: a vertex shader positions its vertices, and a fragment shader colors the pixels covered by its triangles.

Vertex Shaders
--------------

A vertex shader sets each vertex’s position on screen. Change it to bend grass, ripple a surface, or move particles. It can also pass values such as colors and texture coordinates to the fragment shader.

Fragment Shaders
----------------

The GPU fills in the triangles between vertices and blends the values passed from their corners. A fragment shader uses these values to calculate each covered pixel’s color and, optionally, its depth.

Compute Shaders
---------------

Compute shaders update data without drawing triangles. Use them for image effects, particle motion, or simulations.

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

``shader:dispatch()`` runs a given number of workgroups. Divide the image dimensions or buffer length by ``shader:workgroupSize()`` and round up. Check ``gl_GlobalInvocationID`` against the data size in your shader, since the last group may contain extra threads.

Image Properties
^^^^^^^^^^^^^^^^

Declare an ``image2D`` property and attach an image with ``shader:setImage()``. Use ``image.pixel(width, height, ...)`` for a simulation grid so its size is in pixels rather than display points. The GLSL format, such as ``rgba16f``, must match the image.

When a simulation reads neighboring pixels, read from one image and write to another, then swap them. Mark them ``readonly`` and ``writeonly`` in the shader. The reaction-diffusion example below shows this.

Buffers
^^^^^^^

A ``shader.buffer`` holds data that compute and drawing shaders can share. Define a matching ``bufferLayout`` in Lua and ``struct`` in GLSL. The particle example stores position in ``xy`` and velocity in ``zw`` of a ``vec4``. Its compute shader updates these values; its vertex shader reads them using ``gl_InstanceID``.


Shader Definitions
------------------

A shader definition is a Lua table containing its code and settings.

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

``<name>`` names the property. Start with a letter or underscore, followed by letters, digits, or underscores.

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

Options turn parts of a shader on or off using ``#if`` and ``#ifdef``. Use them for features that you want to skip when they are not needed.

``<name> = {<default>, ...}``

Options can also depend on properties or conditions.

Passes
""""""

Each pass contains shader code and its drawing settings. Use ``pass`` for a single pass or ``passes`` for a list of passes.

Materials
---------

Objects that share a shader also share its property values. Give each object a separate material to use the same shader with different colors, textures, or other settings.

The Standard Shader
-------------------

Use the built-in standard shader for common surface effects, including lighting and textures.

For more details see: :lua:func:`material.unlit` and :lua:func:`material.lit`

Surface Shaders
^^^^^^^^^^^^^^^

Surface shaders let you describe a surface’s color, roughness, and other properties while Codea handles the lighting. Set ``shadingModel`` in the shader definition, then provide ``vertex`` and ``material`` functions to change its shape and appearance.

The shading models are based on Google’s Filament: https://google.github.io/filament/Materials.html

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

Shader Builder
^^^^^^^^^^^^^^

Use ``shader.builder()`` to assemble a shader by chaining commands. Package reusable pieces with ``shader.chunk()`` and combine them with ``add()``. See :doc:`/api/shader` for the builder commands and the example below for shader chunks.

Simulating a grid with compute shaders
--------------------------------------

Drag across the grid to paint. The **Controls** panel selects the material, brush size, and whether the brush creates a continuing source. One texture holds the current state and another receives the next state; swapping them after dispatch avoids reading partially updated neighbors. The mesh displays that state using the bundled rock, water, and lava images.

.. codea-example:: Simulating a grid with compute shaders
   :project: code/Modern/Shader 06 - Sand Sim.codea

Composing reusable shader chunks
--------------------------------

Drag to orbit a marble sphere with a glowing rim. The ground combines a checkerboard, a normal map, and a moving cloud shadow. Each effect is a reusable shader chunk; try changing the checkerboard colors first.

.. codea-example:: Composing reusable shader chunks
   :project: code/Modern/Shader 07 - Materials.codea

Updating neighboring pixels safely
----------------------------------

Touch to start a reaction-diffusion pattern. Each step reads one image and writes to another, then swaps them, so neighboring pixels are read before they change. Try changing the feed and kill rates in ``ReactionDiffusion.lua`` to explore different patterns.

.. codea-example:: Updating neighboring pixels safely
   :project: code/Modern/Shader 08 - Reaction Diffusion.codea

.. literalinclude:: /code/Modern/Shader 08 - Reaction Diffusion.codea/ReactionDiffusion.lua
   :language: lua
   :caption: ReactionDiffusion.lua — simulation, texture swapping, and visualization

Sharing a GPU buffer between compute and drawing
------------------------------------------------

Touch to attract ten thousand particles. A compute shader updates their positions and velocities in a shared buffer, which a mesh reads to draw them. Adjust the attraction range and strength in **Controls**. The shader checks ``instanceCount`` to skip unused threads in the last workgroup.

.. codea-example:: Sharing a GPU buffer between compute and drawing
   :project: code/Modern/Shader 09 - Particles.codea

Animating instanced grass on terrain
------------------------------------

Drag to orbit the terrain and use **Controls** to change the wind, grass shape, and colors. ``Terrain.lua`` creates a height map; ``Grass.lua`` places and bends the grass. Increase density gradually: doubling it creates four times as many blades.

.. codea-example:: Animating instanced grass on terrain
   :project: code/Modern/Shader 10 - Grass.codea

.. literalinclude:: /code/Modern/Shader 10 - Grass.codea/Terrain.lua
   :language: lua
   :caption: Terrain.lua — generating and displaying the height map

.. literalinclude:: /code/Modern/Shader 10 - Grass.codea/Grass.lua
   :language: lua
   :caption: Grass.lua — placing and animating instances
