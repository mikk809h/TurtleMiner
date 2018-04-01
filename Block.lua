local Block = {}

Block.Name = ""
Block.State = {}
Block.Metadata = -1
Block.Blacklisted = false

TurtleMiner = TurtleMiner or {
    Path = "/github",
}

local BlacklistClass = loadfile(fs.combine(TurtleMiner.Path, "Blacklist.lua"))()
--[[

state = {
    variant = "granite/andesite/diorite/etc..."
}

]]

function Block:Init(arg)
    if not self then
        self = arg or Block
    end

    if not turtle then
        return false
    end

    self.Name = ""
    self.State = {}
    self.Metadata = -1
    self.Blacklisted = false
end

function Block:Get(arg)
    if not self then
        self = arg or Block
    end
    local isBlock, blockData = turtle.inspect()
    if isBlock then
        self.Name = blockData.name
        self.Metadata = blockData.metadata
        self.State = blockData.state
        self.Blacklisted = BlacklistClass:IsBlacklisted(self.Name)
    end
end

function Block:Mine(arg)
    if not self then
        self = arg or Block
    end
    if not self.Blacklisted then
        self.Name = ""
        self.State = {}
        self.Metadata = -1
        self.Blacklisted = false
        return turtle.dig()
    end
end

local BlockMetatable = {}

function BlockMetatable.__call(...)
    return false, "Cannot call table"
end


return setmetatable(Block, BlockMetatable)
