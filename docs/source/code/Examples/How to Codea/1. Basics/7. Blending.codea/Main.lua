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
    
    matrix.push().translate(WIDTH/2, HEIGHT/2 + 300)

    style.reset()    
    style.blend(_G[blendModes[Blend]])
    style.fill(ColorA)
    ellipse(-100, 0, 300)
    style.fill(ColorB)
    ellipse(100, 0, 300)
    
    matrix.translate(0, -300)

    style.reset().blendFunc(EQUATION_MAX)
    sprite(alpha1, -100, 0, 300)
    sprite(alpha2, 100, 0, 300)        
        
    matrix.pop()
end

function touched(touch)
end
