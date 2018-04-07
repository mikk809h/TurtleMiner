local Turtle = {}

TurtleMiner = TurtleMiner or {}
TurtleMiner.Path    = TurtleMiner.Path or "/github"

Turtle.TurtleLog = loadfile(fs.combine(TurtleMiner.Path, "TurtleLog.lua"))()
Config = Config or nil

if not Config then
    Config = loadfile(fs.combine(TurtleMiner.Path, "Config.lua"))()
    Config:Init()
end

Config.Orientation = Config.Orientation or 0

Config.Y = Config.Y or 0
Config.X = Config.X or 0
Config.Z = Config.Z or 0
Config.IsGPSEnabled = Config.IsGPSEnabled or false

Config.TurtleLog = Config.TurtleLog or {}

Config.MinimumFuelLevel = Config.MinimumFuelLevel or 75
Config.MaximumFuelLevel = Config.MaximumFuelLevel or 250
Config.CurrentFuelLevel = turtle.getFuelLevel()
Turtle.TurtleLog:Set(Config.TurtleLog)

local Orientations = {
    [0] = "north",
    [1] = "east",
    [2] = "south",
    [3] = "west"
}

function Turtle:Init()
    sleep(1.5) -- To secure correct modem initialization
    local modem = peripheral.find("modem", function(n, o) return o.isWireless() end)
    if modem then
        if gps.locate(2) then
            Config:Update("IsGPSEnabled", true)
        end
    else
        Config:Update("IsGPSEnabled", false)
    end
end

function Turtle:Move(direction, amount)
    amount = amount or 1
    for i = 1, amount do
        self:Refuel()
        if direction == "up" then
            while not turtle.up() do
                turtle.digUp()
                turtle.attackUp()
                sleep(.5)
            end
            Config:Update("Y", Config.Y + 1)
            self.TurtleLog:Add({Config.Orientation, "up"})
        elseif direction == "down" then
            while not turtle.down() do
                turtle.digDown()
                turtle.attackDown()
                sleep(.5)
            end
            Config:Update("Y", Config.Y - 1)
            self.TurtleLog:Add({Config.Orientation, "down"})
        elseif direction == "north" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("Z", Config.Z - 1)
            self.TurtleLog:Add({Config.Orientation, "north"})
        elseif direction == "south" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("Z", Config.Z + 1)
            self.TurtleLog:Add({Config.Orientation, "south"})
        elseif direction == "east" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("X", Config.X + 1)
            self.TurtleLog:Add({Config.Orientation, "east"})
        elseif direction == "west" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("X", Config.X - 1)
            self.TurtleLog:Add({Config.Orientation, "west"})
        elseif direction == "back" then
            while not turtle.back() do
                turtle.turnRight()
                turtle.turnRight()
                turtle.dig()
                turtle.attack()
                turtle.turnRight()
                turtle.turnRight()
                sleep(.5)
            end
            if Config.Orientation == 0 or Config.Orientation == 2 then
                Config:Update("Z", Config.Orientation == 0 and Config.Z + 1 or Config.Z - 1)
                self.TurtleLog:Add({Config.Orientation, Config.Orientation == 0 and "north" or "south"})
            elseif Config.Orientation == 1 or Config.Orientation == 3 then
                Config:Update("X", Config.Orientation == 1 and Config.X - 1 or Config.X + 1)
                self.TurtleLog:Add({Config.Orientation, Config.Orientation == 1 and "east" or "west"})
            end
        else
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            if Config.Orientation == 0 or Config.Orientation == 2 then
                Config:Update("Z", Config.Orientation == 0 and Config.Z - 1 or Config.Z + 1)
                self.TurtleLog:Add({Config.Orientation, Config.Orientation == 0 and "north" or "south"})
            elseif Config.Orientation == 1 or Config.Orientation == 3 then
                Config:Update("X", Config.Orientation == 1 and Config.X + 1 or Config.X - 1)
                self.TurtleLog:Add({Config.Orientation, Config.Orientation == 1 and "east" or "west"})
            end
        end
    end
end

