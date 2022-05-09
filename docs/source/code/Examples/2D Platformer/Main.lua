require 'Gamepad'
require 'Animation'

viewer.fullscreen()

Character = class('Character')

function Character:init(x, y)
    self.body = world:body(physics2d.dynamic, x, y)
    self.body.fixedRotation = true
    local h = 0.65
    local r = 0.22
    self.top = self.body:circle(r, 0, h/2 - r)
    self.top.category = CHARACTER
    self.mid = self.body:box(r * 0.9, h/2 - r, 0, 0)
    self.mid.category = CHARACTER
    self.bot = self.body:circle(r, 0, -h/2 + r)
    self.bot.category = CHARACTER
    self.bot.friction = 0.5
    
    self.height = h
    self.radius = r
    
    local folder = asset.Main_Characters.Ninja_Frog
    self.idle = Animation(folder['Idle (32x32).png'], 32, 1):loop()
    self.run = Animation(folder['Run (32x32).png'], 32, 1):loop()
    self.jumpUp = Animation(folder['Jump (32x32).png'], 32, 1):loop()
    self.fallDown = Animation(folder['Fall (32x32).png'], 32, 1):loop()
    self.doubleJump = Animation(folder['Double Jump (32x32).png'], 32, 0.25):loop():onComplete(function()
        self.doubleJumping = false
    end)
    self.wallJump = Animation(folder['Wall Jump (32x32).png'], 32, 1)
        
    self.sprite = self.idle:update(0)
    self.walkDir = 0
    self.maxSpeed = 3
    self.walkImpulse = 0.125
    self.flip = false
    self.grounded = false
    self.jumpImpulse = 2.5
    self.jumpCount = 2
    self.jumpTimer = 0
end

function Character:checkGrounded(offset)
    offset = offset or 0
    local hit = world:raycast(self.body.position + vec2(offset, 0), vec2(0, -1), self.height/2 + 0.1, GROUND)
    if hit and hit.normal.y > 0.5 then                
        return hit
    end
    return nil
end

function Character:checkWall(offset, dir)
    offset = offset or 0
    local hit = world:raycast(self.body.position + vec2(0, offset), 
                              vec2(dir, 0), 
                              self.radius + 0.05, GROUND)
    if hit and math.abs(hit.normal.x) > 0.5 then
        return hit
    end
    return nil
end

    
function Character:fixedUpdate(dt)
    
    self.grounded = self:checkGrounded()
    if not self.grounded then
        self.grounded = self:checkGrounded(-.05)
    end
    if not self.grounded then
        self.grounded = self:checkGrounded(.05)
    end

    local mult = self.grounded and 1.0 or 0.25    
    local impulse = self.walkDir * self.walkImpulse * mult
    
    local v = nil
    
    if self.grounded then
        local gpoint = self.grounded.point
        local gnorm = self.grounded.normal
        local gbody = self.grounded.shape.body
        self.groundVel = self.body:velocityAtWorldPoint(gpoint) - gbody:velocityAtWorldPoint(gpoint)
        --local imp = -self.walkDir * self.walkImpulse * mult * 0.1
        --gbody:applyLinearImpulse(imp * gnorm.y, imp * -gnorm.x, gpoint)
        
        local tangent = vec2(gnorm.y, -gnorm.x)
        
        self.body:applyLinearImpulse(impulse * tangent.x, impulse * tangent.y)
        v = self.body.linearVelocity
        
        -- velocity right/up
        local vr = v:dot(tangent)
        local vu = v:dot(gnorm)
        
        vr = math.min(math.max(vr, -self.maxSpeed), self.maxSpeed)
        v = vr * tangent + vu * gnorm
            
    else
        self.body:applyLinearImpulse(impulse)
        v = self.body.linearVelocity
        v.x = math.min(math.max(v.x, -self.maxSpeed), self.maxSpeed)
    end
        
    local wallCheck1 = self:checkWall(-0.05, -1)
    local wallCheck2 = self:checkWall(0.05, -1)

    self.wall = nil
    if wallCheck1 and wallCheck2 then
        self.wall = wallCheck1 
    end
    
    local wallCheck1r = self:checkWall(-0.05, 1)
    local wallCheck2r = self:checkWall(0.05, 1)
    
    if wallCheck1r and wallCheck2r then
        self.wall = wallCheck1r
    end
    
    local left = key.pressing(key.left) or key.pressing(key.a)
    local right = key.pressing(key.right) or key.pressing(key.d)
    
    if self.wall then
        local slow = false
        if self.wall.normal.x > 0 and self.walkDir < 0 then
            slow = true
        elseif self.wall.normal.x < 0 and self.walkDir > 0 then
            slow = true
        end
        if slow then 
            v.y = v.y * 0.9
        end
    end
    
    self.body.linearVelocity = v
    
    if self.jumpTimer > 0 then
        self.jumpTimer = self.jumpTimer - dt
    end
