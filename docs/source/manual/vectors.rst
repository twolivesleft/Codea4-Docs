Using Vectors
=============

Vectors represent positions, directions, and velocities in 2D and 3D space. This guide walks through the most common vector patterns in game development, each with a complete runnable example.

Moving Along a Vector
#####################

The most fundamental vector operation in games is movement: add a velocity vector to a position each frame, and an object moves. Because velocity has both **direction** and **magnitude** (speed), you can fire a bullet toward any point on screen with just a subtraction, a normalization, and a scale.

**Shooting bullets toward a touch**

.. code-block:: lua

   function setup()
       bullets = {}
       origin  = vec2(WIDTH/2, HEIGHT/2)
   end

   function draw()
       background(20, 25, 35)

       -- Move and draw each bullet
       for i = #bullets, 1, -1 do
           local b = bullets[i]
           b.pos = b.pos + b.vel * DeltaTime

           fill(255, 220, 50)
           ellipse(b.pos.x, b.pos.y, 8, 8)

           -- Remove once off-screen
           if b.pos.x < 0 or b.pos.x > WIDTH or
              b.pos.y < 0 or b.pos.y > HEIGHT then
               table.remove(bullets, i)
           end
       end

       -- Draw turret
       fill(100, 180, 255)
       ellipse(origin.x, origin.y, 28, 28)
   end

   function touched(touch)
       if touch.state == BEGAN then
           local dir = (vec2(touch.x, touch.y) - origin):normalized()
           table.insert(bullets, {
               pos = vec2(origin.x, origin.y),
               vel = dir * 600  -- 600 pixels per second
           })
       end
   end

Subtracting two positions gives a direction vector. ``:normalized()`` scales it to length 1 so that multiplying by ``600`` always produces the same speed, no matter how far away the touch was.

Rotating Vectors
################

``:rotate(angleRadians)`` rotates a ``vec2`` by an angle. Rotating an offset vector each frame and adding it to a center point produces natural circular motion — no trigonometry functions needed.

**Objects orbiting a center point**

.. code-block:: lua

   function setup()
       center = vec2(WIDTH/2, HEIGHT/2)
       moons  = {
           { offset = vec2(140, 0), speed = 1.2, size = 18, r = 255, g = 100, b = 100 },
           { offset = vec2(220, 0), speed = 0.7, size = 24, r = 100, g = 180, b = 255 },
           { offset = vec2( 80, 0), speed = 2.4, size = 12, r = 120, g = 255, b = 140 },
       }
   end

   function draw()
       background(10, 12, 20)

       -- Central body
       fill(255, 200, 80)
       ellipse(center.x, center.y, 40, 40)

       for _, moon in ipairs(moons) do
           moon.offset = moon.offset:rotate(moon.speed * DeltaTime)
           local pos = center + moon.offset

           -- Draw orbit ring
           stroke(60, 65, 80)
           strokeWidth(1)
           noFill()
           ellipse(center.x, center.y, moon.offset:length() * 2, moon.offset:length() * 2)

           -- Draw moon
           noStroke()
           fill(moon.r, moon.g, moon.b)
           ellipse(pos.x, pos.y, moon.size, moon.size)
       end
   end

Each moon stores only its offset from the center. Rotating that offset by ``speed * DeltaTime`` radians per frame moves it around the orbit automatically.

Dot Product — Field of View
###########################

The dot product of two **normalized** vectors equals ``cos(θ)`` where ``θ`` is the angle between them. This makes it a fast way to ask *"is this target within my field of view?"* without computing any angles.

- ``dot == 1`` → same direction (0°)
- ``dot == 0`` → perpendicular (90°)
- ``dot == -1`` → opposite (180°)

If you want a 120° cone (60° either side of forward), pre-compute ``math.cos(math.pi/3)`` and compare the dot product against it.

**Guard with a cone of vision**