function Turtle:Turn(direction)
    if type(direction) == "string" then
        while (direction == "north" and Config.Orientation ~= 0) or (direction == "east" and Config.Orientation ~= 1) or (direction == "south" and Config.Orientation ~= 2) or (direction == "west" and Config.Orientation ~= 3) do
            turtle.turnRight()
            Config:Update("Orientation", (Config.Orientation + 1) % 4)
            self.TurtleLog:Add({Config.Orientation, direction, "turn", Orientations[(Config.Orientation - 1) % 4]})
        end
    elseif direction == nil then
        turtle.turnRight()
        Config:Update("Orientation", (Config.Orientation + 1) % 4)
        self.TurtleLog:Add({Config.Orientation, Orientations[Config.Orientation], "turn", Orientations[(Config.Orientation - 1) % 4]})
    end
end

function Turtle:MoveUnlogged(direction, amount)
    amount = amount or 1
    for i = 1, amount do
        self:Refuel()
        if direction == "up" then
            while not turtle.up() do
                turtle.digUp()
                turtle.attackUp()
                sleep(.5)
            end
            Config:Update("Y", Config.Y + 1)
        elseif direction == "down" then
            while not turtle.down() do
                turtle.digDown()
                turtle.attackDown()
                sleep(.5)
            end
            Config:Update("Y", Config.Y - 1)
        elseif direction == "north" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("Z", Config.Z - 1)
        elseif direction == "south" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("Z", Config.Z + 1)
        elseif direction == "east" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("X", Config.X + 1)
        elseif direction == "west" then
            self:Turn(direction)
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            Config:Update("X", Config.X - 1)
        elseif direction == "back" then
            while not turtle.back() do
                turtle.turnRight()
                turtle.turnRight()
                turtle.dig()
                turtle.attack()
                turtle.turnRight()
                turtle.turnRight()
                sleep(.5)
            end
            if Config.Orientation == 0 or Config.Orientation == 2 then
                Config:Update("Z", Config.Orientation == 0 and Config.Z + 1 or Config.Z - 1)
            elseif Config.Orientation == 1 or Config.Orientation == 3 then
                Config:Update("X", Config.Orientation == 1 and Config.X - 1 or Config.X + 1)
            end
        else
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(.5)
            end
            if Config.Orientation == 0 or Config.Orientation == 2 then
                Config:Update("Z", Config.Orientation == 0 and Config.Z - 1 or Config.Z + 1)
            elseif Config.Orientation == 1 or Config.Orientation == 3 then
                Config:Update("X", Config.Orientation == 1 and Config.X + 1 or Config.X - 1)
            end
        end
    end
end

function Turtle:TurnUnlogged(direction)
    if type(direction) == "string" then
        while (direction == "north" and Config.Orientation ~= 0) or (direction == "east" and Config.Orientation ~= 1) or (direction == "south" and Config.Orientation ~= 2) or (direction == "west" and Config.Orientation ~= 3) do
            turtle.turnRight()
            Config:Update("Orientation", (Config.Orientation + 1) % 4)
        end
    elseif direction == nil then
        turtle.turnRight()
        Config:Update("Orientation", (Config.Orientation + 1) % 4)
    end
end

--[[
    Selects either a slot, or the first occurance of the item name (e.g. "minecraft:stone")
    If no item name is found, no slot is selected and returns false
    @returns true|false
]]
function Turtle:Select(slot)
    if type(slot) == "string" then
        for i = 1, 16 do
            if turtle.getItemCount(i) > 0 then
                local info = turtle.getItemDetail(i)
                if info.name == slot then
                    turtle.select(i)
                    return true
                end
            end
        end
        return false
    elseif type(slot) == "number" then
        if slot >= 0 and slot <= 16 then
            turtle.select(slot)
            return true
        end
        return false
    end
end

function Turtle:Place(direction, force)
    self:Turn(direction)
    if direction == "up" then
        while not turtle.placeUp() do
            turtle.digUp()
            turtle.attackUp()
            sleep(.5)
        end
    elseif direction == "down" then
        while not turtle.placeDown() do
            turtle.digDown()
            turtle.attackDown()
            sleep(.5)
        end
    else
        while not turtle.place() do
            turtle.dig()
            turtle.attack()
            sleep(.5)
        end
    end
