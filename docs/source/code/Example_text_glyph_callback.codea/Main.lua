function setup()
    parameter.text("str", "Here is a line of text that might wrap at some point...")
    parameter.integer("fontSize", 5, 100, 24)    
    
    parameter.enumerated("TextAlignH", {"LEFT", "CENTER", "RIGHT"}, 2)
    parameter.enumerated("TextAlignV", {"BOTTOM", "MIDDLE", "TOP"}, 2)
    
    parameter.action("Reset", function() timer = 0 end)
    
    alignH = {LEFT, CENTER, RIGHT}
    alignV = {BOTTOM, MIDDLE, TOP}
    timer = 0
end

function draw()

    local boxWidth = 400
    local boxHeight = 200
    
    background(128)
    
    -- Setup the text drawing style
    style.font("Arial Bold Italic")
    style.fill(color.cyan).fontSize(fontSize)
    style.textAlign(alignH[TextAlignH] | alignV[TextAlignV])
    
    matrix.transform2d(WIDTH/2, HEIGHT/2 - boxHeight/2, 1, 1)
        
    style.fill(255)
    style.stroke(0).strokeWidth(5)
    
    -- Cache some locals for performance
    local len = str:len()
    local cps = 10
    local t = timer * 15
    local r1, r2 = string.find(str, "text")
    
    text(str, 0, 0, boxWidth, boxHeight, function(str, i, mod)
        -- Ease in character visibility
        local a = math.min(math.max(t - i, 0.0), 1.0)
        mod.offsetY = 5 * math.cos(a * math.pi/2)

        -- If the target word is found make it red and use sin wave animation
        if r1 and i >= r1 and i <= r2 then 
            mod.color = color.red
            mod.offsetY = mod.offsetY + math.sin(time.elapsed*5 + i) * 2
        end
        mod.alpha = a * 255        
    end)
    
    timer = timer + time.delta
    
    -- Draw the text's bounding box and origin
    style.noFill().stroke(color.yellow).strokeWidth(2)
    rect(0, 0, boxWidth, boxHeight)
    ellipse(0, 0, 10)
end
