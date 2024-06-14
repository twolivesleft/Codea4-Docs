-- Shaders / Solid Fill

-- Shaders tell our screen what to draw, they are small programs that run on the GPU
-- They have highly specialised APIs to perform this task
-- We'll start with just setting pixels to one color 

-- You can create simple shaders using the following boilerplate GLSL code:

-- The vertex shader, used to transform vertices before being passed into the fragment shader
-- Used to pass and modify position, color and uv data
local vertexSh = 
[[
    #version 430
    #include <codea/common.glsl>
    
    // This is raw incoming vertex data from whatever we are drawing (a sprite/quad in this case)
    layout (location = POSITION) in vec3 a_position;
        
    // GLSL shaders always need a main() function to run the program from
    void main()
    {
        // This applies all the matrix transforms/projections to display our shader properly on screen
        gl_Position = u_modelViewProj * vec4(a_position, 1.0);
    }
]]

-- The fragment shader, used to calculate the final pixel colors, typically used for texturing
-- and lighting effects, as well as post processing
local fragmentSh = 
[[
    #version 430
    #include <codea/common.glsl>

    // Uniforms are variables that stay the same for all vertices/pixels handled by the shader
    // pass outside data to configure how the shader works
    uniform vec4 color;

    // We have to define where we want our calculations to end up
    out vec4 FragColor;

    // Both vertex and fragment shaders have their own separate main() functions
    void main()
    {
        // Whatever we set our output color to will be displayed on screen
        // In this case we use our color uniform/property which is set outside the shader   
        FragColor = color;
    }
]]

-- The shader() type has a few different ways it can be created, but this is the simplest for now
solidFill = shader(vertexSh, fragmentSh)
    
function setup()
    -- Here we create a parameter to set our shader property/uniform (exposing it to the user)
    -- Try changing it when you run the example or write code to change it every frame!
    parameter.color("FillColor", color(196, 18, 109), function(c)
        solidFill.color = c
    end)
end

function draw()
    -- Simple shortcut to draw our shader as a fullscreen quad and fill the whole screen :)
    style.spriteMode(CORNER)
    sprite(solidFill, 0, 0, WIDTH, HEIGHT)
end
