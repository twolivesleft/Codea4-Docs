local Grabber = class('Grabber')

function Grabber:created()
    self.world = self.scene.world3d
    self.cam = self.entity:get(camera)
    self.rig = self.entity:get(camera.rigs.orbit)
end

function Grabber:touched(touch)
    local origin, dir = self.cam:screenToRay(touch.x, touch.y)

    if touch.began then
        local hit = self.world:raycast(origin, dir, 100)
        if hit and hit.body.type == physics3d.dynamic then
            self.body = hit.body
            self.anchor = self.body:localPoint(hit.point)
            self.dist = hit.fraction * 100
            self.rig.pan.enabled = false
            self.rig.pinch.enabled = false
            return true
        end
    elseif touch.moving then
        self.target = origin + dir * self.dist
    elseif touch.ended then
        self.anchor = nil
        self.target = nil
        self.body = nil
        self.rig.pan.enabled = true
        self.rig.pinch.enabled = true
    end
end

function Grabber:draw()
    if self.anchor and self.target then
        matrix.push().reset()
        style.push().noFill().stroke(255).strokeWidth(5)
        local wp = self.body:worldPoint(self.anchor)
        gizmos.line(wp, self.target)
        style.pop()
        matrix.pop()
    end
end

function Grabber:fixedUpdate(dt)
    if self.anchor and self.target then
        local wp = self.body:worldPoint(self.anchor)
        local v = self.target - wp
        --
        self.body:applyForce(v * 100 - self.body:velocityAtWorldPoint(wp) * 10.0, wp)
    end
end

function scene:sphere(dynamic, radius, x, y, z)
    local sphere = self:entity("sphere")
    sphere.position = vec3(x, y, z)
    sphere.scale = vec3(1,1,1)
    sphere:add(physics3d.body, dynamic and physics3d.dynamic or physics3d.static) --:sphere(0.5)
    sphere:add(physics3d.sphere, radius).rollingFriction = 0.1
    sphere.mesh = mesh.sphere(radius)
    sphere.mesh.material = checkers
    return sphere
end

function scene:capsule(dynamic, radius, height, x, y, z)
    local sphere = self:entity("sphere")
    sphere.position = vec3(x, y, z)
    sphere.scale = vec3(1,1,1)
    sphere:add(physics3d.body, dynamic and physics3d.dynamic or physics3d.static):capsule(radius, height)
    sphere.mesh = mesh.capsule(radius, height / 2)
    sphere.mesh.material = checkers
    return sphere
end

function scene:box(dynamic, sx, sy, sz, x, y, z)
    local box = self:entity("box")
    box.position = vec3(x, y, z)
    box:add(physics3d.body, dynamic and physics3d.dynamic or physics3d.static) --:sphere(0.5)
    box:add(physics3d.box, sx, sy, sz)
    box.mesh = mesh.box(sx, sy, sz)
    box.mesh.material = checkers
    return box
end

function entity:box(sx, sy, sz, x, y, z)
    local box = self:child()
    box.position = vec3(x, y, z)
    box:add(physics3d.box, sx, sy, sz)
    box.mesh = mesh.box(sx, sy, sz)
    box.mesh.material = checkers
    return box
end

function scene:convex(dynamic, msh, x, y, z, s)
    local teapot = scn:entity()
    teapot.position = vec3(x, y, z)
    teapot.mesh = msh
    teapot.mesh.material = checkers
    teapot:add(physics3d.body, dynamic and physics3d.dynamic or physics3d.static):mesh(teapot.mesh, true)
    s = s or 1.0
    teapot.scale = vec3(s,s,s)
    return teapot
end

function setup()
    scn = scene.default3d()
    scn.camera:add(camera.rigs.orbit)
    scn.camera:add(Grabber)

    cam = scn.camera:get(camera)

    scn.sun:get(light).intensity = 5.0

    checkers = material.lit()
    checkers.baseColorMap = image.read(asset.checkers)
    --checkers.metallic = 1.0
    --checkers.enableAnisotropy = true
    --checkers.anisotropy = 1.0
    --checkers.anisotropyDirectionMap = image.read(asset.anisoMap)
    checkers.roughness = 0.5

    --checkers.blend = material.blendTransparent
    --checkers.baseColor = color(255, 255, 255, 64)
    for k,v in pairs(checkers.properties) do
        --print(v.name, v.type)
    end

    compound = scn:entity()
    compound.position = vec3(3, 5, 0)
    compound:add(physics3d.body, physics3d.dynamic)
    compound:box(1, 0.1, 1, 0, -.9, 0)
    compound:box(1, 0.1, 1, 0, .9, 0)
    compound:box(0.1, 1, 1, -.9, 0, 0)
    compound:box(0.1, 1, 1, .9, 0, 0)
    
    sphere = scn:sphere(true, 0.5, -2.5, 5, 0)
    box = scn:box(true, .125, .5, .125, 0, 5, 0)
    capsuleA = scn:capsule(true, 0.25, 1, 0, 2, 0)
    capsuleB = scn:capsule(true, 0.25, 1, capsuleA:transformPoint(vec3(0, 1.5, 0)):unpack())
    capsuleC = scn:capsule(true, 0.25, 1, capsuleB:transformPoint(vec3(0, 1.5, 0)):unpack())
    local mx, my, mz = capsuleC:transformPoint(vec3(0, 1.0, 0)):unpack()
    monkey = scn:convex(true, mesh.read(asset.builtin.Primitives.Monkey_obj), mx, my, mz, 0.75)
    --monkey:get(physics3d.body).mass = 0.25
    local h1 = capsuleA:get(physics3d.body):hinge(capsuleB:get(physics3d.body), 0, 0.75, 0, 1, 0, 0)
    local h2 = capsuleA:get(physics3d.body):hinge(0, -0.75, 0, 0, 1, 0)
    local h3 = capsuleB:get(physics3d.body):hinge(capsuleC:get(physics3d.body), 0, 0.75, 0, 1, 0, 0)
    local h4 = capsuleC:get(physics3d.body):hinge(monkey:get(physics3d.body), 0, 0.75, 0, 1, 0, 0)

    h1.useMotor = true
    h1.maxTorque = 1
    h1.useLimit = true
    h1.lowerLimit = -125
    h1.upperLimit = 125

    h3.useMotor = true
    h3.maxTorque = 0.5
    h3.useLimit = true
    h3.lowerLimit = -125
    h3.upperLimit = 125

    h4.useMotor = true
    h4.maxTorque = 0.25
    h4.useLimit = true
    h4.lowerLimit = -125
    h4.upperLimit = 125

    h2.useMotor = true
    h2.maxTorque = 2
    --h2.useMotorTarget = true

    parameter.number("Target", -180, 180, 0, function(angle)
        --h2.motorSpeed = (angle - h2.angle) * -1 + h2.speed * 0.5
        --capsuleA:get(physics3d.body).awake = true
    end)

    --scn:convex(true, mesh.read(asset.builtin.Primitives.Monkey_obj), 0, 2, 0, 1)
    --scn:convex(true, mesh.icoSphere(0.5, 3), 2, 2, 2, 1)

    ground = scn:entity("ground")
    ground:add(physics3d.body, physics3d.static)
    ground:add(physics3d.box, 5, .1, 5)
    ground.mesh = mesh.box(5, .1, 5)
    ground.mesh.material = checkers

    time.scale = 1
end

function update()
end

function draw()
    scn:draw()
end

function touched(touch)
    return scn:touched(touch)
end
