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
Config.MaximumFuelLevel = Config.MaximumFuelLevel or 1000

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
    while turtle.detect() do
        turtle.dig()
        sleep(1)
    end
    turtle.forward()
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
        moveDown()
        moveDown()
        Config:Update("State", "down")
        return true
    elseif Config.State == "down" then
        while not Block:IsBedrockBelow() do
            print("Orientation " .. Config.Orientation)
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
        local toMoveX = Config.Pattern.X - Config.X

        while toMoveX > 0 do
            move()
            toMoveX = toMoveX - 1
        end
        turnRight()
        Config:Update("State", "moving Z")
        return true
    elseif Config.State == "moving Z" then
        print("MOVING Z")
        print("ORIENTATION: " .. Config.Orientation)
        local toMoveZ = Config.Pattern.Z - Config.Z

        while toMoveZ > 0 do
            move()
            toMoveZ = toMoveZ - 1
        end
        while Config.Orientation ~= 0 do
            turnLeft()
        end
        Config:Update("State", "idle")
        return true
    end
end


while main() do sleep(2.5) end
