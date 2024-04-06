light
=====

Casts a light source onto the 3D environment. Can be used with basic immediate mode rendering or as an entity component in scenes

.. code-block:: lua
   :caption: Using a light as a component in a scene

   function setup()
      -- Create a basic scene with a single directional light source
      scn = scene()    
      sun = scn:entity("sun")
      sun.eulerRotation = vec3(45, 45, 0)      
      sunLight = sun:add(light.directional(vec3(0,-1,0)))
      sunLight.castShadows = true

      -- Add a model to represent the sun
      sun:add(mesh.cone())
      sun.material = material.unlit()
      sun.material.color = color.yellow

      sun.position = vec3(0,3,0)
      
      inspector.add(sun)
      
      cam = scn:entity("camera")
      cam:add(camera.perspective(60))
      cam:add(camera.rigs.orbit)
      cam.z = -10
      
      -- Some stuff to light
      sphere = scn:entity("sphere")
      sphere:add(mesh.sphere())
      
      ground = scn:entity("ground")
      ground:add(mesh.plane())
      ground.y = -1
      ground.uniformScale = 10
      
      scene.main = scn
   end
.. lua:class:: light

   .. lua:staticmethod:: light.directional([direction])

      Create a new directional light

   .. lua:staticmethod:: light.point([position])

      Create a new positional light

      *note: currently not supported by the renderer*

   .. lua:staticmethod:: light.spot([position, direction])

      Create a new positional light

      *note: currently not supported by the renderer*

   .. lua:staticmethod:: light.push(light)

      Pushes a light source onto the rendering stack
      
      This will apply basic lighting to 3D objects with lit materials after the light has been pushed but will not support advanced features such as shadows

   .. lua:staticmethod:: light.pop()

      Pops a light source from the rendering stack
   
   .. lua:staticmethod:: light.clear()

      Clears all lights from the rendering stack

   .. lua:attribute:: type: enum

      Get/set the type of light. Possible values are:

      * `DIRECTIONAL`
      * `POINT`
      * `SPOT`
      * `ENVIRONMENT`

   .. lua:attribute:: intensity: number

      The intensity of the light source

   .. lua:attribute:: color: color

      The color of the light source

   .. lua:attribute:: castShadows: boolean

      Enables/disables shadow casting. Cascaded shadow mapping works for a single directional light source

      *note: shadows currently only work with directional lights*

   .. lua:attribute:: shadowOptions: light.shadowOptions [readonly]

      Get the shadow options for this light

      *note: shadows currently only work with directional lights*

   .. lua:class:: shadowOptions

      .. lua:attribute:: cascades: integer

         The number of shadow cascades to used in rendering. The maximum number of cascades is 5

      .. lua:attribute:: size: integer

         The size of the cascade textures to use when rendering. High values result in more detailed shadows at the cost of memory and rendering performance
         
      .. lua:attribute:: constantBias: number

         This attribute represents the constant bias applied to the depth values during shadow map comparisons. It helps in reducing self-shadowing artifacts by offsetting the comparison depth slightly. The default value is set to 0.001

      .. lua:attribute:: normalBias: number

         This attribute denotes the normal bias applied during shadow map comparisons. Normal bias helps in mitigating surface acne by adjusting the depth comparison based on surface normals. The default value is set to 0.1

      .. lua:attribute:: far: number

         The far clipping plane distance for the shadow map rendering. It defines the maximum distance up to which shadows will be calculated. The default value is set to 0.0, implying no limit by default

      .. lua:attribute:: nearHint: number

         A hint for the near clipping plane distance for shadow map rendering. It suggests the minimum distance from the camera to start shadow map calculations efficiently. The default value is set to 1

      .. lua:attribute:: farHint: number

         Similar to 'nearHint', this provides a hint for the far clipping plane distance for shadow map rendering. It suggests the maximum distance from the camera for efficient shadow map calculations. The default value is set to 100

      .. lua:attribute:: polygonOffsetConstant: number [default = 0.5]
                  
         This represents the constant factor used in polygon offset calculations. It adjusts the depth values of rendered polygons to resolve depth fighting issues. The default value is set to 0.5

      .. lua:attribute:: polygonOffsetSlope: number [default = 2.0]
         
         Denotes the slope factor used in polygon offset calculations. It works in conjunction with the constant factor to provide precise depth adjustments for polygons. The default value is set to 2.0
      
