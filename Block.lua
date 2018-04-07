local Block = {}
-- TEST COMMENT
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

function Block:Init()
    if not turtle then
        return false
    end

    self.Name = ""
    self.State = {}
    self.Metadata = -1
    self.Blacklisted = false
    self:Get()
end

function Block:Get()
    local isBlock, blockData = turtle.inspect()
    if isBlock then
        self.Name = blockData.name
        self.Metadata = blockData.metadata
        self.State = blockData.state
        self.Blacklisted = BlacklistClass:IsBlacklisted(self.Name)
    end
end

function Block:IsBedrockBelow()
    local isBlock, blockData = turtle.inspectDown()
    if isBlock then
        if blockData.name == "minecraft:bedrock" then
            return true
        end
    end
    return false
end

function Block:IsBedrockInFront()
    local isBlock, blockData = turtle.inspect()
    if isBlock then
        if blockData.name == "minecraft:bedrock" then
            return true
        end
    end
    return false
end

function Block:DropBlacklisted()
    local slotsHasItems = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            slotsHasItems = slotsHasItems + 1
        end
    end
    if slotsHasItems >= 15 then
        for i = 16, 1, -1 do
            local d = turtle.getItemDetail(i)
            if d then
                if d.name == "minecraft:cobblestone" then
                    if d.damage == 1 or d.damge == 2 or d.damage == 3 or d.damage == 4 then
                        turtle.select(i)
                        turtle.drop(d.count)
                    end
                else
                    if BlacklistClass:IsBlacklisted(d.name) then
                        turtle.select(i)
                        turtle.drop(d.count)
                    end
                end
            end
        end
        local slotTo = 16
        local slotReversed = 15
        while true do
            if turtle.getItemCount(slotReversed) > 0 then
                turtle.select(slotReversed)
                turtle.transferTo(slotTo)
            end
            if slotReversed ~= 1 and slotTo ~= 1 then
                slotReversed = slotReversed - 1
            elseif slotReversed == 1 and slotTo ~= 2 then
                slotTo = slotTo - 1
                slotReversed = slotTo - 1
            elseif slotTo == 2 then
                break
            end
            sleep(.05)
        end

        local invCache = {}
        for i = 1, 16 do
            invCache[i] = turtle.getItemDetail(i)
        end
        local blockCache = {}
        for i = 1, 16 do
            if invCache[i] then
                local name = invCache[i].name .. ":" .. invCache[i].damage
                if blockCache[name] then
                    blockCache[name] = blockCache[name] + invCache[i].count
                else
                    blockCache[name] = invCache[i].count
                end
            end
        end

        if blockCache["minecraft:cobblestone:0"] > 64 then
            local lastCobbleSlot = 1
            for i = 1, 16 do
                if invCache[i] then
                    if invCache[i].name == "minecraft:cobblestone" then
                        lastCobbleSlot = i
                    end
                end
            end
            for i = 1, lastCobbleSlot > 1 and lastCobbleSlot-1 or 1 do
                if invCache[i] then
                    if invCache[i].name == "minecraft:cobblestone" and i ~= lastCobbleSlot then
                        turtle.select(i)
                        turtle.drop(invCache[i].count)
                    end
                end
            end
        end
    end
    if false then
        slotsHasItems = 0
        for i = 1, 16 do
            if turtle.getItemCount(i) > 0 then
                slotsHasItems = slotsHasItems + 1
            end
        end
        if slotsHasItems >= 15 then
            Config:Update("InventoryState", "full")
        else
            Config:Update("InventoryState", "normal")
        end
    end
end

function Block:Mine(force)
    self:Get()
    self:DropBlacklisted()
    if force == true or self.Blacklisted == false then
        self.Name = ""
        self.State = {}
        self.Metadata = -1
        self.Blacklisted = false
        return turtle.dig(), force and "Forced" or nil
    else
        return false, "Blacklisted block"
    end
end

local BlockMetatable = {}

function BlockMetatable.__call(...)
    return false, "Cannot call table"
end


return setmetatable(Block, BlockMetatable)
