DialogueBox = class('DialogueBox')

function DialogueBox:created()
    self.borderImg = image.read(asset.builtin.PixelUI.space)
    self.borderImg.smooth = false
    self.border = self.borderImg.slice:patch(12)
   
    -- Create a basic text box
    local box = self.entity
    box.size = vec2(800, 150)
    box.pivot = vec2(0.5, 0.5)
    box:anchor(CENTER, TOP)
    box.y = -150
    
    local textBox = box:child("Text")
    textBox:anchor(STRETCH, STRETCH)
    textBox.size = vec2(700 - 75, 140)
    textBox.x = 75
    local label = textBox:add(ui.label)
    label.text = "" -- words
    label.style = TEXT_RICH
    label.shadow = color(32)
    label.shadowOffset = vec2(4, 4)
    
    local pbox = box:child("Portrait Border")
    pbox.size = vec2(130, 130)
    pbox:anchor(LEFT, CENTER)
    pbox.pivot = vec2(0, 0.5)
    pbox.x = 10
    pbox.sprite = self.border
    pbox.tint = color(200)
    
    local inner = pbox:child("Portrait")    
    inner:anchor(STRETCH, STRETCH)
    inner.size = vec2(130, 130)    
    self.portrait = inner
    self.portaitBorder = pbox
        
    box.sprite = self.border    
    box.scale = vec3(1,0,1)
    
    self.textBox = textBox
    self.label = label
    
    self.tempo = 1
    self.triggers = {}
    
    text.style.pause = function(tag, format, i)
        if self.triggers[i] == nil then
            self.triggers[i] = 
            {
                done = false,
                func = function()
                    self.pause = 1
                end
            }
        end
    end
    
    text.style.appear = function(tag, format)
        local t = self.timer * tag:number("speed", 5)                
        
        format.callback = function(str, i, mod)
            local a = math.min(math.max(t - i, 0.0), 1.0)
            local len = str:len()
            mod.offsetY = 5 * math.cos(a * math.pi/2)
            mod.alpha = a * 255
            
            if i == 1 then self.length = #str end
            if a == 1 then self.index = math.max(self.index, i) end
            
            --[[
            if a == 1.0 and self.triggers[i+1] and not self.triggers[i+1].done then
                self.triggers[i+1].done = true
                self.triggers[i+1].func()
            end
               
            if i == 1 and a >= 1 then self.talking = true end
            if i == #str and a >= 1 then self.talking = false end--]]
        end
    end
end

function DialogueBox:update(dt)
    if self.co then
        local status, err = coroutine.resume(self.co, self)
        if not status then
            self.co = nil
        end
    end    
end

function DialogueBox:setScript(script)
    self.script = script
    self.co = coroutine.create(self.next)
end

function DialogueBox:delay(d)
    local t = d
    while t > 0 do 
        t = t - time.delta
        coroutine.yield()
    end
end

function DialogueBox:next()
    self:delay(2.0)
    
    for _, part in pairs(self.script) do
        
        self.portrait.sprite = part.portrait
        self.tempo = part.tempo or 1.0
        
        local align = part.align or LEFT
        if align == LEFT then
            self.textBox.x = 75
            self.portaitBorder:anchor(LEFT, CENTER)
            self.portaitBorder.pivot = vec2(0.0, 0.5)
            self.portaitBorder.x = 10
        elseif align == RIGHT then
            self.textBox.x = 0
            self.portaitBorder:anchor(RIGHT, CENTER)
            self.portaitBorder.pivot = vec2(1.0, 0.5)
            self.portaitBorder.x = -10
        end
            
        self.label.text = ""
        self.opening = true
        self.scene:tween(self.entity):to{scale = vec3(1,1,1)}:time(.6):ease(tween.backOut)
        self:delay(.6)

        for _, line in pairs(part.lines) do
            self.label.text = line
            self:playSample(100, 1.4, 0.1)     
            self:delay(.6)       
            self.label.text = ""
        end   
        
        self.opening = true
        self.scene:tween(self.entity):to{scale = vec3(1,0,1)}:time(.6):ease(tween.backIn)
        self:delay(.6) 
    end
end

function DialogueBox:playSample(count, tempo, gap)
    tempo = tempo or 1.0
    gap = gap or 0.0
    self.timer = 0
    self.index = 1
    self.talking = true
    self.triggers = {}
    
    local source = samples[math.random(1, #samples)]
    local instance = sound.play(source, random.number(0.8, 1.2) * .5, random.number(0.8, 1.2) * tempo * self.tempo)
    local length = source.length / (tempo * self.tempo) + gap
    
    while count > 1 and self.talking do 
        
        if self.length then
            self.talking = self.index < self.length
            if self.triggers[self.index] and not self.triggers[self.index].done then
                self.triggers[self.index].done = true
                self.triggers[self.index].func()
            end
        end
        
        self.portrait.y = math.abs(math.sin(time.elapsed * 10) * 3)
        if length <= 0 then  
            source = samples[math.random(1, #samples)]
            instance = sound.play(source, random.number(0.8, 1.2) * .5, random.number(0.8, 1.2) * tempo * self.tempo)
            length = source.length / (tempo * self.tempo) + gap
            count = count - 1            
        end
        length = length - time.delta
        
        if self.pause and self.pause > 0 then
            self:delay(self.pause)
            self.pause = 0
        else         
            self.timer = self.timer + time.delta
        end
        coroutine.yield()
    end    
end
