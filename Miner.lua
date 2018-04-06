local Miner = {}

TurtleMiner = TurtleMiner or {}
TurtleMiner.Path    = TurtleMiner.Path or "/github"

local Config = Config or loadfile(fs.combine(TurtleMiner.Path, "Config.lua"))()
Config:Init()

local Turtle = loadfile(fs.combine(TurtleMiner.Path, "Turtle.lua"))()
Turtle:Init()

local Block = loadfile(fs.combine(TurtleMiner.Path, "Block.lua"))()
Block:Init()

Config.MinerState       = Config.MinerState or "idle"

Config.Pattern = Config.Pattern or {
    X = 1,
    Z = 2,
}

Config.MinimumFuelLevel = Config.MinimumFuelLevel or 100
Config.MaximumFuelLevel = Config.MaximumFuelLevel or 500
Config.CurrentFuelLevel = turtle.getFuelLevel()
Config.ThresholdCoords  = Config.ThresholdCoords or vector.new(0, 7, 0);
Config:Save()

function Miner:Main()
    self.Running = true
    while self.Running do
        -- Check if forced termination and continue from last save.
        if Config.MinerState == "begin" then
            if not Config.MinerHasBegun then
                Config:Update("BeginCoords", vector.new(Config.X, Config.Y, Config.Z))
                Config:Update("MinerHasBegun", true)
            end
            while Config.Y >= BeginCoords.y - 2 do
                Turtle:Move("down")
            end
            Config:Update("MinerState", "begin_fillhole")
        elseif Config.MinerState == "begin_fillhole" then
            Turtle:Select("minecraft:cobblestone")
            if turtle.detectUp() then
                Turtle:Place("up")
            end
            Config:Update("MinerState", "firstToBedrock")
        elseif Config.MinerState == "firstToBedrock" then
            while not Block:IsBedrockBelow() do
                while Config.Orientation <= 3 do
                    Block:Mine()
                    Turtle:Turn()
                    if Config.Orientation == 0 then
                        break
                    end
                end
                Turtle:Move("down")
            end
            Config:Update("MinerState", "firstToUpNext")
        elseif Config.MinerState == "firstToUpNext" then
            while Config.Y < Config.ThresholdCoords.y do
                Turtle:Move("up")
            end
            Config:Update("MinerState", "firstToNextNorth")
        elseif Config.MinerState == "firstToNextNorth" then
            while Config.Z % Config.Pattern.Z > Config.Pattern.Z do
                Turtle:Move("north")
            end
            Config:Update("MinerState", "firstToNextEast")
        elseif Config.MinerState == "firstToNextEast" then
            while Config.X % Config.Pattern.X < Config.Pattern.X do
                Turtle:Move("east")
            end
            Config:Update("MinerState", "firstToTurnSecond")
        elseif Config.MinerState == "firstToTurnSecond" then
            Turtle:Turn("north")
            Config:Update("MinerState", "secondToBedrock")
        elseif Config.MinerState == "secondToBedrock" then
            while not Block:IsBedrockBelow() do
                while Config.Orientation <= 3 do
                    Block:Mine()
                    Turtle:Turn()
                    if Config.Orientation == 0 then
                        break
                    end
                end
                Turtle:Move("down")
            end
            Config:Update("MinerState", "secondToUp")
        elseif Config.MinerState == "secondToUp" then
            while Config.Y < BeginCoords.y - 2 do
                while Config.Orientation <= 3 do
                    Block:Mine()
                    Turtle:Turn()
                    if Config.Orientation == 0 then
                        break
                    end
                end
                Turtle:Move("up")
            end
            Config:Update("MinerState", "secondToUpPrepareFill")
        elseif Config.MinerState == "secondToUpPrepareFill" then
            while Config.Y < BeginCoords.y do
                Turtle:Move("up")
            end
            Config:Update("MinerState", "secondToUpFill")
        elseif Config.MinerState == "secondToUpFill" then
            Turtle:Select("minecraft:cobblestone")
            Turtle:Place("down")
            Config:Update("MinerState", "finished")
        elseif Config.MinerState == "finished" then
            self.running = false
            return true
        end

        Config:Update("MinerHasBegun", false)

        os.queueEvent("Miner_EVENT")
        os.pullEvent("Miner_EVENT")
    end
    return false
end

function Miner:GetStatus()
    Config.CurrentFuelLevel = turtle.getFuelLevel()
    return Config
end

return setmetatable(Miner, {})
