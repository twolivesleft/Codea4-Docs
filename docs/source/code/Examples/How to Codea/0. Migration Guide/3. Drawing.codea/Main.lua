-- Changes to Style in Codea 4
--

--viewer.fullscreen()

function setup()
    -- A note on asset handling
    -- readImage() has been folded into the image type namespace as image.read()
    -- likewise saveImage() is now image.save()
    -- The same applies to all other read/save functions
    -- readText()/saveText() is now string.read()/string.save()

    -- image.slice()
    -- A new type intended to be used in atlases for efficient use of hundreds of sprites packed into a single image
    -- Slices have many advantages ranging from performance to convenience. If you have a sprite sheet grid you can slice it up using built-in methods
    -- You can also create 9-patch image slices for for use with stretchable UI images

    -- Load an image atlas    
    local adventure = asset.builtin.Pixel_Adventure
    slime = image.read(adventure.Enemies.Slime.."/Idle-Run (44x30).png")
    slime.sampler.u = image.clamp
    slime.sampler.v = image.clamp
    
    -- Slice up the atlas using the sprite cell size
    -- Individual slices can be accessed with atlas[i]
    atlas = slime.atlas
    atlas:setWithCellSize(44,30)
end

function draw()
    background(25, 25, 25)

    -- Dynamic arguments!

    -- Many drawing commands now accept dynamic arguments
    -- sprite(drawable, x, y, size)
    -- Drawable can be one of the following:
    -- - string path to an image
    -- - asset object (i.e. asset.builtin...)
    -- - image
    -- - image.slice (new type for atlases)
    -- - shader (yes shaders can be drawn directly and size must be specified)

    -- The rest of the arguments for sprite just need to contain enough values
    -- sprite(drawable, vec2(x, y)) is now acceptable
    -- sprite(drawable, vec3(x, y, size)) works too
    -- sprite(drawable, vec2(x, y), size) also works...
    -- sprite(drawable, vec4(x, y, width, height)) also works...
    -- sprite(drawable, x, y, vec2(width, height)) also works...
    -- sprite(drawable, x, vec2(y, width), height) also works if you really want it for some reason?

    -- Basically any command that accepts dynamic arguments will take any sequence of types that provide numbers and attempt to unpack them in order. This doesn't work for every function in Codea but for standard style, matrix and drawing commands it is generally supported

    matrix.translate(WIDTH/2, HEIGHT/2)
    local frame = math.floor(1 + (time.elapsed * 20) % atlas.count) 
    local pos = vec2(math.cos(time.elapsed * 5) * 20, 0)
    sprite(atlas[frame], pos.x, pos.y, 44, 30)
    matrix.translate(0, -50)
    sprite(atlas[frame], pos, 44, 30)
    matrix.translate(0, -50)
    sprite(atlas[frame], pos, vec2(44, 30) * 1.5)
    matrix.translate(0, -50)
    sprite(atlas[frame], vec4(pos.x, pos.y, 44 * 1.5, 30 * 0.5))
end
