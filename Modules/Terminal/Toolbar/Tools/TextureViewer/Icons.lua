local warExtended			= warExtended
local TerminalTextureViewer = TerminalTextureViewer
local GetIconData           = GetIconData
local mfloor             = math.floor
local icons 			= {}
local WINDOW_NAME        = "TerminalTextureViewer"
local MAX_ICON_ID           = 200000
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
local ICON_EDITOR_BACKGROUND_PICKER = ColorPicker_:Subclass()

local ICON_ICON = 1
local ICON_COLUMN = 2
local ICON_NAME = 3
local ICON_ID_COLUMN = 4
local ICON_ID_NAME = 5
local ICON_X_OFFSET = 6
local ICON_Y_OFFSET = 7
local ICON_X_DIMS = 8
local ICON_Y_DIMS = 9
local ICON_WIDTH = 11
local ICON_HEIGHT = 12
local ICON_DISPLAY_FRAME = 13
local ICON_BACKGROUND_PICKER_COLUMN = 32
local ICON_BACKGROUND_PICKER = 15
local ICON_DISPLAY_BACKGROUND = 16


local tooltips = {
  [ICON_X_OFFSET] = L"Set icon X offset.",
  [ICON_Y_OFFSET] = L"Set icon Y offset.",
  [ICON_X_DIMS] = L"Set icon X dimensions.",
  [ICON_Y_DIMS] = L"Set icon Y dimensions.",
  [ICON_WIDTH] = L"Set icon width.",
  [ICON_HEIGHT] = L"Set icon height.",
}

local labels = {
  [ICON_X_OFFSET] = L"X Offset:",
  [ICON_Y_OFFSET] = L"Y Offset:",
  [ICON_X_DIMS] = L"X Dimensions:",
  [ICON_Y_DIMS] = L"Y Dimensions:",
  [ICON_WIDTH] = L"Icon Width:",
  [ICON_HEIGHT] = L"Icon Height:",
}

local backgroundColors = {
  DefaultColor.YELLOW,
  DefaultColor.RED,
  DefaultColor.MEDIUM_LIGHT_GRAY,
  DefaultColor.BLACK,
  DefaultColor.WHITE
}

do
  for color=1,5 do
	backgroundColors[color].id = color
  end
end

local BUTTON_X = 55
local BUTTON_Y = 55
local MAX_COLUMN = 10
local MAX_ROW = 4
local MAX_ICONS = MAX_COLUMN * MAX_ROW
local MAX_ICONS_CACHE

