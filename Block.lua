local Block = {}

Block.Name = ""
Block.State = {}
Block.Metadata = 0

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
        Block = {}
        self = Block
        return false
    end
end

function Block:Get()
    local isblock, blockData = turtle.inspect()

end

local BlockMetatable = {}

function BlockMetatable.__call(...)
    return false, "Cannot call table"
end


return setmetatable(Block, BlockMetatable)
