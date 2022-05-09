{
    name = 'Trail Effect Baked',

    options =
    {
         
    },

    -- Made with Shade Pro by Two Lives Left
    properties =
    {
        {"_trail", "texture", "Output 1" },
        {"_contrast", "float", 0.40000000596046 },
        {"_gradient1", "texture", "Gradient 1" },
        {"_gradient", "texture", "Gradient" },
        {"_gain", "float", 4.0 },
    },

    pass =
    {
        
        
        shadingModel = 'unlit',


        renderQueue = opaque,
        depthWrite = true,

        vertex =
        [[
            uniform mediump sampler2D _trail;
            uniform float _contrast;
            uniform mediump sampler2D _gradient1;
            uniform mediump sampler2D _gradient;
            uniform float _gain;


            void materialVertex(inout MaterialVertexInputs material)
            {
            }
        ]],

        material =
        [[
            uniform mediump sampler2D _trail;
            uniform float _contrast;
            uniform mediump sampler2D _gradient1;
            uniform mediump sampler2D _gradient;
            uniform float _gain;

            
            float remap(float value, float minA, float maxA, float minB, float maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec2 remap(vec2 value, vec2 minA, vec2 maxA, vec2 minB, vec2 maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec3 remap(vec3 value, vec3 minA, vec3 maxA, vec3 minB, vec3 maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec4 remap(vec4 value, vec4 minA, vec4 maxA, vec4 minB, vec4 maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec2 remap(vec2 value, float minA, float maxA, float minB, float maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec3 remap(vec3 value, float minA, float maxA, float minB, float maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            vec4 remap(vec4 value, float minA, float maxA, float minB, float maxB)
            {
                return minB + (value - minA) * (maxB - minB) / (maxA - minA);
            }
            
            
            vec2 append(float a, float b)
            {
                return vec2(a, b);
            }
            
            vec3 append(float a, vec2 b)
            {
                return vec3(a, b);
            }
            
            vec3 append(vec2 a, float b)
            {
                return vec3(a, b);
            }
            
            vec4 append(float a, vec3 b)
            {
                return vec4(a, b);
            }
            
            vec4 append(vec3 a, float b)
            {
                return vec4(a, b);
            }
            
            vec4 append(vec2 a, vec2 b)
            {
                return vec4(a, b);
            }
            
            

            void material(inout MaterialInputs material)
            {
                material.emissive.rgb = vec3(0.0, 0.0, 0.0);
                material.baseColor.rgb = (textureLod(_gradient, vec2((pow(textureLod(_trail, (append(clamp(((remap(pow(getUV0().y, 8.4062), vec2(0.0, 1.0).x, vec2(0.0, 1.0).y, vec2(1.0, 12.12).x, vec2(1.0, 12.12).y) * (getUV0().x - 0.5)) + 0.5), 0.0, 1.0), getUV0().y)+append(0.0, (u_time.x*1.0))), 0.0).rgb.r, _contrast)*textureLod(_gradient1, vec2(getUV0().y, 0.0), 0.0).rgb.r), 0.0), 0.0).rgb * _gain);
                material.baseColor.a = 1.0;
                

                #if defined(SHADING_MODEL_STANDARD)
                prepareMaterial(material);
                #endif
            }

        ]]


    }
}
