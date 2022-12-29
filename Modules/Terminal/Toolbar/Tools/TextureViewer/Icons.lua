local warExtended			= warExtended
local TerminalTextureViewer = TerminalTextureViewer
local GetIconData           = GetIconData
local mfloor             = math.floor
local icons 			= {}
local WINDOW_NAME        = "TerminalTextureViewer"
local MAX_ICON_ID           = 100000
local INVALID_ENTRY         = "icon-00001"
local INVALID_ENTRY2        = "icon-00002"
local INVALID_ENTRY3        = "icon000000"

local ICON_SCROLL_WINDOW = 1
local ICON_SCROLL_WINDOW_CHILD = 2
local ICON_SCROLLBAR = 3
local ICON_EDIT = 4

local ICON_FRAME     = Frame:Subclass(WINDOW_NAME .. "Icons")
local ICON_BUTTON  = ButtonFrame:Subclass(WINDOW_NAME.."IconSelection")
local ICON_SCROLLBAR_FRAME = VerticalScrollbar:Subclass(WINDOW_NAME.."IconSelectionScrollbar")
local ICON_EDITOR   = Frame:Subclass(WINDOW_NAME.."IconEditor")
local ICON_EDITOR_EDIT_BOX = TextEditBox:Subclass ()
local ICON_EDITOR_EDIT_NUMBER_BOX  = ICON_EDITOR_EDIT_BOX:Subclass ()
local BUTTON_X = 55
local BUTTON_Y = 55
local MAX_COLUMN = 10
local MAX_ROW = 4
local MAX_ICONS = MAX_COLUMN * MAX_ROW
local MAX_ICONS_CACHE

-- EDITOR_EDIT_BOX --

function ICON_EDITOR_EDIT_BOX:Create (windowName, anchorEditor, tooltip, modifiedId)
  local frame = self:CreateFrameForExistingWindow (windowName)
  
  if (frame)
  then
	frame.m_AnchorEditor    = anchorEditor
	frame.m_Tooltip         = tooltip
	frame.m_ModifiedId      = modifiedId
  end
  
  return frame
end

function ICON_EDITOR_EDIT_BOX:OnMouseOver (flags, x, y)
  Tooltips.CreateTextOnlyTooltip (self:GetName (), self.m_Tooltip)
  Tooltips.Finalize ()
  Tooltips.AnchorTooltip (Tooltips.ANCHOR_WINDOW_VARIABLE)
end

function ICON_EDITOR_EDIT_BOX:OnMouseWheel (x, y, delta, flags)
  p(self)
  -- Does nothing, that's cool...
end

function ICON_EDITOR_EDIT_BOX:AA_GetModifiedId ()
  return self.m_ModifiedId
end


function ICON_EDITOR_EDIT_NUMBER_BOX:OnMouseWheel (x, y, delta, flags)
  p(self)
  if (flags == SystemData.ButtonFlags.SHIFT)
  then
	delta = delta * 10
  end
  
  self:SetText (self:TextAsNumber () + delta)
  self.m_AnchorEditor:Apply ()
end

function ICON_EDITOR_EDIT_NUMBER_BOX:Clear ()
  self:SetText (L"0")
end

-- ICON_BUTTON --

local function setIconTooltipText()
  local buttonFrame = FrameManager:GetMouseOverWindow ()
  Tooltips.SetTooltipText(1, 1, L"Texture: "..buttonFrame:GetIconTexture())
  Tooltips.SetTooltipText(2, 1, L"Icon ID: "..buttonFrame:GetIconId())
end

function ICON_BUTTON:GetIconData()
  return TerminalTextureViewer:GetSettings().icons.list[self:GetId()]
end

function ICON_BUTTON:GetIconId()
  local id = self:GetIconTexture():match(L"icon00(%d+)") or self:GetIconTexture():match(L"icon0(%d+)")
  return id
end

function ICON_BUTTON:GetIconTexture()
  local texture = warExtended:toWString(self:GetIconData())
  return texture
end

function ICON_BUTTON:OnMouseOver()
  local anchor = { Point = "top", RelativeTo = self:GetName(), RelativePoint = "top", XOffset = 0, YOffset = -90 }
  local extraText = L"SHIFT + "..warExtended:GetLMBIcon()..L" to link in chat."
  
  warExtended:CreateTextTooltip(self:GetName(), {
	[1]={{text = L"Texture: "..self:GetIconTexture(), color=Tooltips.COLOR_HEADING}},
	[2]={{text = L"Icon ID: "..self:GetIconId(), color=Tooltips.COLOR_HEADING}},
  }, extraText, anchor, nil, setIconTooltipText)
end

function ICON_BUTTON:OnLButtonUp(flags)
  if warExtended:IsShiftPressed(flags) then
	EA_ChatWindow.InsertText(warExtended:GetIconString(self:GetIconId()))
  end
