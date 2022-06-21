-- Learn to Codea
-- The Matrix
    
function setup()
end

function draw()
    
    background(25, 25, 25)
        
    r = time.elapsed * 15
    
    -- The matrix module gives you control over positioning of drawing commands
    
    -- By changing the current matrix, this changes where drawing occurs
    
    -- The easiest way to think of this is that the current matrix represents
    -- the origin of the screen
    -- matrix.translate(WIDTH/2, HEIGHT/2) - move drawing to the middle of the screen
    
    -- You can also rotate and scale drawing 
    -- Transforming the matrix combines with any previous transformation
    -- i.e. matrix.translate(WIDTH/2, HEIGHT/2).translate(100, 100)
    -- Drawing will now originate 100 pixels up and to the right of the middle of the screen
    
    -- You can also use matrix.push()/pop() to save and load the current matrix transform
    -- similar to how style.push()/pop() is used
    
    -- matrix.transform2d()/transform3d() allows you to apply full transformations in one
    -- command for convenience
    
    -- If you need to clear all current transformations you can use matrix.reset()    
    
    -- You can also create a mat4 (4x4 matrix) type and use this with matrix.get()/set()
    
    -- There are additional commands for adjusting view and projection matrices
    -- matrix.ortho() - use orthographic (2D) projection
    -- matrix.perspective() - use perspective (3D) projection
    -- matrix.projection(m) - use a custom projection matrix
    -- matrix.view(m) - use a custom view matrix
    
    -- Move the origin to the center of the screen and rotate over time
    matrix.transform2d(WIDTH/2, HEIGHT/2, 1, 1, r)    
    ellipse(0, 0, 50)
    
    -- Draw 6 satellites that orbit and rotate the center
    for i = 1, 6 do
        -- Accumulate rotations
        matrix.rotate(360/6)
        
        -- Use additional push and transform to create a recursive hierarchy
        matrix.push().transform2d(150, 0, 1, 1, r * 1.25)
        ellipse(0, 0, 25)
        
        -- Additional mini satellites that orbit the current origin
        for i = 1, 6 do
            matrix.rotate(360/6)
            matrix.push().transform2d(40, 0)
            ellipse(0, 0, 15)
            matrix.pop()
        end
        
        -- Pop here is cruciel to let the next satellite transform relative to its parent
        matrix.pop()    
    end
            
end

function touched(touch)
end
