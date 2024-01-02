local ButtonFrame = ButtonFrame
local ButtonSetStayDownFlag = ButtonSetStayDownFlag
local ButtonGetDisabledFlag = ButtonGetDisabledFlag
local ButtonGetPressedFlag = ButtonGetPressedFlag
local ButtonSetDisabledFlag = ButtonSetDisabledFlag

function ButtonFrame:SetStayDownFlag(flag)
    ButtonSetStayDownFlag(self:GetName(), flag)
end

function ButtonFrame:IsDisabled()
    local isDisabled = ButtonGetDisabledFlag(self:GetName())
    return isDisabled
end

function ButtonFrame:IsPressed()
    return self.m_IsPressed or ButtonGetPressedFlag(self:GetName())
end

function ButtonFrame:SetDisabled(flag)
    ButtonSetDisabledFlag(self:GetName(), flag)
end
