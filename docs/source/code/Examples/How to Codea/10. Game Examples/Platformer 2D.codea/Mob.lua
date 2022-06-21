Mob = class('Mob'):include(require'codea.properties')

-- Mob:heading("Walking")

-- Walking
Mob:property {'acceleration', 'number', default = 90 * 8}
Mob:property {'moveClamp', 'number', default = 13 * 8}
Mob:property {'deAcceleration', 'number', default = 60 / 3}
Mob:property {'apexBonus', 'number', default = 4}

-- Mob:heading("Gravity")

-- Gravity
Mob:property {'fallClamp', 'number', default = -25}
Mob:property {'minFallSpeed', 'number', default = 60}
Mob:property {'maxFallSpeed', 'number', default = 80}
Mob:property {'fallSpeed', 'number', default = 0;}

-- Jumping

-- Mob:heading("Jumping")

Mob:property {'jumpHeight', 'number', default = 20}
Mob:property {'jumpApexThreshold', 'number', default = 10}
Mob:property {'coyoteTimeThreshold', 'number', default = 0.1}
Mob:property {'jumpBuffer', 'number', default = 0.1}
Mob:property {'jumpEndEarlyGravityModifier', 'number', default = 3}

Mob:property
{
    'grounded', 'boolean',
    get = function(self) return self.colDown end
}

Mob:property
{
    'dashing', 'boolean',
    get = function(self) return self.lastDashTime + self.dashDuration > time.elapsed end
}

Mob:property
{
    'hasBufferedJump', 'boolean',
    readonly = true,
    get = function(self)
        return self.colDown and self.lastJumpPressed + self.jumpBuffer > time.elapsed
    end
}

Mob:property
{
    'canUseCoyote', 'boolean',
    readonly = true,
    get = function(self)
        return self.coyoteUsable and not self.colDown and self.timeLeftGrounded + self.coyoteTimeThreshold > time.elapsed
    end
}

-- Dashing

Mob:property {'dashDuration', 'number', default = 0.15}
Mob:property {'dashSpeed', 'number', default = 18}
Mob:property {'maximumDashes', 'number', default = 1}

function Mob:created()
    if Mob.characters == nil then
        Mob.static.characters = image.read(asset.characters_png)
        Mob.static.atlas = Mob.characters.atlas
        Mob.atlas:setWithCellSize(24, 24)
        Mob.characters.smooth = false
    end

    if Mob.sounds == nil then
        Mob.sounds =
        {
            impacts =
            {
                sound.read(asset.sounds.impactWood_light_000),
                sound.read(asset.sounds.impactWood_light_001),
                sound.read(asset.sounds.impactWood_light_002),
                sound.read(asset.sounds.impactWood_light_003),
                sound.read(asset.sounds.impactWood_light_004)
            },
            footsteps =
            {
                sound.read(asset.sounds.footstep_concrete_000),
                sound.read(asset.sounds.footstep_concrete_001),
                sound.read(asset.sounds.footstep_concrete_002),
                sound.read(asset.sounds.footstep_concrete_003),
                sound.read(asset.sounds.footstep_concrete_004)
            }
        }
    end

    self.entity.sprite = Mob.atlas[1]
    self.entity.sortOrder = -2

    -- Movement
    self.velocity = vec3()
    self.jumpingThisFrame = false
    self.landingThisFrame = false
    self.timeLeftGrounded = 0
    self.jumpDown = false
    self.jumpUp = false
    self.x = 0
    self.y = 0
    self.dashDown = false
    self.rawMovement = vec3()
    self.lastPosition = vec3()
    self.currentHorizontalSpeed = 0
    self.currentVerticalSpeed = 0;

    -- Collision
    self.size = vec2(12, 18) / self.scene.pixelsPerUnit
    self.offset = vec2(0, -3) / self.scene.pixelsPerUnit
    self.extents = vec3(self.size.x/2, self.size.y/2, 0)
    self.bounds = bounds.aabb(vec3(), vec3())
    self.groundMask = GROUND_MASK
    self.detectorCount = 3
    self.detectionRayLength = 0.1
    self.rayBuffer = 0.1 -- Prevents side detectors hitting the ground

    self.colUp = false
    self.colDown = false
    self.colLeft = false
    self.colRight = false

    self.raysUp = {p1 = vec2(), p2 = vec2(), dir = vec2(0, 1) }
    self.raysDown = {p1 = vec2(), p2 = vec2(), dir = vec2(0, -1) }
    self.raysLeft = {p1 = vec2(), p2 = vec2(), dir = vec2(-1, 0) }
    self.raysRight = {p1 = vec2(), p2 = vec2(), dir = vec2(1, 0) }

    self.coyoteUsable = false
    self.endedJumpEarly = true
    self.apexPoint = 0
    self.lastJumpPressed = 0

    -- Move
    self.freeColliderIterations = 4

    -- Dashing
    self.lastDashTime = -10000
    self.wasDashing = false
    self.dashCount = 0
    self.dashDirection = vec2()
    self.trailIndex = 1
    self.lastTrail = -10000
    self.trailGap = 0.05

    -- Animation
    
    self.frames = {Mob.atlas[1], Mob.atlas[2]}
    self.walkCycle = 0
    self.frameDelay = 0.7
    self.frame = 1
    self.flipX = false

    local trailCount = 5
    self.trails = {}
    for i = 1,trailCount do
        table.insert(self.trails, {pos = vec3(), alpha = 128})
    end
