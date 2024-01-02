local warExtended = warExtended
local SystemData = SystemData

function warExtended:GetMousePosition()
  local x, y = SystemData.MousePosition.x, SystemData.MousePosition.y
  return x, y
end

function warExtended:SetCursor(id)
  if not id then
    ClearCursor()
    return
  end
  
  SetHardwareCursor(id)
end




---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by rumpe.
--- DateTime: 23/02/2023 01:08
---