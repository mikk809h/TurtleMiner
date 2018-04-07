TurtleMiner = TurtleMiner or {}
TurtleMiner.Path    = TurtleMiner.Path or "/github"

local Miner = loadfile(fs.combine(TurtleMiner.Path, "Miner.lua"))()

print("Running...")
function miner()
    local ok, err = pcall(function()
        print("Begun")
        Miner:Main()
    end)

    if not ok then
        printError(tostring(err))
    end
end

parallel.waitForAny(miner, function()
    while true do
        rednet.broadcast(textutils.serialize(Miner:GetStatus()))
        sleep(2)
    end
end)

newMain()
--while main() do sleep(1.5) end
