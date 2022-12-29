local WINDOW_NAME      = "TerminalTextureViewer"
local TOOL_NAME        = L"Texture Viewer"
local TOOL_DESCRIPTION = L"Preview all game icons, textures & slices."
local TOOL_ICON        = 20284

TerminalTextureViewer     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, {
  icons = {
    list = {},
    currentPage = 0,
    maxPage = 0,
  },
  textures = {
    list = {}
  }
}, {})

function TerminalTextureViewer.OnInitialize()
  TerminalTextureViewer:GetSettings().icons.list = TerminalTextureViewer.GetIconsList()
  TerminalTextureViewer:GetSettings().icons.list = {}
  
 --[[ local maxPos = #warExtendedTerminal.TextureViewerGetIconList2()*2.29
  VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", maxPos)
  
  p("onInit")
  p(VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))
  p('-----')]]
end

function TerminalTextureViewer.OnResizeBegin()
  local currentTab = GetFrame(WINDOW_NAME.."Icons") or GetFrame(WINDOW_NAME.."Textures")
  warExtended:OnResizeWindow(630, 600, currentTab.OnResizeEnd)
end

function TerminalTextureViewer.OnShown()

end

function TerminalTextureViewer.OnHidden()
  --  VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 140*90)

end