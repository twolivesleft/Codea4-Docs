--display.fullscreen()

function string.titleCase(str)
    local function titleCase( first, rest )
        return first:upper()..rest:lower()
    end
    
    return string.gsub(str, "(%a)([%w_']*)", titleCase)
end

function string.removeNonAlphanumeric(str)
    return str:gsub('%W','')
end

function string.removeWhitespace(str)
    return str:gsub('%s','')
end


LuaDoc = class('LuaDoc')

function LuaDoc:init() 
    self.globals =
    {
        classes = {},
        constants = {},
        funcs = {},
    }
    self:crawl(_G)
    
    self.sections = {}
    self.sectionMap = {}
end

function LuaDoc:crawl(storage, obj)
    local t = type(obj)
    if t == 'table' then
        
    elseif t == 'function' then
        
    end
end

function LuaDoc.static.toId(name)
    return name:titleCase():removeNonAlphanumeric():removeWhitespace()
end

local HasDescription = 
{
    description = function(self, desc)
        if self._description == nil then
            self._description = {}
        end
    
        table.insert(self._description, desc)
        return self
    end
}

local HasSyntax =
{
    syntax = function(self, syntax)
        if self._syntax == nil then
            self._syntax = {}
        end
    
        table.insert(self._syntax, desc)
        return self
    end
}

local HasExamples =
{
    example = function(self, example)
        if self._examples == nil then
            self._examples = {}
        end
    
        table.insert(self._examples, example)
        return self
    end
}

local HasRelated =
{
    related = function(self, related)
        if self._related == nil then
            self._related = {}
        end
    
        if type(related) == 'table' then
            for k,v in pairs(self._related) do
                table.insert(self._related, v)
            end
        else        
            table.insert(self._related, related)
        end
        return self
    end
}



local Method = class('Method')
    :include(HasDescription)
    :include(HasSyntax)
    :include(HasRelated)

function Method:init(class, method, id, name)
    self.class = class
    self.method = method
    self.id = id
    self.name = name
    self.parameters = {}
    self.returns = {}
    self.related = {}
end

function Method:pop()
    return self.class
end

local Class = class('Class')
    :include(HasDescription)
    :include(HasSyntax)
    :include(HasExamples)    
    :include(HasRelated)


function Class:init(group, klass, id, name)
    self.group = group
    self.klass = klass
    self.id = id
    self.name = name
    self.properties = {}
    self.methods = {}
    self.methodMap = {}
    self.staticMethods = {}
end

function Class:property(name, valueType, description)
    table.insert(self.properties, {name = name, valueType = valueType, description = description})
    return self
end

function Class:method(name)
    local func = self.klass.___class[name]
    assert(func)
    local id = LuaDoc.toId(name)
    local method = self.methodMap[func]
    if method == nil then
        method = Method(self, func, id, name)
        self.methodMap[method] = method
        table.insert(self.methods, method)
    end
    return method
end

function Class:pop()
    return self.group
end

local Overview = class('Overview')
    :include(HasDescription)
    :include(HasRelated)

function Overview:init(group, id, name)
    self.group = group
    self.id = id
    self.name = name
end

function Overview:pop()
    return self.group
end

local Group = class('Group')
function Group:init(section, id, name)
    self.section = section
    self.id = id
    self.name = name
    self.itemMap = {}
    self.items = {}
end

function Group:klass(class, name)
    assert(class)
    local id = LuaDoc.toId(name)
    local item = self.itemMap[class]
    if item == nil then
        item = Class(self, class, id, name)
        self.itemMap[class] = item
        table.insert(self.items, item)
    end
    return item
end

function Group:overview(name)
    local id = LuaDoc.toId(name)
    local item = self.itemMap[id]
    if item == nil then
        item = Overview(self, id, name)
        self.itemMap[class] = item
        table.insert(self.items, item)
    end
    return item
end

function Group:pop()
    return self.section
end

local Function = class('Function')
-- ...

local Section = class('Section')
function Section:init(doc, id, name)
    self.doc = doc
    self.id = id
    self.name = name
    self.groups = {}
    self.groupMap = {}
end

function Section:subtitle(subtitle)
    self.subtitle = subtitle
    return self
end

function Section:group(name)
    local id = LuaDoc.toId(name)
    local group = self.groupMap[id]
    if group == nil then
        group = Group(self, id, name)
        self.groupMap[id] = group
        table.insert(self.groups, group)
    end
    return group    
end

function Section:pop()
    return self.doc
end

function LuaDoc:section(name)
    local id = LuaDoc.toId(name)
    local section = self.sectionMap[id]
    if section == nil then
        section = Section(self, id, name)
        self.sectionMap[id] = section
        table.insert(self.sections, section)
    end
    return section
end
    
function setup()
    doc = LuaDoc()
    
    local graphics = doc:section('Graphics')
    
    graphics:group('Overview'):overview('How Codea Draws'):description(
    [[
    Description goes here!
    ]])
    
    graphics:group('Meshes'):klass(mesh, 'mesh')
    :description("TODO")
    :property('vertexCount', 'integer', 'the number of mesh vertices')
    :method('draw')
    :description('draw this mesh using the current style/matrix state')
    :pop()
    :example(
    [[
        Some mesh example!
    ]])
    :related('shader')
