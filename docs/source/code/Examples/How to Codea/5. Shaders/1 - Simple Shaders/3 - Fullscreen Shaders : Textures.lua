-- Shaders / UV Coordinates

-- Values from the vertex shader are smoothly blended when fragments are drawn
-- We can visualise this by simply drawing the default UV coordinates of our sprite

-- UV coordinates are mapped from [0,1] at each corner of our sprite
-- u represents the horizontal span of the coordintes and v represents the vertical

--  0,1 --- 1,0
--   |    /  |
--   |   /   |
--   |  /    |
--  0,0 --- 1,1

-- When we want to draw a quad we actually draw two triangles that share an edge down the center
-- Codea handles this automatically for sprites, but later when we use meshes you'll need to
-- handle this yourself

local vertexSh = 
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
]]

local fragmentSh = 
[[
    #version 430
    #include <codea/common.glsl>

    layout(location = 0) in vec4 v_color0;
    layout(location = 1) in vec2 v_texcoord0;

    uniform sampler2D tex;

    out vec4 FragColor;

    void main()
    {
        // Draw the texture!
        vec2 uv = v_texcoord0;

        // Uncomment the following lines one by one to see how we can modify UVs 
        // to change how the texture is drawn:

        // *** 1 ***
        // Our texture is squashed because the screen isn't a perfect rectangle
        // Determine the aspect ratio of the screen using the built-in variable u_viewTexel
        //float aspect = u_viewTexel.x / u_viewTexel.y;

        // *** 2 ***
        // Unsquash the uv y coordinate
        //uv.y *= aspect;        

        // *** 3 ***
        // The texture is now bigger than the screen, we can tile our texture by scaling the UVs up
        //uv *= 10.0;

        // *** 4 ***
        // We can also use u_time.x (the time elapsed in seconds) to scroll our texture around
        //uv.x += u_time.x * 0.5;

        vec4 color = texture(tex, uv); 

        // *** 5 ***
        // combine with the tinted vertex color
        //color.rgb *= v_color0.rgb;

        FragColor = color;
    }
]]

textured = shader(vertexSh, fragmentSh)
    
function setup()
    textured.tex = image.read(asset.Codea)
end

function draw()
    -- Simple shortcut to draw our shader as a fullscreen quad and fill the whole screen :)
    style.spriteMode(CORNER)
    style.tint(128, 0, 128)
    sprite(textured, 0, 0, WIDTH, HEIGHT)
end
