
    local Grabber = class('HitTest')
    function Grabber:created()
        self.world = self.scene.world2d
        self.cam = self.scene.camera:get(camera)
        self.body = self.entity:get(physics2d.body)
    end
    
    function Grabber:touched(touch)        
        local p = touch:worldSpace(self.entity)
        if touch.state == BEGAN and touch:hitTest(self.entity) then        
            self.anchor = self.body:localPoint(p)
            return true
        elseif touch.state == MOVING then
            self.target = p
        elseif touch.state == ENDED then
            self.anchor = nil
            self.target = nil
        end
    end
    
    function Grabber:draw()
        if self.anchor and self.target then
            matrix.push().reset()
            style.push().noFill().stroke(255).strokeWidth(5)
            local wp = self.body:worldPoint(self.anchor)
            line(wp, self.target)
            style.pop()
            matrix.pop()
        end
    end

    function Grabber:fixedUpdate(dt)
        if self.anchor and self.target then
            local wp = self.body:worldPoint(self.anchor)
            local v = self.target - wp
            self.body:applyForce(v * 100 - self.body:velocityAtWorldPoint(wp) * 10.0, wp)
        end
    end

function setup()
    scn = scene.default2d()
    ground = scn:entity("Ground")
    ground:add(physics2d.body, physics2d.static)
    ground:add(physics2d.box, 5, 0.5)
    ground.rotation = quat.eulerAngles(0, 0, 0)
    
    cam = scn.camera:get(camera)
    
    ball = scn:entity("Ball")
    ball.y = 2
    ball:add(physics2d.circle, 0.5).restitution = .5
    ball:get(physics2d.body).gravityScale = .5
    ball:add(Grabber)
    
    scn.camera:get(camera).clearColor = color(128)
    scn.camera.z = -10
    
    tilesheet = image.read(asset.builtin.Simplified_Platformer.Tilesheet_png)
    local atlas = tilesheet.atlas
    
    local ballSprite = ball:child()
    ballSprite.uniformScale = 2
    ballSprite.sprite = atlas["Slice.071"]
end

function draw()
    scn:draw()
end

function touched(touch)
    scn:touched(touch)
end
