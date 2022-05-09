---[[
rd = shader {
    options =
    {
    },

    properties =
    {
        {"image", "image2D"},
    },

    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba32f) uniform image2D image;

            NUM_THREADS(16, 16, 1)
            void main()
            {
                uvec2 size = imageSize(image);
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

                if ( all(lessThan(pixel.xy, size)) )
                {
                    vec4 value = vec4(0.0, 0.0, 0.0, 0.0);
                    imageStore(image, pixel, value);
                }
            }
        ]]
    }
}

paint = shader {
    options =
    {
    },

    properties =
    {
        {"image", "image2D", format = image.rgba32f},
        {"u_paintPos", "vec2", {0.0, 0.0}},
        {"u_brushSize", "float", 10.0}
    },

    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba32f) uniform image2D image;
            uniform vec2 u_paintPos;
            uniform float u_brushSize;

            float random (vec2 st)
            {
                return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
            }

            NUM_THREADS(16, 16, 1)
            void main()
            {
                uvec2 size = imageSize(image);
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

                if ( all(lessThan(pixel.xy, size)) )
                {
                    if (distance(u_paintPos, vec2(pixel)) < u_brushSize)
                    {
                        vec4 value = vec4(1.0, 0.0, 0.0, 0.0);
                        value.r = 0.5 + random(pixel.xy) * 0.02 - 0.01;
                        value.g = 0.5 + random(pixel.xy * 5) * 0.02 - 0.01;
                        imageStore(image, pixel, value);
                    }
                }
            }
        ]]
    }
}

visualise = shader{
    options =
    {
    },

    properties =
    {
        {"u_gradient", "float", 0.0}
    },

    pass =
    {
        vertex =
        [[
            #version 430
            #include <codea/common.glsl>

            layout (location = POSITION) in vec3 a_position;
            layout (location = COLOR0) in vec4 a_color0;
            layout (location = TEXCOORD0) in vec2 a_texcoord0;

            layout(location = 0) out vec4 v_color0;
            layout(location = 1) out vec2 v_texcoord0;

            void main()
            {
                gl_Position = u_modelViewProj * vec4(a_position, 1.0);
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

            const float COLOR_MIN = 0.2, COLOR_MAX = 0.4;

            GRADIENT(u_gradient);

            void main()
            {
                vec2 ab = texture(s_texture, v_texcoord0).rg;
                float d = 1.0 - (COLOR_MAX - ab.y) / (COLOR_MAX - COLOR_MIN);
                vec4 g = gradient(u_gradient, saturate(d));
                FragColor = vec4(g.rgb, 1.0);
            }
        ]],
    }
}

function swap(a, b)
    return b, a
end

function reset()
    rd:setOption("INIT", true)
    rd:setImage("image", buffer, 0, shader.readwrite)
    rd:dispatch(math.ceil(buffer.width / 16), math.ceil(buffer.height / 16), 1)
end

function setup()

    size = vec2(WIDTH, HEIGHT)

    buffer = image(size.x, size.y, true, 1, image.rgba32f)

    reset()


    m = mesh()

    m.positions =
    {
        vec3(-size.x/2, size.y/2),
        vec3(size.x/2, size.y/2),
        vec3(size.x/2, -size.y/2),
        vec3(-size.x/2, -size.y/2)
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
    m.shader = visualise
    m.texture = buffer

    parameter.number("Speed", 0.0, 100.0, 75.0)
    parameter.number("Brush_Size", 10.0, 100.0, 10.0)
    parameter.action("Reset", function() reset() end)
    parameter.gradient("Gradient", gradient(), function(g)
        visualise.u_gradient = g
    end)
end

-- This function gets called whenever a touch
--  begins or changes state
function touched(touch)
    --print(touch.x, touch.y)
    X = touch.x

    paint:setImage("image", buffer, 0, shader.readwrite)

    paint.u_paintPos = vec2(touch.x, (HEIGHT - touch.y))
    paint.u_brushSize = Brush_Size
    paint:dispatch(math.ceil(buffer.width / 16), math.ceil(buffer.height / 16), 1)
end

function draw()
    background(0, 0, 0, 255)

    rd:setOption("INIT", false)
    rd.u_diffusion = vec2(1.0, 0.5)
    rd.u_feed = 0.0545
    rd.u_kill = 0.062
    rd.u_dt = DeltaTime * Speed

    for i = 1, 15 do
        rd:dispatch(math.ceil(buffer.width / 16), math.ceil(buffer.height / 16), 1)
    end

    matrix.push().translate(WIDTH/2, HEIGHT/2).scale(HEIGHT/size.y)
    m:draw()
    matrix.pop()
end
]]
