-- Shaders / ShaderToy

-- This shader adapts an existing ShaderToy shader to run in Codea

-- Special thanks to iq for all the shaders and inspiration

display.fullscreen()

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

    // ShaderToy unique inputs
    uniform int iFrame;
    uniform vec4 iMouse;
    // Some of these are already available so just adapt using macros
    #define iResolution vec3(u_viewRect.zw, 1.0)
    #define iTime u_time.x
    #define iTimeDelta u_time.y

    // Grab the shader code from the project folder
    #include <project/primitives.glsl>

    out vec4 fragColor;

    void main()
    {
        // Draw the texture!
        vec2 fragCoord = vec2(gl_FragCoord.x, u_viewRect.w - gl_FragCoord.y);
        mainImage(fragColor, fragCoord);
    }
]]

function setup()
    shaderToy = shader(vertexSh, fragmentSh)
    
    -- Render to a texture so we can scale down rendering if the shader is a bit slow
    scaleFactor = 2
    screen = image(math.ceil(WIDTH/scaleFactor), math.ceil(HEIGHT/scaleFactor))
    frame = 0
end

function draw()
    -- Pass in parameters used by ShaderToy
    frame = frame + 1
    shaderToy.iFrame = frame
    local mouseDown = CurrentTouch.state == BEGAN or CurrentTouch.state == MOVING
    shaderToy.iMouse = vec4(CurrentTouch.x, CurrentTouch.y, mouseDown and 1.0 or 0.0, 0.0)

    style.spriteMode(CORNER)
    context.push(screen)
        sprite(shaderToy, 0, 0, WIDTH/scaleFactor, HEIGHT/scaleFactor)
    context.pop()
    sprite(screen, 0, 0, WIDTH, HEIGHT)
end
