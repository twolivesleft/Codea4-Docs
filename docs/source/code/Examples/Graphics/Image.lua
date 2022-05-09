function setup()
    img = image(512, 512)
    context(img, function()
        background(128)
        --style.fill(255, 255, 255, 255)
    end)
end

function draw()
    background(0, 0, 0, 0)
    sprite(img, WIDTH/2, HEIGHT/2)
    ellipse(WIDTH/2, HEIGHT/2, 150, 150)
    style.fill(255).strokeWidth(10).stroke(255)
    line(0, 0, 200, 200)
    --text("TEST", WIDTH/2, HEIGHT/2)
end

function touched(touch)
end
