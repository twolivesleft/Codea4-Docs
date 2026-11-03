-- Track simultaneous fingers by their stable touch IDs.
local fingers = {}
function setup() end
function draw()
    background(30, 35, 45)
    style.fill(255).fontSize(20).textAlign(CENTER | MIDDLE)
    text("Touch and drag to draw circles", WIDTH/2, HEIGHT - 40)
    for id, position in pairs(fingers) do
        style.fill(100, 220, 200).noStroke()
        ellipse(position.x, position.y, 70)
    end
end
function touched(t)
    if t.ended or t.cancelled then
        fingers[t.id] = nil
    else
        fingers[t.id] = vec2(t.x, t.y)
    end
end