end

function Character:update(dt)
    
    local v = self.body.linearVelocity

    self.walkDir = 0
        
    local left = key.pressing(key.left) or key.pressing(key.a)
    local right = key.pressing(key.right) or key.pressing(key.d)
    local jump = key.wasPressed(key.space)
    
    if gp then
        self.walkDir = self.walkDir + gp.leftStick.dir.x
        jump = jump or gp.buttonA.pressed
        left = gp.dpad.left or left
        right = gp.dpad.right or right
    end
    
    if left then
        self.walkDir = self.walkDir - 1
    end
    if right then
        self.walkDir = self.walkDir + 1
    end
        
    if self.grounded and self.jumpTimer <= 0 then     
        self.jumpCount = 2   
        self.doubleJumping = false
        local groundSpeed = self.groundVel.length
        if groundSpeed > 0.2 then
            self.sprite = self.run:update(dt * groundSpeed)
            self.flip = self.groundVel.x < 0
        else
            self.sprite = self.idle:update(dt)
        end
    elseif self.wall and self.jumpTimer <= 0 then
        self.jumpCount = 2
        if self.wall.normal.x > 0 and left then
            self.flip = true
        elseif right then
             self.flip = false
        end
        self.sprite = self.wallJump.frames[1]
    else 
        if math.abs(v.x) > 0.1 then
            self.flip = v.x < 0
        end
        if self.doubleJumping then 
            self.sprite = self.doubleJump:update(dt) 
        else
            if v.y > 0 then self.sprite = self.jumpUp:update(dt) end
            if v.y <= 0 then self.sprite = self.fallDown:update(dt) end
        end
    end
    
    self.sprite:flip(self.flip, false)
  
    if jump then
        print("JUMP!")
        self:jump()
    end
    
end

function Character:draw()
    local pos = self.body.position
    sprite(self.sprite, pos.x, pos.y + 0.05, 0.75)
end

function Character:jump()

    if self.jumpTimer > 0 then return end
    
    if self.grounded or self.wall or self.jumpCount == 1 then
        
        if self.wall then
            local ix, iy = 0, self.jumpImpulse
            self.body.linearVelocity = vec2(self.body.linearVelocity.x, 0)
            if self.wall.normal.x > 0 then
                ix = self.jumpImpulse / 2
            else
                ix = -self.jumpImpulse / 2
            end
            self.body:applyLinearImpulse(ix, iy)
            self.jumpCount = self.jumpCount - 1
            self.jumpTimer = 0.25
            return
        end
        
        if self.jumpCount == 1 then
            self.doubleJumping = true
        end
        
        self.body.linearVelocity = vec2(self.body.linearVelocity.x, 0)
        self.body:applyLinearImpulse(0, self.jumpImpulse)
        if self.grounded then
            self.grounded.shape.body:applyLinearImpulse(0, -self.jumpImpulse * 0.1, self.grounded.point)
        end
        self.jumpCount = self.jumpCount - 1
        self.jumpTimer = 0.25
    end
end
    
GROUND = 1
CHARACTER = 1<<1
ITEM = 1<<2

