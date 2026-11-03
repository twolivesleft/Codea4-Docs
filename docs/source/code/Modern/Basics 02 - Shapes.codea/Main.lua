-- Learn to Codea
-- Drawn in Code

function setup()
end

-- Codea calls the draw() function every frame to redraw the screen
-- This could be as much as 60 or 120 times per second, or less if
-- you demand too much from the CPU/GPU

-- Put drawing commands in here to draw the various doodads you want
function draw()

    -- Some background on the background(r,g,b,a) command
    -- This command clears the screen with the specified color. The parameters
    -- represent the amount of each primary color component to use (i.e. red, green, blue)
    -- When called all previous things drawn on the screen will be cleared with the color used
    background(25, 25, 25)

    -- 2D Vector Drawing

    -- For based 2D drawing jobs we can use the following commands:
    -- ellipse(x, y, w, h)
    -- rect(x, y, w, h)
    -- rect(x, y, w, h, radius)
    -- line(x1, y1, x2, y2)
    -- polygon(p1, p2, p3, p4...)
    -- shape(x, y, closed, func)

    -- ellipse() draws an ellipse (no kidding?) at the specified x, y location
    -- The x, y values are euclidian coordinates (i.e. horizontal and vertical) with the
    -- origin starting at 0, 0 (bottom left of the screen)
    -- Lets draw one:
    ellipse(WIDTH/2 - 120, HEIGHT/2 + 120, 100, 100)

    -- You may have noticed the all-caps constant WIDTH and HEIGHT
    -- These handily give us the current resolution of the screen in sort-of pixels
    -- (this is a retina screen thing, don't worry for now)
    -- By using WIDTH/2 and HEIGHT/2 I get the exact center of the screen regardless of how
    -- big it happens to be

    -- Style

    -- To control the things like colors and strokes for shapes we use Codea's style commands
    -- You can just do:

    style.fill(255, 0, 0) -- make shapes fill with red
    ellipse(WIDTH/2, HEIGHT/2 + 120, 100, 100)

    -- Make shapes have a white stroke with 5 pixel width
    -- We can also chain together multiple style commands
    style.stroke(255).strokeWidth(5)
    ellipse(WIDTH/2 + 120, HEIGHT/2 + 120, 100, 100)

    -- We can also reset the style to it's default state
    style.reset().rectMode(CENTER)

    -- We can also draw a rectangle
    -- rectMode(CENTER) makes these positions the centers of the rectangles
    rect(WIDTH/2 - 120, HEIGHT/2, 100, 100)

    style.fill(255, 0, 0)
    rect(WIDTH/2, HEIGHT/2, 100, 100)

    style.stroke(255).strokeWidth(5)
    rect(WIDTH/2 + 120, HEIGHT/2, 100, 100)


    style.reset().rectMode(CENTER)

    -- Rounded rectangles are possible too!
    -- Extra 1 parameter to round all corners
    rect(WIDTH/2 - 120, HEIGHT/2 - 120, 100, 100, 5)

    style.fill(255, 0, 0)
    rect(WIDTH/2, HEIGHT/2 - 120, 100, 100, 10)

    -- Extra 4 parameters to vary how much each corner is rounded
    style.stroke(255).strokeWidth(5)
    rect(WIDTH/2 + 120, HEIGHT/2 - 120, 100, 100, 5, 10, 5, 15)
end

function touched(touch)
end
