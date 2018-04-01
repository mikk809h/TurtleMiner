local Blacklist = {}

local Blacklist.rawBlacklist = {
    "cobblestone", "stone", "gravel", "dirt", "grass", "sand", "planks", "log"
}

function Blacklist:IsBlacklisted(input)
    for k,v in pairs(self.rawBlacklist) do
        if string.find(input, v) then
            return true
        end
    end
    return false
end

return setmetatable(_ENV, Blacklist)
