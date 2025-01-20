PLAYER_MASK = 2
GROUND_MASK = 4

function setup()
    scn = scene.default2d()

    scn.physics2d.debugDraw = true
    scn.pixelsPerUnit = 18
    time.scale = 1

    root = scn:entity()
    map = root:add(Map)
    map:read(asset.TestMap)

    scene.main = scn
end