-- Mesh 2 - Triangulate Example
-- Author: John Millard

function setup()
    print("Hello Triangulate!")

    msh = mesh()
    points = {}
    colors = {}
end

function updateMesh()
    if #points >= 3 then
        msh.positions = points
        msh.colors = colors
        msh.indices = mesh.triangulate(points)
    end
end

-- This function gets called once every frame
function draw()
    -- Dark background color
    background(20, 20, 40)
    msh:draw()

    style.noStroke().fill(255)
    for k, v in pairs(points) do
        ellipse(v, 10)
    end
end

function touched(touch)
    if touch.state == ENDED and touch.tapCount == 1 then
        table.insert(points, touch.pos)
        table.insert(colors, color(touch.x / WIDTH * 255, touch.y / HEIGHT * 255, 128))
        updateMesh()
    end
end
