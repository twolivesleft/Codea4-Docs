function blendModeTest(mode)
    local img = image(512, 512)
    local w, h = img.width, img.height
    local inset = w * 0.35
    local size = w * 0.5
    context.push(img)    
    style.push()
    style.fill(180).stroke(180).strokeWidth(3)
    rect(12, 12, 512 - 24, 512 - 24, 30)
    --ellipse(inset, inset, size)
    --ellipse(w * 0.5, h - inset, size)    
    --ellipse(w - inset, inset, size)  
    
    style.blend(_G[mode])
    style.noStroke().strokeWidth(5)
    style.fill(color(255, 49, 0, 118))
    ellipse(inset, inset, size)
    style.fill(color(34, 255, 0, 118))    
    ellipse(w * 0.5, h - inset, size)    
    style.fill(color(0, 124, 255, 118))    
    ellipse(w - inset, inset, size)  
    style.pop()
    context.pop()
    image.save(asset..string.format('/example_blendMode_%s.png', mode), img)
end

function setup()
    -- Do your setup here   
    blendModeTest("NORMAL")
    blendModeTest("ADDITIVE")     
    blendModeTest("MULTIPLY")    
    blendModeTest("SCREEN")        
    blendModeTest("LIGHTEN")        
    blendModeTest("LINEAR_BURN")
    blendModeTest("PREMULTIPLIED")            
    blendModeTest("DISABLED")                
end

function draw()
end