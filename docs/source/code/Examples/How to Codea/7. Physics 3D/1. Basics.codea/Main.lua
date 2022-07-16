function setup()
    scn = scene.default3d()
    scn.camera:add(camera.rigs.orbit)
    scn.camera:add(physics3d.grabber)
    
    dark = material.lit()
    dark.
    
    checkers = material.lit()
    checkers.baseColorMap = image.read(asset.checkers)
    checkers.scaleOffset = vec4(0.125, 0.125, 0.0, 0.0)
    checkers.roughness = 0.5
    --material.save(asset.."/checkersMat", checkers)
    --checkers = material.read(asset.."/checkersMat")
    
    ground = scn:entity("ground")
    ground.y = -1
    ground:add(physics3d.body, STATIC):box(100,0.1,100)
    ground:add(mesh.box(100, 0.1, 100))
    ground.meshMaterial = checkers
    
    box = scn:entity("box")
    box.y = 1
    box:add(physics3d.body, DYNAMIC):box(1,1,1)
    box:add(mesh.box(1,1,1))
    box.meshMaterial = checkers
    
    scene.main = scn
end