.. code-block:: lua

   function setup()
       guardPos = vec2(WIDTH/2, HEIGHT/2)
       guardDir = vec2(0, 1)     -- facing up
       fovCos   = math.cos(math.pi / 3)  -- 60° half-angle → 120° total FOV
       sightDist = 220
   end

   function draw()
       background(25, 30, 40)

       -- Guard slowly rotates
       guardDir = guardDir:rotate(0.6 * DeltaTime)

       local touchPos = vec2(CurrentTouch.x, CurrentTouch.y)
       local toTouch  = touchPos - guardPos
       local dist     = toTouch:length()

       -- Dot product test: within range AND within cone?
       local spotted = dist < sightDist and dist > 1 and
                       guardDir:dot(toTouch / dist) >= fovCos

       -- Draw sight cone (two edge lines)
       local left  = guardDir:rotate( math.pi/3) * sightDist
       local right = guardDir:rotate(-math.pi/3) * sightDist
       stroke(spotted and color(255, 80, 80, 120) or color(80, 200, 80, 80))
       strokeWidth(1)
       fill(spotted and color(255, 80, 80, 30) or color(80, 200, 80, 20))
       -- draw the cone as two lines from guard
       line(guardPos.x, guardPos.y, guardPos.x + left.x,  guardPos.y + left.y)
       line(guardPos.x, guardPos.y, guardPos.x + right.x, guardPos.y + right.y)

       -- Draw guard
       noStroke()
       fill(150, 190, 255)
       ellipse(guardPos.x, guardPos.y, 28, 28)

       -- Draw touch target
       fill(spotted and color(255, 80, 80) or color(80, 255, 80))
       ellipse(touchPos.x, touchPos.y, 20, 20)

       fill(255)
       fontSize(20)
       text(spotted and "SPOTTED!" or "hidden", WIDTH/2, 50)
   end

Move your finger around the screen. The guard rotates slowly — watch for the moment the dot product crosses the threshold and the target is detected.

Smooth Following with Lerp
##########################

``:lerp(target, t)`` blends between two vectors. Calling it every frame with a small ``t`` (proportional to ``DeltaTime``) makes an object ease toward its target — the further away it is, the faster it moves, gradually slowing as it closes in.

This pattern appears everywhere: cameras, enemy AI homing, UI elements sliding into place, and health bars draining smoothly.

**Camera that lags behind the player**

.. code-block:: lua

   function setup()
       playerPos = vec2(WIDTH/2, HEIGHT/2)
       cameraPos = vec2(WIDTH/2, HEIGHT/2)
   end

   function draw()
       -- Player snaps to touch
       if CurrentTouch.state ~= ENDED then
           playerPos = playerPos:lerp(
               vec2(CurrentTouch.x, CurrentTouch.y), 12 * DeltaTime)
       end

       -- Camera lazily follows
       cameraPos = cameraPos:lerp(playerPos, 4 * DeltaTime)

       background(20, 28, 38)

       -- World grid, offset by camera
       local offset = vec2(WIDTH/2, HEIGHT/2) - cameraPos
       stroke(45, 55, 70)
       strokeWidth(1)
       for gx = -8, 8 do
           for gy = -8, 8 do
               local wx = gx * 70 + offset.x
               local wy = gy * 70 + offset.y
               line(wx - 6, wy, wx + 6, wy)
               line(wx, wy - 6, wx, wy + 6)
           end
       end

       -- Player is always drawn at the screen center (the camera follows them)
       noStroke()
       fill(100, 220, 110)
       ellipse(WIDTH/2, HEIGHT/2, 26, 26)
   end

The factor ``4 * DeltaTime`` controls lag — increase it to snap the camera closer, decrease it for more cinematic drift. The player uses ``12 * DeltaTime`` to stay responsive.

Reflecting Vectors — Bouncing Ball
###################################

``:reflect(normal)`` flips a direction vector about a surface normal. It is the correct and efficient way to handle elastic collisions with flat surfaces.

The normal always points *away from* the surface: ``vec2(1, 0)`` for a left wall, ``vec2(0, 1)`` for a floor, and so on.

**Ball bouncing around the screen**

