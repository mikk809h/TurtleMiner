local Config = {}

Config.Path = "/.config"
Config.Config = {}

function Config:Init()
    if not self then
        self = Config
    end
    if not fs.exists(self.Path) then
        local handle = fs.open(self.Path, "w")
        handle.write("{}")
        handle.close()
        self.Config = {}
    else
        local handle = fs.open(self.Path, "r")
        self.Config = textutils.unserialize(handle.readAll()) or {}
        handle.close()
    end
end

function Config:Load()
    if not fs.exists(self.Path) then
        local handle = fs.open(self.Path, "w")
        handle.write("{}")
        handle.close()
        self.Config = {}
    else
        local handle = fs.open(self.Path, "r")
        self.Config = textutils.unserialize(handle.readAll()) or {}
        handle.close()
    end
end

function Config:Update(key, value)
    self.Config[key] = value
    self:Save()
end

function Config:Save()
    local handle = fs.open(self.Path, "w")
    handle.write(textutils.serialize(self.Config))
    handle.close()
end

local mt = {}

function mt.__index(k, v)
    return k.Config[v]
end
function mt.__newindex(t, k, v)
    t.Config[k] = v
    Config:Save()
end


return setmetatable(Config, mt)
