local icon
local spr = sprite

function setup() 
    icon = asset.builtin.Cargo_Bot.Codea_Icon
end

function draw()
    background(25, 25, 25)
    
    -- The sprite command draws an image on the screen for us
    
    -- Sprites can come from two different places:
    -- Asset Keys, which are paths to assets on your device, including built-in assets, project assets and documents assets
    -- Images, which are loaded or generated somewhere else in the code via image.read(key) or image(w,h)
    
    -- The basic command is: sprite(x, y, w, h) where you specify the x and y position and optional width and height
    -- Specifying only the width will scale the sprite's height correctly to match aspect ratio
    --style.blend(DISABLED)
    local t = time.elapsed
    for i = 0, 1000 do 
        spr(icon, WIDTH/2 + math.sin(t + i) * 50, HEIGHT/2 + math.cos(t + i) * 50)
    end
end

function touched(touch)
end
