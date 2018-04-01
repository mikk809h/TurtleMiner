TurtleMiner = TurtleMiner or {}

TurtleMiner.Path        = TurtleMiner.Path or "/github",
TurtleMiner.Orientation = TurtleMiner.Orientation or 0,
TurtleMiner.State       = TurtleMiner.State or "idle",

TurtleMiner.Y = TurtleMiner.Y or 0,
TurtleMiner.X = TurtleMiner.X or 0,
TurtleMiner.Z = TurtleMiner.Z or 0,

TurtleMiner.Pattern     = TurtleMiner.Pattern or {
    X = 2,
    Z = 1,
},


local Block = loadfile(fs.combine(TurtleMiner.Path, "Block.lua"))()
Block:Init()

--[[
SETUP
]]
if fs.exists(fs.combine(TurtleMiner.Path, ".turtleminercfg")) then
    local cfg = fs.open(fs.combine(TurtleMiner.Path, ".turtleminercfg"), "r")

    TurtleMiner = textutils.unserialize(cfg.readAll())

    cfg.close()
end

--[[
Initialization
]]

if TurtleMiner.State == "idle" then

elseif TurtleMiner.State == "down" then

elseif TurtleMiner.State == "up" then

elseif TurtleMiner.State == "moving next" then

end
