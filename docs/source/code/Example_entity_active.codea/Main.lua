function setup()
    scene.main = scene.default3d()
    
    red = material.lit()
    red.baseColor = color.red
    red.roughness = 1

    green = material.lit()
    green.baseColor = color.green
    green.roughness = 1

    blue = material.lit()
    blue.baseColor = color.blue
    blue.roughness = 1
    
    -- Create some sphere that orbit each other with parenting
    e1 = scene.main:entity()
    e1.mesh = mesh.sphere(1.0)
    e1.mesh.material = red
    
    e1.update = function(entity, dt)
        entity.rotation = quat.eulerAngles(0, 0, time.elapsed * 90)
    end
    
    e2 = e1:child()
    e2.y = -2.5
    e2.mesh = mesh.sphere(0.5)
    e2.mesh.material = green
    e2.update = e1.update
    
    e3 = e2:child()
    e3.y = -1
    e3.mesh = mesh.sphere(0.25)
    e3.mesh.material = blue
    
    -- Test switching entity active states on and off for bits of the hierarchy
    parameter.boolean("E1_Active", true, function(b)
        e1.active = b
    end)
    
    parameter.watch("e1.activeInHierarchy")
    
    parameter.boolean("E2_Active", true, function(b)
        e2.active = b
    end)
    
    parameter.watch("e2.activeInHierarchy")
    
    parameter.boolean("E3_Active", true, function(b)
        e3.active = b
    end)
    
    parameter.watch("e3.activeInHierarchy")
end
