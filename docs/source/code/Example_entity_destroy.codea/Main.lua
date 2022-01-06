function setup()
    scene.main = scene.default3d()
    e = scene.main:entity()
    e.rotation = quat.eulerAngles(45, 45, 45)    
    e.mesh = mesh.box(1,1,1)
    e.mesh.material = material.lit()
    
    -- Destroy after 1 second when touched
    e.touched = function(entity, touch)
        if touch.began then entity:destroy(1) end
    end

    -- Play hurt sound when destroyed
    e.destroyed = function()
        sound.play(HURT)
    end
    
end