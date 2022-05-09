caustics = shader {
    name = "Caustics",
    
    options =
    {
    },

    properties =
    {
        {"normalMask", "texture"},
        {"image", "image2D"},
        {"spread", "float", 0.5},
        {"ior", "float", 1.33},
        {"samples", "int", 1}
    },

    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>
        
            #define hash(x) lowbias32(x)
        
            uint lowbias32(uint x)
            {
                x ^= x >> 16;
                x *= 0x7feb352dU;
                x ^= x >> 15;
                x *= 0x846ca68bU;
                x ^= x >> 16;
                return x;
            }
        
            // Construct a float with half-open range [0:1] using low 23 bits.
            // All zeroes yields 0.0, all ones yields the next smallest representable value below 1.0.
            float floatConstruct( uint m ) 
            {
                const uint ieeeMantissa = 0x007FFFFFu; // binary32 mantissa bitmask
                const uint ieeeOne      = 0x3F800000u; // 1.0 in IEEE binary32
                
                m &= ieeeMantissa;                     // Keep only mantissa bits (fractional part)
                m |= ieeeOne;                          // Add fractional part to 1.0
                
                float  f = uintBitsToFloat( m );       // Range [1:2]
                return f - 1.0;                        // Range [0:1]
            }
        
            int mod2(int a, int b) { return (a%b+b)%b; }
            ivec2 mod2(ivec2 a, ivec2 b) { return (a%b+b)%b; }
                    
            layout(r16f) uniform image2D image;
            uniform sampler2D normalMask;
            uniform float spread;
            uniform float ior;
            uniform int samples;
        
            NUM_THREADS(16, 16, 1)
            void main()
            {                
                uvec2 size = imageSize(image);
        
                uint h1 = hash(gl_GlobalInvocationID.x) ^ hash(gl_GlobalInvocationID.y) ^ hash(gl_GlobalInvocationID.z);
                uint h2 = hash(h1);
                vec2 uv = vec2(floatConstruct(h1), floatConstruct(h2));                              
                ivec2 pixel = ivec2(uv * (vec2(size) - 1));
        
                if (all(lessThan(pixel, ivec2(size))))
                {
                    vec4 nm = texture(normalMask, uv);
                    float m = nm.a;
                    if (m < 0.9) return;
                    vec3 normal = nm.rgb * 2 - 1;
                    vec3 light = normalize(vec3(0,0,-1));
                    vec3 r = refract(light, normal, ior);
                    ivec2 diff = ivec2(r.xy * ivec2(size) * spread);
                    pixel = mod2(pixel + diff, ivec2(size));
                    /*
                    if (pixel.x < 0) pixel.x += int(size.x);
                    if (pixel.y < 0) pixel.y += int(size.y);        
                    pixel.x = pixel.x % int(size.x);
                    pixel.y = pixel.y % int(size.y);        
                    */
                    
        
                    vec4 value = imageLoad(image, pixel);
                    imageStore(image, pixel, value + vec4(0.25 / float(samples)));
                }                
            }
        ]]
    }
}

blur = shader {
    name = "Blur",
    
    options =
    {
    },

    properties =
    {
        {"imageIn", "texture"},
        {"imageOut", "image2D"},
        {"kernelSize", "int", 5},
        {"axis", "int", 0},
        {"sigma", "float", 1}
    },

    pass =
    {
        compute = [[
            #version 430
            #include <codea/common.glsl>
            
            uniform sampler2D imageIn;        
            layout(r16f) uniform image2D imageOut;        
            uniform int kernelSize;
            uniform int axis;
            uniform float sigma;
        
            const float TWO_PI = 6.28319;
            const float E = 2.71828;
        
            float gaussian(int x)
            {
                float sigmaSqu = sigma * sigma;
                return (1 / sqrt(TWO_PI * sigmaSqu)) * pow(E, -(x * x) / (2 * sigmaSqu));
            }
                
            NUM_THREADS(16, 16, 1)
            void main()
            {                                
                ivec2 size = ivec2(imageSize(imageOut));
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
                if (all(lessThan(pixel, size)))
                {
                    int upper = ((kernelSize - 1) / 2);
                    int lower = -upper;             
                    vec2 uv = vec2(pixel.yx) / vec2(size);       
                    vec2 texelSize = 1 / vec2(size);
                    float kernelSum = 0.0;
        
                    vec4 sum = vec4(0.0);
                    for (int i = lower; i <= upper; ++i)
                    {
                        float gauss = gaussian(i);
                        kernelSum += gauss;
                        vec2 uv2 = uv;
                        uv2[axis] += texelSize[axis] * i;
                        sum += gauss * texture(imageIn, uv2);
                    }
                    sum /= kernelSum;
                    imageStore(imageOut, pixel, sum);
                }                
            }
        ]]
    }
}

