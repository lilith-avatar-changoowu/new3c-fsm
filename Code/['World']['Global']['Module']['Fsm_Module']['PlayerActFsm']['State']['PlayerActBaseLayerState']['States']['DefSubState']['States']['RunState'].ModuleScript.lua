local RunState = class('RunState', PlayerActState)

function RunState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer.Avatar:PlayAnimation('RunFront', 2, 1, 0.1, true, true, 1)
end

function RunState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:IdleMonitor()
    self:WalkMonitor()
end
function RunState:OnLeave()
    PlayerActState.OnLeave(self)
end

return RunState