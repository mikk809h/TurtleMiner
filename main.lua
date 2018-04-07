TurtleMiner = TurtleMiner or {}
TurtleMiner.Path    = TurtleMiner.Path or "/github"

local Miner = loadfile(fs.combine(TurtleMiner.Path, "Miner.lua"))()

print("Running...")
function newMain()
    local ok, err = pcall(Miner:Main)
    

    parallel.waitForAny(function()
        print("Begun")
        Miner:Main()
    end, function()
        while true do
            print("UPDATE")
            rednet.broadcast(textutils.serialize(Miner:GetStatus()))
            sleep(10)
        end
    end)
end

newMain()
--while main() do sleep(1.5) end
