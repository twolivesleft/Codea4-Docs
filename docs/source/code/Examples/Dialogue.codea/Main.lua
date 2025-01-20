function setup()
        
    -- Custom text tags for dialogue effects
    text.style.wave = function(tag, format)
        local height = tag:number("height", 2)                   
        format.fillColor = color.yellow
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
    
    -- Gather sound samples
    samples = {}
    for k,v in pairs(asset.Samples.all) do 
        table.insert(samples, sound.read(v))
    end    
    
    portraits = {}
    for k,v in pairs(asset.Portraits.all) do 
        local img = image.read(v)
        img.smooth = false
        table.insert(portraits, img)
    end    
        
    local script = 
    {
        {
            portrait = portraits[1].slice,
            align = LEFT,
            lines = 
            {
                "<appear speed='20'>A dynamic dialogue system made in codea. <wave>wow</wave> that's so <shake intensity='3'>cool!</shake></appear>",
                "<appear speed='20'>It even has multiple pages of <wave>dialogue</wave>...</appear>",
                "<appear speed='20'>And gibberish <wave height='5'>sounds</wave>...</appear>",                
            }
        },
        {
            portrait = portraits[2].slice,
            align = RIGHT,
            tempo = .3,
            lines = 
            {
                "<appear speed='20'><wave>WOOOOW...</wave><pause>so cool...</pause></appear>",
                "<appear speed='20'>I'll have to rethink my life now...</appear>"                            
            }
        },
        {
            portrait = portraits[3].slice,
            align = RIGHT,
            tempo = .7,
            lines = 
            {
                "<appear speed='20'>Hah, it's not that impressive!</appear>",
            }
        }
        
    }
        
    scn = scene.default2d()
    scene.main = scn
    
    db = scn.canvas:child():add(DialogueBox)
    db:setScript(script)
            
    inspector = editor.inspector()
    --inspector.target = textBox
    
    
end

function gui()
    inspector:gui()
end

function draw()
    --background(16)
    --coroutine.resume(co)
end