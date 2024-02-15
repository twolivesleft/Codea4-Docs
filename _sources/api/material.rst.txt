material
========

.. lua:class:: material

   Materials apply shaders to renderable objects (meshes, sprites, entities, etc), maintaining separate property values per instance. This allows the same shader to be used many times in different places without incurring additional overhead from copying or compiling shader code again

   Materials can also be saved/loaded, although they will need to access to the original shader asset

   **The Standard Material**

   The standard material is built on the standard uber-shader, providing a convenient all purpose material

   .. list-table:: Standard Material Properties
      :widths: 25 20 10 45
      :header-rows: 1

      * - Name
        - Type
        - Models
        - Description
      * - ``shadingModel``
        - ``enum``
        - N/A
        - Current shading model: ``LIT``, ``UNLIT``
      * - ``blend``
        - ``enum``
        - All
        - Current blending mode: ``BLEND_OPAQUE``, ``BLEND_TRANSPARENT``, ``BLEND_ADD``, ``BLEND_MASKED``, ``BLEND_MULTIPLY``, ``BLEND_SCREEN`` 
      * - ``tintBlend``
        - ``enum``
        - All
        - Current tint mode: ``TINT_NONE``, ``TINT_OPAQUE``, ``TINT_TRANSPARENT``, ``TINT_ADD``, ``TINT_MULTIPLY``, ``TINT_SCREEN``
      * - ``tintColor``
        - ``vec4`` (linear color)
        - All
        - Tint color overlay blended using ``tintBlend`` mode
      * - ``color``
        - ``vec4`` (srgb color)
        - All
        - Diffuse albedo color of the surface
      * - ``map``
        - ``texture`` (rgba)
        - All
        - Diffuse albedo color texture map
      * - ``emissive``
        - ``vec4`` (srgb hdr color)
        - All
        - Emissive color of the surface (can be more than 1)
      * - ``emissiveMap``
        - ``texture`` (rgba)
        - All
        - Emissive color texture map
      * - ``scaleOffset``
        - ``vec2``
        - All
        - Scale (``.xy``) and offset (``.zw``) for texture uvs
      * - ``roughness``
        - ``number`` [0..1]
        - Lit
        - Perceptual roughness of the surface
      * - ``roughnessMap``
        - ``texture``
        - Lit
        - Perceptual roughness texture map
      * - ``metallic``
        - ``number`` [0..1]
        - Lit
        - Metalness of the surface
      * - ``metallicMap``
        - ``texture``
        - Lit
        - Metallic texture map
      * - ``normalMap``
        - ``texture`` (linear encoded rgb)
        - Lit
        - Normal texture map in tangent space
      * - ``occlusionMap``
        - ``texture``
        - Lit
        - Ambient occlusion texture map
      * - ``reflectance``
        - ``number``
        - Lit
        - Reflectance of the surface
      * - ``enableClearCoat``
        - ``boolean``
        - Lit
        - Switch to enable/disable clearcoat
      * - ``clearCoat``
        - ``vec2``
        - Lit
        - Clearcoat strength (``.x``) and roughness (``.y``)
      * - ``enableAnisotropy``
        - ``boolean``
        - Lit
        - Switch to enable/disable anisotrophic shading
      * - ``anisotropyDirection``
        - ``vec3``
        - Lit
        - Direction of anisotrophic shading in tangent space
      * - ``anisotropyDirectionMap``
        - ``texture`` (linear encoded rgb)
        - Lit
        - Anisotrophic direction texture map
      * - ``enableRefraction``
        - ``boolean``
        - Lit
        - Switch to enable/disable refraction
      * - ``ior``
        - ``number``
        - Lit
        - Index of refraction
      * - ``refractionType``
        - ``enum``
        - Lit
        - Refraction type: ``REFRACT_SOLID``, ``REFRACT_THIN``
      * - ``refractionMode``
        - ``enum``
        - Lit
        - Refraction mode: ``REFRACT_ENVIRONMENT``, ``REFRACT_SCENE``
      * - ``enableTransmission``
        - ``boolean``
        - Lit
        - Switch to enable/disable transmission
      * - ``absorption``
        - ``boolean``
        - Lit
        - Switch to enable/disable transmission
      * - ``hasCombinedMaps``
        - ``boolean``
        - Lit
        - Switch to enable/disable combined occlusion (``r`` channel), metallic (``g`` channel) and roughness (``b`` channel) maps

   .. lua:staticmethod:: material(shader)

      Create a new material using the supplied :lua:class:`shader` 

   .. lua:staticmethod:: lit()

      Create a default lit material using the standard shader

   .. lua:staticmethod:: unlit()

      Create a default unlit material using the standard shader