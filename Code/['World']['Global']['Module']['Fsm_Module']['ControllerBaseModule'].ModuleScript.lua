--- 状态机控制器基类
-- @module ControllerBase
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local ControllerBase = class('ControllerBase')

function ControllerBase:initialize(_stateMachineNode, _folder)
    self.machine = _stateMachineNode
    self.states = {}
    self.lastState = nil
    self.curState = nil
    self:ConnectStates(self, _folder)
end

--绑定所有状态
function ControllerBase:ConnectStates(_controller, _folder)
    for _, module in pairs(_folder:GetChildren()) do
        if module.ClassName == 'ModuleScriptObject' then
            local tempStateClass = require(module)
            local stateModule = tempStateClass:new(_controller, module.Name)
            local stateInMachine = self.machine:CreateState(module.Name)
            self.states[module.Name] = stateModule
            stateInMachine.OnEnter:Connect(
                function()
                    stateModule:OnEnter()
                end
            )
            stateInMachine.OnUpdate:Connect(
                function()
                    stateModule:OnUpdate()
                end
            )
            stateInMachine.OnExit:Connect(
                function()
                    stateModule:OnLeave()
                end
            )
        end
    end
    for _, state in pairs(self.states) do
        state:InitData()
    end
end

--初始化默认状态
function ControllerBase:SetDefState(_stateName)
    self.machine:SetDefaultState(self.machine:GetState(_stateName))
    self.curState = self.states[_stateName]
    self.machine:Play()
end

--切换状态
function ControllerBase:Switch(_state)
    if _state then
        self.lastState = self.curState
        self.machine:GotoState(self.machine:GetState(_state.stateName))
        self.curState = _state
    end
end

function ControllerBase:Update(dt)
    if self.curState then
        self:Switch(self.curState:TransUpdate(dt))
        for k, v in pairs(self.states) do
            v:AnyStateCheck()
        end
    end
end

return ControllerBase
