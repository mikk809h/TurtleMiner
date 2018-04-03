local Blacklist = {}
Blacklist.rawBlacklist = {
    "minecraft:cobblestone", "minecraft:stone", "minecraft:gravel", "minecraft:dirt", "minecraft:grass", "minecraft:sand", "minecraft:planks", "minecraft:log", "minecraft:bedrock"
}

function Blacklist:IsBlacklisted(input)
    for k,v in pairs(self.rawBlacklist) do
        if input == v then
            return true
        end
    end
    return false
end

return setmetatable(Blacklist, _ENV)
