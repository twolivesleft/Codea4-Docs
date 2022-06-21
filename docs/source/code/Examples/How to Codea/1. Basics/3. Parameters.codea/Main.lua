function setup()
    -- Parameters let create global variables that can be edited in the sidebar
    
    -- There are parameters for most basic variable types:
    -- parameter.color(initial, callback)
    -- parameter.number(min, max, initial, callback)
    -- parameter.integer(min, max, initial, callback) [like number but whole numbers only]
    -- parameter.boolean(initial) [creates a switch, true or false)
    -- parameter.action(callback) [creates a button and calls your function)
    
    -- Parameters can include an optional callback, which is just a function you want to call whenever the parameter value changes
    
    parameter.color('BackgroundColor', color(64, 64, 64))
    parameter.number('RectPosition', 0, WIDTH, WIDTH/2)
    parameter.boolean('ShowRect', true)
end

function draw()
    -- You can parameters anywhere in your code like in this background command:
    background(BackgroundColor)

    -- We can control the position of shapes too    
    style.fill(255).noStroke()
    rect(RectPosition, HEIGHT/2, 100, 100)
    
    -- We can turn things an and off with boolean parameters
    if ShowRect then
        rect(RectPosition, HEIGHT/2 - 100, 100, 100)
    end
end

function touched(touch)
end
