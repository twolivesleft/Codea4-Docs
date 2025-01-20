TestClass = class('TestClass')

function TestClass:init()
end

function TestClass:created()
    print("Created: ", tostring(self))
    print(self.enabled, self.entity, self.scene)
end

function TestClass:update(dt)
    print(self)
end

    
function setup()
    scn = scene.default2d()
    
    local length = 0.5
    local count = 5
    
    local prev = scn:entity()
    prev:add(physics2d.body, physics2d.static)
    prev:add(physics2d.box, 0, 0, length, 0.1)
    
    for i = 1,count do
        local next = scn:entity()
        next.x = i * length * 2
        next:add(physics2d.box, 0, 0, length, 0.1)        
        local joint = next:add(physics2d.hinge, prev)
        joint.useMotor = true
        joint.maxTorque = (count - i+1) * (count-i+1) * 1
        prev = next
    end
    
    local test = scn:entity()
    local t = test:add(TestClass)
    print(t)
    print(t.created)
    
    --local frog = asset.Main_Characters.Ninja_Frog
    --local img = image.read(frog.."Idle (32x32).png")
    --e:add(img.atlas[1])
end

function draw()
    scn:draw()
end

function touched(touch)
end
