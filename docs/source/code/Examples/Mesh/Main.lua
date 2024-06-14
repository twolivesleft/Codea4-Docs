function setup()
    local size = vec2(50, 50)

    -- Create mesh using tables
    m = mesh()
    m.positions =
    {
        vec3(-size.x/2, size.y/2),
        vec3(size.x/2, size.y/2),
        vec3(size.x/2, -size.y/2),
        vec3(-size.x/2, -size.y/2)
    }
    m.uvs =
    {
        vec2(0, 0),
        vec2(1, 0),
        vec2(1, 1),
        vec2(0, 1)
    }
    m.colors =
    {
        color(255),
        color(255),
        color(255),
        color(255)
    }
    m.indices = {3,2,1,4,3,1}

    -- Create mesh procedurally (no extra allocations)
    m2 = mesh()
    m2:resizeVertices(4)
    -- TODO: add resizeVertices(), check index method
    m2:position(1, -size.x/2, size.y/2, 0)
    m2:position(2, size.x/2, size.y/2, 0)
    m2:position(3, size.x/2, -size.y/2, 0)
    m2:position(4, -size.x/2, -size.y/2, 0)
    m2:color(1, 255, 255, 255, 255)
    m2:color(2, 255, 255, 255, 255)
    m2:color(3, 255, 255, 255, 255)
    m2:color(4, 255, 255, 255, 255)
    m2:addElement(3,2,1)
    m2:addElement(4,3,1)

    -- More procedural methods
    -- addQuad, addTriangle, addShape, addPlane, addSphere, etc

end

function draw()
    background(0, 0, 0, 0)
    matrix.translate(WIDTH/2, HEIGHT/2)
    m2:draw()
end

function touched(touch)
end
