viewer.fullscreen()

function setup()

    -- Here are some built-in colors that come with codea!
    colors =
    {
        color.black,
        color.white,
        color.clear,
        color.cyan,
        color.gray,
        color.red,
        color.green,
        color.blue,
        color.magenta,
        color.yellow
    }

    swatchFG = style.reset().rectMode(CENTER).stroke(255).strokeWidth(3).get()
    swatchBG = style.reset().rectMode(CENTER).noStroke().fill(90).get()
    label = style.reset().fontSize(14).textAlign(CENTER).fill(200).get() 

end

local SWATCH_SIZE = 100
local SWATCH_SPACING = 15

function swatch(x, y, ...)
    style.set(swatchBG)
    rect(x + 5, y - 5, SWATCH_SIZE, SWATCH_SIZE, 10)
    style.set(swatchFG).fill(...)
    rect(x, y, SWATCH_SIZE, SWATCH_SIZE, 10)
end

function draw()
    background(32)

    matrix.translate(WIDTH/2 - (SWATCH_SIZE + SWATCH_SPACING) * (#colors/2-0.5), HEIGHT/2)
    for k, v in pairs(colors) do
        swatch(0, 0, v)
        style.set(label)
        text(tostring(v), 0, -SWATCH_SIZE/2 - 20)
        matrix.translate(SWATCH_SIZE + SWATCH_SPACING)
    end

end

function touched(touch)
end
