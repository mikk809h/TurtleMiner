TurtleMiner = TurtleMiner or {}
TurtleMiner.Path    = TurtleMiner.Path or "/github"

local Miner = loadfile(fs.combine(TurtleMiner.Path, "Miner.lua"))()
if not Miner then
    printError("Miner failed to load")
    return false
end

sleep(.05)
for k, v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "modem" then
        rednet.open(v)
    end
end


print("Running...")
function miner()
    local ok, err = pcall(function()
        print("Begun")
        Miner:Main()
    end)

    if not ok then
        printError(tostring(err))
        rednet.broadcast(textutils.serialize({tError = tostring(err), position = gps.locate(2)}))
    end
end

parallel.waitForAny(miner, function()
    while true do
        rednet.broadcast(textutils.serialize(Miner:GetStatus()))
        sleep(2)
    end
end)
