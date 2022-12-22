local warExtended             = warExtended
local warExtendedTerminal     = warExtendedTerminal
local TOOLBAR_WINDOW          = "DebugWindowToolbar"
local TOOLBAR_BUTTON_TEMPLATE = "DebugWindowToolbarButton"
local DEBUG_WINDOW            = "DebugWindow"

TerminalToolbar               = warExtended.Register("warExtended Terminal Toolbar")
local TOOLBAR_FRAME           = Frame:CreateFrameForExistingWindow(TOOLBAR_WINDOW)
local MOD_BUTTON              = ButtonFrame:Subclass(TOOLBAR_BUTTON_TEMPLATE)
local REGISTER_QUEUE          = Queue:Create()

function TOOLBAR_FRAME:Create()
  TerminalToolbar:Hook(warExtendedTerminal.OnShown, TOOLBAR_FRAME.OnShown, true)
  TerminalToolbar:Hook(warExtendedTerminal.OnHidden, TOOLBAR_FRAME.OnHidden, true)
  
  self:ProcessQueue()
  self:Resize()
  self:Show(WindowGetShowing(DEBUG_WINDOW))
end

function TOOLBAR_FRAME.OnShown()
  TOOLBAR_FRAME:Show(true)
end

function TOOLBAR_FRAME.OnHidden()
  TOOLBAR_FRAME:Show(false)
end

function TOOLBAR_FRAME:ProcessQueue()
  for index = REGISTER_QUEUE:Begin(), REGISTER_QUEUE:End()
  do
    local module=REGISTER_QUEUE[index]
    
    if index == 0 then
      module:SetAnchor({ Point = "topleft", RelativeTo = self:GetName(), RelativePoint = "topleft", XOffset = 5, YOffset = 5 })
    else
      module:SetAnchor({ Point = "right", RelativeTo = self.m_Windows[module:GetId()-1]:GetName(), RelativePoint = "left", XOffset = 2, YOffset = 0 })
    end
    
    module:SetParent(TOOLBAR_WINDOW)
  end
  
  REGISTER_QUEUE = nil
end

function TOOLBAR_FRAME:AddTool(name, description, activationFunction, icon, settings)
  local toolData = MOD_BUTTON:Create(name, description, activationFunction, icon, settings)
  self.m_Windows[toolData:GetId()] = toolData
  return toolData
end

function TOOLBAR_FRAME:RegisterTool(name, description, activationFunction, icon, settings, savedSettings)
  local modData = self:AddTool(name, description, activationFunction, icon, settings)
  local newMod  = setmetatable({}, { __index = modData })
  
  if savedSettings ~= nil and modData:GetSavedSettings() == nil then
	if not warExtendedTerminal.Settings.Toolbar[modData.m_Activator] then
	  warExtendedTerminal.Settings.Toolbar[modData.m_Activator] = {}
	end
    warExtended:ExtendTable(warExtendedTerminal.Settings.Toolbar[self.m_Activator], savedSettings)
  end

  return newMod
end

function TOOLBAR_FRAME:GetRegisteredModulesCount()
  if not self.m_Windows then
    self.m_Windows = {}
  end
  
  return #self.m_Windows
end


function TOOLBAR_FRAME:Resize()
  
  local width           = 0
  local height          = 0
  local numColumns      = 1
  local numRows         = 1
  local border          = 5 * 2
  local horizontalPad   = 2 * (numColumns - 1)
  local verticalPad     = 2 * 0 -- only one row for now...
  local buttonWidth     = 42
  local buttonHeight    = 42
  local fudgeHeight     = 5
  
  numColumns   = #self.m_Windows
  
  local button = self.m_Windows[next(self.m_Windows)]
  
  if (button)
  then
	buttonWidth, buttonHeight = button:GetDimensions()
  end
  
  width  = (numColumns * buttonWidth) + horizontalPad + border
  height = (numRows * buttonHeight) + verticalPad + border + fudgeHeight

  WindowSetDimensions(TOOLBAR_WINDOW,width, height)
end


--MOD BUTTON--

function MOD_BUTTON:Create(name, description, activationFunction, iconNum, settings)
  local id              = TOOLBAR_FRAME:GetRegisteredModulesCount()+1
  local module          = self:CreateFromTemplate(TOOLBAR_BUTTON_TEMPLATE .. id)
  
  REGISTER_QUEUE:PushBack(module)
  
  module.m_Icon         = DynamicImage:CreateFrameForExistingWindow(module:GetName() .. "IconBase")
  module.m_Icon.iconNum = iconNum
  module.m_Tool         = name
  module.m_Description  = description
  module.m_Activator    = activationFunction
  module.m_Settings     = settings
  module.m_Id           = id
  
  module.m_Icon:SetTexture(GetIconData(module.m_Icon.iconNum))
  module:Show(true)
  
  return module
end

function MOD_BUTTON:OnMouseOver()
  warExtended:CreateTextTooltip(
		  self:GetName(), {
			[1] = { { text = self.m_Tool, color = Tooltips.COLOR_HEADING } },
			[2] = { { text = self.m_Description } }
		  },
		  nil,
		  { Point = "topleft", RelativeTo = self:GetName(), RelativePoint = "bottomleft", XOffset = 0, YOffset = -10 }
  )
end

function MOD_BUTTON:GetSettings()
  return self.m_Settings
end

function MOD_BUTTON:GetSavedSettings()
  return warExtendedTerminal.Settings.Toolbar[self.m_Activator]
end

function MOD_BUTTON:CallActivator()
  if (type(self.m_Activator) == "string")
  then
	WindowSetShowing(self.m_Activator, not WindowGetShowing(self.m_Activator))
  elseif (type(self.m_Activator) == "function")
  then
	self.m_Activator()
  else
	warExtendedTerminal.ConsoleLog(L "Unable to call activator for [" .. self.m_Tool .. L "]")
  end
end

function MOD_BUTTON:OnLButtonUp()
  self:CallActivator()
end

function MOD_BUTTON:SetTexture()
  self.m_Icon:SetTexture(GetIconData(self.m_Icon.iconNum))
end

----- END OF MOD -------


-- CORE --

function TerminalToolbar:RegisterTool(name, desc, activationFunc, icon, settings, savedSettings)
  return TOOLBAR_FRAME:RegisterTool(name, desc, activationFunc, icon, settings, savedSettings)
end

function TerminalToolbar.Toggle()
  TOOLBAR_FRAME:Show(not TOOLBAR_FRAME:IsShowing())
end

TOOLBAR_FRAME:RegisterTool(L"Reload UI", L"Reloads the interface.", InterfaceCore.ReloadUI, 13321)
TOOLBAR_FRAME:RegisterTool(L"Toggle UI Logging", L"Enables logging messages to the terminal.", warExtendedTerminal.ToggleLogging, 00922)

function TerminalToolbar.OnInitialize()
  TOOLBAR_FRAME:Create()
end

-- CORE --


