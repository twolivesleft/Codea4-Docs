function setup()
    scn = scene.default3d()
    scn.camera:add(camera.rigs.orbit)
    
    toon = shader
    {
        name = "Toon",
        
        pass =
        {
            shadingModel = "lit",
            
            material = 
            [[
                void material(inout MaterialInputs material) 
                {
                    vec2 uv = getUV0();
                    prepareMaterial(material);
                    material.baseColor = vec4(1.0, 0.5, 0.3, 1.0);
                }            
            ]],
            shading = 
            [[
                vec3 surfaceShading(const MaterialInputs materialInputs,
                                    const ShadingData shadingData,
                                    const LightData lightData) 
                {
                    // Number of visible shade transitions
                    const float shades = 5.0;
                    // Ambient intensity
                    const float ambient = 0.1;

                    float toon = max(ceil(lightData.NdotL * shades) / shades, ambient);

                    // Shadowing and attenuation
                    toon *= lightData.visibility * lightData.attenuation;

                    // Color and intensity
                    vec3 light = lightData.colorIntensity.rgb * lightData.colorIntensity.w;

                    return shadingData.diffuseColor * light * toon;
                }            
            ]]
        }
    }
    
    model = scn:entity()
    model.mesh = mesh.read(asset.builtin.Primitives.Monkey_obj)
    model.mesh.material = material(toon)
end

function draw()
    scn:draw()
end

function touched(touch)
end
