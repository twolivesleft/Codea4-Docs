display.fullscreen()

function setup()
    
    tap = gesture.tap(function(gesture)
        local x, y = cam:screenToWorld(gesture.location, 0)
        local body = world:body(physics2d.dynamic, x, y)
        body:circle(0, 0, 0.25)
    end)
    
    pan = gesture.pan(function(gesture)
        -- Use screenToWorld to scale pan delta from pixels to world coordinates
        local dx, dy = cam:screenToWorld(gesture.delta.x + WIDTH/2, gesture.delta.y + HEIGHT/2, 0)
        velocity.x, velocity.y = dx, dy
    end)
    pan.group = 1
        
    rot = gesture.rotation(function(gesture)
        angularVelocity = -gesture.rotation
    end)
    rot.group = 1
    
    pinch = gesture.pinch(function(gesture)
        box.size = box.size * gesture.pinchScale
    end)
    pinch.group = 1
    
    
    world = physics2d.world()
    -- Create a simple ortho camera to scale from physics units to pixels
    cam = camera.ortho(10, 0, 100)
    
    body = world:body(physics2d.kinematic, 0, 0)
    box = body:box(0, 0, 3, 1)
    velocity = vec2(0, 0)
    angularVelocity = 0
end

function fixedUpdate(dt)
    body.linearVelocity = vec2(velocity.x / dt, velocity.y / dt)
    body.angularVelocity = angularVelocity / dt
    world:step(DeltaTime)
end

function draw()
    background(0, 0, 0, 0)
    
    cam:apply()
    world:draw()
end

function touched(touch)
end
