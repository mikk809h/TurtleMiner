TurtleMiner = TurtleMiner or {}

TurtleMiner.Path    = TurtleMiner.Path or "/github"

local Config = loadfile(fs.combine(TurtleMiner.Path, "Config.lua"))()
Config:Init()

local Block = loadfile(fs.combine(TurtleMiner.Path, "Block.lua"))()
Block:Init()

Config.Orientation = Config.Orientation or 0
Config.State       = Config.State or "idle"

Config.Y = Config.Y or 0
Config.X = Config.X or 0
Config.Z = Config.Z or 0

Config.Pattern = Config.Pattern or {
    X = 2,
    Z = 1,
}

Config.MinimumFuelLevel = Config.MinimumFuelLevel or 100
Config.MaximumFuelLevel = Config.MaximumFuelLevel or 500

Config:Save()

function refuel()
    if turtle.getFuelLevel() < Config.MinimumFuelLevel then
        local slot = 1
        while turtle.getFuelLevel() < Config.MaximumFuelLevel do
            turtle.select(slot)
            if turtle.refuel(0) then
                turtle.refuel(1)
            else
                slot = slot < 16 and slot + 1 or 1
                if slot == 1 then
                    os.pullEvent("turtle_inventory")
                end
            end
        end
    end
end

function moveDown()
    refuel()
    while not turtle.down() do
        if Block:IsBedrockBelow() then
            return false, "Bedrock"
        end
        turtle.digDown()
        turtle.attackDown()
        sleep(.1)
    end
    Config:Update("Y", Config.Y - 1)
end

function moveUp()
    refuel()
    while not turtle.up() do
        turtle.digUp()
        turtle.attackUp()
        sleep(.1)
    end
    Config:Update("Y", Config.Y + 1)
end

function move()
    refuel()
    while not turtle.forward() do
        turtle.dig()
        turtle.attack()
        sleep(.1)
    end
    if Config.Orientation == 0 then
        Config:Update("X", Config.X + 1)
    elseif Config.Orientation == 1 then
        Config:Update("Z", Config.Z + 1)
    elseif Config.Orientation == 2 then
        Config:Update("X", Config.X - 1)
    elseif Config.Orientation == 3 then
        Config:Update("Z", Config.Z - 1)
    end
end

function moveBack()
    refuel()
    turtle.back()
end

function turnRight()
    turtle.turnRight()
    Config:Update("Orientation", Config.Orientation < 3 and Config.Orientation + 1 or 0)
end

function turnLeft()
    turtle.turnLeft()
    Config:Update("Orientation", Config.Orientation > 0 and Config.Orientation - 1 or 3)
end


function main()
    if Config.State == "idle" then
        while Config.Y > -2 do
            moveDown()
        end
        Config:Update("State", "down")
        return true
    elseif Config.State == "down" then
        while not Block:IsBedrockBelow() do
            while Config.Orientation <= 3 do
                Block:Mine()
                turnRight()
                if Config.Orientation == 0 then
                    break
                end
            end
            moveDown()
        end
        Config:Update("State", "up")
        return true
    elseif Config.State == "up" then
        while Config.Y < 0 do
            moveUp()
        end
        Config:Update("State", "to move")
        return true
    elseif Config.State == "to move" then
        for i = 1, 16 do turtle.select(i) turtle.placeDown() end
        Config:Update("State", "moving X")
        return true
    elseif Config.State == "moving X" then
        while Config.Orientation ~= 0 do
            turnRight()
        end
        local toMoveX = Config.Pattern.X - Config.X
        while toMoveX > 0 do
            move()
            toMoveX = toMoveX - 1
        end
        while Config.Orientation ~= 1 do
            turnRight()
        end
        Config:Update("X", 0)
        Config:Update("State", "moving Z")
        return true
    elseif Config.State == "moving Z" then
        local toMoveZ = Config.Pattern.Z - Config.Z
        while toMoveZ > 0 do
            move()
            toMoveZ = toMoveZ - 1
        end
        while Config.Orientation ~= 0 do
            turnLeft()
        end

        Config:Update("Z", 0)
        Config:Update("State", "idle")
        return true
    end
end

parallel.waitForAny(
    function()
        while main() do sleep(2.5) end
    end, function()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print(textutils.serialize(Config.Config))
        sleep(1)
    end
    end
)
