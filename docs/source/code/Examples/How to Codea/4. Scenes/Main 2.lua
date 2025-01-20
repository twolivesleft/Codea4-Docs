ModelPreview = class('ModelPreview')

function ModelPreview:init(w, h)
    self.scn = scene.default3d()
    self.model = self.scn:entity()
    self.scn.camera.rotation = quat.eulerAngles(45, 45, 0)
    self.scn.camera.position = -self.scn.camera.forward * 8.0
    self.cam = self.scn.camera:get(camera)
    self.cam.isOrtho = true
    self.cam.orthoSize = 1.75
    self.scn.sky = nil
end

function ModelPreview:create(model, w, h)
    local thumb = image(w, h, false, 1, image.rgba8, image.d16)
    self.model:add(model)
    
    context.push(thumb)
    background(0,0,0,0)
    self.scn:draw()
    context.pop()
    
    return thumb
end

    
function setup()
    
    local sceneKey = asset.."/Test.scene"
    --scn = scene.read(sceneKey)
    
    if scn == nil then     
        scn = scene.default3d()
        scn.camera:add(camera.rigs.orbit)
    
        ground = scn:entity("ground")
    end

    ground = scn.ground
    
    cam = scn.camera:get(camera)
    ground:add(mesh.box(3, .1, 3)).material = material.lit()        
    ground:add(physics3d.body, physics3d.static)
    ground:add(physics3d.box, 3, .1, 3).rollingFriction = 0
    
    models = {}
    thumbs = {}
    
    previewer = ModelPreview()
    
    for k, v in pairs(asset.builtin.Minigolf.all) do
        if v.type == 'models' then
            local m = mesh.read(v)
            if m and math.abs(m.bounds.size.x - 1) < 0.01  then 
                table.insert(models, m)
                table.insert(thumbs, previewer:create(m, 128, 128))
            end
        end
    end

    parameter.watch("models[Model].key.name")
    parameter.watch("thumbs[Model]")
    parameter.boolean("Play", false, function()
        
    end)
    parameter.boolean("Rotate", false)
    parameter.integer("Model", 1, #models, 1)
    parameter.action("Save", function() 
        scene.save(sceneKey, scn)
    end)

end

function draw()
    scn:draw()
end

function edit(touch)
    if touch.began then    
        local hit = ground.worldBounds:raycast(cam:screenToRay(touch.pos))
        if hit then
            local x, y, z = hit.point.x, ground.worldBounds.size.y/2, hit.point.z
            x = math.floor(x/2) * 2
            z = math.floor(z/2) * 2
            local name = string.format("Tile_%d_%d", x, z)
                
            tile = ground[name]
        
            if tile == nil then
                tile = ground:child(name)            
                tile.position = vec3(x + 0.5, y, z + 0.5)
                tile.scale = vec3(2,2,2)
                tile:add(models[Model])
                local mc = tile:add(physics3d.body, physics3d.static):mesh(models[Model])   
                mc.rollingFriction = 0.0
                mc.friction = 0.5
                mc.restitution = 0.5
                tile:placementWobble(.5, 3, 20, 1)        
            elseif Rotate then
                scn:tween(tile):to{worldRotation = tile.worldRotation * quat.angleAxis(90, vec3(0,1,0))}:time(0.25):ease(tween.backOut)            
            else 
                tile:destroy()                  
            end
        end   
    end
end

function play(touch)
    if touch.began then
        local hit = ground.worldBounds:raycast(cam:screenToRay(touch.pos))        
        if scn.ball == nil then
            if hit then            
                local ball = scn:entity("ball")
                ball.mesh = mesh.read(asset.builtin.Minigolf.ball_blue_obj)
                ball.x = hit.point.x
                ball.z = hit.point.z
                ball.y = 2              
                ball.scale = vec3(2,2,2)   
                local rb = ball:add(physics3d.body, physics3d.dynamic)
                rb.sleepingAllowed = false
                rb.angularDamping = .3                               
                rb.bullet = false                
                local sc = ball:add(physics3d.sphere, ball.mesh.bounds.size.x/2)
                sc.rollingFriction = 0.0
                sc.friction = 0.5
                sc.restitution = 1.0

            end
        else 
            if hit then
                local ball = scn.ball
                ball.x = hit.point.x
                ball.z = hit.point.z
                ball.y = 2        
                ball:get(physics3d.body).linearVelocity = vec3(0,0,0)                                        
            end
        end    
    end
end
    
function touched(touch)
    scn:touched(touch)

    if Play then 
        play(touch)
    else 
        edit(touch)
    end
    
end