Animation = class('Animation')

function Animation:init(key, size, duration)
    self.frame = 1
    self.duration = duration
    self.timer = 0
    self.image = image.read(key)
    self.atlas = self.image.atlas
    self.atlas:setWithCellCount(self.image.width / size)
    self.frames = {}
    for i = 1, self.atlas.count do
        table.insert(self.frames, self.atlas[i])
    end
    self._loop = false
    self._playing = true
end

function Animation:loop()
    self._loop = true
    return self
end

function Animation:rewind()
    self.frame = 1
    return self
end

function Animation:onComplete(func)
    self._onComplete = func
    return self
end

function Animation:update(dt)
    if self._playing then self.timer = self.timer + dt end
    if self.timer >= self.duration / #self.frames then
        self.timer = 0
        if self._loop then
            self.frame = (self.frame % #self.frames) + 1
        else
            self.frame = math.min(self.frame + 1, #self.frame)
        end
        if self.frame == #self.frames and self._onComplete then
            self._onComplete(self)
        end
    end
    return self.frames[self.frame]
end