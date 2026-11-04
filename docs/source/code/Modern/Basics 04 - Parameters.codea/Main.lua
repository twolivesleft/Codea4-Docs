-- Modern

-- Use this function to perform your initial setup
function setup()
    print("Hello Parameters!")

    -- Create a simple scene containing a model to play with
    scn = scene.default3d()
    rig = scn.camera:add(camera.rigs.orbit)
    scn.camera:get(camera).clearMode = CAMERA_CLEAR_DEPTH_COLOR

    -- Basic entity with a sphere mesh
    ent = scn:entity()
    ent:add(mesh.sphere())

    mat = material.lit()
    mat.color = color.red
    ent.material = mat
    ent.expr = function() return 1.5 end

    -- Draw some text above the entity
    function ent:draw()
        style.fill(255).textAlign(CENTER|MIDDLE).fontSize(1)
        matrix.push()
        matrix.translate(0, self.expr(), 0)
        text(ent.name)
        matrix.pop()
    end

    -- Auto-update/draw the scene
    scene.main = scn


    parameter.text("Name", ent.name, function(value)
        ent.name = value
    end)

    -- Expression idiom (use multiline as well)
    parameter.text("Expression", "1.5", function(value)
        ent.expr = load("return "..value) or function() return 0 end
    end, true)

    -- Y value for the entity
    parameter.number("Y", 0, 10, 0, function(value)
        ent.y = value
    end)

    -- (De)activate entity
    parameter.boolean("Active", true, function(value)
        print(value and "On" or "Off")
        ent.active = value
    end)

    -- Adjust entity material color
    parameter.color("Color", color.yellow, function(value)
        mat.color = value
    end)

    -- Do a simple tween to squash and stretch
    parameter.action("Action", function()
        scn:tween(ent):punch{sx=2, sy=0.5}:time(1)
    end)

end
