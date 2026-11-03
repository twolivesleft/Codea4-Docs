function setup()
    parameter.color("ColorA", color(225, 138, 130))
    parameter.color("ColorB", color(169, 255, 129))

    blendModes =
    {
        "NORMAL",
        "ADDITIVE",
        "MULTIPLY",
        "SCREEN",
        "LIGHTEN",
        "LINEAR_BURN",
        "PREMULTIPLIED",
        "DISABLED"
    }

    parameter.enumerated("Blend", blendModes)

    alpha1 = image.read(asset.Alpha1)
    alpha2 = image.read(asset.Alpha2)
end

function draw()
    background(64)

    matrix.push().translate(WIDTH/2, HEIGHT/2 + 130)

    style.reset()
    style.blend(_G[blendModes[Blend]])
    style.fill(ColorA)
    ellipse(-50, 0, 160)
    style.fill(ColorB)
    ellipse(50, 0, 160)

    matrix.translate(0, -220)

    style.reset().blendFunc(EQUATION_MAX)
    sprite(alpha1, -50, 0, 160)
    sprite(alpha2, 50, 0, 160)

    matrix.pop()
end

function touched(touch)
end
