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

      Create a new directional light. Directional lights simulate a distant light source (like the sun) that casts parallel rays in a given direction and supports shadow mapping.

      :param direction: The direction vector the light casts in world space, defaults to ``vec3(0, -1, 0)``
      :type direction: vec3

      :return: A new directional light
      :rtype: light

      .. code-block:: lua

         sun = scn:entity("sun")
         sunLight = sun:add(light.directional(vec3(0, -1, 0)))
         sunLight.castShadows = true

      .. helptext:: create a new directional light

   .. lua:staticmethod:: light.point([position])

      Create a new positional point light that radiates in all directions from a given position.

      *Note: point lights are not currently supported by the renderer*

      :param position: The world-space position of the light source, defaults to the origin
      :type position: vec3

      :return: A new point light
      :rtype: light

      .. helptext:: create a new point light

   .. lua:staticmethod:: light.spot([position, direction])

      Create a new spot light that emits a cone of light from a position toward a direction.

      *Note: spot lights are not currently supported by the renderer*

      :param position: The world-space position of the light source, defaults to the origin
      :type position: vec3
      :param direction: The direction the cone points in world space, defaults to ``vec3(0, -1, 0)``
      :type direction: vec3

      :return: A new spot light
      :rtype: light

      .. helptext:: create a new spot light

   .. lua:staticmethod:: light.push(light)

      Pushes a light source onto the immediate mode rendering stack.

      This applies basic lighting to 3D objects with lit materials for all subsequent draw calls until ``light.pop()`` is called. Immediate mode lighting does not support advanced features such as shadows — use scene-based lights for those.

      :param light: The light to push onto the rendering stack
      :type light: light

      :return: The same light for chaining
      :rtype: light

      .. helptext:: push a light source onto the rendering stack

   .. lua:staticmethod:: light.pop()

      Pops a light source from the rendering stack

      .. helptext:: pop a light source from the rendering stack
   
   .. lua:staticmethod:: light.clear()

      Clears all lights from the rendering stack

      .. helptext:: clear all lights from the rendering stack

   .. lua:attribute:: type: enum

      Get/set the type of light. Possible values are:

      * `DIRECTIONAL`
      * `POINT`
      * `SPOT`
      * `ENVIRONMENT`

      .. helptext:: get or set the type of light

   .. lua:attribute:: intensity: number

      The intensity of the light source

      .. helptext:: get or set the intensity of the light

   .. lua:attribute:: color: color

      The color of the light source

      .. helptext:: get or set the light color

   .. lua:attribute:: castShadows: boolean

      Enables/disables shadow casting. Cascaded shadow mapping works for a single directional light source

      *note: shadows currently only work with directional lights*

      .. helptext:: get or set whether the light casts shadows

   .. lua:attribute:: shadowOptions: light.shadowOptions [readonly]

      Get the shadow options for this light

      *note: shadows currently only work with directional lights*

      .. helptext:: get the shadow options for this light

   .. lua:class:: shadowOptions

      .. lua:attribute:: cascades: integer

         The number of shadow cascades to used in rendering. The maximum number of cascades is 5

         .. helptext:: get or set the number of shadow cascades

      .. lua:attribute:: size: integer

         The size of the cascade textures to use when rendering. High values result in more detailed shadows at the cost of memory and rendering performance

         .. helptext:: get or set the shadow map size
         
      .. lua:attribute:: constantBias: number

         This attribute represents the constant bias applied to the depth values during shadow map comparisons. It helps in reducing self-shadowing artifacts by offsetting the comparison depth slightly. The default value is set to 0.001

         .. helptext:: get or set the constant shadow bias

      .. lua:attribute:: normalBias: number

         This attribute denotes the normal bias applied during shadow map comparisons. Normal bias helps in mitigating surface acne by adjusting the depth comparison based on surface normals. The default value is set to 0.1

         .. helptext:: get or set the normal shadow bias

      .. lua:attribute:: far: number

         The far clipping plane distance for the shadow map rendering. It defines the maximum distance up to which shadows will be calculated. The default value is set to 0.0, implying no limit by default

         .. helptext:: get or set the far shadow distance

      .. lua:attribute:: nearHint: number

         A hint for the near clipping plane distance for shadow map rendering. It suggests the minimum distance from the camera to start shadow map calculations efficiently. The default value is set to 1

         .. helptext:: get or set the near shadow distance hint

      .. lua:attribute:: farHint: number

         Similar to 'nearHint', this provides a hint for the far clipping plane distance for shadow map rendering. It suggests the maximum distance from the camera for efficient shadow map calculations. The default value is set to 100

         .. helptext:: get or set the far shadow distance hint

      .. lua:attribute:: polygonOffsetConstant: number [default = 0.5]
                  
         This represents the constant factor used in polygon offset calculations. It adjusts the depth values of rendered polygons to resolve depth fighting issues. The default value is set to 0.5

         .. helptext:: get or set the polygon offset constant

      .. lua:attribute:: polygonOffsetSlope: number [default = 2.0]
         
         Denotes the slope factor used in polygon offset calculations. It works in conjunction with the constant factor to provide precise depth adjustments for polygons. The default value is set to 2.0

         .. helptext:: get or set the polygon offset slope
      
