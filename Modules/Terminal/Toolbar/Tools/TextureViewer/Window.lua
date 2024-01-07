local TerminalTextureViewer = TerminalTextureViewer
local WINDOW_NAME           = "TerminalTextureViewer"
local ICONS_FRAME           = 1
local TEXTURES_FRAME        = 2
local TAB_GROUP             = 3
local TITLEBAR              = 4
local RESIZE_BUTTON 		= 5

local WINDOW                = Frame:Subclass(WINDOW_NAME)
local RESIZE_FRAME			= ButtonFrame:Subclass(WINDOW_NAME.."ResizeButton")

--TODO fix tabgroup to be independent class; move window into core

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  
  self.m_Windows            = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[TAB_GROUP] = TabGroup:Create(WINDOW_NAME .. "Tab", TerminalTextureViewer:GetSavedSettings()),
	[ICONS_FRAME] = TerminalTextureViewer.CreateIconsFrame(),
	[ICONS_FRAME] = TEXTURE_FRAME:Create(),
	[RESIZE_BUTTON] = RESIZE_FRAME:CreateFrameForExistingWindow(WINDOW_NAME.."ResizeButton"),
  }
  
  self.m_Windows[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabIcons", WINDOW_NAME .. "Icons", L"Icons", L"Icon Selection")
  self.m_Windows[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabTextures", WINDOW_NAME .. "Textures", L"Textures", L"Texture Selection")
  
  self.m_Windows[TITLEBAR]:SetText(L"Texture Viewer")
end

function RESIZE_FRAME:OnResizeBegin()
  self:GetParent():BeginResize("topleft", 630, 600, WINDOW.m_Windows[TAB_GROUP]:GetCurrentTab().OnResizeEnd)
end

WINDOW:Create()