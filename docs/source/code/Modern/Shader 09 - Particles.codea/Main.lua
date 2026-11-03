-- Compute Shaders using shader.builder()
-- Instanced sprites with curl-noise velocity field

-- Use this function to perform your initial setup
function setup()

    -- Create a reusable shader chunk for the instances buffer that looks like this in GLSL:
    -- struct Instances
    -- {
    --    vec4 position; // (x, y, vx, vy) position and velocity
    -- };


    instancesChunk = shader.chunk()
        :struct{"Instance"}
            :vec4("position")
        :done()
        :buffer{"Instance", "instances", access = "readwrite"}

    -- Create the instanced unlit sprite shader
    instancing = shader.builder()
    :unlit()
    :add(instancesChunk) -- make instances buffer available to shader
    :cull("none"):blend("additive")
    :variable{"posVel"}
    :vertex
    [[
        vec4 posVel = instances[gl_InstanceID].position;
        float speed = max(length(posVel.zw), 0.0001);
        vec2 x = posVel.zw;
        vec2 y = vec2(-x.y, x.x) / speed;
        // Matrix to rotate and stretch along velocity
        mat2 rot = mat2(x * 1, y);

        // Apply translation and rotation to particle
        material.worldPosition.xy = rot * material.worldPosition.xy + posVel.xy;
        material.posVel = posVel;
    ]]
    :func
    [[
        vec3 hueShift( vec3 color, float hueAdjust ){

            const vec3  kRGBToYPrime = vec3 (0.299, 0.587, 0.114);
            const vec3  kRGBToI      = vec3 (0.596, -0.275, -0.321);
            const vec3  kRGBToQ      = vec3 (0.212, -0.523, 0.311);

            const vec3  kYIQToR     = vec3 (1.0, 0.956, 0.621);
            const vec3  kYIQToG     = vec3 (1.0, -0.272, -0.647);
            const vec3  kYIQToB     = vec3 (1.0, -1.107, 1.704);

            float   YPrime  = dot (color, kRGBToYPrime);
            float   I       = dot (color, kRGBToI);
            float   Q       = dot (color, kRGBToQ);
            float   hue     = atan (Q, I);
            float   chroma  = sqrt (I * I + Q * Q);

            hue += hueAdjust;

            Q = chroma * sin (hue);
            I = chroma * cos (hue);

            vec3    yIQ   = vec3 (YPrime, I, Q);

            return vec3( dot (yIQ, kYIQToR), dot (yIQ, kYIQToG), dot (yIQ, kYIQToB) );
        }
    ]]
    :material
    [[
        vec4 posVel = vertex_posVel;
        material.baseColor = vec4(hueShift(vec3(0.2, 0.4, 0.3), length(posVel.zw)), 0.05);
    ]]
    :build()

    -- Compute shader for updating the instances each frame
    updatePositions = shader.builder()
    :add(instancesChunk)
    -- GPU noise functions (see the GPU Noise reference)
    :include("codea/noise/noise.glsl")
    :uint{"instanceCount", value = 0}
    :vec2{"screenSize", value = vec2(WIDTH, HEIGHT)}
    -- TODO: add support for uniform arrays to make this easier
    :vec4{"attractorA", value = vec4(WIDTH/2, HEIGHT/2, 300, 0.001)}
    :vec4{"attractorB", value = vec4(WIDTH/2, HEIGHT/2, 300, 0.001)}
    :vec4{"attractorC", value = vec4(WIDTH/2, HEIGHT/2, 300, 0.001)}
    :threads(512,1,1)
    :compute
    [[
        // Get the current instance to work on
        uint i = gl_GlobalInvocationID.x;

        // Prevent going over the end of the buffer
        if (i < instanceCount)
        {
            vec2 pos = instances[i].position.xy;
            vec2 vel = instances[i].position.zw;


            // Sample two curl-noise fields that scroll in different directions and rates
            vec2 curl1 = SimplexPerlin2D_Deriv(pos * 0.01 + vec2(u_time.x, -u_time.x) * 0.5).yz;
            curl1 = vec2(-curl1.y, curl1.x) * 0.75;

            vec2 curl2 = SimplexPerlin2D_Deriv(pos * 0.05 + vec2(0, u_time.x) * 5.0).yz;
            curl2 = vec2(-curl2.y, curl2.x) * 0.5;

            // Apply curl noise velocity field
            vel += (curl1 + curl2) * u_time.y;

            vec4 attractors[3] =
            {
                attractorA,
                attractorB,
                attractorC,
            };

            for (int i = 0; i < 3; i++)
            {
                vec4 attractor = attractors[i];
                vec2 force = (attractor.xy - pos);
                float dist = length(force);
                force = force / max(dist, 0.0001) * (1 - min(dist / max(attractor.z, 0.0001), 1));
                vel += force * attractor.w;
            }

            // Apply some damping
            vel -= vel * 0.8 * u_time.y;

            // Add velocity to position * delta time
            pos += vel * 30.0 * u_time.y;

            // Bounce instances to screen bounds
            if (pos.x < 0.0)
            {
                vel.x *= -2.0; pos.x = 0.0;
            }
            else if (pos.x > screenSize.x)
            {
                vel.x *= -2.0; pos.x = screenSize.x;
            }
            if (pos.y < 0.0)
            {
                vel.y *= -2.0; pos.y = 0.0;
            }
            else if (pos.y > screenSize.y)
            {
                vel.y *= -2.0; pos.y = screenSize.y;
            }

            instances[i].position = vec4(pos, vel);
        }
    ]]
    :build()

    -- Create a buffer to match the shader buffer (syntax is a bit ugly right now)
    local layout = shader.bufferLayout
    {
        {shader.position, 4, shader.float} -- vec4
    }
    -- Create buffer to hold instance data
    instancesBuffer = shader.buffer(layout)

    -- Create initial instances by appending data to buffer
    -- Change this number to adjust the total particles being created
    for k = 1, 10000 do
        instancesBuffer:append(shader.position, vec4(math.random(0, WIDTH), math.random(0, HEIGHT),
        0, 0)) --math.random() * 0.5 - 0.5, math.random() * 0.5 - 0.5))
    end

    updatePositions:setBuffer("instancesBuffer", instancesBuffer)
    updatePositions.instanceCount = instancesBuffer.size

    instancing:setBuffer("instancesBuffer", instancesBuffer)

    -- Make one tiny little quad for our sprites
    m = mesh()
    m:addRect(0, 0, 1.5, 1.5)
    m.shader = instancing

    attractors =
    {
        {name = "attractorA", params = vec4()},
        {name = "attractorB", params = vec4()},
        {name = "attractorC", params = vec4()}
    }

    parameter.integer("Attractor", 1, 3, 1)
    parameter.number("AttractorRadius", 0, 1000, 300, updateAttractor)
    parameter.number("AttractorStrength", 0, 100, 5, updateAttractor)

    -- Camera effects are documented separately; this demo focuses on GPU buffers.
end

function updateAttractor()
    local a = attractors[Attractor]
    a.params.z = (AttractorRadius or 300)
    a.params.w = (AttractorStrength or 5) / 100
    updatePositions[a.name] = a.params
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color

    updatePositions.screenSize = vec2(WIDTH, HEIGHT)
    local wx = updatePositions:workgroupSize()
    updatePositions:dispatch(math.ceil(instancesBuffer.size / wx), 1, 1)

    --b:push()
    background(40, 40, 50)
    style.push().noStroke().fill(255)
    for k,v in pairs(attractors) do
        ellipse(v.params.x, v.params.y, 5)
    end
    style.pop()
    m:draw(instancesBuffer.size)
    --b:pop()
end

function touched(touch)
    local a = attractors[Attractor]
    a.params.x = touch.x
    a.params.y = touch.y
    updateAttractor()
end
