-- Reaction Diffusion via compute shaders
-- The documentation host manages presentation.

-- Use this function to perform your initial setup
function setup()
    print("Hello Reaction Diffusion!")
    rd = ReactionDiffusion(192, 192)
    rd:set(rd.size.x/2, rd.size.y/2, 10)

    cam = camera.ortho(rd.size.y / 2, -1, 1)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(40, 40, 50)

    -- Do your drawing here
    cam:apply()
    rd:draw(0, 0, rd.size.x, rd.size.y)
end

function fixedUpdate(dt)
    rd:fixedUpdate(dt)
end

function touched(touch)
    local x, y = cam:screenToWorld(touch.pos)
    rd:set(x + rd.size.x/2, rd.size.y/2 - y, 10)
end
