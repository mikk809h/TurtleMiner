local TurtleLog = {}
TurtleLog.RawLog = {}

function TurtleLog:Set(tbl)
    self.RawLog = tbl
end

function TurtleLog:Add(tbl)
    local newLog = {}
    newLog[1] = tbl
    for i = 1, #self.RawLog do
        newLog[i+1] = self.RawLog[i]
    end
    self.RawLog = newLog
end

--[[ Remove: Removes first index (last log/last move)]]
function TurtleLog:Remove()
    local newLog = {}
    self.RawLog[1] = nil
    for i, v in pairs(self.RawLog) do
        newLog[i-1] = v
    end
    self.RawLog = newLog
end

function TurtleLog:GetLast()
    return self.RawLog[1]
end

return setmetatable(TurtleLog, {})
