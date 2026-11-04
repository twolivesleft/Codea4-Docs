Terrain = class()

-- HeightMap displacement shader for terrain
Terrain.static.shader = shader.builder():lit()
    :include "codea/utilities.glsl"
    :texture{"heightMap", binding = 5}
    :texture{"baseColor"}
    :number{"terrainSize", value = 50}
    :number{"terrainHeight", value = 20}
    :vertex([[
        material.uv0 = fract(material.worldPosition.xz / (terrainSize * 2 + 1) + 0.5);
        material.worldPosition.y += textureLod(heightMap, material.uv0, 0).x * terrainHeight;
    ]])
    :normals([[
        material.normal = decodeNormal(textureLod(heightMap, fract(getUV0()), 0).yzw);
    ]])
    :material([[
        vec3 bc = texture(baseColor, getUV0() * 2).rgb;
        bc = pow(bc, vec3(2.2));
        material.baseColor = vec4(bc, 1.0);
    ]])
    :build()

function Terrain:created()

    self.mesh = mesh.plane(50, 50, 100, 100)
    self.entity:add(self.mesh)
    self.height = 20
    self.size = 50

    -- Generate a noise-based height map
    self.heightMap = image(512, 512)
    context.push(self.heightMap)
    background(shader.builder():unlit()
    :include "codea/noise/noise.glsl"
    :include "codea/utilities.glsl"
    :material([[
        vec2 uv = getUV0() * 2;
        float n = Perlin2D(uv); // + Perlin2D(uv * 2) * 0.1;
        vec2 d = vec2(dFdx(n), dFdy(n));
        d *= 30;
        float h = n.x * 0.4 + 0.5;
        vec3 nrm = encodeNormal(normalize(vec3(d.x, d.y, 0.5)));
        material.baseColor = vec4(h, nrm);
    ]])
    :build())
    context.pop()

    self.mat = material(Terrain.shader)
    self.mat.heightMap = self.heightMap
    self.mat.terrainHeight = self.height
    self.mat.terrainSize = self.size
    self.mat.baseColor = asset.Ground
    self.entity.material = self.mat
end
