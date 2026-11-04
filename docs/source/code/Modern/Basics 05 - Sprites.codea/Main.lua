local icon
local spr = sprite

function setup()
    -- Generate a local image so this example needs no installed asset packs.
    icon = image(64, 64)
    context.push(icon)
    background(0, 0, 0, 0)
    style.fill(100, 220, 200).noStroke()
    ellipse(32, 32, 56)
    style.fill(25)
    ellipse(32, 32, 20)
    context.pop()
end

function draw()
    background(25, 25, 25)

    -- The sprite command draws an image on the screen for us

    -- Sprites can come from two different places:
    -- Asset Keys, which are paths to assets on your device, including built-in assets, project assets and documents assets
    -- Images, which are loaded or generated somewhere else in the code via image.read(key) or image(w,h)

    -- The basic command is: sprite(imageOrAsset, x, y, w, h) where you specify the x and y position and optional width and height
    -- Specifying only the width will scale the sprite's height correctly to match aspect ratio
    --style.blend(DISABLED)
    local t = time.elapsed
    for i = 0, 24 do
        sprite(icon, WIDTH/2 + math.sin(t + i) * 100, HEIGHT/2 + math.cos(t + i) * 100, 32)
    end
end

function touched(touch)
end
