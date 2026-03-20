-- RGB Cube
-- A rotating cube with RGB vertex colors

function setup()
    viewer.mode = FULLSCREEN

    -- Build a cube mesh with 8 corners
    cubeMesh = mesh()
    local s = 0.5

    local v = {
        vec3(-s,-s,-s), vec3( s,-s,-s), vec3( s, s,-s), vec3(-s, s,-s),
        vec3(-s,-s, s), vec3( s,-s, s), vec3( s, s, s), vec3(-s, s, s),
    }

    -- Map each corner's position to an RGB color
    local function posToColor(p)
        return color(
            math.floor((p.x + s) / (2*s) * 255),
            math.floor((p.y + s) / (2*s) * 255),
            math.floor((p.z + s) / (2*s) * 255))
    end

    -- 6 faces × 2 triangles, wound for correct front-face culling
    local faces = {
        {v[5],v[6],v[7]}, {v[5],v[7],v[8]}, -- Front  (+z)
        {v[2],v[1],v[4]}, {v[2],v[4],v[3]}, -- Back   (-z)
        {v[1],v[5],v[8]}, {v[1],v[8],v[4]}, -- Left   (-x)
        {v[6],v[2],v[3]}, {v[6],v[3],v[7]}, -- Right  (+x)
        {v[8],v[7],v[3]}, {v[8],v[3],v[4]}, -- Top    (+y)
        {v[1],v[2],v[6]}, {v[1],v[6],v[5]}, -- Bottom (-y)
    }

    local verts, cols = {}, {}
    for _, tri in ipairs(faces) do
        for _, p in ipairs(tri) do
            table.insert(verts, p)
            table.insert(cols, posToColor(p))
        end
    end

    -- Use 'vertices' (not 'positions') so indices are set automatically
    cubeMesh.vertices = verts
    cubeMesh.colors   = cols

    angleX, angleY = 0, 0
end

function draw()
    background(20, 20, 30)

    angleX = angleX + 0.4
    angleY = angleY + 0.6

    -- Set up perspective projection.
    -- With matrix.perspective() the camera is at the origin looking
    -- toward +Z, so objects must have a positive Z to be visible.
    matrix.push()
        matrix.perspective(60)
        matrix.translate(0, 0, 3)      -- place cube 3 units in front
        matrix.rotate(angleX, 1, 0, 0)
        matrix.rotate(angleY, 0, 1, 0)
        cubeMesh:draw()
    matrix.pop()
end
