local TerminalTextureViewer = TerminalTextureViewer
local WINDOW_NAME           = "TerminalTextureViewer"
local ICONS_FRAME           = 1
local TEXTURES_FRAME        = 2
local TAB_GROUP             = 3
local TITLEBAR              = 4

local WINDOW                = Frame:Subclass(WINDOW_NAME)

--TODO fix tabgroup to be independent

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  
  self.m_Windows            = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[TAB_GROUP] = TabGroup:Create(WINDOW_NAME .. "Tab", TerminalTextureViewer:GetSavedSettings()),
	[ICONS_FRAME] = TerminalTextureViewer.CreateIconsFrame()
  }
  
  self.m_Windows[TAB_GROUP] = {
	[ICONS_FRAME] = self.m_Windows[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabIcons", WINDOW_NAME .. "Icons", "Icons", "Icon Selection"),
	[TEXTURES_FRAME] = self.m_Windows[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabTextures", WINDOW_NAME .. "Textures", "Textures", "Texture Selection"),
  }
  
  self.m_Windows[TITLEBAR]:SetText(L"Texture Viewer")
end

WINDOW:Create()