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

local colorNames = {"black", "white", "clear", "cyan", "gray", "red", "green", "blue", "magenta", "yellow"}
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

    local columns = math.max(1, math.floor(WIDTH / (SWATCH_SIZE + SWATCH_SPACING)))
    local rows = math.ceil(#colors / columns)
    for k, v in ipairs(colors) do
        local column, row = (k - 1) % columns, math.floor((k - 1) / columns)
        matrix.push().translate((column + 0.5) * WIDTH / columns,
            HEIGHT/2 + (rows/2 - row - 0.5) * 150)
        swatch(0, 0, v)
        style.set(label)
        text(colorNames[k], 0, -SWATCH_SIZE/2 - 20)
        matrix.pop()
    end

end

function touched(touch)
end