end

function Turtle:Dig(direction)
    self:Turn(direction)
    if direction == "up" then
        if turtle.detectUp() then
            while not turtle.digUp() do
                turtle.attackUp()
                sleep(.5)
            end
        end
    elseif direction == "down" then
        if turtle.detectDown() then
            while not turtle.digDown() do
                turtle.attackDown()
                sleep(.5)
            end
        end
    else
        if turtle.detect() then
            while not turtle.dig() do
                turtle.attack()
                sleep(.5)
            end
        end
    end
end

local opposites = {
    up = "down",
    down = "up",
    north = "south",
    east = "west",
    south = "north",
    west = "east"
}

function Turtle:UndoLastMove()
    local lastAction = self.TurtleLog:GetLast()
    if lastAction then
        local undoCommand = opposites[lastAction[2]]
        if lastAction[3] == "turn" then
            self:TurnUnlogged(lastAction[4])
        else
            self:MoveUnlogged(undoCommand)
        end
        self.TurtleLog:Remove()
    end
end

function Turtle:Locate()
    if Config.IsGPSEnabled then
        local x,y,z = gps.locate(2)
        self:MoveUnlogged()
        local nx,ny,nz = gps.locate(2)
        self:MoveUnlogged("back")

        if (nz < z) then
            Config:Update("Orientation", 0)
        elseif nx > x then
            Config:Update("Orientation", 1)
        elseif nz > z then
            Config:Update("Orientation", 2)
        elseif nx < x then
            Config:Update("Orientation", 3)
        end

        Config:Update("X", x)
        Config:Update("Y", y)
        Config:Update("Z", z)
        Config:Update("GPSLocated", true)
        return {X = Config.X, Y = Config.Y, Z = Config.Z, Orientation = Config.Orientation}
    else
        return {X = Config.X, Y = Config.Y, Z = Config.Z, Orientation = Config.Orientation}
    end
end

function Turtle:VerifyLocation()
    local didLocate, vy, vz, vx = gps.locate(2)
    if didLocate ~= nil then
        vx = didLocate
        local currentPosition = vector.new(vx, vy, vz)
        if currentPosition.x ~= Config.X or currentPosition.y ~= Config.Y or currentPosition.z ~= Config.Z then
            self:Locate()
        end
        return true
    end
    return false
end

--[[
    @params tbl { X = int x, Y = int y, Z = int z(, Orientation = int orientation) }
]]
function Turtle:Goto(goal)
    local begin = { X = Config.X, Y = Config.Y, Z = Config.Z, Orientation = Config.Orientation }
    local beginVector = vector.new(begin.X, begin.Y, begin.Z)
    local goalVector = vector.new(goal.X, goal.Y, goal.Z)
    local diffVector = goalVector - beginVector

    if diffVector.y > 0 then
        self:Move("up", diffVector.y)
    elseif diffVector.y < 0 then
        self:Move("down", -diffVector.y)
    end

    if diffVector.x > 0 then
        self:Move("west", diffVector.x)
    elseif diffVector.x < 0 then
        self:Move("east", -diffVector.x)
    end

    if diffVector.z > 0 then
        self:Move("south", diffVector.z)
    elseif diffVector.z < 0 then
        self:Move("north", -diffVector.z)
    end

    if goal.Orientation then
        self:Turn(Orientations[goal.Orientation])
    end
end

function Turtle:Refuel()
    Config:Update("CurrentFuelLevel", turtle.getFuelLevel())
    if turtle.getFuelLevel() < Config.MinimumFuelLevel then
        local slot = 1
        while turtle.getFuelLevel() < Config.MaximumFuelLevel do
            turtle.select(slot)
            if turtle.refuel(0) then
                turtle.refuel(1)
            else
                slot = (slot % 16) + 1
                if slot == 1 then
                    os.pullEvent("turtle_inventory")
                end
            end
        end
    end
    turtle.select(1)
    Config:Update("CurrentFuelLevel", turtle.getFuelLevel())
end


local mt = {}

function mt.__index(t, k)

end

function mt.__newindex(t, k, v)

end

return setmetatable(Turtle, mt)
