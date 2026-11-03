function swap(a, b)
    return b, a
end

ReactionDiffusion = class()

function ReactionDiffusion:init(w, h)
    self.rd = shader {
        options =
        {
            INIT = {false, multicompile = true},
        },

        properties =
        {
            {"image", "image2D"},
            {"previous", "image2D"},
            {"u_diffusion", "vec2", {1.0, 0.5}},
            {"u_feed", "float", 0.055},
            {"u_kill", "float", 0.062},
            {"u_dt", "float", 1.0 / 60.0},
        },

        pass =
        {
            compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba16f) uniform image2D image;
            layout(rgba16f) uniform readonly image2D previous;
            uniform vec2 u_diffusion = vec2(1.0, 0.5);
            uniform float u_feed = 0.055;
            uniform float u_kill = 0.062;
            uniform float u_dt = 1.0 / 60.0;

            #ifdef INIT

            float random (vec2 st)
            {
                return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
            }

            NUM_THREADS(16, 16, 1)
            void main()
            {
                ivec2 size = imageSize(image);
                ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

                if ( all(lessThan(pixel.xy, size)) )
                {
                    vec4 value = vec4(1.0, 0.0, 0.0, 1.0);
                    /*
                    if (pixel.x > size.x/2-10 && pixel.y > size.y/2-10 && pixel.x < size.x/2+10 && pixel.y < size.y/2+10)
                    {
                        value.r = 0.5 + random(pixel.xy) * 0.02 - 0.01;
                        value.g = 0.5 + random(pixel.xy * 5) * 0.02 - 0.01;
                    }*/

                    imageStore(image, pixel, value);
                }
            }

        #else

            vec2 sampleImage(ivec2 pos)
            {
                    return imageLoad(previous, clamp(pos, ivec2(0), imageSize(previous) - 1)).rg;
            }

            NUM_THREADS(16, 16, 1)
            void main()
            {
                ivec2 size = imageSize(image);
                ivec2 id = ivec2(gl_GlobalInvocationID.xy);

                if ( all(lessThan(id.xy, size)) )
                {
                    vec2 pq = sampleImage(id.xy);

                        ivec3 d = ivec3(1, -1, 0);
                        vec2 q = -pq;

                        q += sampleImage(id.xy - d.xx).xy * 0.05; // -1,-1
                        q += sampleImage(id.xy - d.zx).xy * 0.20; // 0, -1
                        q += sampleImage(id.xy - d.yx).xy * 0.05; // +1, -1
                        q += sampleImage(id.xy - d.xz).xy * 0.20; // -1, 0
                        q += sampleImage(id.xy + d.xz).xy * 0.20; // +1, 0
                        q += sampleImage(id.xy + d.yx).xy * 0.05; // -1, +1
                        q += sampleImage(id.xy + d.zx).xy * 0.20; // 0, +1
                        q += sampleImage(id.xy + d.xx).xy * 0.05; // +1, +1

                        float ABB = pq.x * pq.y * pq.y;

                        float a = pq.x + (u_diffusion.x * q.x - ABB + u_feed * (1.0 - pq.x)) * u_dt;
                        float b = pq.y + (u_diffusion.y * q.y + ABB - (u_kill + u_feed) * pq.y) * u_dt;

                        imageStore(image, id, vec4(saturate(a), saturate(b), 0.0, 1.0));
                }
            }
            #endif

        ]]
        }
    }

    self.paint = shader {
        options =
        {
        },

        properties =
        {
            {"image", "image2D"},
            {"u_paintPos", "vec2", {0.0, 0.0}},
            {"u_brushSize", "float", 10.0}
        },

        pass =
        {
            compute = [[
            #version 430
            #include <codea/common.glsl>

            layout(rgba16f) uniform image2D image;
            uniform vec2 u_paintPos;
            uniform float u_brushSize;

            float random (vec2 st)
            {
            return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
            }

            NUM_THREADS(16, 16, 1)
            void main()
            {
            ivec2 size = imageSize(image);
            ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

            if ( all(lessThan(pixel.xy, size)) )
            {
                if (distance(u_paintPos, vec2(pixel)) < u_brushSize)
                {
                    vec4 value = vec4(1.0, 0.0, 0.0, 0.0);
                    value.r = 0.5 + random(pixel.xy) * 0.02 - 0.01;
                    value.g = 0.5 + random(pixel.xy * 5) * 0.02 - 0.01;
                    imageStore(image, pixel, value);
                }
            }
            }
            ]]
        }
    }

    self.visualise = shader{
        properties =
        {
            {"img", "texture"}
        },
        pass =
        {
            vertex =
            [[
                #version 430
                #include <codea/common.glsl>

                layout (location = POSITION) in vec3 a_position;
                layout (location = TEXCOORD0) in vec2 a_texcoord0;

                layout(location = 0) out vec4 v_color0;
                layout(location = 1) out vec2 v_texcoord0;

                void main()
                {
                    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
                    v_texcoord0 = a_texcoord0;
                }
            ]],

            fragment =
            [[
                #version 430
                #include <codea/common.glsl>

                layout(location = 1) in vec2 v_texcoord0;

                uniform highp sampler2D img;

                out vec4 FragColor;

                const float COLOR_MIN = 0.2, COLOR_MAX = 0.4;

                void main()
                {
                    vec2 ab = texture(img, v_texcoord0).rg;
                    float d = 1.0 - (COLOR_MAX - ab.y) / (COLOR_MAX - COLOR_MIN);
                    FragColor = vec4(vec3(saturate(d)), 1.0);
                }
            ]],
        }
    }

    self.size = vec2(w or 256, h or 256)
    self.buffer = image.pixel(self.size.x, self.size.y, false, 1, image.rgba16f)
    self.nextBuffer = image.pixel(self.size.x, self.size.y, false, 1, image.rgba16f)
    self.buffer.smooth = true
    self:reset()
end

function ReactionDiffusion:draw(x, y, w, h)
    matrix.push().translate(x, y)
    self.visualise.img = self.buffer
    sprite(self.visualise, 0, 0, w, h)
    matrix.pop()
end

function ReactionDiffusion:fixedUpdate(dt)
    self.rd:setOption("INIT", false)
    self.rd.u_diffusion = vec2(1.0, 0.5)
    self.rd.u_feed = 0.0545
    self.rd.u_kill = 0.062
    self.rd.u_dt = dt * 30

    for i = 1, 12 do
        self.rd:setImage("previous", self.buffer)
        self.rd:setImage("image", self.nextBuffer)
        self.rd:dispatch(math.ceil(self.buffer.width / 16), math.ceil(self.buffer.height / 16), 1)
        self.buffer, self.nextBuffer = self.nextBuffer, self.buffer
    end
end

function ReactionDiffusion:reset()
    self.rd:setOption("INIT", true)
    self.rd:setImage("image", self.buffer)
    self.rd:dispatch(math.ceil(self.buffer.width / 16), math.ceil(self.buffer.height / 16), 1)
end

function ReactionDiffusion:set(x, y, size)
    self.paint:setImage("image", self.buffer)
    self.paint.u_paintPos = vec2(x, y)
    self.paint.u_brushSize = size
    self.paint:dispatch(math.ceil(self.buffer.width / 16), math.ceil(self.buffer.height / 16), 1)
end
