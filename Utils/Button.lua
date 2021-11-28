local warExtended = warExtended
local ButtonGetPressedFlag = ButtonGetPressedFlag
local ButtonSetPressedFlag = ButtonSetPressedFlag


function warExtended:IsButtonPressed(buttonName)
  local isPressed = ButtonGetPressedFlag(buttonName)
  return isPressed
end

function warExtended:SetButtonPressed(buttonName)
  ButtonSetPressedFlag(buttonName)
end