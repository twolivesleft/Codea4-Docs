-- Shaders / Surface Shaders

-- Surface shaders are able to make use of complex built-in shader
-- functionality, such as lighting, displacement and skinning

-- Codea's surface shaders are built on top of Filament 
-- You can see a full reference for how filament materials work:
-- https://google.github.io/filament/Materials.html

viewer.fullscreen()

function setup()
    
    surfaceLit = shader
    {
        options = {},
        properties = 
        {
            {"baseColor", "vec4", {1.0, 1.0, 1.0, 1.0}, color = true}
        },

        pass =
        {
            blendMode = "disabled",
            cullFace = "back",
            shadingModel = "lit",

            vertex = 
            [[        
                // mat3 getWorldTangentFrame()
                // vec3 getWorldPosition()
                // vec3 getWorldViewVector()
                // vec3 getWorldNormalVector()
                // vec3 getWorldGeometricNormalVector()
                // vec3 getWorldReflectedVector()
                // vec3 getNormalizedViewportCoord()
                // float getNdotV()
                // vec4 getColor()
                // vec2 getUV0()
                // vec2 getUV1()
                void materialVertex(inout MaterialVertexInputs material) 
                {
                }
            ]],
    
            material = 
            [[    
                uniform vec4 baseColor;
            
                void material(inout MaterialInputs material) 
                {
                    prepareMaterial(material);
            
                    vec2 uv = getUV0();
                    material.metallic = 1.0;
                    material.roughness = 
                        mod(floor(uv.x * 20) + floor(uv.y * 10), 2)
                        * 0.5;
                    material.baseColor = baseColor;
                }                
            ]],    
        }
    }
    
    scn = scene.default3d()    
    scn:entity("Sphere"):add(mesh.sphere()).material = material(surfaceLit)
    scn.camera:add(camera.rigs.orbit)
        
    scn.Sphere:baseColorTo(color.red, 1):ease(tween.cubicInOut):pingpong(-1)
end


function draw()    
    scn:draw()
end
