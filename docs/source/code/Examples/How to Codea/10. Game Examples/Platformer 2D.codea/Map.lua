-- Map
-- Loads a Tiled json map and associated tilesets

Tileset = class('Tileset')

Map = class('Map')

Map.static.mask = GROUND_MASK

function Map:read(key)

    self.data = json.decode(string.read(key))
    self.tilesets = {}
    self.tiles = {}

    -- Find and load all tilesets linked to this map
    for _, t in pairs(self.data.tilesets) do
        local set = json.decode(string.read(asset..'/'..t.source))

        local img = image.read(asset..'/'..set.image)
        img.smooth = false
        local atlas = img.atlas
        atlas:setWithCellSize(set.tilewidth, set.tileheight)

        for id = 0, set.tilecount-1 do
            local tile = {sprite = atlas[id+1]}
            for _, info in pairs(set.tiles or {}) do
                if info.id == id and info.properties then
                    for _, prop in pairs(info.properties) do
                        tile[prop.name] = prop.value
                    end
                end
            end
            self.tiles[id + t.firstgid] = tile
        end

        set.firstgid = t.firstgid
        set.img = img
        set.atlas = atlas
        table.insert(self.tilesets, set)
    end

    self.atlases = {}

    for k, v in pairs(self.data.layers) do
        if v.type == "tilelayer" then
            self:readTileLayer(k, v)
        elseif v.type == "objectgroup" then
            self:readObjectGroup(k, v)
        end
    end
end

function Map:tileWithId(id)
    return self.tiles[id]
end

function Map:readObjectGroup(id, group)
    -- Load any objects in the map
    for k,v in pairs(group.objects) do
        -- Special object tagged as the player
        if v.type == "Player" then
            local player = self.scene:entity(v.name)
            player.x = v.x / self.scene.pixelsPerUnit
            player.y = (self.data.height+0.5) - (v.y - v.height + 1) / self.scene.pixelsPerUnit
            player:add(Mob)

            local follow = self.scene.camera:add(CameraFollow)
            follow.target = player
        end
    end
end

function Map:readTileLayer(id, layer)
    local entity = self.entity:child(layer.name)
    local data = layer.data
    local w, h = layer.width, layer.height
    local noCollision = false
    local sortOrder = 0

    if layer.properties then
        for k,v in pairs(layer.properties) do
            if v.name == "noCollision" and v.value then
                noCollision = true
            elseif v.name == "sortOrder" then
                sortOrder = v.value
            end
        end
    end

    for y = 0, layer.height-1 do
        for x = 0, layer.width-1 do
            local id = data[y * w + x + 1]
            if id ~= 0 then
                local t = self:tileWithId(id)
                local tile = scn:entity(string.format('%d_%d', x, y))
                if not noCollision then
                    local tb = tile:add(physics2d.body, STATIC)
                    local box = tb:box(0.5, 0.5)
                    if t.isLadder then
                        box.sensor = true
                        box.category = 2
                    else
                        box.category = 1
                    end
                end
                tile.x = x - 0.5
                tile.y = h - y + 0.5
                tile.sprite = t.sprite
                tile.sortOrder = sortOrder
            end
        end
    end
end
