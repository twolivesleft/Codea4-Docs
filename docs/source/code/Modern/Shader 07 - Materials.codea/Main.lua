-- Shader Builder
-- A utility class that makes modular shaders easy to create

-- Use this function to perform your initial setup
function setup()
    scn = scene.default3d()
    scn.camera:add(camera.rigs.orbit)
    scene.main = scn

    -- Bake spherical noise texture
    noiseTex = image(512, 512, false, 1, image.rgba8)
    context.push(noiseTex)
    sprite(shader.builder():unlit()
    :include("codea/noise/classic/3d.glsl") -- include 3D noise utility (cnoise)
    :include("codea/utilities.glsl") -- include for sphericalToCartesian() helper function
    :material
    [[
        {
            vec3 p = sphericalToCartesian(vec3(3, getUV0().yx * vec2(PI, 2*PI)  ));
            float o1 = cnoise(p*0.5 + vec3(10)) * 1.75;
            float o2 = cnoise(p*0.25 + o1) * 0.5;
            float n = abs(cnoise(p + o2));
            material.baseColor = vec4(0,0,0,1);
            material.baseColor.r = n;
        }

        {
            vec3 p = sphericalToCartesian(vec3(5, getUV0().yx * vec2(PI, 2*PI)  ));
            material.baseColor.g = cnoise(p) * 0.5 + 0.5;
            material.baseColor.b = cnoise(p + vec3(100.423)) * 0.5 + 0.5;
            material.baseColor.a = cnoise(p + vec3(2323.232)) * 0.5 + 0.5;
        }
    ]]
    :build(), 256, 256, 512, 512)
    context.pop()

    -- Shader chunks are reusable pieces of shader functionality
    -- they are able to contain properties, code, functions, includes and more
    -- they can be added to a shader builder via builder:add()
    -- multiple chunks can easily be combined although some may
    -- interfere with each other if they modify the same material parameters

    -- Raymarched parallax shader
    marble = shader.chunk()
        :include("codea/utilities.glsl")
        :texture{"heightMap", value = noiseTex}
        :color{"colorB", value = color.black}
        :color{"colorA", value = color(211, 13, 125)}
        :number{"iterations", value = 5}
        :number{"depth", value = 1}
        :number{"smoothing", value = 0}
        :func
        [[
            vec3 marchMarble(vec3 rayOrigin, vec3 rayDir) {
                float perIteration = 1. / float(iterations);
                vec3 deltaRay = rayDir * perIteration * depth;

                // Start at point of intersection and accumulate volume
                vec3 p = rayOrigin;

                vec3 col = vec3(0);
                for (int i=0; i<iterations; ++i) {
                    // Read heightmap from current spherical direction
                    vec2 uv = equirectUv(normalize(p));

                    vec3 rand = texture(heightMap, uv + vec2(u_time.x * 0.02, 0)).gba;
                    uv.y = 1 - uv.y;
                    vec3 rand2 = texture(heightMap, uv - vec2(u_time.x * 0.05, 0)).gba;

                    uv = equirectUv(normalize(p + rand * 0.025 + rand2 * 0.05));
                    float heightMapVal = texture(heightMap, uv).r;

                    // Take a slice of the heightmap
                    float height = length(p); // 1 at surface, 0 at core, assuming radius = 1
                    float cutoff = 1. - float(i) * perIteration;
                    float slice = smoothstep(cutoff, cutoff + smoothing, heightMapVal);

                    // Accumulate the volume and advance the ray forward one step

                    vec3 col2 = texture(heightMap, vec2(cutoff, 0.5)).gba;

                    col += slice * perIteration * mix(colorA.xyz, col2, 0.2);
                    p += deltaRay;
                }
                //return mix(colorA, colorB, totalVolume).xyz;
                return col;
            }
        ]]
        :material
        [[
            material.roughness = 0.1;
            material.baseColor = vec4(marchMarble(getWorldPosition(), -getWorldViewVector()), 1);
        ]]

    -- Simple emissive fresnel rim effect
    fresnel = shader.chunk()
    :number{"power", value = 4}
    :number{"intensity", value = 1}
    :color{"color", value = color.white}
    :material
    [[
        float f = pow(1.0 - dot(getWorldPosition(), getWorldViewVector()), power);
        material.emissive = (f * intensity) * color;
    ]]

    -- Simple checkerboard pattern
    checkers = shader.chunk()
    :vec2{"size", value = vec2(10, 10)}
    :color{"colorA", value = color.white}
    :color{"colorB", value = color.black}
    :material
    [[
        vec2 uv = getUV0();
        uv = floor(uv * size);
        float c = mod(uv.x + uv.y, 2);
        material.baseColor *= mix(colorA, colorB, c);
    ]]

    cracks = shader.chunk()
    :texture{"normalMap", value = asset.RockyNormals}
    :normals
    [[
        material.normal = texture(normalMap, getUV0() * 0.5).rgb * 2.0 - 1.0;
    ]]

    clouds = shader.chunk()
    :texture{"noiseTex", value = noiseTex}
    :material
    [[
        float n = texture(noiseTex, getWorldPosition().xz * 0.1 + vec2(u_time.x, 0) * 0.1).r;
        material.ambientOcclusion = mix(n, 1.0, 0.5);
    ]]

    ball = material(shader.builder():lit()
    :add(fresnel)
    :add(marble)
    :build())

    parameter.integer("Iterations", 1, 40, 32, function(i)
        ball.iterations = i
    end)

    parameter.number("Depth", 0, 1, 0.5, function(i)
        ball.depth = i
    end)

    parameter.number("Smoothing", 0, 1, 0.2, function(i)
        ball.smoothing = i
    end)

    parameter.number("SkyBlur", 0, 10, 0.0, function(i)
        scn.skyBlur = i
    end)


    ball.intensity = 2
    ball.power = 10
    ball.color = color.yellow

    -- tween the intensity property on the rim highlight
    scn:tween(ball):to{intensity = 0}:time(1):pingpong(-1)

    sphere = scn:entity("sphere")
    sphere:add(mesh.sphere(1.0))
    sphere.material = ball
    sphere.y = 0

    ground = scn:entity("ground")
    ground.y = -1
    ground:add(mesh.box(10, 0.1, 10))

    ground.material = material(shader.builder()
    :lit()
    :texture{"normalMap", value = asset.RockyNormals}
    :normals
    [[
        material.normal = texture(normalMap, getUV0() * 0.1).rgb * 2.0 - 1.0;
        material.normal.xy *= 0.75;
    ]]
    :add(checkers)
    :add(clouds)
    :build())

    ground.material.colorA = color(121, 188, 226)
    ground.material.colorB = color(30, 94, 131)
    ground.material.size = vec2(1,1)

    -- You can also use shader builder to create simple unlit materials for use in sprites
    spriteShader = shader.builder()
        :unlit()
        :material([[
            vec2 uv = getUV0();
            uv = floor(uv * 20);
            float c = mod(uv.x + uv.y, 2);
            material.baseColor = vec4(vec3(c), 1);
        ]])
        :build()

end

function draw()
    matrix.reset().ortho()
    style.fontSize(20).stroke(0).strokeWidth(3).textAlign(CENTER|BOTTOM)
    text("Modular Shader Builder", WIDTH/2, HEIGHT - 50)

    sprite(spriteShader, WIDTH - 60, HEIGHT/2, 100, 100)
    sprite(noiseTex,WIDTH - 120,HEIGHT/2 + 200,200)
end
