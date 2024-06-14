function setup() 
    scn = scene.default2d()
    
    icon = image.read(asset.builtin.Cargo_Bot.Codea_Icon)
    slice = icon.slice
    
    scn.camera:get(camera).orthoSize = HEIGHT
    
    local sin = math.sin
    local cos = math.cos
    
    --msh = mesh.sphere()
    
    for i = 1, 1000 do
        local ent = scn:entity()
        ent.scale = vec3(1,1,1) * 0.25
        ent.sprite = slice
        --ent:add(msh)
                
        function ent:update(dt)
            local t = time.elapsed
            ent.x = sin(t + i) * i * 0.25
            ent.y = cos(t + i) * i * 0.25
        end
    end
    
    scene.main = scn
end