-- Changes to Style in Codea 4
--

function setup()
end

function draw()
    background(25, 25, 25)

    -- The API for matrix transforms has changed in Codea 4
    -- All matrix calls have been folded into the matrix namespace

    -- pushMatrix() becomes matrix.push()
    matrix.push()

    -- translate() becomes matrix.translate()
    matrix.translate(WIDTH/2, HEIGHT/2)

    -- Matrix calls can be chained together
    matrix.rotate(45).translate(100, 0)

    -- Drawing works as normal!
    ellipse(WIDTH/2, HEIGHT/2, 100)

    -- There is now a new convenience command for generic transformations...
    -- This allows you to append a full transform directly:
    -- matrix.transform2d(x, y, scaleX, scaleY, rotation)

    -- There is also a 3D variation of this:
    -- matrix.transform3d(x, y, z, sx, sy, sz, rx, ry, rz)

    -- popMatrix() becomes matrix.pop()
    style.pop()

    -- m = matrix.get() can be used to the current transform
    -- matrix.set(s) can then be used to apply it later
end
