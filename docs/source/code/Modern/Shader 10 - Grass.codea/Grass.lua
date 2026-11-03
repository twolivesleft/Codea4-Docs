Grass = class()

function Grass:created()

    Grass.static.layout = shader.bufferLayout
    {
        {shader.position, 4, shader.float}, -- position(x, y, z, rot)
        {shader.texcoord0, 4, shader.float} -- details(height, n/a, n/a, n/a)
    }

    Grass.static.shader = shader.builder():unlit()
    :add(InstancesChunk) -- make instances buffer available to shader
    :add(GrassColorChunk)
    :doubleSided(true)
    :texture{"windNoise"}
    :option{"USE_MASK_MAP", value = false}
    :texture{"maskMap", option = "USE_MASK_MAP"}
    :number{"terrainSize", value = 50}
    :number{"terrainHeight", value = 20}
    :vec4{"windParams", value = vec4(250, 0.04, 3, 0)} -- noise scale, panning speed, noise strength
    :vec4{"bladeParams", value = vec4(0.5, 4.0, 2, 0.5)} -- thickness, height, bendFactor, bendStrength
    :variable{"color"}
    :vertex([[
        // Get the instance parameters
        vec4 pos = instances[gl_InstanceID].position;
        vec4 det = instances[gl_InstanceID].details;

        // Use texture as a mask for grass coverage
        #ifdef USE_MASK_MAP
            float m = texture(maskMap, fract(pos.xz / (terrainSize * 2 + 1) + 0.5)).r;
            material.worldPosition.xyz *= 2.0 - m;
        #endif

        // Create 2D rotation matrix to rotate blades on y axis
        vec2 v = vec2(sin(pos.w), cos(pos.w));
        mat2 rot = mat2(v.x, v.y, -v.y, v.x);

        // Scale blades up based on height
        material.worldPosition.xyz *= vec3(bladeParams.x, det.x * bladeParams.y, bladeParams.x) * det.y;

        // Rotate blades using rotation
        material.worldPosition.xz *= rot;

        // Translate blades to instance location
        material.worldPosition.xyz += pos.xyz;

        // Calculate height-based blend parameter using UVs
        float h = pow(1 - material.uv0.y, bladeParams.z);

        // Initial directional grass bend
        material.worldPosition.xz += rot * vec2(1, 0) * h * bladeParams.w;

        // Rotate normals (if we add lighting at some point)
        material.worldNormal.xz *= rot;

        // View dependent grass bend when viewing from above
        vec3 fwd = vec3(u_view[0][2], u_view[1][2], u_view[2][2]);
        vec3 fwd2 = normalize(vec3(fwd.x, 0.01, fwd.z));
        float downBlend = dot(fwd, vec3(0,-1,0));
        downBlend *= downBlend;
        material.worldPosition.xyz += fwd2 * h * downBlend * 3;

        // Use noise for wind effect
        vec2 noiseUV = fract(pos.xz / windParams.x + u_time.x * windParams.y);
        material.worldPosition.xz -= texture(windNoise, noiseUV).x * h * det.x * windParams.z;

        // Pass additional color variable based on height
        material.color = vec4(-det.x * 0.01, 0, -det.x * 0.05, 0);
    ]])
    :material([[
        vec2 uv = getUV0();
        vec4 fc = mix(baseColor2, midColor, 1 - uv.y);
        fc += mix(vec4(0), tipColor, pow(1 - uv.y, 4)) * 0.25;
        fc.rgb += vertex_color.rgb;
        material.baseColor = vec4(fc.rgb, 1);
    ]])
    :build()

    self.heightMap = self.entity:get(Terrain).heightMap

    self.model = mesh.read(asset.GrassBlade4)
    self.model.shader = Grass.shader
    Grass.shader.windNoise = image.read(asset.WindNoise3)

    self.setupGrass = shader.builder()
        :include "codea/noise/noise.glsl"
        :add(InstancesChunk)
        :texture{"heightMap"}
        :number{"terrainSize", value = 50}
        :number{"terrainHeight", value = 20}
        :uint{"instanceCount"}
        :number{"density"}
        :threads(256, 1, 1)
        :func([[
        vec2 hashwithoutsine22(vec2 p)
        {
            vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
            p3 += dot(p3, p3.yzx+33.33);
            return fract((p3.xx+p3.yz)*p3.zy);
        }

        float hashwithoutsine13(vec3 p3)
        {
            p3  = fract(p3 * .1031);
            p3 += dot(p3, p3.yzx + 33.33);
            return fract((p3.x + p3.y) * p3.z);
        }
        ]])
        :compute([[
            uint id = gl_GlobalInvocationID.x;
            if (id < instanceCount)
            {
                vec4 pos = vec4(0);
                pos.x = (((id % int(density)) / density) - 0.5) * (terrainSize * 2);
                pos.y = 0;
                pos.z = (((id / int(density)) / density) - 0.5) * (terrainSize * 2);

                float h = textureLod(heightMap, fract(pos.xz / (terrainSize * 2 + 1) + 0.5), 0).r;
                pos.y += h * 20;

                pos.w = hashwithoutsine13(pos.xyz);

                vec2 o = hashwithoutsine22(pos.zw) - vec2(0.5);
                pos.xz += o * 2;

                float scale = 1;

                float n = (Perlin2D(pos.xz / 30) + 1) * 0.5;
                if (n < 0.05) scale = clamp(n * 20, 0, 1);
                if (pos.w < 0.2) n *= 1.25;

                pos.w *= 3.1415964;

                instances[id].position = pos;
                instances[id].details = vec4(clamp(n, 0, 1), scale, 0, 0);
            }
        ]])
        :build()

    self.windNoiseScale = 250
    self.windPanSpeed = 0.04
    self.windNoiseStrength = 3
    self.bladeThickness = 0.4
    self.bladeHeight = 4
    self.bladeBendFactor = 2
    self.bladeBendStrength = 0.5

    self.wind = vec4()
    self.blade = vec4()

    self:setDensity(100)

end

function Grass:setDensity(density)
    self.density = density
    self:setup()
end

function Grass:setup()
    if self.buffer == nil then
    end
    self.buffer = shader.buffer(Grass.layout)
    self.buffer:resize(self.density*self.density)
    self.setupGrass:setBuffer("instancesBuffer", self.buffer)
    self.setupGrass.heightMap = self.heightMap
    self.setupGrass.instanceCount = self.buffer.size
    self.setupGrass.density = self.density
    self.setupGrass:dispatch(math.ceil(self.buffer.size / 256), 1, 1)
end

function Grass:draw()
    self.wind.x = self.windNoiseScale
    self.wind.y = self.windPanSpeed
    self.wind.z = self.windNoiseStrength

    self.blade.x = self.bladeThickness
    self.blade.y = self.bladeHeight
    self.blade.z = self.bladeBendFactor
    self.blade.w = self.bladeBendStrength

    matrix.push().reset()
    Grass.shader.windParams = self.wind
    Grass.shader.bladeParams = self.blade
    Grass.shader:setBuffer("instancesBuffer", self.buffer)
    self.model:draw(self.buffer.size)
    matrix.pop()
end
