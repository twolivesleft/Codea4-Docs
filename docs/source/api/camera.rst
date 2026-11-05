Camera
======


.. lua:class:: camera

   A camera object used for rendering. Can also be used as a component in scenes

   .. code-block:: lua

      scn = scene()
      -- Create an entity and attach a perspective camera to it
      cam = scn:entity():add(camera.perspective(45, 0.1, 100))

   .. code-block:: lua

      -- Use a camera directly with drawing calls
      cam = camera.perspective(45, 0.1, 100)
      cam:apply()

   .. lua:staticmethod:: ortho(size[, near, far])

      .. helptext:: create an orthographic camera

      :return: A new orthographic camera
      :rtype: camera

   .. lua:staticmethod:: perspective(fov[, near, far])

      .. helptext:: create a perspective camera

      :return: A new perspective camera
      :rtype: camera

   .. lua:attribute:: isOrtho: boolean

      Determines if the camera is orthographic or perspective

      .. helptext:: whether the camera is orthographic

   .. lua:attribute:: orthoSize: number

      The ortho graphic size (height) of this camera when in orthographic mode

      .. helptext:: orthographic height of the camera

   .. lua:attribute:: clearMode: enum

      The clear mode, which can be one of the following values:

      * ``camera.none`` - do not clear the background
      * ``camera.color`` - clear the color only
      * ``camera.depth`` - clear the depth only
      * ``camera.depthAndColor`` - clear both the depth and color

      .. helptext:: how the camera clears the view

   .. lua:attribute:: clearColor: color

      The color to use when clearing the screen with this camera

      .. helptext:: clear color of the camera

   .. lua:attribute:: fieldOfView: number

      The field of view for this camera when in perspective mode

      .. helptext:: field of view of the camera

   .. lua:attribute:: nearPlane: number

      The distance of near view plane from the view origin

      .. helptext:: distance to the near plane

   .. lua:attribute:: farPlane: number

      The distance of far view plane from the view origin

      .. helptext:: distance to the far plane

   .. lua:attribute:: priority: integer

      The priority of the camera when used within a scene (cameras with lower values are drawn first)

      .. helptext:: draw order priority of the camera

   .. lua:attribute:: projection: mat4

      Sets/gets a custom projection matrix

      .. helptext:: custom projection matrix

   .. lua:attribute:: view: mat4

      Sets/gets a custom view matrix

      .. helptext:: custom view matrix

   .. lua:attribute:: viewport: vec4

      Sets/gets the current viewport using normalized coordinates. Can be used for adjusting the rendered area of the camera relative to the screen. For instance, writing ``camera.viewport = vec4(0.0, 0.0, 0.5, 1.0)`` will render the camera to only the left half of the screen.

      - ``x``: The x position of the viewport
      - ``y``: The y position of the viewport
      - ``z``: The width of the viewport
      - ``w``: The height of the viewport

      .. helptext:: normalized viewport of the camera

   .. lua:attribute:: aspect: number

      Sets/gets the aspect ratio of the viewport

      .. helptext:: aspect ratio of the viewport

   .. lua:method:: apply()

      Apply this cameras settings to the matrix stack

      .. helptext:: apply the camera to the matrix stack

   .. lua:method:: screenToWorld(x, y, z)

      Takes a 2D point on the screen (in points) and a depth value and unprojects this point into 3D space. Useful for things like raycasting from touches

      .. helptext:: convert screen coordinates to world space

      :return: The point at screen position ``x``, ``y`` projected ``z`` units into the screen in world space
      :rtype: number, number, number

   .. lua:method:: screenToRay(x, y)

      Takes a 2D point on the screen (in points) and returns a ray that starts at the camera and points through that point into the scene. Use it with raycasts to find what is under a touch

      .. code-block:: lua

         function touched(touch)
            local origin, dir = scene.main.camera:get(camera):screenToRay(touch.x, touch.y)
            local hit = scene.main.world3d:raycast(origin, dir, 100)
         end

      .. helptext:: convert a screen point to a ray

      :return: The origin of the ray and its direction (normalized)
      :rtype: vec3, vec3

   .. lua:method:: worldToScreen(x, y, z)

      Takes a 3D point in world space and projects it onto screen coordinates (in points)

      .. helptext:: convert world coordinates to screen space

      :return: The point in world space (``x``, ``y``, ``z``) projected onto the screen
      :rtype: number, number, number
   

   .. lua:attribute:: effectsEnabled: boolean

      Enable post-processing for this camera. Defaults to ``true``. Set to
      ``false`` for a reflection or other secondary draw, then restore it.
      Settings and custom effects are retained while disabled. Effects are only
      used when the camera renders a scene; ``cam:apply()`` alone applies matrices.

      .. helptext:: enable or bypass camera post-processing

   .. lua:attribute:: bloom: table [readonly]

      Read-only settings object; change its fields rather than replacing it.
      Bloom spreads bright parts of the camera image into a glow. A strength of
      zero skips the bloom passes. The camera renders into a floating-point image
      before finishing, preserving brightness above white.

      .. helptext:: configure glow around bright parts of the image

      :param strength: Glow amount; defaults to 0 (off). Start with 0.5 and increase to taste.
      :type strength: number
      :param threshold: Brightness cutoff; defaults to 0.9. Lower values include more of the picture.
      :type threshold: number

   .. lua:attribute:: tiltShift: table [readonly]

      Read-only settings object; change its fields rather than replacing it.
      Blur increases away from a sharp horizontal band. Coordinates for the band
      are fractions of the camera image height, measured from the bottom.
      A blur of zero skips tilt shift. This is an image-space effect, not a
      depth-of-field simulation.

      .. helptext:: configure a sharp band with blur above and below it

      :param blur: Maximum blur radius in points; defaults to 0 (off).
      :type blur: number
      :param focus: Vertical center of the sharp band; defaults to 0.5.
      :type focus: number
      :param range: Half-height of the sharp band; defaults to 0.12.
      :type range: number
      :param falloff: Distance beyond the band over which blur reaches its maximum; defaults to 0.4.
      :type falloff: number

   .. lua:attribute:: saturation: number

      Color saturation, default 1. Use 0 for grayscale, values between 0 and 1
      for muted color, and values above 1 for stronger color.

      .. helptext:: adjust camera color saturation

   .. lua:attribute:: vignette: number

      Darkening toward the image edges, default 0 (off). Start with a small
      positive value such as 0.2 and adjust for the image. Values are not clamped
      by the setter.

      .. helptext:: darken the edges of the camera image

   .. lua:attribute:: grain: number

      Animated film-grain strength, default 0 (off). Small positive values such
      as 0.02 add subtle noise. Values are not clamped by the setter.

      .. helptext:: add animated grain to the camera image

   .. lua:method:: addEffect(source)

      Compile a fragment-shader body and append it to this camera's custom
      effect chain. Returns the shader, which can be used to set uniforms or
      remove the effect later. Effects run in insertion order, after tilt shift,
      bloom and color grading. Intermediate custom-effect images are RGBA8;
      ``scene`` still provides the original floating-point camera image.

      The supplied body has ``uv`` (texture coordinates), ``FragColor`` (output),
      ``source`` (sampler2D containing the previous stage), ``resolution``
      (vec4: pixel width, pixel height, inverse width, inverse height), and
      ``time`` (seconds) declared for it. Declare ``uniform sampler2D scene;``
      to sample the camera image before any effects. Write all four components
      of ``FragColor``, preserving alpha when compositing cameras.

      If the source contains ``#version``, it is treated as a complete fragment
      shader: provide the declarations yourself. Effect passes disable depth
      testing and depth writes and manage their own blend state.

      .. helptext:: append a custom full-screen fragment effect

      :param source: GLSL fragment body, or a complete fragment shader with a version declaration.
      :type source: string
      :return: The appended effect shader.
      :rtype: shader

      .. code-block:: lua

         local effect = cam:addEffect([[
         uniform sampler2D scene;
         void main() {
             vec4 processed = texture(source, uv);
             vec4 original = texture(scene, uv);
             // Keep the center sharp while retaining effects at the edges.
             float edge = smoothstep(0.15, 0.5, length(uv - vec2(0.5)));
             FragColor = mix(original, processed, edge);
         }
         ]])

   .. lua:method:: addEffect(effect)

      Append an existing shader and return it. It must render a full-screen
      image using the effect vertex layout and declare a ``source`` sampler.
      ``resolution`` and ``scene`` are supplied when declared. The shader
      returned by the source-string overload can be reused with another camera.
      Uniforms are shared when the same shader instance is reused.

      .. helptext:: append an existing camera effect shader

      :param effect: Full-screen effect shader.
      :type effect: shader
      :return: The same shader instance.
      :rtype: shader

   .. lua:method:: removeEffect(effect)

      Remove every occurrence of this shader from this camera's custom chain.
      Does nothing if it is absent. Built-in effect settings are unchanged.

      .. helptext:: remove a custom camera effect

      :param effect: Shader previously returned by ``addEffect``.
      :type effect: shader

   .. lua:method:: clearEffects()

      Remove all custom shaders from this camera. Bloom, tilt shift, saturation,
      vignette and grain settings are unchanged. Use ``effectsEnabled = false``
      to bypass both built-in and custom effects without discarding settings.

      .. helptext:: remove all custom camera effects

   .. lua:attribute:: bloom.strength: number

      Glow amount, default 0 (off). Positive values add bloom.

      .. helptext:: glow amount

   .. lua:attribute:: bloom.threshold: number

      Brightness cutoff for bloom, default 0.9. Lower values include more of the image.

      .. helptext:: brightness cutoff for bloom

   .. lua:attribute:: tiltShift.blur: number

      Maximum blur radius in points, default 0 (off).

      .. helptext:: maximum blur radius in points

   .. lua:attribute:: tiltShift.focus: number

      Center of the sharp band as a fraction of image height from the bottom, default 0.5.

      .. helptext:: center of the sharp band as a fraction of image height from the bottom

   .. lua:attribute:: tiltShift.range: number

      Half-height of the sharp band as a fraction of image height, default 0.12.

      .. helptext:: half-height of the sharp band as a fraction of image height

   .. lua:attribute:: tiltShift.falloff: number

      Distance outside the sharp band over which blur reaches its maximum, default 0.4.

      .. helptext:: distance outside the sharp band over which blur reaches its maximum
