function setup()
    -- Create a custom background shader
    skybox = shader{
        name = "Skybox",
        
        properties =
        {
            {"environment", "texture"},
            {"mipLevel", "float", 0}
        },
        
        pass =
        {
            cullFace = "none", -- backgrounds don't need culling
            depthWrite = false, -- no need to write to depth buffer
            depthFunc = "always", -- no need for depth testing
            blendMode = "disabled", -- no need for blending
            renderQueue = "background", -- render behind everything else
            
            vertex =
            [[
            #version 430
            #include <codea/common.glsl>
            
            layout (location = POSITION) in vec3 a_position;
            
            layout (location = 0) out vec3 v_eyeDirection;
            
            void main()
            {
                // vertex layout is a quad between -1 and 1, use this to unproject and calculate eye direction from view/perspective matrix
                vec3 unprojected = (u_invProj * vec4(a_position, 1)).xyz;
                v_eyeDirection = mat3(u_invView) * unprojected;
                
                gl_Position = vec4(a_position.xy, 1, 1);
            }
            ]],
    
            fragment =
            [[       
                #version 430
                #include <codea/common.glsl>
    
                layout (location = 0) in vec3 v_eyeDirection;
                out vec4 fragColor;
    
                uniform samplerCube environment;
                uniform float mipLevel;
    
                void main()
                {
                    vec3 rayDir = normalize(v_eyeDirection);
                    rayDir = vec3(rayDir.x, rayDir.y, rayDir.z);
                    vec3 col = texture(environment, rayDir, mipLevel).rgb;
                    fragColor = vec4(col, 1.0);
                }
            ]],
        }
    }

    local hdr = image.cube(image.read(asset.builtin.hdr.Norway_Forest))
    skybox.environment = hdr:generateIrradiance()

    -- Test mip level adjustment
    parameter.number("MipLevel", 0, 10, 0, function(mip)
        skybox.mipLevel = mip
    end)
end

function draw()
    matrix.perspective()
    background(skybox)
end