end

function Mob:landed()
    local impacts = Mob.sounds.impacts
    sound.play(impacts[random.integer(1, #impacts)], random.number(0.025, 0.05), random.number(0.8, 1.2))
end

function Mob:footstep()
    local footsteps = Mob.sounds.impacts
    sound.play(footsteps[random.integer(1, #footsteps)], random.number(0.01, 0.03), random.number(0.7, 1.0))
end

function Mob:draw()
    style.push().blend(ADDITIVE).tintMode(REPLACE)
    matrix.push().reset()
    for i = 1, self.trailIndex do
        local t = self.trails[i]
        style.tint(t.alpha * 0.75, t.alpha, t.alpha * 0.75, t.alpha)
        sprite(self.frames[2], t.pos.x, t.pos.y)
    end
    matrix.pop()
    style.pop()


    -- style.push().noFill().stroke(color.yellow).strokeWidth(1)
    -- style.rectMode(CENTER)
    -- rect(self.offset.x, self.offset.y, self.size:unpack())
    --
    -- self:calculateRayRanged()
    --
    -- local w2d = self.scene.world2d
    --
    -- matrix.push()
    -- matrix.reset()
    -- local function runDetection(range)
    --     for i = 1, self.detectorCount do
    --         local t = (i-1.0) / (self.detectorCount-1.0)
    --         local p = range.p1:lerp(range.p2, t)
    --         local hit = w2d:raycast(p, range.dir, self.detectionRayLength, 1)
    --         style.stroke(hit and color.green or color.red)
    --         line(p, p + range.dir * self.detectionRayLength)
    --     end
    --     return false
    -- end
    -- runDetection(self.raysUp)
    -- runDetection(self.raysDown)
    -- runDetection(self.raysLeft)
    -- runDetection(self.raysRight)
    -- matrix.pop()
    --
    -- style.pop()
end

function Mob:update(dt)
    self:gatherInput()

    local speed = math.abs(self.rawMovement.x)
    if self.grounded and not self.dashing then
        if speed > 0.1 then
            self.walkCycle = self.walkCycle + speed * dt
            if self.walkCycle > self.frameDelay then
                self.walkCycle = 0
                self.frame = self.frame + 1
                self:footstep()
                if self.frame > #self.frames then self.frame = 1 end
                self.entity.sprite = self.frames[self.frame]
            end
        else
            self.entity.sprite = self.frames[1]
        end
    else
        self.entity.sprite = self.frames[2]
    end

    if self.rawMovement.x > 0 then
        self.flipX = true
    elseif self.rawMovement.x < 0 then
        self.flipX = false
    end
    self.entity.flipX = self.flipX

    if self.dashing then
        if self.lastTrail + self.trailGap < time.elapsed and self.trailIndex < #self.trails then
            self.trailIndex = self.trailIndex + 1
            self.lastTrail = time.elapsed
            self.trails[self.trailIndex].pos = self.entity.position
            self.trails[self.trailIndex].alpha = 255
        end
    end
    for i = 1,self.trailIndex do
        self.trails[i].alpha = self.trails[i].alpha - 800 * dt
    end

end

function Mob:fixedUpdate(dt)

    -- Calculate velocity
    local e = self.entity

    self.velocity = (e.position - self.lastPosition) / dt;
    self.lastPosition = e.position;

    self:runCollisionChecks();

    if not self:calculateDash() then
        self:calculateWalk(dt) -- Horizontal movement
        self:calculateJumpApex() -- Affects fall speed, so calculate before gravity
        self:calculateGravity(dt) -- Vertical movement
        self:calculateJump() -- Possibly overrides vertical
    end

    self:moveCharacter(dt) -- Actually perform the axis movement

    if self.landingThisFrame then self:landed() end

    self:clearInput()
end

function Mob:clearInput()
    self.jumpUp = false
    self.jumpDown = false
    self.dashDown = false
end

function Mob:gatherInput()

    local gp = gamepad.all[1]

    self.x = 0
    self.y = 0

    if gp then
        local jumpButton = gp.a
        local dashButton = gp.rightShoulder
        local moveStick = gp.leftStick
        local movePad = gp.dpad

        if jumpButton.pressed then self.jumpDown = true end
        if jumpButton.released then self.jumpUp = true end
        if dashButton.pressed then self.dashDown = true end
        self.x = moveStick.x + movePad.x
        self.y = moveStick.y + movePad.y
    end

    if key.wasPressed(key.space) then self.jumpDown = true end
    if key.wasReleased(key.space) then self.jumpUp = true end
    if key.wasPressed(key.e) then self.dashDown = true end

    local moveLeft = key.pressing(key.left)
    local moveRight = key.pressing(key.right)
    local moveUp = key.pressing(key.up)
    local moveDown = key.pressing(key.down)

    self.x = self.x + (moveLeft and -1 or 0) + (moveRight and 1 or 0)
    self.y = self.y + (moveDown and -1 or 0) + (moveUp and 1 or 0)

    if self.jumpDown then
        self.lastJumpPressed = time.elapsed
    end

end

function Mob:runCollisionChecks()
    self:calculateRayRanged()

    local w2d = self.scene.world2d

    local function runDetection(range)
        for i = 1, self.detectorCount do
            local t = (i-1.0) / (self.detectorCount-1.0)
            local p = range.p1:lerp(range.p2, t)
            local hit = w2d:raycast(p, range.dir, self.detectionRayLength, 1)
            if hit then return true end
        end
        return false
    end

    self.landingThisFrame = false
    local groundedCheck = runDetection(self.raysDown)

    if self.colDown and not groundedCheck then
        self.timeLeftGrounded = time.elapsed
    elseif not self.colDown and groundedCheck then
        self.coyoteUsable = true
        self.landingThisFrame = true
    end

    self.colDown = groundedCheck

    self.colUp = runDetection(self.raysUp)
    self.colLeft = runDetection(self.raysLeft)
    self.colRight = runDetection(self.raysRight)
end

function Mob:calculateRayRanged()
    self.bounds:set(-self.extents, self.extents)
    self.bounds:translate(self.entity.position)
    self.bounds:translate(vec3(self.offset.x, self.offset.y, 0))
    local bmin = self.bounds.min
    local bmax = self.bounds.max

    self.raysDown.p1.x, self.raysDown.p1.y = bmin.x + self.rayBuffer, bmin.y
    self.raysDown.p2.x, self.raysDown.p2.y = bmax.x - self.rayBuffer, bmin.y

    self.raysUp.p1.x = bmin.x + self.rayBuffer
    self.raysUp.p1.y = bmax.y
    self.raysUp.p2.x = bmax.x - self.rayBuffer
    self.raysUp.p2.y = bmax.y

    self.raysLeft.p1.x = bmin.x
    self.raysLeft.p1.y = bmin.y + self.rayBuffer
    self.raysLeft.p2.x = bmin.x
    self.raysLeft.p2.y = bmax.y - self.rayBuffer

    self.raysRight.p1.x = bmax.x
    self.raysRight.p1.y = bmin.y + self.rayBuffer
    self.raysRight.p2.x = bmax.x
    self.raysRight.p2.y = bmax.y - self.rayBuffer
end

function easeInOutQuad(x)
    return x < 0.5 and 2 * x * x or 1 - (-2 * x + 2)^2 / 2
end

function Mob:calculateDash()
    local dashing = self.dashing

    if self.wasDashing and not dashing then
        self.wasDashing = false
        self.currentVerticalSpeed = self.currentVerticalSpeed * 0.5
        return false
    end

    -- Check for dashing input and allow a dash if not currently dashing (or maximum dash count has not been reached)
    if self.dashDown and not dashing and self.dashCount < self.maximumDashes then
        self.dashDirection.x = self.x
        self.dashDirection.y = self.y

        if self.x == 0 and self.y == 0 then
            self.dashDirection.x = self.flipX and 1 or -1
        end

        self.dashDirection:normalize()

        if self.dashDirection.length2 > 0 then

            local dx, dy = self.dashDirection:unpack()

            -- Cancel dash if hitting a wall (but not on a diagonal)
            local hitWall = (dx > 0 and self.colRight) or
                            (dx < 0 and self.colLeft) or
                            (dy > 0 and self.colUp) or
                            (dy < 0 and self.colDown)
            local monoDir = not (dx ~= 0 and dy ~= 0)

            if not (hitWall and monoDir) then
                self.lastDashTime = time.elapsed
                self.trailIndex = 1
                self.dashCount = self.dashCount + 1
                self.lastTrail = time.elapsed
                self.trails[1].pos = self.entity.position
                self.trails[1].alpha = 255
                dashing = true
            end
        end
    elseif dashing then
        -- local t = (time.elapsed - self.lastDashTime) / self.dashDuration
        local dashSpeed = self.dashSpeed -- easeInOutQuad(t) * self.dashSpeed
        self.currentHorizontalSpeed = self.dashDirection.x * dashSpeed
        self.currentVerticalSpeed = self.dashDirection.y * dashSpeed

        local dx, dy = self.dashDirection:unpack()
        -- Cancel dash if hitting a wall while only dashing in one cardinal direction
        local hitWall = (dx > 0 and self.colRight) or
                        (dx < 0 and self.colLeft) or
                        (dy > 0 and self.colUp) or
                        (dy < 0 and self.colDown)
        local monoDir = not (dx ~= 0 and dy ~= 0)
        if hitWall and monoDir then self.lastDashTime = -10000 end
    elseif self.grounded then
        self.dashCount = 0
    end

    self.wasDashing = dashing

    return dashing
end

-- Horizontal movement
function Mob:calculateWalk(dt)
    if self.x ~= 0 then
        -- Set horizontal move speed
        self.currentHorizontalSpeed = self.x * self.acceleration * dt

        -- Clamped by max frame movement
        self.currentHorizontalSpeed = math.min(math.max(self.currentHorizontalSpeed, -self.moveClamp), self.moveClamp)

        -- Apply bonus at the apex of a jump
        local apexBonus = math.sign(self.x) * self.apexBonus * self.apexPoint
        self.currentHorizontalSpeed = self.currentHorizontalSpeed + apexBonus * dt
    else
        local diff = self.grounded and -self.currentHorizontalSpeed or -self.currentHorizontalSpeed * 0.5
        local max = self.deAcceleration * dt
        self.currentHorizontalSpeed = self.currentHorizontalSpeed + math.min(math.max(diff, -max), max)
    end

    if (self.currentHorizontalSpeed > 0 and self.colRight) or (self.currentHorizontalSpeed < 0 and self.colLeft) then
        self.currentHorizontalSpeed = 0
    end
end

-- Affects fall speed, so calculate before gravity
function Mob:calculateJumpApex()
    if not self.colDown then
        -- Gets stronger the closer to the top of the jump
        self.apexPoint =  math.clamp01(math.inverseLerp(self.jumpApexThreshold, 0, math.abs(self.velocity.y)))
        self.fallSpeed = math.lerp(self.minFallSpeed, self.maxFallSpeed, self.apexPoint)
    else
        self.apexPoint = 0
    end
end

-- Vertical movement
function Mob:calculateGravity(dt)

    if self.colDown then
        if self.currentVerticalSpeed < 0 then self.currentVerticalSpeed = 0 end
    else
        -- Add downward force while ascending if we ended the jump early
        local fallSpeed = (self.endedJumpEarly and self.currentVerticalSpeed > 0) and
                          (self.fallSpeed * self.jumpEndEarlyGravityModifier) or self.fallSpeed

        -- Fall
        self.currentVerticalSpeed = self.currentVerticalSpeed - fallSpeed * dt

        -- Clamp
        if self.currentVerticalSpeed < self.fallClamp then self.currentVerticalSpeed = self.fallClamp end
    end
end

-- Possibly overrides vertical
function Mob:calculateJump()
    -- Jump if: grounded or within coyote threshold || sufficient jump buffer
    if self.jumpDown and (self.canUseCoyote or self.hasBufferedJump) then
        self.currentVerticalSpeed = self.jumpHeight
        self.endedJumpEarly = false
        self.coyoteUsable = false
        self.timeLeftGrounded = -10000
        self.jumpingThisFrame = true
    else
        self.jumpingThisFrame = false
    end

    -- End the jump early if button released
    if not self.colDown and self.jumpUp and not self.endedJumpEarly and self.velocity.y > 0 then
        self.endedJumpEarly = true
    end

    if self.colUp then
        if self.currentVerticalSpeed > 0 then self.currentVerticalSpeed = 0 end
    end
end

-- Actually perform the axis movement
function Mob:moveCharacter(dt)
    local pos = self.entity.position

    self.rawMovement.x = self.currentHorizontalSpeed
    self.rawMovement.y = self.currentVerticalSpeed

    local move = self.rawMovement * dt

    local furthestPoint = pos + move

    -- check furthest movement. If nothing hit, move and don't do extra checks
    local ent = self.entity

    local world = self.scene.world2d
    local w, h = self.size:unpack()
    local x, y = self.offset:unpack()

    -- local hit = world:query(furthestPoint.x + x - w/2, furthestPoint.y + y - h/2, w, h)
    --
    -- if not hit then
    --     ent.x = ent.x + move.x;
    --     ent.y = ent.y + move.y;
    --     return
    -- end

    for i = 1,4 do
        local hasPen, nrm, pen = world:collideBox(furthestPoint.x + x - w/2, furthestPoint.y + y - h/2, w, h, 1)
        if hasPen then
            furthestPoint.x = furthestPoint.x + nrm.x * pen
            furthestPoint.y = furthestPoint.y + nrm.y * pen
        end
    end
    ent.position = furthestPoint
end
