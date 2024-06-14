GamepadVisualiser = class("GamepadVisualiser")

function GamepadVisualiser:init(gp)
    self.gp = gp
end

function GamepadVisualiser:drawRoundButton(button, label, x, y, r)
    matrix.push().translate(x, y)
    style.push()
    style.noStroke()
    style.fill(64)
    ellipse(x, y - 10, r, r)
    if button.pressing then matrix.translate(0,-8) end
    style.stroke(200)
    style.strokeWidth(5)
    style.fill(128, 128, 128, 255)
    ellipse(x, y, r, r)
    style.fill(255).textAlign(CENTER).fontSize(30)
    text(label, x, y)
      
    style.pop()
    matrix.pop()
end

function GamepadVisualiser:drawSquareButton(button, label, x, y, w, h)
    matrix.push().translate(x, y)
    style.push()
    style.noStroke()
    style.fill(64)
    style.rectMode(CENTER)
    rect(x, y - 10, w, h)
    matrix.translate(0,-8 * button.value)
    style.stroke(200)
    style.strokeWidth(5)
    style.fill(128, 128, 128, 255)
    rect(x, y, w, h)
    style.fill(255).textAlign(CENTER).fontSize(30)
    text(label, x, y)
    
    style.pop()
    matrix.pop()
end


function GamepadVisualiser:drawFaceButtons(x, y)
    matrix.push().translate(x, y)
    self:drawRoundButton(self.gp.buttonA, "A", 0, -25, 50)
    self:drawRoundButton(self.gp.buttonB, "B", 25, 0, 50)
    self:drawRoundButton(self.gp.buttonY, "Y", 0, 25, 50)
    self:drawRoundButton(self.gp.buttonX, "X", -25, 0, 50)
    matrix.pop()
end

function GamepadVisualiser:drawDPadElement(pressed, x, y, w, h)
    matrix.push().translate(x, y)
    style.push()
    style.noStroke()
    style.fill(64)
    style.rectMode(CENTER)
    roundRect(x, y - 10, w, h, 5)
    if pressed then matrix.translate(0,-8) end
    style.stroke(200)
    style.strokeWidth(5)
    style.fill(128, 128, 128, 255)
    roundRect(x, y, w, h, 5)
    style.pop()
    matrix.pop()
end

function GamepadVisualiser:drawDPad(dpad, x, y)
    matrix.push().translate(x, y)
    self:drawDPadElement(dpad.down, 0, -25, 40, 50)
    self:drawDPadElement(dpad.up, 0, 25, 40, 50)
    self:drawDPadElement(dpad.right, 25, 0, 50, 40)
    self:drawDPadElement(dpad.left, -25, 0, 50, 40)
    matrix.pop()
end


function GamepadVisualiser:drawTopButtons(b1, b2, prefix, x, y)
    matrix.push().translate(x, y)
    self:drawSquareButton(b1, prefix.."S", 0, -15, 80, 40)
    self:drawSquareButton(b2, prefix.."T", 0, 15, 80, 40)
    matrix.pop()
end

function GamepadVisualiser:drawStick(stick, x, y)
    matrix.push().translate(x, y)
    style.push()
    style.noStroke()
    style.fill(64)
    ellipse(0, 0, 100)
    style.fill(128).strokeWidth(5).stroke(200)
    ellipse(stick.x * 25, stick.y * 25, 70)
    style.pop()
    matrix.pop()
end

function GamepadVisualiser:draw(x, y, s)
    matrix.push().transform2d(x, y, s, s)
    self:drawFaceButtons(250, 0)
    self:drawDPad(gp.dpad, -250, 0)
    self:drawTopButtons(gp.leftShoulder, gp.leftTrigger, "L", -250, 200)
    self:drawTopButtons(gp.rightShoulder, gp.rightTrigger, "R", 250, 200)
    matrix.push().translate(0, gp.leftStickButton.pressing and -8 or 0)
    self:drawStick(gp.leftStick, -150, -150)
    matrix.pop()
    matrix.push().translate(0, gp.rightStickButton.pressing and -8 or 0)
    self:drawStick(gp.rightStick, 150, -150)        
    matrix.pop()
    self:drawDPadElement(gp.options.pressing, -75, 50, 25, 40)
    self:drawDPadElement(gp.menu.pressing, 75, 50, 25, 40)
    self:drawDPadElement(gp.touchpadButton.pressing, 0, 20, 200, 140)
    matrix.push().translate(0, 40)
    style.push().noStroke().fill(50,50,200,100)
    ellipse(gp.touchpadSurface.x * 200/2, gp.touchpadSurface.y * 140/2, 30)
    style.pop()
    matrix.pop()
    style.push().noStroke().fill(gp.light).rectMode(CENTER)
    matrix.push().translate(0, 150)
    roundRect(0, 0, 170, 25, 15)
    matrix.pop()
    style.pop()
    matrix.pop()
end