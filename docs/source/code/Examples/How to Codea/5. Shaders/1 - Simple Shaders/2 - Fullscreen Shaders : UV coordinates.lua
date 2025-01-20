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
    
    // This is the data we want to send to the fragment shader below (position has a special variable)
    layout (location = POSITION) in vec3 a_position;
    layout (location = TEXCOORD0) in vec2 a_texcoord0;
    
    layout(location = 1) out vec2 v_texcoord0;
    
    void main()
    {
        gl_Position = u_modelViewProj * vec4(a_position, 1.0);
        // Pass the vertex texture coordinate to fragment shader
        v_texcoord0 = a_texcoord0;
    }
]]

local fragmentSh = 
[[
    #version 430
    #include <codea/common.glsl>

    layout(location = 1) in vec2 v_texcoord0;

    out vec4 FragColor;

    void main()
    {
        // Draw the UV coordinates 
        vec2 uv = v_texcoord0;
        FragColor = vec4(uv.xy, 0.0, 1.0);
    }
]]

uvs = shader(vertexSh, fragmentSh)
    
function setup() 
end

function draw()
    -- Simple shortcut to draw our shader as a fullscreen quad and fill the whole screen :)
    style.spriteMode(CORNER)
    sprite(uvs, 0, 0, WIDTH, HEIGHT)
end
