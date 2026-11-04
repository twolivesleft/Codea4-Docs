-- GPU Grass
-- viewer.displayStats = true

-- Reusable glass properties
GrassColorChunk = shader.chunk()
    :color{"midColor", value = color(61, 161, 25)}
    :color{"baseColor2", value = color(27, 53, 27)}
    :color{"tipColor", value = color(229, 203, 100)}

-- Reusable grass instance buffer settings
InstancesChunk = shader.chunk()
    :struct{"Instance"}
        :vec4("position")
        :vec4("details")
    :done()
    :buffer{"Instance", "instances", access = "readwrite"}

function setup()
    scn = scene.default3d()
    sunlight = scn.sun:get(light)
    sunlight.castShadows = true
    cam = scn.camera:get(camera)
    cam.clearColor = color(47)
    scn.skyBlur = 9
    rig = scn.camera:add(camera.rigs.orbit)
    rig.distance = 75
    rig.angles.x = 45
    rig.angles.y = 45

    groundEnt = scn:entity("ground")
    terrain = groundEnt:add(Terrain)
    grass = groundEnt:add(Grass)

    box = scn:entity("box")
    box.scale = vec3(3, 5, 3)
    box.y = 15
    box:add(mesh.box())

    scene.main = scn

    parameter.color("GrassBaseColor", color(27, 53, 27), function(s)
        Grass.shader.baseColor2 = s
    end)

    parameter.color("GrassMidColor", color(61, 161, 25), function(s)
        Grass.shader.midColor = s
    end)

    parameter.color("GrassTipColor", color(229, 203, 100), function(s)
        Grass.shader.tipColor = s
    end)

    parameter.number("WindNoiseScale", 0, 500, 250, function(s)
        grass.windNoiseScale = s
    end)

    parameter.number("WindPanSpeed", 0, 0.5, 0.04, function(s)
        grass.windPanSpeed = s
    end)

    parameter.number("WindNoiseStrength", 0, 10, 3, function(s)
        grass.windNoiseStrength = s
    end)

    parameter.number("BladeThickness", 0.1, 3, 0.4, function(s)
        grass.bladeThickness = s
    end)

    parameter.number("BladeHeight", 0.1, 10, 4, function(s)
        grass.bladeHeight = s
    end)

    parameter.number("BladeBendFactor", 0.1, 4, 2, function(s)
        grass.bladeBendFactor = s
    end)

    parameter.number("BladeBendStrength", 0.0, 3, 0.5, function(s)
        grass.bladeBendStrength = s
    end)

    parameter.boolean("ShadowsEnabled", false, function(s)
        sunlight.castShadows = s
    end)

    parameter.integer("GrassDensity", 100, 1000, 100, function(d)
    end)

    parameter.action("UpdateGrass", function()
        grass:setDensity(GrassDensity)
    end)

end

function draw()
    matrix.reset().ortho()
    sprite(terrain.heightMap, WIDTH-100, HEIGHT/2, 100)

end
