local warExtended        = warExtended
local mfloor             = math.floor
local WINDOW_NAME        = "TerminalTextureViewer"

local ICON_SCROLL_WINDOW         = 1
local ICON_SCROLL_WINDOW_CHILD         = 2
local ICON_SCROLLBAR        = 3
local ICON_EDITOR = 4

local TITLEBAR           = 10
local TABGROUP           = 11

local MAX_COLUMN = 10
local MAX_ROW = 4
local MAX_ICONS = MAX_COLUMN * MAX_ROW

local TerminalTextureViewer = TerminalTextureViewer
local WINDOW             = Frame:Subclass(WINDOW_NAME)

local ICON_BUTTON  = ButtonFrame:Subclass(WINDOW_NAME.."IconSelection")
local ICON_OUTPUT      = Frame:CreateFrameForExistingWindow(WINDOW_NAME .. "Icons")
local ICON_EDIT   = Frame:Subclass(WINDOW_NAME.."IconEditor")
local ICON_SCROLLBAR_FRAME = VerticalScrollbar:Subclass(WINDOW_NAME.."IconSelectionScrollbar")


local TEXTURE_OUTPUT      = Frame:CreateFrameForExistingWindow(WINDOW_NAME .. "Textures")

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  
  self.m_Windows = {
    [TITLEBAR]      = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
    [TABGROUP]      = TabGroup:Create(WINDOW_NAME.."Tab", TerminalTextureViewer:GetSavedSettings()),
  }
  
  self.m_Windows[TABGROUP]      = {
    [ICON_OUTPUT] = self.m_Windows[TABGROUP]:AddExistingTab(WINDOW_NAME.."TabIcons", WINDOW_NAME.."Icons", "Icons", "Icon Selection"),
   -- [TEXTURE_OUTPUT] = self.m_Windows[TABGROUP]:AddExistingTab(WINDOW_NAME.."TabTextures", WINDOW_NAME.."Textures", "Textures", "Texture Selection"),
  }
  
  self.m_Windows[ICON_OUTPUT] = {
    [ICON_SCROLL_WINDOW] = ScrollWindow:CreateFrameForExistingWindow(ICON_OUTPUT:GetName() .. "Selection"),
    [ICON_SCROLL_WINDOW_CHILD] = Frame:CreateFrameForExistingWindow(ICON_OUTPUT:GetName() .. "SelectionScrollChild"),
    [ICON_SCROLLBAR] = ICON_SCROLLBAR_FRAME:CreateFrameForExistingWindow(ICON_OUTPUT:GetName() .. "SelectionScrollbar"),
    [ICON_EDITOR] = ICON_EDIT:CreateFromTemplate(ICON_OUTPUT:GetName().."IconEditor", ICON_OUTPUT:GetName())
  }
  
  self.m_Windows[TEXTURE_OUTPUT] = {
  }
  
  local win = self.m_Windows
  
  win[TITLEBAR]:SetText(L"Texture Viewer")
  win[ICON_OUTPUT][ICON_EDITOR]:SetAnchor ({Point = "bottomright", RelativePoint = "bottomright", RelativeTo= ICON_OUTPUT:GetName(), XOffset = 0, YOffset = 40})
  win[ICON_OUTPUT][ICON_EDITOR]:Show(true)
end

local function setIconTooltipText()
  local buttonFrame = FrameManager:GetMouseOverWindow ()
  local iconName = warExtended:toWString(TerminalTextureViewer:GetSettings().icons.list[buttonFrame:GetId()])
  Tooltips.SetTooltipText(1, 1, iconName)
end

function ICON_BUTTON:OnMouseOver()
  local iconName = warExtended:toWString(TerminalTextureViewer:GetSettings().icons.list[self:GetId()])
  local anchor = { Point = "top", RelativeTo = self:GetName(), RelativePoint = "top", XOffset = 0, YOffset = -32 }
  
  warExtended:CreateTextTooltip(self:GetName(), {
    [1]={{text = iconName, color=Tooltips.COLOR_HEADING}},
  }, nil, anchor, nil, setIconTooltipText)
end

function ICON_OUTPUT:OnShown()
  TerminalTextureViewer:GetSettings().icons.list = TerminalTextureViewer.GetIconsList()
  
  local win = WINDOW.m_Windows[ICON_OUTPUT]
  ICON_OUTPUT:CreateIcons()
  ICON_OUTPUT:SetPageIcons(win[ICON_SCROLLBAR]:GetScrollPos()/90)
  win[ICON_SCROLL_WINDOW]:UpdateScrollRect()
end

function ICON_OUTPUT.OnHidden()
  TerminalTextureViewer:GetSettings().icons.list = {}
end

function ICON_OUTPUT:CreateIcons()
  for icon=1,MAX_ICONS do
    if GetFrame(self:GetName().."Slot"..icon) then
      return
    end
    
      local buttonFrame = ICON_BUTTON:CreateFromTemplate(self:GetName().."Slot"..icon, self:GetName().."SelectionScrollChild" )
      buttonFrame.m_Icon = DynamicImage:CreateFrameForExistingWindow(buttonFrame:GetName().."IconBase")
      buttonFrame:Show(true)
      
      if icon == 1 then
        buttonFrame:SetAnchor({
          RelativeTo = self:GetName().."SelectionScrollChild", YOffset = 24
        })
      elseif icon%MAX_COLUMN == 1 then
        buttonFrame:SetAnchor({
          Point = "bottomleft", RelativeTo = self:GetName().."Slot"..icon-MAX_COLUMN, YOffset = 4
        })
      else
        buttonFrame:SetAnchor({
          Point = "right", RelativePoint = "left", RelativeTo = self:GetName().."Slot"..icon-1, XOffset = 4,
        })
      end
  end
  
  local scrollbar = WINDOW.m_Windows[ICON_OUTPUT][ICON_SCROLLBAR]
  self:SetPageIcons(scrollbar:GetScrollPos()/90)
end

function ICON_OUTPUT:SetPageIcons(page)
  local scrollbar = WINDOW.m_Windows[ICON_OUTPUT][ICON_SCROLLBAR]
  local scrollWindow = WINDOW.m_Windows[ICON_OUTPUT][ICON_SCROLL_WINDOW]
  local icons = TerminalTextureViewer:GetSettings().icons.list
  page = mfloor(page)
  
  if page == 0 then
    page = 1
  end
  
  for icon= 1,MAX_ICONS do
    local frame = GetFrame(self:GetName().."Slot"..icon)
    local iconId = icon+(page*40)-40
    
    if icons[iconId] then
      frame.m_Icon:SetTexture(icons[iconId], 0, 0)
      frame:SetId(iconId)
      
      if not frame:IsShowing() then
        frame:Show(true)
      end
      
    else
      frame:Show(false)
    end
  end
  
  scrollbar:SetMaxScrollPos(#icons*2.29)
  p(page)
  scrollWindow:UpdateScrollRect()
end


function ICON_SCROLLBAR_FRAME:OnScrollPosChanged(scrollPos)
  ICON_OUTPUT:SetPageIcons(scrollPos/90)
end


WINDOW:Create()