end

local apiFilter = { text = ''}

function apiExplorer()
    imgui.begin("API", function()
        imgui.setWindowPos(WIDTH/2 - WIDTH/6, 70, imgui.cond.once)
        imgui.setWindowSize(WIDTH/3, 500, imgui.cond.once)        
        
        if imgui.button("Dump") then
            dump(asset..'API Dump.md')
        end
        
        imgui.inputText("Filter", apiFilter)
        imgui.text(apiFilter.text)
        
        local globals = {}
        for k,v in pairs(_G) do
            table.insert(globals, {k = k,v = v})
        end
        table.sort(globals, function(a, b) return a.k:lower() < b.k:lower() end)
        for k,v in ipairs(globals) do
            apiTree(v.k, v.v, true)            
        end
    end)
end

function dumpItem(doc, k, v)
    local isClass = (type(v) == 'table' and v.___class)
    if isClass then
        table.insert(doc.classes, string.format("### %s", k))
        table.insert(doc.classes, "")
        table.insert(doc.classes, "#### Static Methods")
        for k,v in pairs(v) do 
            if type(v) == 'function' then
                table.insert(doc.classes, string.format("%s()", k))
                table.insert(doc.classes, "")
            end
        end
        table.insert(doc.classes, "#### Methods")
        for k,v in pairs(v.___class) do
            if type(v) == 'function' then
                table.insert(doc.classes, string.format("%s()", k))
                table.insert(doc.classes, "")
            end
        end
        table.insert(doc.classes, "#### Properties")
        table.insert(doc.classes, "")
    elseif type(k) == 'string' and type(v) == 'function' then
        table.insert(doc.globalFuncs, string.format("%s()", k))
    elseif type(k) == 'string' and type(v) == 'number' then
        table.insert(doc.constants, string.format("%s: %f", k, v))
    end
end

function dump(key)
    local doc = 
    {
        classes = {},
        globalFuncs = {},
        constants = {},
    }
    
    local globals = {}
    for k,v in pairs(_G) do
        table.insert(globals, {k = k,v = v})
    end
    table.sort(globals, function(a, b) return a.k:lower() < b.k:lower() end)
    
    for k,v in ipairs(globals) do
        dumpItem(doc, v.k, v.v)
    end
    
    local formatting = 
[[
## Classes
%s
    
## Global Functions
%s
    
## Constants
%s
]]
    local classes = table.concat(doc.classes, '\n')
    local globalFuncs = table.concat(doc.globalFuncs, '\n')
    local constants = table.concat(doc.constants, '\n')
    local output = string.format(formatting, classes, globalFuncs, constants) 
    print(output)
    
    text.save(key, output)
end

function containsKey(key, value, filter, cache)
    if cache[value] then return false end
    if type(key) == 'string' and key:lower():find(filter:lower()) then return true end
    
    if type(value) == 'table' then
        cache[value] = value
        for k,v in pairs(value) do
            if not rawequal(v, _G) and containsKey(k, v, filter, cache) then return true end
        end            
    end
    return false
end

function apiTree(key, value, shouldFilter)

    if shouldFilter then
        if apiFilter.text ~= '' and not containsKey(key, value, apiFilter.text, {}) then return end
    end
        
    local isClass = (type(value) == 'table' and value.___class)
    if type(key) == 'string' then
        --if key:find('___') then return end
        --if key:find('__') then return end        
    end
       
    if isClass then
        imgui.treeNode(key, function()
            imgui.treeNode("methods", function()
                for k,v in pairs(value.___class) do
                    if type(k) == 'string' then imgui.text(k) end
                end                            
            end)
            imgui.treeNode("static methods", function()
                for k,v in pairs(value) do
                    if type(k) == 'string' and type(v) == 'function' then imgui.text(k) end
                end
            end)
            imgui.treeNode("getters", function()
                for k,v in pairs(value.___class.___getters) do
                    imgui.text(k)
                end                            
            end)            
            imgui.treeNode("setters", function()
                for k,v in pairs(value.___class.___setters) do
                    imgui.text(k)
                end                            
            end)            
            imgui.treeNode("getters (static)", function()
                for k,v in pairs(value.___getters) do
                    imgui.text(k)
                end                            
            end)            
            imgui.treeNode("setters (static)", function()
                for k,v in pairs(value.___setters) do
                    imgui.text(k)
                end                            
            end)                        
        end)
    elseif type(value) == 'table' then 
        imgui.treeNode(key, function()
            for k,v in pairs(value) do
                if not rawequal(v, _G) then apiTree(k,v, shouldFilter) end
            end
        end)
    elseif type(value) == 'number' then
        imgui.text(string.format("%s = %f", key, value))
    elseif type(value) == 'string' then
        imgui.text(string.format("%s = %s", key, value))
    elseif type(value) == 'function' then
        imgui.text(string.format("%s <function>", key))
    elseif type(value) == 'userdata' then
        imgui.treeNode(string.format("%s = %s", key, value), function()
            if is(value, image) then
                imgui.image(value, 300)
            end
        end)
    elseif value == nil then
        imgui.text(string.format("%s = nil", key))
    end
    
end

function gui()
    apiExplorer()
end

function draw()
    background(0, 0, 0, 0)
end

function touched(touch)
end
