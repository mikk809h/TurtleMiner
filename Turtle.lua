local Turtle = {}

local Config = Config or nil

if not Config then
    Config = loadfile(fs.combine(TurtleMiner.Path, "Config.lua"))()
    Config:Init()
end
Config.Orientation = Config.Orientation or 0

Config.Y = Config.Y or 0
Config.X = Config.X or 0
Config.Z = Config.Z or 0

function Turtle:Move(arg, direction)
    if not self then
        self = Turtle
    else
        direction = arg
    end

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
        Config:Update("X", Config.X + 1)
    elseif direction == "east" then
        self:Turn(direction)
        while not turtle.forward() do
            turtle.dig()
            turtle.attack()
            sleep(.5)
        end
        Config:Update("Z", Config.Z + 1)
    elseif direction == "south" then
        self:Turn(direction)
        while not turtle.forward() do
            turtle.dig()
            turtle.attack()
            sleep(.5)
        end
        Config:Update("X", Config.X - 1)
    elseif direction == "west" then
        self:Turn(direction)
        while not turtle.forward() do
            turtle.dig()
            turtle.attack()
            sleep(.5)
        end
        Config:Update("Z", Config.Z - 1)
    else
        return false, "Direction " .. direction .. " invalid!"
    end
end

function Turtle:Turn(arg, direction)
    if not self then
        self = Turtle
    else
        direction = arg
    end

    if direction == "north" then
        if Config.Orientation > 0 and Config.Orientation <= 2 then
            repeat
                turtle.turnLeft()
                Config:Update("Orientation", Config.Orientation - 1)
            until Config.Orientation == 0
        elseif Config.Orientation == 3 then
            turtle.turnRight()
            Config:Update("Orientation", 0)
        end
    elseif direction == "east" then
        if Config.Orientation > 1 and Config.Orientation <= 3 then
            repeat
                turtle.turnLeft()
                Config:Update("Orientation", Config.Orientation - 1)
            until Config.Orientation == 1
        elseif Config.Orientation == 0 then
            turtle.turnRight()
            Config:Update("Orientation", 1)
        end
    elseif direction == "south" then
        if Config.Orientation >= 0 and Config.Orientation <= 1 then
            repeat
                turtle.turnRight()
                Config:Update("Orientation", Config.Orientation + 1)
            until Config.Orientation == 2
        elseif Config.Orientation == 3 then
            turtle.turnLeft()
            Config:Update("Orientation", 2)
        end

    elseif direction == "west" then
        if Config.Orientation > 0 and Config.Orientation <= 2 then
            repeat
                turtle.turnRight()
                Config:Update("Orientation", Config.Orientation + 1)
            until Config.Orientation == 3
        elseif Config.Orientation == 0 then
            turtle.turnLeft()
            Config:Update("Orientation", 3)
        end
    else
        return false, "Direction " .. direction .. " invalid!"
    end
end


local mt = {}

function mt.__index(t, k)

end

function mt.__newindex(t, k, v)

end

return setmetatable(Turtle, mt)
