shaders = {}

shaders.init = shader {
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
                    vec4 value = imageLoad(image, pixel);
                    value.r *= 255.0;
                    imageStore(image, pixel, value);
                }
            }
        ]]
    }
}

shaders.constants = 
[[
    //The normal, un-pressurized mass of a full water cell
    const float MaxMass = 1.5;
    //How much excess water a cell can store, compared to the cell above it
    const float MaxCompress = 0.1;
    //Ignore cells that are almost dry
    const float MinMass = 0.0001;  
    const float MinFlow = 3.0;
    const float MaxSpeed = 10;
    const float SideFlow = 0.6;
    const float DownFlow = 0.99;

    const int AIR = 0;
    const int ROCK = 1;
    const int WATER = 2;
    const int LAVA = 3;
    const int SAND = 4;
    const int OBSIDIAN = 5;

    const int CENTRE = 0;
    const int UP_LEFT = 1;
    const int UP = 2;
    const int UP_RIGHT = 3;
    const int LEFT = 4;
    const int RIGHT = 5;
    const int DOWN_LEFT = 6;
    const int DOWN = 7;
    const int DOWN_RIGHT = 8;

    const float MaxFlowRate[6][6] =
    {
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {1.0, 0.0, 1.0, 0.0, 0.025, 0.0},
        {1.0, 0.0, 0.0, 1.0, 0.05, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    };

    const float waterMask[6] = { 0, 0, 1, 0, 0, 0 };
    const float lavaMask[6] = { 0, 0, 0, 1, 0, 0 };
]]

shaders.update = shader {
    options =
    {
    },

    properties =
    {
        {"imageIn", "image2D"},
        {"imageOut", "image2D"},
    },

    includes = 
    {
        constants = shaders.constants  
    },

    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba32f) uniform image2D imageIn;
            layout(rgba32f) uniform image2D imageOut;

            #define GROUP_SIZE 16

            struct Flow
            {
                float down;
                float left;
                float right;
                float up;
            };
            shared vec4 flowCache[GROUP_SIZE+2][GROUP_SIZE+2];

            #include "constants.glsl"

            vec4 get(int x, int y)
            {            
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
                return imageLoad(imageIn, pixel + ivec2(x, y));
            }

            void setFlow(int x, int y, vec4 v)
            {
                flowCache[gl_LocalInvocationID.x+x+1][gl_LocalInvocationID.y+y+1] = v;
            }

            vec4 getFlow(int x, int y)
            {
                return flowCache[gl_LocalInvocationID.x+x+1][gl_LocalInvocationID.y+y+1];
            }

            float getStableState(float totalMass)
            {
                if (totalMass <= 1)
                    return 1;
                else if ( totalMass < 2*MaxMass + MaxCompress )
                    return (MaxMass*MaxMass + totalMass*MaxCompress)/(MaxMass + MaxCompress);
                else
                return (totalMass + MaxCompress)/2;
            }

            void flowDown(in ivec2 offset, inout vec4 current, inout vec4 flowValues)
            {
                vec4 down = get(offset.x, offset.y + 1);
                float flowRate = MaxFlowRate[int(current.r)][int(down.r)];
                if (flowRate > 0.0)
                {
                    flowValues.r = getStableState(current.g + down.g) - down.g;
                    if (flowValues.r > MinFlow) flowValues.r *= 0.5;
                    flowValues.r = min(flowValues.r + down.g, MaxMass + MaxCompress) - down.g;
                    flowValues.r = clamp(flowValues.r, 0.0, min(MaxSpeed, current.g * DownFlow));                
                    flowValues.r = min(flowValues.r, flowRate);
                    current.g -= flowValues.r;
                }
            }

            void flowLeft(in ivec2 offset, inout vec4 current, inout vec4 flowValues)
            {
                vec4 left = get(offset.x - 1, offset.y);
                float flowRate = MaxFlowRate[int(current.r)][int(left.r)];
                if (flowRate > 0.0)
                {
                    flowValues.g = (current.g - left.g) * SideFlow;
                    //if (flowValues.g > MinFlow) flowValues.g *= 0.5;
                    flowValues.g = min(flowValues.g + left.g, MaxMass + MaxCompress) - left.g;
                    flowValues.g = clamp(flowValues.g, 0, current.g);
                    flowValues.g = min(flowValues.g, flowRate);                    
                    current.g -= flowValues.g;
                }
            }

            void flowRight(in ivec2 offset, inout vec4 current, inout vec4 flowValues)
            {
                vec4 right = get(offset.x + 1, offset.y);
                float flowRate = MaxFlowRate[int(current.r)][int(right.r)];
                if (flowRate > 0.0)
                {
                    flowValues.b = (current.g - right.g) * SideFlow;
                    //if (flowValues.b > MinFlow) flowValues.b *= 0.5;
                    flowValues.b = min(flowValues.b + right.g, MaxMass + MaxCompress) - right.g;
                    flowValues.b = clamp(flowValues.b, 0, current.g);
                    flowValues.b = min(flowValues.b, flowRate);                    
                    current.g -= flowValues.b;
                }
            }

            void flowUp(in ivec2 offset, inout vec4 current, inout vec4 flowValues)
            {
                vec4 up = get(offset.x, offset.y - 1);
                if (up.r != ROCK)
                {
                    flowValues.a = current.g - getStableState(current.g + up.g);
                    if (flowValues.a > MinFlow) flowValues.a *= 0.5;
                    flowValues.a = clamp(flowValues.a, 0.0, min(MaxSpeed, current.g));
                    current.g -= flowValues.a;
                }               
            }

            vec4 liquid(in ivec2 offset, in vec4 current)
            {
                vec4 flowValues = vec4(0, 0, 0, 0);

                flowDown(offset, current, flowValues);
                flowLeft(offset, current, flowValues);
                flowRight(offset, current, flowValues);                                
                //flowUp(offset, current, flowValues);

                setFlow(offset.x, offset.y, flowValues);
                
                return current;
            }   

            vec4 process(ivec2 offset)
            {
                vec4 current = get(offset.x, offset.y);
                if (current.r == WATER || current.r == LAVA)
                {
                    current = liquid(offset, current);
                }
                else 
                {
                    setFlow(offset.x, offset.y, vec4(0.0));
                }

                return current;
            }

            NUM_THREADS(GROUP_SIZE, GROUP_SIZE, 1)
            void main()
            {
                uvec2 size = imageSize(imageIn);
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

                // Process workgroup edge cases
                if ( all(lessThan(pixel.xy, size)) )
                {   
                    // Bottom edge
                    if (gl_LocalInvocationID.y == 0)
                    {
                        process(ivec2(0, -1));
                    }
                    // Top edge
                    else if (gl_LocalInvocationID.y == GROUP_SIZE-1)
                    {
                        process(ivec2(0, 1));
                    }
                    // Left edge
                    if (gl_LocalInvocationID.x == 0)
                    {
                        process(ivec2(-1, 0));
                    }
                    // Right edge
                    else if (gl_LocalInvocationID.x == GROUP_SIZE-1)
                    {
                        process(ivec2(1, 0));
                    }
 
                    // Final value
                    vec4 current = process(ivec2(0, 0));

                    barrier();

                    if (current.r == AIR || current.r == WATER || current.r == LAVA || current.r == SAND)
                    {                             
                        vec4 u = get(0, -1);
                        vec4 l = get(-1, 0);
                        vec4 r = get(1, 0);
                        vec4 d = get(0, 1);    
                        float waterFlow = current.g * waterMask[int(current.r)];
                        waterFlow += getFlow(0, -1).r * waterMask[int(u.r)];
                        waterFlow += getFlow(1, 0).g * waterMask[int(r.r)];
                        waterFlow += getFlow(-1, 0).b * waterMask[int(l.r)];
                        waterFlow += getFlow(0, 1).a * waterMask[int(d.r)];                        
                        bool hasWater = waterFlow > MinMass;
                        
                        float lavaFlow = current.g * lavaMask[int(current.r)];
                        lavaFlow += getFlow(0, -1).r * lavaMask[int(u.r)];
                        lavaFlow += getFlow(1, 0).g * lavaMask[int(r.r)];
                        lavaFlow += getFlow(-1, 0).b * lavaMask[int(l.r)];
                        lavaFlow += getFlow(0, 1).a * lavaMask[int(d.r)];                        
                        bool hasLava = lavaFlow > MinMass;                                
        
                        if (current.r == SAND)
                        {
                            current.g += (lavaFlow + waterFlow) * 0.75;
                            if (current.g >= 1.0)
                            {
                                current.r = hasWater ? WATER : (hasLava ? LAVA : SAND);
                            }
                        }
                        else if (hasWater && waterFlow > lavaFlow) 
                        {
                            current.r = WATER;                    
                            current.g = max(waterFlow, current.a);                            
                        }
                        else if (hasLava && lavaFlow > waterFlow)
                        {
                            current.r = LAVA;        
                            current.g = max(lavaFlow, current.a);        
                            //current.b = max(current.b - waterFlow, 0);
                            //if (current.b == 0) current.r = ROCK;
                        }
                        else 
                        {
                            current.r = AIR;
                        }
                        current.g = max(current.g, 0.0);
                    }
                    
                    imageStore(imageOut, pixel, current);
                }
            }
        ]]
    }
}

