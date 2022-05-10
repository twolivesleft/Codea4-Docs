-- Changes to Style in Codea 4
--

function setup() 
end

function draw()
    background(25, 25, 25)
    
    -- The API for changing style has changed in Codea 4
    -- All style calls have been folded into the style namespace
    
    -- pushStyle() becomes style.push()
    style.push()
    
    -- fill() becomes style.fill()
    style.fill(255, 160, 0)
    
    -- Style calls can be chained together
    style.stroke(150, 50, 50).strokeWidth(5)
    
    -- Drawing works as normal
    ellipse(WIDTH/2, HEIGHT/2, 100, 100)
    
    -- popStyle() becomes style.pop()
    style.pop()
    
    -- s = style.get() can be used to make a copy of a style
    -- style.set(s) can then be used to apply it later
end
