-- #######
-- Grabber
-- #######
-- Add's a touch-based grabber to interact with physics objects
-- Simply add to your scene camera: 
--     scn.camera:add(physics2d.grabber)

local grabber = class('grabber')

function grabber:created()
    self.world = self.scene.world2d
    -- Need the camera for translating touches to world space
    self.cam = self.entity:get(camera)
end

function grabber:touched(touch)
    -- Convert touches from screen to world space using the camera
    local wx, wy = self.cam:screenToWorld(touch.x, touch.y)
    local point = vec2(wx, wy)
    
    if touch.began then
        -- Check for a hit when touches began
        local hit = self.world:queryBox(point, 0, 0)
        -- Ensure the found body is dynamic
        if hit and hit.body.type == DYNAMIC then
            -- Keep track of it and the local point that was grabbed
            self.body = hit.body
            self.anchor = self.body:localPoint(point)
            return true
        end
    elseif touch.moving then
        self.target = point
    elseif touch.ended then
        self.anchor = nil
        self.target = nil
        self.body = nil
    end
end

-- Visualise the grabber force / anchor point
function grabber:draw()
    if self.anchor and self.target then
        matrix.push().reset()
        style.push().noFill().stroke(255).strokeWidth(0.1).sortOrder(-10)
        local wp = self.body:worldPoint(self.anchor)
        line(wp, self.target)
        style.noStroke().fill(255)
        ellipse(wp, 0.2)
        ellipse(self.target, 0.2)
        style.pop()
        matrix.pop()
    end
end

function grabber:fixedUpdate(dt)
    if self.anchor and self.target then
        local wp = self.body:worldPoint(self.anchor)
        local v = self.target - wp
        self.body:applyForce(v * 100 - self.body:velocityAtWorldPoint(wp) * 10.0, wp)
    end
end

physics2d.grabber = grabber