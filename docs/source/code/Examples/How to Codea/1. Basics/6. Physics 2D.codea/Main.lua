-- Physics in Codea

function setup()
    -- Create a 2D physics world
    world = physics2d.world()

    -- Once you have a physics world you can start creating bodies, which represent our simulated objects
    -- We can create 3 types of bodies:
    -- static - an immovable object that stays in one place
    -- dynamic - a dynamic object that moves and responds to gravity and collisions
    -- kinematic - like a static object but it can also move, hitting other objects

    -- Create a static floor for things to fall on and set position to 0, -5
    floor = world:body(STATIC, 0, -5)
    -- The box method attaches a box collider to our floor body (5 meters by 0.5 meters)
    floor:box(5, 0.5)

    -- Create a dynamic box to fall on our floor
    body = world:body(DYNAMIC, 0, 0)
    body:box(1, 1)

    body2 = world:body(DYNAMIC, 0, 3)
    body2:circle(0.5)

    -- Create a 2D camera to scale the world (our physics world uses meters as units, rather than pixels)
    cam = camera.ortho(20, 0, 100) -- make the screen 20 units wide
end

-- The fixedUpdate function gets called a fixed number of times every second
-- This is useful for physics simulations, keeping them stable
function fixedUpdate(dt)
    world:step(dt) -- advance the physics simulation by one frame
end

function draw()
    background(25, 25, 25)

    -- Use our camera to scale the screen to the right units
    cam:apply()
    -- Draw the physics world (you can use your own shapes but this is just handy to get started quickly)
    world:draw()
end

function touched(touch)
    -- We can also use our camera to convert touches from the screen to our physics units
    -- Using that we can spawn more physics shapes after each touch
    if touch.state == BEGAN then
        cam:apply() -- Apply the camera so we can convert to/from the physics units
        -- Convert from touch coordinates to world coordinates
        local x, y = cam:screenToWorld(touch.x, touch.y)
        -- Make a body at this x,y position
        local body = world:body(DYNAMIC, x, y)
        body:box(1, 1)
    end
end
