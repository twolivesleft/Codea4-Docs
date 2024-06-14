local Grabber = class('Grabber')

function Grabber:created()
    self.spring = 100
    self.damper = 10
    self.world = self.scene.world3d
    self.cam = self.entity:get(camera)
    self.rig = self.entity:get(camera.rigs.orbit)
end

function Grabber:touched(touch)        
    local origin, dir = self.cam:screenToRay(touch.x, touch.y)
    
    if touch.began then        
        local hit = self.world:raycast(origin, dir, 100)        
        if hit and hit.body.type == DYNAMIC then
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
        self.body:applyForce(v * self.spring - self.body:velocityAtWorldPoint(wp) * self.damper, wp)
    end
end

function scene:sphere(dynamic, radius, x, y, z)    
    local sphere = self:entity("sphere")
    sphere.position = vec3(x or 0, y or 0, z or 0)
    sphere:add(physics3d.body, dynamic and DYNAMIC or STATIC) --:sphere(0.5)
    sphere:add(physics3d.sphere, radius).rollingFriction = 0.1
    sphere.mesh = mesh.sphere(radius)    
    sphere.meshMaterial = checkers
    return sphere
end

function scene:capsule(dynamic, radius, height, x, y, z)    
    local sphere = self:entity("sphere")
    sphere.position = vec3(x or 0, y or 0, z or 0)
    sphere.scale = vec3(1,1,1)
    sphere:add(physics3d.body, dynamic and DYNAMIC or STATIC):capsule(radius, height)
    sphere.mesh = mesh.capsule(radius, height / 2)    
    sphere.meshMaterial = checkers
    return sphere
end

function scene:box(dynamic, sx, sy, sz, x, y, z)    
    local box = self:entity("box")
    box.position = vec3(x or 0, y or 0, z or 0)    
    box:add(physics3d.body, dynamic and DYNAMIC or STATIC)
    box:add(physics3d.box, sx, sy, sz)
    box.mesh = mesh.box(sx, sy, sz)    
    box.meshMaterial = checkers
    return box
end

function entity:box(sx, sy, sz, x, y, z, rx, ry, rz)    
    local box = self:child()
    box.position = vec3(x or 0, y or 0, z or 0)    
    box.rotation = quat.eulerAngles(rx or 0, ry or 0, rz or 0)
    box:add(physics3d.box, sx, sy, sz)
    box.mesh = mesh.box(sx, sy, sz)    
    box.meshMaterial = checkers
    return box
end

function entity:capsule(radius, height, x, y, z, rx, ry, rz)    
    local box = self:child()
    box.position = vec3(x or 0, y or 0, z or 0)    
    box.rotation = quat.eulerAngles(rx or 0, ry or 0, rz or 0)
    box:add(physics3d.capsule, radius, height)
    box.mesh = mesh.capsule(radius, height / 2)    
    box.meshMaterial = checkers
    return box
end

function scene:convex(dynamic, msh, x, y, z, s)    
    local teapot = scn:entity()
    teapot.position = vec3(x, y, z)
    teapot.mesh = msh
    teapot.meshMaterial = checkers    
    teapot:add(physics3d.body, dynamic and DYNAMIC or STATIC):mesh(teapot.mesh, true)
    s = s or 1.0
    teapot.scale = vec3(s,s,s)    
    return teapot
end

function scene:torus(dynamic, radius1, radius2, x, y, z)
    local torus = scn:entity()
    torus.position = vec3(x, y, z)    
    torus:add(physics3d.body, dynamic and DYNAMIC or STATIC)
    
    torus:capsule(radius2 - radius1, 1, 0, 0, 0)
    
    return torus
end

function setup()
    scn = scene.default3d()
    local orbit = scn.camera:add(camera.rigs.orbit)
    orbit.angles.x = 45
    orbit.angles.y = 45
    orbit.distance = 20
    
    grabber = scn.camera:add(Grabber)    
    cam = scn.camera:get(camera)    
    scn.sun:get(light).intensity = 5.0

    parameter.boolean("PhysicsDebugDraw", false, function(b)
        scn.physics3d.debugDraw = b
    end)
    
    parameter.number("TimeScale", 0, 1, 1, function(t)
        time.scale = t
    end)
    
    checkers = material.lit()
    checkers.baseColorMap = image.read(asset.checkers)
    checkers.roughness = 0.5
            
    compound = scn:entity()
    compound.position = vec3(3, 5, 0)    
    compound:add(physics3d.body, DYNAMIC)
    compound:box(1, 0.1, 1, 0, -.9, 0, 0, 0, 20)
    compound:box(1, 0.1, 1, 0, .9, 0, 0, 0)    
    compound:box(0.1, 1, 1, -.9, 0, 0, 0, 0)
    compound:box(0.1, 1, 1, .9, 0, 0, 0, 0)    
    
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
    
    --torus = scn:torus(true, 1, 1.5, 0, 5, 0)
    ground = scn:box(false, 10, .1, 10)
end

function update()
end

function draw()
    scn:draw()    
end

function touched(touch)
    return scn:touched(touch)
end