function chain(x, y, w, h, r, count)
    local body = world:body(physics2d.dynamic)
    
end

function createChain(x, y, angle, length, thickness, segments)
    for i = 1, segments do
        
    end
end

function createLevel()
    local ground = world:body(physics2d.static, 0, 0)
    ground:box(10, 0.5).category = GROUND
    
    local wall = world:body(physics2d.static, -5, 0)
    wall:box(0.5, 10).category = GROUND
    
    local seesaw = world:body(physics2d.dynamic, 5, 2)
    seesaw:box(1, 0.125).category = GROUND
    seesaw:hinge(seesaw.position)
    
    local roller = world:body(physics2d.dynamic, -2, 0.5)
    roller:circle(1.5).category = GROUND
    roller:box(2, 0.1, 0, 0, 0)
    roller:box(2, 0.1, 0, 0, 90)
    roller:box(2, 0.1, 0, 0 , 45)
    roller:box(2, 0.1, 0, 0, 135)
    
    roller:hinge(ground, roller.position)
    
    local box = world:body(physics2d.dynamic, 2, 0.5)
    box:box(0.4, 0.4, 0, 0)
    
    local box2 = world:body(physics2d.dynamic, 2, 2)
    box2:box(.25, .25, 0, 0)
    local slider = box2:slider(box2.position, vec2(1,0))
    slider.useLimit = true
    slider.lowerLimit = 0
    slider.upperLimit = 2
    
    local box3 = world:body(physics2d.dynamic, 2, 3)
    box3:box(.6, .1, 0, 0)
    local distA = box3:distance(box3.position - vec2(.4,0), box3.position + vec2(0,2))
    distA.minLength = 0
    local distB = box3:distance(box3.position + vec2(.4,0), box3.position + vec2(0,2))
    distB.minLength = 0
    
    local coin = world:body(physics2d.static, 5, 5)
    local coinSensor = coin:circle(0, 0, .25)
    coinSensor.sensor = true
    coinSensor.category = ITEM
    coin.onCollisionBegan = function(collision)
        if collision.other.body == char.body then
            coin:destroy()
        end

    end
end

function setup()
    
    gp = gamepad.virtual
        
    if gp then
        --gpVis = GamepadVisualiser(gp)
    end
    
    world = physics2d.world()
    
    
    cam = camera.ortho(8, -100, 100)
    camPos = vec2(0, 0)    
    char = Character(0, 2)    
    
    createLevel()
end

function fixedUpdate(dt)
    world:step()
    char:fixedUpdate(dt)
end

function update(dt)
    char:update(dt)
    
    local followSpeed = dt * 3
    camPos = char.body.position * followSpeed + camPos * (1 - followSpeed)
end

function draw()
    background(0, 0, 0, 0)
    matrix.push().transform2d(camPos)
    cam:apply()

    world:draw()    

    -- Draw in front of other stuff
    matrix.push().translate(0,0,0)
    char:draw()
    matrix.pop()
    
    -- Debugging
    --[[
    if char.grounded then
        local gpoint = char.grounded.point
        local gnorm = char.grounded.normal
        style.push().stroke(255, 255, 0).strokeWidth(0.01)
        line(gpoint.x, gpoint.y, gpoint.x + gnorm.x * 1, gpoint.y + gnorm.y * 1)
        line(gpoint.x, gpoint.y, gpoint.x + gnorm.y * 1, gpoint.y - gnorm.x * 1)
        style.noStroke().fill(100,100,255)
        ellipse(gpoint.x, gpoint.y, 0.1, 0.1)
        style.pop()
    end]]
    
    matrix.pop()
    matrix.ortho()
    
    text(string.format("grounded = %s, jumpTimer = %s", char.grounded ~= nil, char.jumpTimer), WIDTH/2, HEIGHT - 20)
    
    if gpVis then
        gpVis:draw(WIDTH - 250, HEIGHT - 250, 0.6)
    end
end

function touched(touch)
end