grayscale = shader
{
    properties = 
    {
        {"tex", "texture"}
    },
    
    pass = 
    {        
        vertex = [[
        #version 430
        #include <codea/common.glsl>
        
        layout (location = POSITION) in vec3 a_position;
        layout (location = TEXCOORD0) in vec2 a_texcoord0;
        
        layout(location = 1) out vec2 v_texcoord0;
        
        void main()
        {
            gl_Position = u_modelViewProj * vec4(a_position, 1.0);
            v_texcoord0 = a_texcoord0;
        }
        ]],
        fragment = [[
        #version 430
        #include <codea/common.glsl>
        
        layout(location = 1) in vec2 v_texcoord0;
        
        uniform sampler2D tex;
        
        out vec4 FragColor;
        
        void main()
        {
            vec2 uv = v_texcoord0;
            float c = texture(tex, uv).r;
            FragColor = vec4(c, c, c, 1);
        }
        ]]
    }
}


function applyBlur(img, ks, b, tmp, out)
    local cx, cy = blur:workgroupSize()
        
    blur.sigma = b * ks
    blur.kernelSize = ks * 2 + 1
    blur.imageIn = img
    blur:setImage("imageOut", tmp, 0, shader.readwrite)
    blur.axis = 0
    blur:dispatch(math.ceil(tmp.width / cx), math.ceil(tmp.height / cy), 1)

    blur.imageIn = tmp
    blur:setImage("imageOut", out, 0, shader.readwrite)
    blur.axis = 0
    blur:dispatch(math.ceil(out.width / cx), math.ceil(out.height / cy), 1)    
end
    
function setup()
    normalMask = image(1024, 1024, false, 1, image.rgba16f)    
    output = image(1024, 1024, false, 1, image.r16f)
    outputTemp = image(1024, 1024, false, 1, image.r16f)
    
    caustics.normalMask = normalMask
    caustics:setImage("image", output, 0, shader.readwrite)
    
    dirtyFlag = true
    local setDirtyFlag = function() dirtyFlag = true end
    
    trails = shader.read(asset.Trails)
    trailEffect = shader.read(asset.Trail_Effect_Baked)
    trailEffect._gradient1.sampler.u = image.clamp
    trailEffect._gradient.sampler.u = image.clamp
    --trailEffect._gradient = trailEffect._gradient
    
    
    parameter.number("TimeScale", 0, 1, 1, function(t) time.scale = t end)
    parameter.number("Zoom", 1, 10, 1)
    parameter.vec2("NoiseTiling", trails._noiseTiling, setDirtyFlag)
    parameter.number("WidthScale", 0.1, 2, 1, setDirtyFlag)
    parameter.vec2("WarpScale", trails._warpScale, setDirtyFlag)
    parameter.number("Spread", 0, 1, 0.5, setDirtyFlag)
    parameter.number("IOR", 1, 3, 1.33, setDirtyFlag)    
    parameter.integer("Samples", 1, 30, 10, setDirtyFlag)
    parameter.integer("KernelSize", 1, 20, 5, setDirtyFlag)    
    parameter.number("Blur", 0.01, 1, 1, setDirtyFlag)        
    parameter.action("Save", function()
        local output2 = image(512, 512)
        context.push(output2)    
        sprite(output, output2.width/2, output2.height/2, output2.width)
        context.pop()        
        image.save(asset.."/Output.png", output2)
    end)
    
end

function draw()
    
    if dirtyFlag then
        context.push(normalMask)
        background(0, 0, 0, 0)
        trails._noiseTiling = NoiseTiling
        trails._widthScale = WidthScale
        trails._warpScale = WarpScale
        sprite(trails, normalMask.width/2, normalMask.height/2, normalMask.width, normalMask.height)
        context.pop()
        
        context.push(output)
        background(0, 0, 0, 0)
        context.pop(output)
        
        local cx, cy = caustics:workgroupSize()
        caustics.spread = Spread
        caustics.ior = IOR
        caustics.samples = Samples
        caustics:dispatch(math.ceil(output.width / cx), math.ceil(output.height / cy), Samples)

        applyBlur(output, KernelSize, Blur, outputTemp, output)
        
        dirtyFlag = false
    end

    background(0, 0, 0, 0)                                
    sprite(normalMask, WIDTH-200, HEIGHT-200, 200)    
    grayscale.tex = output
    sprite(grayscale, WIDTH - 200, HEIGHT - 400, 200 * Zoom, 200 * Zoom)
    
    trailEffect._trail = output    
    sprite(trailEffect, WIDTH/2, HEIGHT/2, 400, HEIGHT)
    
end

function touched(touch)
end