shaders.paint = shader {
    options = {},

    properties =
    {
        {"image", "image2D", format = image.rgba32f},
        {"u_paintPos", "vec2", {0.0, 0.0}},
        {"u_brushSize", "float", 5.0},
        {"u_brushType", "int", 1},
        {"u_brushSource", "bool", false}
    },

    includes = 
    {
        constants = shaders.constants  
    },
    
    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba32f) uniform image2D image;
            uniform vec2 u_paintPos;
            uniform float u_brushSize;
            uniform int u_brushType;
            uniform bool u_brushSource;

            #include "constants.glsl"
        
            NUM_THREADS(16, 16, 1)
            void main()
            {
                uvec2 size = imageSize(image);
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

                if ( all(lessThan(pixel.xy, size)) )
                {
                    if (distance(u_paintPos, vec2(pixel)) < u_brushSize)
                    {        
                        vec4 value = vec4(u_brushType, 0.0, 0.0, 0.0);
                        if (u_brushType == WATER)
                        {
                            value.g = 1.0;
                            if (u_brushSource) value.a = 0.5;
                        }    
                        if (u_brushType == LAVA)
                        {
                            value.g = 1.0;
                            value.b = 1.0;
                            if (u_brushSource) value.a = 0.5;        
                        }
                        if (u_brushType == SAND)
                        {
                            value.g = 0.0;
    
                        }

                    
                        imageStore(image, pixel, value);
                    }
                }
            }
        ]]
    }
}

