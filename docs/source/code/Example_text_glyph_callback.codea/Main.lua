function setup()
    text.style.wave = function(tag, format)
        local height = tag:number("height", 2)                   
        format.fillColor = color.red
        format.textStyle = format.textStyle | TEXT_ITALICS | TEXT_BOLD
        format.callback = function(str, i, mod)
            mod.offsetY = mod.offsetY + math.sin(time.elapsed*5 + i) * height
        end
    end
    
    text.style.shake = function(tag, format)
        local intensity = tag:number("intensity", 2)                   
        
        format.callback = function(str, i, mod)
            local r1 = (math.random() * 0.5 - 0.5) * intensity
            local r2 = (math.random() * 0.5 - 0.5) * intensity
            
            mod.offsetX = mod.offsetX + r1
            mod.offsetY = mod.offsetY + r2
        end
    end
    
    text.style.appear = function(tag, format)
        local t = timer * tag:number("speed", 5)                   
                
        format.callback = function(str, i, mod)
            local a = math.min(math.max(t - i, 0.0), 1.0)
            local len = str:len()
            mod.offsetY = 5 * math.cos(a * math.pi/2)
            mod.alpha = a * 255        
        end
    end
    
    parameter.text("str", "<appear speed='15'><b>This</b> line will appear and <shake intensity = '2'>shake</shake> and <wave height='5'>wave</wave> and might wrap at some point...</appear>")
    --parameter.text("str", "Here is a line of text that might wrap at some point...")
    parameter.integer("fontSize", 5, 100, 24)    
    parameter.number("WaveHeight", 0, 10, 5)
    parameter.enumerated("TextAlignH", {"LEFT", "CENTER", "RIGHT"}, 2)
    parameter.enumerated("TextAlignV", {"BOTTOM", "MIDDLE", "TOP"}, 2)
    
    parameter.action("Reset", function() timer = 0 end)
    
    alignH = {LEFT, CENTER, RIGHT}
    alignV = {BOTTOM, MIDDLE, TOP}
    timer = 0
    
    --[[
    scn = scene.default3d()
    local rig = scn.camera:add(camera.rigs.orbit)
    rig.distance = 50
    rig.angles.y = -45    
    rig.angles.y = -75
    scene.main = scn--]]
    
    
end

function draw()

    local boxWidth = 400
    local boxHeight = 200
    
    background(128)
    
    --matrix.ortho()
    
    -- Setup the text drawing style
    style.font("Arial")
    style.fill(color.cyan).fontSize(fontSize)
    
    matrix.transform3d(WIDTH/2 - 50, HEIGHT/2 - boxHeight/2, 0, 2, 2, 2, 0, 0, 0)
    --matrix.transform3d(0, 0, 0, 0.1, 0.1, 0.1, 0, 0, 0)
        
    style.fill(255)
    style.stroke(0).strokeWidth(5).textStyle(TEXT_RICH)
    --style.noStroke()
    style.textAlign(alignH[TextAlignH] | alignV[TextAlignV])
    
    local so = (CurrentTouch.pos - vec2(WIDTH/2, HEIGHT/2)) * 0.1
    
    style.textShadow(0, 0, 0, 128).textShadowSoftner(10).textShadowOffset(so.x, so.y)
        
    -- Cache some locals for performance
    local len = str:len()
    local cps = 10
    local t = timer * 5
    local r1, r2 = string.find(str, "text")
    
    text(str, 0, 0, boxWidth, boxHeight)
    
    timer = timer + time.delta
    
    -- Draw the text's bounding box and origin
    style.noFill().stroke(color.yellow).strokeWidth(2)
    rect(0, 0, boxWidth, boxHeight)
    ellipse(0, 0, 10)
end
