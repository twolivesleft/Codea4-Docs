-- 2D Physics in Scenes
--
-- Adding a body to a scene entity will automatically enable 
-- physics for it. You can use callbacks to tap into various
-- physics features, including hit tests (for touches) and
-- collisions (to react to physical events)
    
function eye(x, y, parent)
    local eye = scn:entity()
    eye.parent = parent
    eye.x = x
    eye.y = y
    eye:add(physics2d.body, DYNAMIC):circle(0.25)

    -- Draw an eye shape on top of this rigidbody
    function eye:draw()
        matrix.reset().translate(self.position)
        style.push().sortOrder(-3) -- use sortOrder to draw in-front
        style.fill(255)
        ellipse(0, 0, 0.6)
        style.fill(0)
        ellipse(0, 0, 0.45)
        style.fill(255)
        matrix.push().scale(math.sin(time.elapsed * 20) * 0.05 + 1.0)
        ellipse(-.1, .1, .3)
        ellipse(.1, .1, .08)
        ellipse(.1, -.1, .1)
        matrix.pop()
        style.pop()
    end
        
    local p = eye.worldPosition
    local j = eye.body2d:distance(parent.body2d, p.x, p.y, p.x, p.y + 0.1)
    j.minLength = 0
    j.maxLength = 0.125
end

function leg(x, y, parent)
    local leg = scn:entity()
    leg.parent = parent
    
    function leg:draw()
        style.push().sortOrder(-1).rectMode(CENTER)
        style.stroke(255).strokeWidth(0.05).fill(221, 85, 142)
        rect(0, 0, 0.6, 0.8, 0.1)        
        style.pop()
    end
    
    leg.x = x
    leg.y = y
    leg:add(physics2d.body, DYNAMIC):box(0.3, 0.4)
    local p = leg.worldPosition
    local j = leg.body2d:hinge(parent.body2d, p.x, p.y + 0.2)
    j.useMotor = true
    j.motorSpeed = 0
    j.maxTorque = 5
end


function setup()
    -- Create a default 2d scene
    scn = scene.default2d()
    scn.physics2d.debugDraw = true
    
    cam = scn.camera:get(camera)
    
    scn.camera:add(physics2d.grabber)
    
    function scn.camera:touched(touch)
        
    end
    
    floor = scn:entity("floor")
    floor:add(physics2d.body, KINEMATIC):box(8, 0.5)
    
    -- Enable hit test on entity to enable collision checking when receiving touch events
    floor.hitTest = true
    
    -- Simple touch script for dragging around an object
    --[[
    function floor:touched(touch)        
        local delta = touch.delta        
        local px, py = cam:screenToWorld(0, 0)        
        local dx, dy = cam:screenToWorld(delta.x, delta.y)        
        self.x = self.x + (dx - px)
        self.y = self.y + (dy - py)
        return true -- capture touch here
    end]]--
    
    ball = scn:entity()
    ball:add(physics2d.body, DYNAMIC):circle(1.0)
    ball.y = 8
    ball.ouch = 0
    --print(ball.colliders2d[1]:destroy())
    
    function ball:draw()
        style.push().sortOrder(-2)
        style.stroke(255).strokeWidth(0.05).fill(221, 85, 142)
        ellipse(0, 0, 2.0)
        
        if math.abs(time.elapsed - ball.ouch) < 0.5 then 
            style.noStroke().fill(0)
            ellipse(0, -0.2, 0.2)
        else
            style.noFill().stroke(0).strokeWidth(0.1)
            line(-0.1, -0.1, 0.1, -0.1)
        end
    
        style.pop()
    end

    -- Respond to collisions for this entity by implementing the collision callback
    function ball:collisionBegan2d(hit)        
        sound.play(SOUND_HURT)
        self.ouch = time.elapsed
    end

    eye(-0.5, 0, ball)    
    eye(0.5, 0, ball)
    leg(-0.8, -0.8, ball)
    leg(0.8, -0.8, ball)
    
    -- Create a concave 2D polygon (which is automatically decomposed into convex shapes)
    local points = 
    {
        vec2(-1, 1), 
        vec2(-0.8, 1),
        vec2(-0.5, 0.0),
        vec2(0.5, 0.0),
        vec2(0.8, 1),
        vec2(1, 1),
        vec2(1, -1), 
        vec2(-1, -1),
    }
    poly = scn:entity()
    poly.rz = 180
    poly:add(physics2d.body, DYNAMIC):polygon(points)
    poly.y = 3
    
    scene.main = scn
end

function draw()
end