shaders.visualise = shader{
    options =
    {
    },

    properties =
    {
        {"rock", "texture"},
        {"water", "texture"},
        {"lava", "texture"}
    },

    includes =
    {
        constants = shaders.constants
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

            #include "constants.glsl"

            out vec4 FragColor;
            uniform sampler2D water;
            uniform sampler2D rock;
            uniform sampler2D lava;

            vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

            float snoise(vec2 v){
                const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
                vec2 i  = floor(v + dot(v, C.yy) );
                vec2 x0 = v -   i + dot(i, C.xx);
                vec2 i1;
                i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
                vec4 x12 = x0.xyxy + C.xxzz;
                x12.xy -= i1;
                i = mod(i, 289.0);
                vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
                + i.x + vec3(0.0, i1.x, 1.0 ));
                vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
                dot(x12.zw,x12.zw)), 0.0);
                m = m*m ;
                m = m*m ;
                vec3 x = 2.0 * fract(p * C.www) - 1.0;
                vec3 h = abs(x) - 0.5;
                vec3 ox = floor(x + 0.5);
                vec3 a0 = x - ox;
                m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
                vec3 g;
                g.x  = a0.x  * x0.x  + h.x  * x0.y;
                g.yz = a0.yz * x12.xz + h.yz * x12.yw;
                return 130.0 * dot(m, g);
            }

            void main()
            {
                vec4 value = texture(s_texture, v_texcoord0);                
                vec3 c = vec3(0.0);

                vec2 uvRipple = v_texcoord0 * 10.0 + vec2(value.g) * 0.2;
                uvRipple += snoise(v_texcoord0 * 20.0 + u_time.x) * 0.05;

                if (value.r == AIR)
                {
                    // Background rock
                    vec3 bg = texture(rock, v_texcoord0 * 10.0).rgb;
                    c = bg * 0.125;
                }
                else if (value.r == SAND)
                {
                    // Normal rock
                    vec3 r = texture(rock, v_texcoord0 * 5.0).rgb + vec3(0.3, 0.2, 0.0);              
                    r *= (1.0 - value.g);
                    c = r;                    
                }
                else if (value.r == ROCK)
                {
                    // Normal rock
                    vec3 r = texture(rock, v_texcoord0 * 5.0).rgb;              
                    c = r;
                }
                else if (value.r == WATER)
                {
                    vec3 waterTex = texture(water, uvRipple).rgb;
                    float alpha = 0.4 + value.g * 0.3; 
                    c = c + waterTex * alpha;
                }
                else if (value.r == LAVA)
                {
                    vec3 lavaTex = texture(lava, uvRipple * 2.0).rgb;
                    c = lavaTex;
                }

                FragColor = vec4(c, 1.0);
            }
        ]],
    }
}

