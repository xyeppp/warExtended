local warExtended = warExtended
local warExtendedTerminal = warExtendedTerminal
local WINDOW_NAME = "TerminalTextureViewer"
local currentPage = nil
local maxPage = nil
local setScrollbar = false

local maxColumns = 10
local maxRows = 4
local maxIcons = maxColumns * maxRows

local function setTextures(page)
  page = math.floor(page)
  
  if page == 0 then
    page = 1
  end
  
  for icon= 1,maxIcons do
    if warExtendedTerminal.TextureViewerGetIconList2()[icon+(page*40)-40] then
      WindowSetShowing("TerminalTextureViewerIconsSlot"..icon, true)
      DynamicImageSetTexture("TerminalTextureViewerIconsSlot"..icon.."IconBase", unpack(warExtendedTerminal.TextureViewerGetIconList2()[icon+(page*40)-40]))
      WindowSetId("TerminalTextureViewerIconsSlot"..icon, icon+(page*40)-40)
    else
      WindowSetShowing("TerminalTextureViewerIconsSlot"..icon, false)
    end
  end
  
  if not setScrollbar then
    local maxPos = #warExtendedTerminal.TextureViewerGetIconList2()*2.29
    VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", maxPos)
  end
end

local function spawnIcons()
  for icon = 1,maxIcons do
    if not DoesWindowExist("TerminalTextureViewerIconsSlot"..icon) then
      warExtended:CreateWindowTemplate("TerminalTextureViewerIconsSlot"..icon, "TerminalTextureViewerIconSelection", "TerminalTextureViewerIconsIconSelectionScrollChild")
    end
        if icon == 1 then
          warExtended:WindowSetAnchor ("TerminalTextureViewerIconsSlot"..icon)
        elseif icon%maxColumns == 1 then
          warExtended:WindowSetAnchor ("TerminalTextureViewerIconsSlot"..icon, {
            Point = "bottomleft", RelativePoint = "topleft", RelativeTo = "TerminalTextureViewerIconsSlot"..icon-maxColumns, XOffset = 0, YOffset = 4
          })
        else
          warExtended:WindowSetAnchor ("TerminalTextureViewerIconsSlot"..icon, {
            Point = "right", RelativePoint = "left", RelativeTo = "TerminalTextureViewerIconsSlot"..icon-1, XOffset = 4, YOffset = 0
          })
        end
  end
  
  local page = math.floor(VerticalScrollbarGetScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))/90
  setTextures(page)
  

end

function warExtendedTerminal.TextureViewerOnIconSelectionMouseover(...)
  p(...)
  local id = WindowGetId(SystemData.MouseOverWindow.name)
  p(id)
  p(warExtendedTerminal.TextureViewerGetIconList2()[id])
end


local function setSelectedTab(tabIndex)
  warExtendedTerminal.Settings.activeToolbarWindows.TerminalTextureViewer.selectedTab = tabIndex
end



local function initTabs()
  do
    dimyy=Frame:Subclass("TextureViewerIconEditor")
    
  end
  
  function dimyy:Create (windowName, parentName)
    local dims = self:CreateFromTemplate (windowName, parentName)
    return dims
  end
  
  
  warExtendedTerminal:RegisterToolbarItem(L"Texture Viewer", L"Preview all game icons, textures & slices.", "TerminalTextureViewer", 20284, warExtendedTerminal.GetToolbarButtonSettings("TerminalTextureViewer"))
  local TextureViewerTabGroup = TabGroup:Create(WINDOW_NAME.."Tabs", warExtendedTerminal.Settings.activeToolbarWindows.TerminalTextureViewer, setSelectedTab)
  TextureViewerTabGroup:AddExistingTab (WINDOW_NAME.."TabsIconsTab", WINDOW_NAME.."Icons", "Icons", "Icon Selection")
  TextureViewerTabGroup:AddExistingTab (WINDOW_NAME.."TabsTexturesTab", WINDOW_NAME.."Textures", "Textures", "Texture Selection")
  
  local Dims=dimyy:Create(WINDOW_NAME.."IconEditor", WINDOW_NAME.."Icons")
  Dims:SetAnchor ({Point = "bottomright", RelativePoint = "bottomright", RelativeTo= "TerminalTextureViewerIcons", XOffset = 0, YOffset = 40})
  Dims:Show()
end

warExtended:AddEventHandler("initTabsViewer", "CoreInitialized", initTabs)


function warExtendedTerminal.TextureViewerOnInitialize()
 -- warExtendedTerminal:RegisterToolbarItem(L"Texture Viewer", L"Preview all game icons, textures & slices.", "TerminalTextureViewer", 20284, {})
  warExtendedTerminal.TextureViewerGetIconList()
  
  --LabelSetText(WINDOW_NAME.."TitleBarLabel", L"Texture Viewer")
  
 -- ButtonSetText(WINDOW_NAME.."TabsIconsTab", L"Icons")
 -- ButtonSetText(WINDOW_NAME.."TabsTexturesTab", L"Textures")
  
  local maxPos = #warExtendedTerminal.TextureViewerGetIconList2()*2.29
  VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", maxPos)
  
  p("onInit")
  p(VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))
  p('-----')

end

function warExtendedTerminal.TextureViewerOnShown()
  spawnIcons()
  p("onShown")
  p(VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))
  p('-----')
  if not setScrollbar then
    local maxPos = #warExtendedTerminal.TextureViewerGetIconList2()*2.29
    VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", maxPos)
  end
 -- VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 140*90)
  --ScrollWindowSetOffset("TerminalTextureViewerIconsIconSelection", 1)
  VerticalScrollbarSetScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 1)
 -- VerticalScrollbarSetScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 1)

end

function warExtendedTerminal.TextureViewerOnHidden()
--  VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 140*90)

end


function warExtendedTerminal.TextureViewerGetScrollPage()
 -- VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 140*90)
  
  -- return math.floor((macroId-2)/18)
end

function warExtendedTerminal.TextureViewerOnScrollPos()
  p("onPos")
  if not setScrollbar then
    local maxPos = #warExtendedTerminal.TextureViewerGetIconList2()*2.29
    VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", maxPos)
  end
 -- if VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar") ~= 200*100 then
  --  VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 200*100)
--  end
  p(VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))
  p('-----')
  
  
   local page = VerticalScrollbarGetScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar")/90
  setTextures(page)
end

function warExtendedTerminal.TextureViewerOnMouseWheel(x, y, delta, flags)
  p("onMWheel")
  p(VerticalScrollbarGetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar"))
  p('-----')
  --VerticalScrollbarSetMaxScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar", 140*90)
  
   local page = VerticalScrollbarGetScrollPosition("TerminalTextureViewerIconsIconSelectionScrollbar")/90
 setTextures(page)
end