.. code-block:: lua

   function setup()
       pos    = vec2(WIDTH/2, HEIGHT/2)
       vel    = vec2(280, 350)
       radius = 22
   end

   function draw()
       background(18, 22, 32)

       pos = pos + vel * DeltaTime

       -- Bounce off left/right
       if pos.x - radius < 0 then
           pos.x = radius
           vel   = vel:reflect(vec2(1, 0))
       elseif pos.x + radius > WIDTH then
           pos.x = WIDTH - radius
           vel   = vel:reflect(vec2(-1, 0))
       end

       -- Bounce off bottom/top
       if pos.y - radius < 0 then
           pos.y = radius
           vel   = vel:reflect(vec2(0, 1))
       elseif pos.y + radius > HEIGHT then
           pos.y = HEIGHT - radius
           vel   = vel:reflect(vec2(0, -1))
       end

       -- Draw shadow
       fill(0, 0, 0, 60)
       ellipse(pos.x + 6, pos.y - 6, radius * 2, radius * 2)

       -- Draw ball
       fill(255, 100, 60)
       ellipse(pos.x, pos.y, radius * 2, radius * 2)
   end

The same pattern works for angled surfaces — just use the surface's perpendicular as the normal. A 45° ramp has normal ``vec2(1, 1):normalized()``.

Proximity Detection
###################

``:distance()`` measures the straight-line gap between two positions. Comparing it against a threshold radius is the simplest possible collision or pickup test.

**Collecting coins**

.. code-block:: lua

   function setup()
       playerPos = vec2(WIDTH/2, HEIGHT/2)
       coins     = {}
       for i = 1, 12 do
           table.insert(coins, vec2(
               math.random(60, WIDTH  - 60),
               math.random(60, HEIGHT - 60)))
       end
       score = 0
   end

   function draw()
       background(22, 28, 38)

       -- Player follows touch
       if CurrentTouch.state ~= ENDED then
           playerPos = playerPos:lerp(
               vec2(CurrentTouch.x, CurrentTouch.y), 10 * DeltaTime)
       end

       -- Collect any coin within range
       for i = #coins, 1, -1 do
           if playerPos:distance(coins[i]) < 38 then
               table.remove(coins, i)
               score = score + 1
           end
       end

       -- Draw coins
       fill(255, 200, 40)
       for _, c in ipairs(coins) do
           ellipse(c.x, c.y, 22, 22)
       end

       -- Draw player
       fill(80, 160, 255)
       ellipse(playerPos.x, playerPos.y, 30, 30)

       fill(255)
       fontSize(22)
       text("Score: " .. score, WIDTH/2, HEIGHT - 40)

       if #coins == 0 then
           fontSize(36)
           text("All collected!", WIDTH/2, HEIGHT/2)
       end
   end

For performance with many objects, compare ``:distance2()`` against the squared radius instead — it skips the square root entirely.

Vector Swizzling
################

``vec2``, ``vec3`` and ``vec4`` support swizzling, which lets you read or write multiple components in any order using ``xyzw`` (or equivalently ``rgba``) notation.

.. code-block:: lua

   v1 = vec4(1, 2, 3, 4)
   v2 = vec3(5, 6, 7)

   -- Reading — any combination of components
   print(v1.wzyx)      -- prints '(4.0, 3.0, 2.0, 1.0)'
   print(v1.zzz)       -- prints '(3.0, 3.0, 3.0)'
   print(v2.xz)        -- prints '(5.0, 7.0)'

   -- Writing — assign to a subset of components at once
   v1.yx = vec2(5, 6)  -- v1 is now '(6.0, 5.0, 3.0, 4.0)'
   v1.xyz = v2.yzx     -- v1 is now '(6.0, 7.0, 5.0, 4.0)'

Swizzling is particularly useful when working with shader code or converting between ``vec3`` positions and ``vec4`` homogeneous coordinates:

.. code-block:: lua

   local pos3 = vec3(1, 2, 3)

   -- Lift to homogeneous coords (w = 1 for a position)
   local pos4 = vec4(pos3.x, pos3.y, pos3.z, 1)

   -- Extract just the XZ plane (useful for flat-ground games)
   local flat = pos3.xz   -- returns vec2(1, 3)
