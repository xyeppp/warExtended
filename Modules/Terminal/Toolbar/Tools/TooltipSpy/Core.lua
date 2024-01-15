local warExtended      = warExtended
local WINDOW_NAME      = "TerminalTooltipSpy"
local TOOL_NAME        = L"Tooltip Spy"
local TOOL_DESCRIPTION = L"Intercepts tooltip creations to display hidden data about the tooltipped object."

TerminalTooltipSpy     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, 13322, nil, { selectedTab=false })

local function tooltipHook(tooltipData)
  TerminalTooltipSpy:SetObjectData(tooltipData)
end

local function setTooltipHooks()
  local originalActionButtonOnMouseOver = ActionButton.OnMouseOver

  warExtended:Hook(Tooltips.CreateAbilityTooltip, tooltipHook, true)
  warExtended:Hook(Tooltips.CreateItemTooltip, tooltipHook, true)
  warExtended:Hook(Tooltips.CreateMacroTooltip, tooltipHook, true)
  warExtended:Hook(Tooltips.CreateTradeskillTooltip, tooltipHook, true)
  warExtended:Hook(Tooltips.CreateCustomItemTooltip, tooltipHook, true)

  ActionButton.OnMouseOver = function (buttonData, flags, x, y)
    TerminalTooltipSpy:SetActionButtonData(buttonData)
    originalActionButtonOnMouseOver(buttonData, flags, x, y)
  end

  warExtended:RegisterGameEvent({ "player target updated" }, "TerminalTooltipSpy.OnUpdateTarget")
end

function TerminalTooltipSpy.OnInitialize()
 -- warExtended:AddEventHandler("SetTooltipSpyHook", "CoreInitialized", setTooltipHooks)
  setTooltipHooks()

end

function TerminalTooltipSpy.OnUpdateTarget(targetClassification, entityId, _)
  if targetClassification ~= "mouseovertarget" or entityId == 0 then
	return
  end

  local targetData = warExtended:GetTargetData(targetClassification)
  TerminalTooltipSpy:SetObjectData(targetData)
end
