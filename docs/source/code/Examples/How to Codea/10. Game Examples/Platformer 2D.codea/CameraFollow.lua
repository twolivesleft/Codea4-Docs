CameraFollow = class('CameraFollow'):include(require'codea.properties')

CameraFollow:property{'target', entity}

function CameraFollow:created()
    self.cam = self.entity:get(camera)
end

function CameraFollow:update(dt)
    if self.target then
        self.entity.position = self.target.position + vec3(0,0,-1)
    end
end