function ICON_EDITOR:Create(parentName)
  local editor = self:CreateFromTemplate(parentName.."IconEditor", parentName)

  editor.m_Windows = {
	[ICON_DISPLAY_FRAME] = Frame:CreateFrameForExistingWindow(editor:GetName().."Display"),
	[ICON_ICON] = DynamicImage:CreateFrameForExistingWindow(editor:GetName().."DisplayIcon"),
	[ICON_DISPLAY_BACKGROUND] = FullResizeImage:CreateFrameForExistingWindow(editor:GetName().."DisplayBackground"),
	[ICON_COLUMN] = Label:CreateFrameForExistingWindow(editor:GetName().."TextureNameColumn"),
	[ICON_NAME] = Label:CreateFrameForExistingWindow(editor:GetName().."TextureNameElement"),
	[ICON_ID_COLUMN] = Label:CreateFrameForExistingWindow(editor:GetName().."IconIdColumn"),
	[ICON_ID_NAME] = Label:CreateFrameForExistingWindow(editor:GetName().."IconIdElement"),
	[ICON_X_OFFSET] =  ICON_EDITOR_EDIT_NUMBER_BOX:Create(editor:GetName().."XOffset", tooltips[ICON_X_OFFSET], ICON_X_OFFSET, labels[ICON_X_OFFSET]),
	[ICON_Y_OFFSET] = ICON_EDITOR_EDIT_NUMBER_BOX:Create(editor:GetName().."YOffset", tooltips[ICON_Y_OFFSET], ICON_Y_OFFSET, labels[ICON_Y_OFFSET]),
	[ICON_X_DIMS] = ICON_EDITOR_EDIT_NUMBER_BOX:Create(editor:GetName().."XDimensions", tooltips[ICON_X_DIMS], ICON_X_DIMS, labels[ICON_X_DIMS]),
	[ICON_Y_DIMS] = ICON_EDITOR_EDIT_NUMBER_BOX:Create(editor:GetName().."YDimensions", tooltips[ICON_Y_DIMS], ICON_Y_DIMS, labels[ICON_Y_DIMS]),
	[ICON_WIDTH] = ICON_EDITOR_EDIT_NUMBER_BOX:Create (editor:GetName().."Width", tooltips[ICON_WIDTH], ICON_WIDTH, labels[ICON_WIDTH]),
	[ICON_HEIGHT] = ICON_EDITOR_EDIT_NUMBER_BOX:Create(editor:GetName().."Height", tooltips[ICON_HEIGHT], ICON_HEIGHT, labels[ICON_HEIGHT]),
	[ICON_BACKGROUND_PICKER_COLUMN] = Label:CreateFrameForExistingWindow(editor:GetName().."BackgroundLabel"),
	[ICON_BACKGROUND_PICKER] = ICON_EDITOR_BACKGROUND_PICKER:Create(editor:GetName().."ColorPicker", backgroundColors, 5, 7, 0, false),
  }

  local win = editor.m_Windows

  win[ICON_COLUMN]:SetText(L"Texture Name")
  win[ICON_NAME]:SetText(L"No icon selected")
  win[ICON_ID_COLUMN]:SetText(L"Icon ID")
  win[ICON_ID_NAME]:SetText(L"No icon selected")
  win[ICON_BACKGROUND_PICKER_COLUMN]:SetText(L"Background Color")
  win[ICON_BACKGROUND_PICKER]:OnLButtonUp(_,_,_, 4)

  editor:Show(true)

  return editor
end

function ICON_EDITOR:SetIcon(texture)
  local win = self.m_Windows
  local x, y = win[ICON_DISPLAY_FRAME]:GetDimensions()

  win[ICON_ICON]:SetTexture(warExtended:toString(texture), 64, 64)
  win[ICON_ICON]:SetTextureDimensions(64,64)
  win[ICON_ICON]:SetTextureScale(1)
  win[ICON_NAME]:SetText(texture)
  win[ICON_ID_NAME]:SetText(texture:match(L"icon00(%d+)") or texture:match(L"icon0(%d+)"))
  win[ICON_X_OFFSET]:SetText(0)
  win[ICON_Y_OFFSET]:SetText(0)
  win[ICON_X_DIMS]:SetText(64)
  win[ICON_Y_DIMS]:SetText(64)
  win[ICON_WIDTH]:SetText(x)
  win[ICON_HEIGHT]:SetText(y)

  self:Apply()
end

function ICON_EDITOR:Apply()
  local win = self.m_Windows
  if win then
	local texture = win[ICON_NAME]:TextAsString()
	local xOff, yOff =   win[ICON_X_OFFSET]:TextAsNumber(),  win[ICON_Y_OFFSET]:TextAsNumber()
	local xDim, yDim =   win[ICON_X_DIMS]:TextAsNumber(), win[ICON_Y_DIMS]:TextAsNumber()
	local width, height =   win[ICON_WIDTH]:TextAsNumber(),  win[ICON_HEIGHT]:TextAsNumber()
	win[ICON_ICON]:SetTexture(texture, xOff,yOff)
	win[ICON_ICON]:SetTextureDimensions(xDim,yDim)
	win[ICON_DISPLAY_FRAME]:SetDimensions(width, height)

  end
end

function ICON_EDITOR_BACKGROUND_PICKER:OnLButtonUp(flags, x, y, id)
  local backgroundFrame = GetFrame(self:GetParent():GetName().."DisplayBackground")
  local color = self:SelectPrimary(flags, x, y, id)

  if color then
	backgroundFrame:SetTint(color)
  end
