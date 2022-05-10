instancing = shader{
    options =
    {
    },

    properties =
    {
        {"instancesBuffer", "buffer"}
    },

    pass =
    {
        blendMode = "normal",

        vertex =
        [[
            #version 430
            #include <codea/common.glsl>

            in vec3 a_position;
            in vec4 a_color0;
            in vec2 a_texcoord0;

            layout(location = 0) out vec4 v_color0;
            layout(location = 1) out vec2 v_texcoord0;

            struct Instance
            {
                vec4 position;
            };

            BUFFER_RO(instances, Instance, BUFFER0);

            void main()
            {
                gl_Position = u_modelViewProj * vec4(a_position + vec3(instances[gl_InstanceID].position.xy, 0.0), 1.0);
                v_color0 = a_color0 * u_tintColor;
                v_texcoord0 = a_texcoord0;
            }
        ]],

        fragment =
        [[
            #version 430
            #include <codea/common.glsl>

            layout(location = 0) in vec4 v_color0;
            layout(location = 1) in vec2 v_texcoord0;

            out vec4 FragColor;

            void main()
            {
                FragColor = texture(s_texture, v_texcoord0);
            }
        ]],
    }
}

updatePositions = shader.compute(
[[
    #version 430
    #include <codea/common.glsl>

    struct Instance
    {
        vec4 position;
    };

    BUFFER_RW(instances, Instance, BUFFER0);

    uniform uint u_instanceCount;

    float rand(vec2 co){
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    }

    NUM_THREADS(64, 1, 1)
    void main()
    {
        uint i = gl_GlobalInvocationID.x;
        if ( i < u_instanceCount )
        {
            //float r = rand(instances[i].position.xy) * 0.5 - 0.5;
            //float r2 = rand(vec2(r, r * 101.234)) * 0.5 - 0.5;
            //instances[i].position += vec2(r, r2) * u_time.y;
            vec2 pos = instances[i].position.xy;
            vec2 vel = instances[i].position.zw;
            vec2 screenSize = u_viewRect.zw / 2.0;

            pos += vel * 30.0 * u_time.y;

            if (pos.x < 0.0)
            {
                vel.x *= -1.0;
                pos.x = 0.0;
            }

            if (pos.x > screenSize.x)
            {
                vel.x *= -1.0;
                pos.x = screenSize.x;
            }

            if (pos.y < 0.0)
            {
                vel.y *= -1.0;
                pos.y = 0.0;
            }

            if (pos.y > screenSize.y)
            {
                vel.y *= -1.0;
                pos.y = screenSize.y;
            }

            instances[i].position = vec4(pos, vel);
        }
    }
]])

function swap(a, b)
    return b, a
end

function setup()

    m = mesh()

    local size = vec2(50, 50)

    m.positions =
    {
        vec3(-size.x/2, size.y/2, 0),
        vec3(size.x/2, size.y/2, 0),
        vec3(size.x/2, -size.y/2, 0),
        vec3(-size.x/2, -size.y/2, 0)
    }

    m.uvs =
    {
        vec2(0, 0),
        vec2(1, 0),
        vec2(1, 1),
        vec2(0, 1)
    }

    m.colors =
    {
        color(255),
        color(255),
        color(255),
        color(255)
    }

    m:addElement(3,2,1)
    m:addElement(4,3,1)
    m.shader = instancing
    m.texture = image.read(asset.builtin.Simplified_Platformer.Character)

    -- Layout: position = pos.xy, vel.xy
    local layout = shader.bufferLayout{{shader.position, 4, shader.float}}
    -- Create buffer to hold instance data
    instancesBuffer = shader.buffer(layout)
    
    -- Create insances by appending data to buffer
    for k = 1, 10000 do
        instancesBuffer:append(shader.position, vec4(math.random(0, WIDTH), math.random(0, HEIGHT), 
                                                     math.random() * 0.5 - 0.5, math.random() * 0.5 - 0.5))
    end
    instancing:setBuffer("instancesBuffer", instancesBuffer, shader.read)

    updatePositions:setBuffer("instancesBuffer", instancesBuffer, shader.readwrite)
    updatePositions.u_instanceCount = instancesBuffer.size

    parameter.integer("InstanceCount", 1, instancesBuffer.size, 10)
end

-- This function gets called whenever a touch
--  begins or changes state
function touched(touch)
end

function draw()
    background(0, 0, 0, 255)

    updatePositions:dispatch(math.ceil(instancesBuffer.size / 64), 1, 1)

    m:draw(InstanceCount)
end