end

-- SCROLLBAR --

function ICON_SCROLLBAR_FRAME:OnScrollPosChanged(scrollPos)
  local icons = TerminalTextureViewer:GetSettings().icons.list
  local parentFrame = self:GetParent()
  self:SetMaxScrollPos(#icons*2.29)
  parentFrame:GetParent():SetPageIcons(scrollPos/90)
end

-- MAIN FRAME --

function ICON_FRAME:Create()
  local frame = self:CreateFrameForExistingWindow (WINDOW_NAME .. "Icons")
  
  if (frame) then
	local win =
	{
	  [ICON_SCROLL_WINDOW] = ScrollWindow:CreateFrameForExistingWindow(frame:GetName() .. "Selection"),
	  [ICON_SCROLL_WINDOW_CHILD] = Frame:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollChild"),
	  [ICON_SCROLLBAR] = ICON_SCROLLBAR_FRAME:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollbar"),
	  [ICON_EDIT] = ICON_EDITOR:CreateFromTemplate(frame:GetName().."IconEditor", frame:GetName()),
	}
 
	win[ICON_EDIT]:SetAnchor ({Point = "bottomright", RelativePoint = "bottomright", RelativeTo= frame:GetName(), XOffset = 0, YOffset = 40})
	win[ICON_EDIT]:Show(true)
 
	frame.m_Windows = win
	frame:Show (true)
  end
  
return frame
end

function ICON_FRAME:SetMaxIcons()
  local x, y = self.m_Windows[ICON_SCROLL_WINDOW]:GetDimensions(true)
  local scrollbarX, _ = self.m_Windows[ICON_SCROLLBAR]:GetDimensions(true)
  MAX_COLUMN = mfloor((mfloor(x)-scrollbarX-80)/BUTTON_X)
  MAX_ROW = mfloor((mfloor(y)-40)/BUTTON_Y)
  MAX_ICONS_CACHE = MAX_ICONS
  MAX_ICONS = MAX_COLUMN * MAX_ROW
  
  p(MAX_COLUMN, MAX_ROW, MAX_ICONS)
end

function ICON_FRAME:OnShown()
  TerminalTextureViewer:GetSettings().icons.list = TerminalTextureViewer.GetIconsList()
  self:CreateIcons()
  self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
  self.m_Windows[ICON_SCROLL_WINDOW]:UpdateScrollRect()
end

function ICON_FRAME.OnHidden()
  TerminalTextureViewer:GetSettings().icons.list = {}
end

function ICON_FRAME:CreateIcons()
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
  
  self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
end

function ICON_FRAME:DestroyIcons()
  for icon=MAX_ICONS,MAX_ICONS_CACHE do
	local frame = GetFrame(self:GetName().."Slot"..icon)
	frame:Show(false)
  end
end

function ICON_FRAME:RecreateIcons()
local scrollWindow = self.m_Windows[ICON_SCROLL_WINDOW]
  scrollWindow:UpdateScrollRect()
  self:SetMaxIcons()
  self:DestroyIcons()
  
  for icon=1,MAX_ICONS do
	if not GetFrame(self:GetName().."Slot"..icon) then
	  local buttonFrame = ICON_BUTTON:CreateFromTemplate(self:GetName().."Slot"..icon, self:GetName().."SelectionScrollChild" )
	  buttonFrame.m_Icon = DynamicImage:CreateFrameForExistingWindow(buttonFrame:GetName().."IconBase")
	  buttonFrame:Show(true)
	end
  end
  
  self:ReanchorIcons()
  self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
end

function ICON_FRAME:ReanchorIcons()
  for icon=1,MAX_ICONS do
	local buttonFrame = GetFrame(self:GetName().."Slot"..icon)
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
end

function ICON_FRAME:SetPageIcons(page)
  local scrollbar = self.m_Windows[ICON_SCROLLBAR]
  local scrollWindow = self.m_Windows[ICON_SCROLL_WINDOW]
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
  if not page == scrollbar:GetMaxScrollPos()/90 then
	scrollWindow:UpdateScrollRect()
  end
end

function ICON_FRAME.OnResizeEnd()
  local frame = GetFrame(WINDOW_NAME .. "Icons")
  p("yes")
  frame:RecreateIcons()
end

-- CORE --
function TerminalTextureViewer.CreateIconsFrame()
  return ICON_FRAME:Create()
end

function TerminalTextureViewer.GetIconsList()
  icons = {}
  
  for iconId = 0, MAX_ICON_ID do
	local iconData, _, _ = GetIconData(iconId)
	if iconData ~= INVALID_ENTRY and iconData ~= INVALID_ENTRY2 and iconData ~= INVALID_ENTRY3 then
	  icons[#icons + 1] =  iconData
	end
  end
  
  return icons
end





