display.fullscreen()


function setup()
    display.drawOnRequest = true
    inspector = editor.inspector()
    
    assetList = editor.assetList()
    assetList.onAssetSelected = function(ass)
        inspector.target = ass
        if is(ass, scene) then            
            if scn and scn.key.path == ass.key.path then return end
            scn = ass
            scnEditor = scn.editor
            scnEditor.onSelectionChanged = function()
                inspector.target = scnEditor.selection[1]
            end
        end        
    end
end

function draw()
    background(0,0,0,255)
    if scnEditor then scnEditor:draw() end
end

function gui()
    if inspector then inspector:gui() end
    if assetList then assetList:gui() end
    if scnEditor then scnEditor:gui() end
end

function touched(touch)
    if scnEditor then
        if scnEditor then scnEditor:touched(touch) end
    end
end
