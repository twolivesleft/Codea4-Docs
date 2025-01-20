function setup()
    tilesheet = image.read(asset.builtin.Simplified_Platformer.Tilesheet)
    key = asset.."/Tilesheet.atlas"
    sheet = atlas.read(key) or tilesheet.atlas
    
    parameter.watch("tilesheet")
    parameter.watch("sheet.count")
    parameter.watch("sheet[Selected]:name()")
    
    parameter.text("Name", "Untitled", function(n)
        local s = Selected and sheet[Selected]
        if s then
            s:name(n)
        end
    end)
    
    parameter.integer("Selected", 1, sheet.count, 1, function(id)
        local s = Selected and sheet[Selected]
        selectionChanged()        
    end)
    
    parameter.enumerated("Mode", {"Cell Size", "Cell Count"})
    
    parameter.vec2("Size", vec2(1, 1))
    
    parameter.action("Slice", function()
        if Mode == 1 then
            sheet:setWithCellSize(Size.x, Size.y)
        elseif Mode == 2 then 
            sheet:setWithCellCount(Size.x, Size.y)
        end
    end)
        
    parameter.action("Save", function()
        atlas.save(key, sheet)
        print("TEST!")
    end)
    
    print("WHAT?")
end

function selectionChanged()
    local s = Selected and sheet[Selected]
    print(s)
    if s then 
        Name = s:name()
        print(Name)
    end
end

function draw()
    background(128)
    
    matrix.push().translate(WIDTH/2, HEIGHT/2)
    style.sortOrder(0)
    sprite(tilesheet, 0, 0)
    style.sortOrder(0)
    matrix.translate(-tilesheet.width/2, -tilesheet.height/2)
    sheetMatInv = matrix.model():inverse()
    style.push().rectMode(CORNER).noFill().stroke(255).strokeWidth(3)
    local s = sheet[Selected]
    if s then
        local x, y, w, h = s:rect()
        y = tilesheet.height - y - h
        local px, py = s:anchor()
        rect(x, y, w, h)
        
        matrix.translate(tilesheet.width + 12, tilesheet.height/2 - h * 2)
        style.spriteMode(CORNER)
        sprite(s, px * w * 4, py * h * 4, w * 4, h * 4)
        rect(0, 0, w * 4, h * 4)
    end
    matrix.pop()
    
    style.fill(64)
    style.sortOrder(HEIGHT - 100 + math.sin(time.elapsed * 5 + 1) * 10)
    style.blend(MULTIPLY)
    ellipse(WIDTH/2, style.sortOrder(), 64, 64)
    style.blend(NORMAL)
    sprite(sheet[1], WIDTH/2, style.sortOrder())
    style.blend(ADDITIVE)
    ellipse(WIDTH/2, style.sortOrder(), 32, 32)    
    style.blend(NORMAL)
    style.sortOrder(HEIGHT - 100 + math.sin(time.elapsed * 5 + 2) * 10)    
    ellipse(WIDTH/2 + 32, style.sortOrder(), 64, 64)    
    sprite(sheet[2], WIDTH/2 + 32, style.sortOrder())    
    style.sortOrder(HEIGHT - 100 + math.sin(time.elapsed * 5 + 3) * 10)    
    ellipse(WIDTH/2 + 64, style.sortOrder(), 64, 64)    
    sprite(sheet[3], WIDTH/2 + 64, style.sortOrder())        
end

function slice:hitTest(x, y)
    local rx, ry, rw, rh = self:rect()
    if x >= rx and y >= ry and x < rx+rw and y < ry+rh then
        return true
    end
    return false
end

function touched(touch)
    if touch.state == BEGAN then
        -- matrix.push(sheetMatInv)
        -- local x, y = matrix.screenToWorld(touch)
        local p = sheetMatInv * vec4(touch.x, touch.y, 0, 1)
        p.y = tilesheet.height - p.y 
        
        for i = 1,sheet.count do 
            if sheet[i]:hitTest(p.x, p.y) then
                Selected = i
                print(Selected)
                selectionChanged()
                return
            end
        end
    end
end
