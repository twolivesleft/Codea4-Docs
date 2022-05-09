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
    const float MaxMass = 1.0;
    //How much excess water a cell can store, compared to the cell above it
    const float MaxCompress = 0.0;
    //Ignore cells that are almost dry
    const float MinMass = 0.0001;  
    const float MinFlow = 1.0;
    const float MaxSpeed = 1;

    const int AIR = 0;
    const int ROCK = 1;
    const int WATER = 2;
    const int LAVA = 3;

    const int CENTRE = 0;
    const int UP_LEFT = 1;
    const int UP = 2;
    const int UP_RIGHT = 3;
    const int LEFT = 4;
    const int RIGHT = 5;
    const int DOWN_LEFT = 6;
    const int DOWN = 7;
    const int DOWN_RIGHT = 8;

    const vec3 colors[4] =
    {
        vec3(0.0, 0.0, 0.0),
        vec3(0.5, 0.5, 0.5),
        vec3(0.25, 0.35, 1.0),
        vec3(0.9, 0.55, 0.1)
    };
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

            vec4 water(ivec2 offset, in vec4 current)
            {
                vec4 final = current;

                float remaining = current.g;
                vec4 flowValues = vec4(0, 0, 0, 0);

                vec4 down = get(offset.x, offset.y + 1);
                if (down.r == AIR)
                {
                    //flowValues.r = getStableState(remaining - down.g) - down.g;
                    //if (flowValues.r > MinFlow) flowValues.r *= 0.5;
                    //flowValues.r = clamp(flowValues.r, 0.0, min(MaxSpeed, remaining * 0.9));
                    //remaining -= flowValues.r;
                    flowValues.r = 1.0;
                    remaining = 0.0;                    
                }
                
                vec4 left = get(offset.x - 1, offset.y);
                vec4 right = get(offset.x + 1, offset.y);

                if (left.r == AIR)
                {
                    //flowValues.g = (remaining - left.g) / 16;
                    //if (flowValues.g > MinFlow) flowValues.g *= 0.5;
                    //flowValues.g = clamp(flowValues.g, 0, remaining);
                    //remaining -= flowValues.g;
                    flowValues.g = remaining;
                    remaining = 0;
                }
                
                if (right.r == AIR)
                {
                    //flowValues.b = (remaining - right.g) / 16;
                    //if (flowValues.b > MinFlow) flowValues.b *= 0.5;
                    //flowValues.b = clamp(flowValues.b, 0, remaining);
                    //remaining -= flowValues.b;
                    flowValues.b = remaining;
                    remaining = 0;
                }
                
                vec4 up = get(offset.x, offset.y - 1);
                if (up.r != ROCK)
                {
                    //flowValues.a = remaining - getStableState(remaining - up.g);
                    //if (flowValues.a > MinFlow) flowValues.a *= 0.5;
                    //flowValues.a = clamp(flowValues.a, 0.0, min(MaxSpeed, remaining));
                    //remaining -= flowValues.a;
                }               

                setFlow(offset.x, offset.y, flowValues);
                final.g -= (flowValues.x + flowValues.y + flowValues.z + flowValues.w);
                
                return final;
            }   

            vec4 process(ivec2 offset)
            {
                vec4 current = get(offset.x, offset.y);
                if (current.r == WATER)
                {
                    current = water(offset, current);
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

                //flowCache[gl_LocalInvocationID.x+1][gl_LocalInvocationID.y+1] = vec4(0.0);
                //barrier();

                if ( all(lessThan(pixel.xy, size)) )
                {   
                    if (gl_LocalInvocationID.y == 0)
                    {
                        process(ivec2(0, -1));
                    }
                    else if (gl_LocalInvocationID.y == GROUP_SIZE-1)
                    {
                        process(ivec2(0, 1));
                    }
                    if (gl_LocalInvocationID.x == 0)
                    {
                        process(ivec2(-1, 0));
                    }
                    else if (gl_LocalInvocationID.x == GROUP_SIZE-1)
                    {
                        process(ivec2(1, 0));
                    }
 
                    // Final value
                    vec4 current = process(ivec2(0, 0));

                    barrier();

                    if (current.r == AIR || current.r == WATER)
                    {
                        current.g += getFlow(0, -1).r;
                        current.g += getFlow(1, 0).g;
                        current.g += getFlow(-1, 0).b;
                        current.g += getFlow(0, 1).a;
                        current.g = max(current.g, 0.0);
                        current.r = current.g > 0.001 ? WATER : AIR;
                    }
                    
                    imageStore(imageOut, pixel, current);
                }
            }
        ]]
    }
}

shaders.paint = shader {
options =
{
},

properties =
{
{"image", "image2D", format = image.rgba32f},
{"u_paintPos", "vec2", {0.0, 0.0}},
{"u_brushSize", "float", 5.0},
{"u_brushType", "int", 1}
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
vec4 value = vec4(u_brushType, 1.0, 0.0, 0.0);
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

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v){
const vec4 C = vec4(0.211324865405187, 0.366025403784439,
-0.577350269189626, 0.024390243902439);
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
                //FragColor = vec4(value.g, value.g, value.g, 1.0);
                float alpha = (value.r == WATER) ? 
                    (0.5 + value.g * 0.5) : 0.0; 

                vec3 r = texture(rock, v_texcoord0 * 5.0).rgb;              
                vec3 bg = texture(rock, v_texcoord0 * 10.0).rgb;

                vec2 uvRipple = v_texcoord0 * 10.0 + vec2(value.g) * 0.2;
                uvRipple += snoise(v_texcoord0 * 20.0 + u_time.x) * 0.05;

                vec3 w = texture(water, uvRipple).rgb;

                if (value.r != ROCK) r = bg * 0.125;

                vec3 c = r + w * alpha;

                FragColor = vec4(c, 1.0);
            }
        ]],
    }
}

function setup()

    Scale = 4
    
    local w, h = 256, 128
    buffers = 
    {
        image(w, h, false, 1, image.rgba32f),
        image(w, h, false, 1, image.rgba32f)
    }
    
    context(buffers[1], function()
        style.fill(1, 0, 0, 255).noStroke().noSmooth()
        ellipse(w/2 - 20, h/2, 40)
        ellipse(w/2 + 20, h/2, 40)
        
        -- Water, Max Mass
        style.fill(2, 255, 0, 255)
        ellipse(w/2, h/2 + 100, 80)
    end)
    apply(shaders.init, buffers[1])
    
    m = mesh()
    
    m.positions =
    {
        vec3(-w/2, h/2), vec3(w/2, h/2),
        vec3(w/2, -h/2), vec3(-w/2, -h/2)
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
   
    parameter.integer("Material", 0, 3, 1)
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
    --updateStuff()
    
    background(125)
    --sprite(buffers[1], WIDTH/2, HEIGHT/2, 1024, 1024)

    style.push().smooth()
    matrix.push().translate(WIDTH/2, HEIGHT/2).scale(Scale)
    m.texture = buffers[1]
    m:draw()
    matrix.pop()
    style.pop()
end

function touched(touch)
    
end
