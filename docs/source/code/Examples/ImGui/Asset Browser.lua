display.fullscreen()
    
function setup()

end

function draw()
    background(0, 0, 0, 0)
end

function gui()
    imgui.begin("Assets", function()        
        imgui.setWindowPos(WIDTH/2 - 550/2, 150, imgui.cond.once)
        imgui.setWindowSize(550, 680, imgui.cond.once)       
        
        assetTree(asset, "asset")
        assetTree(asset.builtin, "asset.builtin")
        assetTree(asset.documents, "asset.documents")
    end)
end

images = {}
texts = {}
assetCache = {}

function assetTree(root, name)
    
    name = string.gsub(name or root.name, ".assets", "")
    imgui.treeNode(name, function()
        --print(root.type)
        if root.type == 'folder' then
            if assetCache[root.name] == nil then
                assetCache[root.name] = root.all
            end
            for k,v in pairs(assetCache[root.name]) do                
                assetTree(v)
            end
        elseif root.type == 'sprites' then
            local img = images[root.name]
            if img == nil then
                img = image.read(root)
                images[root.name] = img
            end
            imgui.text(string.format("image (width = %d, height = %d)", img.width, img.height))
            local w, h = img.width, img.height
            if w > h then 
                local ratio = h/w
                w, h = 100, ratio * 100
            else
                local ratio = w/h
                w, h = ratio * 100, 100
            end
            imgui.image(img, w, h)
        elseif root.type == 'text' then
            -- TODO
        end
    end)
end

function touched(touch)
end
