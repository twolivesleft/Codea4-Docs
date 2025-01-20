mesh
====

.. code-block:: lua
   :caption: Creating and drawing a basic mesh

   function setup()
      -- create a sphere mesh
      msh = mesh.sphere()
   end

   function draw()
      background(64)
      -- draw the mesh every frame
      msh:draw()
   end

.. lua:class:: mesh

   Represents a drawable shape made of vertices and primitives (typically triangles)

   *Vertices*

   Each vertex contains a number of attributes:

   - position (vec3) - the position
   - normal (vec3) - the surface normal orientation
   - tangent (vec4) - the tangent to the surface normal (automatically calculated)
   - uv (vec2) - the texture coordinate (uv) of the vertex
   - color - the color
   - boneWeights - the weight of each bone's influence on this vertex (used for skinning)
   - boneIndices - the index of each bone that can influence this vertex (used for skinning)

   These attributes can be get/set directly by setting all of them at once via tables (i.e. ``msh.positions = {...}``) or by using methods that set attributes one vertex at a time (i.e. ``msh:position(i, p)``)

   *Triangle Meshes*

   A triangle mesh is drawn using its vertices which are connected using triangles primitives. Every group of consecutive three indices make up an individual triangle

   There are plans to add more primitive types such as ``points``, ``lines``, ``triangle fans`` and ``triangle strips``

   *Shaders and Materials*
   
   Both shaders and materials can be applied to a mesh. Setting a shader/material will override any previous shaders/materials on the mesh

   When no shader/material is set, the default unlit mesh material will be used instead

   *Sub-Meshes*

   A mesh consists of one or more sub-meshes, each of which can have a distinct shader/material. The ``submeshIndex`` property can be used to switch between the current active submeshes for mesh editing purposes

   *Bones*
   
   ``TODO``

   .. lua:staticmethod:: mesh([submeshCount])

      Create an empty mesh

      :param submeshCount: The number of submeshes that this mesh will be created with (optoinal)
      :type submeshCount: integer

   .. lua:staticmethod:: mesh.read(key)

      Loads a mesh from a file

      The following mesh formats are currently supported:
      
      - ``GLTF`` / ``GLB``
      - ``FBX``
      - ``OBJ``
      - ``STL``

      Skinned animations are supported but morph targets are currently not

      Saving meshes is not currently supported
      
      :param key: The asset key to load

   .. lua:attribute:: texture: image

      The mesh texture, used by the default mesh shader (and accessible to custom shaders as well) for basic surface textures

   .. lua:attribute:: shader: shader

      Custom shader for this mesh, used when ``mesh:draw()`` is invoked

   .. lua:attribute:: material: material

      The same as assigning a shader but with a material instead

   .. lua:attribute:: submeshIndex: integer

      The current sub-mesh index. Useful for multi-material meshes

   .. lua:attribute:: submeshCount: integer
   
      The total number of sub-meshes within this mesh

   .. lua:attribute:: vertexCount: integer

      The total number of vertices in the currently selected sub-mesh

      *3.x compatiblity note: This was originally called* ``count``

   .. lua:attribute:: indexCount: integer

      The total number of indices in the currently selected sub-mesh

      *3.x compatiblity note: meshes originally did not contain indices and therefore did not have an index count*

   .. lua:attribute:: bounds: bounds.abbb

      The local bounds of this mesh (no scaling or rotation applied)

   .. lua:attribute:: positions: table<vec3>

      Gets/sets the positions of the mesh vertices

   .. lua:attribute:: normals: table<vec3>      

      Gets/sets the normals of the mesh vertices

   .. lua:attribute:: colors: table<color>

      Gets/sets the colors of the mesh vertices

   .. lua:attribute:: uvs: table<vec2>                  

      Gets/sets the uvs of the mesh vertices

   .. lua:attribute:: indices: table<integer>

      Gets/sets the indices of the mesh

   .. lua:attribute:: vertices: table<vec2|vec3>

      Gets/sets the positions of the mesh vertices while also ensuring that each set of three indices match their corresponding vertices

      *3.x compatiblity note: works the same as the original vertices property*

   .. lua:attribute:: texCoords: table<vec2>                  

      Gets/sets the uvs of the mesh vertices

      *3.x compatiblity note: works the same as the uvs property for the sake of backwards compatiblity*

   .. lua:attribute:: root: entity

      Meshes loaded via ``mesh.read()`` may contain sub-objects and bones used for animations, these can be accessed as entities in a simple scene-like hierarchy

      *WARNING: do not attempt to delete any nodes within the root as it may have unintended side effects*

   .. lua:attribute:: animations: table<animation>

      Contains the list of all animations for this mesh

   **Mesh Drawing**

   .. lua:method:: draw([instances])

      Draws the mesh to the screen with the current camera, matrix and context settings

   .. lua:method:: drawIndirect(indirectBuffer[, start = 0, num  = 1])

      Draws the mesh indirectly using ``indirectBuffer``

      Used in combination with compute shaders for indirect drawing operations

   **Mesh Manipulation**

   .. lua:method:: addRect(position, size[, rotation, uvRect])

      Appends a 2D rectangle to this mesh centered at ``position`` with the size of ``size``, rotation of ``rotation`` (in degrees) and the uv rectangle ``uvRect``

      *This function supports dynamic number type arguments*

      :return: the index of the new rectangle
      :rtype: integer

   .. lua:method:: setRect(index, position, size[, rotation])

      Sets existing rectangle position, size and rotation using an index from a previous call to ``addRect()``

   .. lua:method:: setRectTex(index, uvRect)      

      Sets existing rectangle uvs using an index from a previous call to ``addRect()``

   .. lua:method:: setRectColor(index, color)            

      Sets existing rectangle color using an index from a previous call to ``addRect()``

   .. lua:method:: resizeVertices(size)

      Sets the number of vertices in the mesh (must be positive)

   .. lua:method:: resizeIndices(size)

      Sets the number of indices in the mesh (must be positive)

   .. lua:method:: addElement(p1, p2, p3[, ...])

      Adds a new element to the mesh consisting of ``N`` indices (i.e. add three indices for a new triangle)

   .. lua:method:: clear()

      Clears the mesh, reducing vertices and indices to zero

   .. lua:method:: position(index)
   .. lua:method:: position(index, position)
   
      Gets/sets the position of the vertex at ``index``

   .. lua:method:: normal(index)      
   .. lua:method:: normal(index, normal)

      Gets/sets the normal of the vertex at ``index``

   .. lua:method:: color(index)      
   .. lua:method:: color(index, color)
   
      Gets/sets the color of the vertex at ``index``

   .. lua:method:: uv(index)      
   .. lua:method:: uv(index, uv)            

      Gets/sets the uv of the vertex at ``index``

   .. lua:method:: index(index)
   .. lua:method:: index(index, i)

      Gets/sets the index at ``index``   

   **Mesh Generation**

   .. lua:staticmethod:: mesh.sphere([radius = 1, slices = 32, segments = 16, sliceStart = 0, sliceSweep = 360, segmentStart = 0, segmentSweep = 180])

      Generates a sphere mesh with various settings
      
      :param radius: The radius of the sphere
      :type radius: number
      :param slices: Subdivisions around the z-azis (longitudes)
      :type slices: number
      :param segments: Subdivisions along the z-azis (latitudes)
      :type segments: number
      :param sliceStart: Counterclockwise angle around the z-axis relative to x-axis
      :type sliceStart: number
      :param sliceSweep: Counterclockwise angle
      :type sliceSweep: number
      :param segmentStart: Counterclockwise angle relative to the z-axis
      :type segmentStart: number
      :param segmentSweep: Counterclockwise angle
      :type segmentSweep: number

   .. lua:staticmethod:: mesh.icoSphere([radius = 1, subdivisions = 4]) 

      Generates an ico-sphere, aka spherical subdivided icosahedron

      :param radius: The radius of the ico-sphere
      :type radius: number
      :param subdivisions: Subdivisions for the ico-sphere
      :type subdivisions: number

   .. lua:staticmethod:: mesh.box([size = vec3(1, 1, 1), segments = vec3(8, 8, 8)])

      Rectangular box centered at origin aligned along the x, y and z axis

      :param size: Half of the side length in x, y and z directions
      :type size: vec3
      :param segments: The number of segments in x, y and z directions
      :type segments: vec3

   .. lua:staticmethod:: mesh.roundedBox([radius = 0.25, size = vec3(1, 1, 1), slices = 4, segments = vec3(8, 8, 8)])

      Rectangular box with rounded edges centered at origin aligned along the x, y and z axis

      :param radius: The corner radius of the rounded edges
      :type radius: number
      :param size: Half of the side length in x, y and z directions
      :type size: vec3
      :param slices: The number of subdivisions in the rounded edges / corners
      :type slices:
      :param segments: The number of segments in x, y and z directions
      :type segments: vec3

   .. lua:staticmethod:: mesh.cone([radius = 1, size = 1, slices = 32, segments = 8, rings = 4, start = 0, sweep = 360])

      A cone with a cap centered at origin pointing towards positive y-axis

      :param radius: Radius of the flat (negative z) end along the xz-plane
      :type radius: number
      :param size: Half of the length of the cone along the y-axis
      :type size: number
      :param slices: Number of subdivisions around the y-axis
      :type slices: integer
      :param segments: Number of subdivisions along the y-axis
      :type segments: integer
      :param rings: Number of subdivisions of the cap
      :type rings: integer
      :param start: Counterclockwise angle around the y-axis relative to the positive x-axis
      :type start: number
      :param sweep: Counterclockwise angle around the y-axis
      :type sweep: number

   .. lua:staticmethod:: mesh.cylinder([radius = 1, size = 1, slices = 32, segments = 8, rings = 4, start = 0, sweep = 360])

      Capped cylinder centered at origin aligned along the y-axis

      :param radius: Radius of the flat (negative z) end along the xz-plane
      :type radius: number
      :param size: Half of the length of the cylinder along the y-axis
      :type segments: number
      :param slices: Number of subdivisions around the y-axis
      :type slices: integer
      :param segments: Number of subdivisions along the y-axis
      :type segments: integer
      :param rings: Number of subdivisions of the cap
      :type segments: integer
      :param start: Counterclockwise angle around the y-axis relative to the positive x-axis
      :type segments: number
      :param sweep: Counterclockwise angle around the y-axis
      :type segments: number

   .. lua:staticmethod:: mesh.capsule([radius = 1, size = 1, slices = 32, segments = 8, rings = 4, start = 0, sweep = 360])

      Capsule centered at origin aligned along the y-axis

      :param radius: Radius of the capsule along the xz-plane
      :type radius: number
      :param size: Half of the length capsule along the y-axis
      :type segments: number
      :param slices: Number of subdivisions around the y-axis
      :type slices: integer
      :param segments: Number of subdivisions along the z-axis
      :type segments: integer
      :param rings: Number of subdivisions on the caps
      :type segments: integer
      :param start: Counterclockwise angle around the y-axis relative to x-axis
      :type segments: number
      :param sweep: Counterclockwise angle around the y-axis
      :type segments: number

   .. lua:staticmethod:: mesh.disk([radius = 1, innerRadius = 1, slices = 32, rings = 4, start = 0, sweep = 360])

      A circular disk centered at origin on the xz-plane

      :param radius: Outer radius of the disk on the xz-plane
      :type radius: number
      :param innerRadius: Radius of the inner circle on the xz-plane
      :type innerRadius: number
      :param slices: Number of subdivisions around the y-axis
      :type slices: integer
      :param rings: Number of subdivisions along the radius
      :type rings: integer
      :param start: Counterclockwise angle relative to the y-axis
      :type start: number
      :param sweep: Counterclockwise angle
      :type sweep: number

   .. lua:staticmethod:: mesh.plane([size = vec2(1, 1), segments = vec2(8, 8)])

      A flat plane centered at the origin on the xy-plane

      :param size: Half of the side length in x and z direction
      :type size: vec2
      :param segments: Number of subdivisions in the x and z directions
      :type segments: vec2

   .. lua:staticmethod:: mesh.torus([minor = 0.25, major = 1, slices = 32, segments = 8, minorStart = 0, minorSweep = 360, majorStart = 0, majorSweep = 360])      

      Generates a torus

      :param minor: Radius of the minor (inner) ring
      :type minor: number
      :param major: Radius of the major (outer) ring
      :type major: number
      :param slices: Subdivisions around the minor ring
      :type slices: integer
      :param segments: Subdivisions around the major ring
      :type segments: integer
      :param minorStart: Counterclockwise angle relative to the xz-plane
      :type minorStart: number
      :param minorSweep: Counterclockwise angle around the circle
      :type minorSweep: number
      :param majorStart: Counterclockwise angle around the y-axis relative to the x-axis
      :type majorStart: number
      :param majorSweep: Counterclockwise angle around the y-axis
      :type majorSweep: number

   .. lua:staticmethod:: mesh.torusKnot([radius = 1, size = 1, slices = 32, segments = 8, rings = 4, start = 0, sweep = 360])            

      Generates a torus knot

      :param p: 
      :type p: number
      :param q: 
      :type q: number
      :param slices:
      :type slices: integer
      :param segments:
      :type segments: integer

   .. lua:staticmethod:: mesh.teapot([subdivisions = 8])            

      Generates the Utah teapot using the original data
      The lid is pointing towards the z axis and the spout towards the x axis

      :param segments:
      :type segments: integer

