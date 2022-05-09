displayMode(FULLSCREEN)
    
function setup()
end

function draw()
    background(0, 0, 0, 0)
end

function gui()
    --imgui.setNextWindowSize(200, 200, imgui.cond.once)
    imgui.begin("Columns", function()
        imgui.setNextItemWidth(100)
        imgui.text("HAZA!")
        imgui.columns(2)
        imgui.separator()
        imgui.group(function()
            imgui.text("Left Text")
        end)
        imgui.nextColumn()
        imgui.group(function()
            imgui.text("Right Text")
        end)
        imgui.columns(1)
        imgui.separator()        
    end)
    
end

function touched(touch)
end