function setup()
    
    
    Scale = 3
    
    local w, h = 256, 128 + 64
    buffers = 
    {
        image(w, h, false, 1, image.rgba32f),
        image(w, h, false, 1, image.rgba32f)
    }
    
    context.push(buffers[1])
        -- Water, Max Mass
        --style.fill(2, 255, 0, 255)
        --ellipse(w/2, h/2 + 0, 20)
        style.fill(1, 0, 0, 255).noStroke().noSmooth()
        ellipse(w/2 - 20, h/3, 40)
        ellipse(w/2 + 20, h/3, 40)
    context.pop()
    apply(shaders.init, buffers[1])
    
    m = mesh()
    
    m.positions =
    {
        vec3(-w/2, h/2, 0), vec3(w/2, h/2, 0),
        vec3(w/2, -h/2, 0), vec3(-w/2, -h/2, 0)
    }
    
    m.uvs =
    {
        vec2(0, 0), vec2(1, 0),
        vec2(1, 1), vec2(0, 1)
    }
    
    m.colors =
    {
    color(255), color(255),
    color(255), color(255)
    }
    
    m:addElement(3,2,1)
    m:addElement(4,3,1)
    m.shader = shaders.visualise
    shaders.visualise.rock = image.read(asset.Rock)
    shaders.visualise.water = image.read(asset.Water)
    shaders.visualise.lava = image.read(asset.Lava)
   
    parameter.integer("Material", 0, 4, 1)
    parameter.integer("BrushSize", 5, 50, 5)
    parameter.boolean("IsSource", false)
end

function swap(a, b)
    return b, a
end

function apply(cs, buffer, rw)
    local wx, wy = shaders.init:workgroupSize()
    cs:setImage("image", buffer, 0, rw or shader.readwrite)
    cs:dispatch(math.ceil(buffer.width/wx), math.ceil(buffer.height/wy), 1)
end

function updateStuff()
    if CurrentTouch.state == MOVING then

        local w, h = buffers[1].width * Scale, buffers[1].height * Scale
        local min = vec2(WIDTH/2 - w / 2, HEIGHT/2 - h /2)
        local max = vec2(WIDTH/2 + w / 2, HEIGHT/2 + h /2)
        local x = (CurrentTouch.x - min.x) / (max.x - min.x) * w
        local y = (1 - ((CurrentTouch.y - min.y) / (max.y - min.y))) * h
        
        shaders.paint.u_paintPos = vec2(x/Scale, y/Scale)
        shaders.paint.u_brushType = Material
        shaders.paint.u_brushSize = BrushSize
        shaders.paint.u_brushSource = IsSource
        
        
        apply(shaders.paint, buffers[1])
    end
    
    local wx, wy = shaders.update:workgroupSize()
    shaders.update:setImage("imageIn", buffers[1], 0, shader.readwrite)
    shaders.update:setImage("imageOut", buffers[2], 0, shader.readwrite)
    shaders.update:dispatch(math.ceil(buffers[1].width/wx), math.ceil(buffers[1].height/wy), 1)
    buffers[1], buffers[2] = swap(buffers[1], buffers[2])
 
end

function draw()
    updateStuff()

    background(125)

    style.push().smooth()
    matrix.push().translate(WIDTH/2, HEIGHT/2).scale(Scale)
    m.texture = buffers[1]
    m:draw()
    matrix.pop()
    style.pop()

    sprite(buffers[1], 50, 50, 100, 100)
end

function touched(touch)
    
end
