-- Mesh Example
-- Author: John Millard


function setup()
    print("Hello Mesh!")

    -- Here we create a mesh, just a single triangle
    parameter.integer("triSize", 10, 300, 100)

    -- Create a new empty mesh
    triMesh = mesh()

    -- This is an array of colours we'll assign to the triMesh vertices
    triCol = { color(255, 0, 0, 255),
    color(255, 255, 0, 255),
    color(0, 100, 255, 255)}

    -- Assign colors to the mesh, there must be the same number of colours as vertices
    triMesh.colors = triCol
end

-- This function gets called once every frame
function draw()
    -- Dark background color
    background(20, 20, 40)

    -- Save the current transform (translation, rotation and scale)
    matrix.push()

    -- Translate coordinates to the middle of the screen
    matrix.translate(WIDTH/2, HEIGHT/2)

    -- Rotate the transform at 100 degrees per second
    matrix.rotate(time.elapsed*100)

    -- Construct equilateral triangle points, this could be any 3 points
    local top = vec2(math.cos(2*math.pi/6), math.sin(2*math.pi/6))
    top = top * triSize

    local left = vec2(math.cos(6*math.pi/6), math.sin(6*math.pi/6))
    left = left * triSize

    local right = vec2(math.cos(10*math.pi/6), math.sin(10*math.pi/6))
    right = right * triSize

    -- Set points on mesh, every 3 points constructs a new triangle
    triMesh.vertices = { top,
                         left,
                         right }

    -- Draw the mesh that we setup
    triMesh:draw()

    -- Restore the previous transform
    -- This is useful if you need to position multiple objects differently
    matrix.pop()
end