end

function ICON_EDITOR_EDIT_BOX:Create (windowName, tooltip, modifiedId, labelText)
  local frame = self:CreateFrameForExistingWindow (windowName)
  local label = Label:CreateFrameForExistingWindow(frame:GetName().."Label")
 -- local editBox = self:CreateFrameForExistingWindow(frame:GetName().."Edit")

  if (frame)
  then
	frame.m_Tooltip         = tooltip
	frame.m_ModifiedId      = modifiedId
	--frame.m_EditBox 		= editBox

	frame:SetText(0)
	label:SetText(labelText)
  end

  --editBox:SetText(0)
  --label:SetText(labelText)

  return frame
end

function ICON_EDITOR_EDIT_BOX:OnMouseOver (flags, x, y)
  Tooltips.CreateTextOnlyTooltip (self:GetName (), self.m_Tooltip)
  Tooltips.Finalize ()
  Tooltips.AnchorTooltip (Tooltips.ANCHOR_WINDOW_VARIABLE)
end

function ICON_EDITOR_EDIT_BOX:OnMouseWheel (x, y, delta, flags)
  -- Does nothing, that's cool...
end

function ICON_EDITOR_EDIT_BOX:AA_GetModifiedId ()
  return self.m_ModifiedId
end

function ICON_EDITOR_EDIT_NUMBER_BOX:OnMouseWheel (x, y, delta, flags)
  if warExtended:IsFlag("SHIFT", flags) then
	delta = delta * 10
	elseif warExtended:IsFlag("CTRL", flags) then
	delta = delta / 10
  end

  self:SetText(self:TextAsNumber() + delta)

  local editor = GetFrame(WINDOW_NAME.."IconsIconEditor")
  editor:Apply ()
end

function ICON_EDITOR_EDIT_NUMBER_BOX:OnTextChanged(text)
  if not warExtended:isEmpty(text, nil) or not text:match(L"(%d+)") then
	return
  end

  local editor = GetFrame(WINDOW_NAME.."IconsIconEditor")
  editor:Apply ()
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
  return TerminalTextureViewer:GetSettings().icons.list[self:GetId()].m_texture
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

function ICON_BUTTON:OnLButtonUp(flags, x, y)
  if warExtended:IsShiftPressed(flags) then
	EA_ChatWindow.InsertText(warExtended:GetIconString(self:GetIconId()))
	return
  end

  local editor = GetFrame(WINDOW_NAME.."IconsIconEditor")
  editor:SetIcon(self:GetIconTexture())
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
	frame.m_Windows =
	{
	  [ICON_SCROLL_WINDOW] = ScrollWindow:CreateFrameForExistingWindow(frame:GetName() .. "Selection"),
	  [ICON_SCROLL_WINDOW_CHILD] = Frame:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollChild"),
	  [ICON_SCROLLBAR] = ICON_SCROLLBAR_FRAME:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollbar"),
	  [ICON_EDIT] = ICON_EDITOR:Create(frame:GetName()),
	}


	frame.m_Windows[ICON_EDIT]:SetIcon(L"icon000001")
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
end

function ICON_FRAME:OnShown()
  TerminalTextureViewer:GetSettings().icons.list = warExtended:GetIconList()
  self:CreateIcons()
  self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
  self.m_Windows[ICON_SCROLL_WINDOW]:UpdateScrollRect()
  self:RecreateIcons()
end

function ICON_FRAME:OnHidden()
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
	  frame.m_Icon:SetTexture(icons[iconId].m_texture, 0, 0)
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
      p("not page")
	scrollWindow:UpdateScrollRect()
  end
end

function ICON_FRAME.OnResizeEnd()
  local frame = GetFrame(WINDOW_NAME .. "Icons")
  frame:RecreateIcons()

end

function TerminalTextureViewer.CreateIconsFrame()
  return ICON_FRAME:Create()
end





