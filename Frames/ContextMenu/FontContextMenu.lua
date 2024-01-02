local warExtended = warExtended
local FONT_ENTRY = "ChatContextMenuItemFontSelection"

local FONT_ENTRY_FRAME = Frame:Subclass(FONT_ENTRY)
local LABEL = 1
local TICK = 2

function FONT_ENTRY_FRAME:Create(windowName, idx, callbackObject, callbackFunction)
  local frame = self:CreateFromTemplate(windowName..idx)

  if frame then
	frame.m_Windows = {
	  [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."Label"),
	  [TICK] =  DynamicImage:CreateFrameForExistingWindow(frame:GetName().."Check")
	}

	frame.m_CallbackFunction = callbackFunction
	frame.m_CallbackObject = callbackObject

	local win = frame.m_Windows
	win[LABEL]:SetFont(ChatSettings.Fonts[idx].fontName, WindowUtils.FONT_DEFAULT_TEXT_LINESPACING)
	win[LABEL]:SetText(ChatSettings.Fonts[idx].shownName)

	local _, y = win[LABEL]:GetDimensions()
	local x, _ = frame:GetDimensions()
	frame:SetDimensions(x, y)
	frame:SetScript("OnLButtonUp", "FrameManager.OnLButtonUp")
	frame:SetId(idx)

	return frame
  end
end

function FONT_ENTRY_FRAME:OnLButtonUp()
  local fontIndex = self:GetId()
  self.m_CallbackObject.font = ChatSettings.Fonts[fontIndex].fontName

  local size = #ChatSettings.Fonts
  for idx=1, size
  do
	local frame = GetFrame(self:GetName():gsub("%d+", idx))
	if ( ChatSettings.Fonts[idx].fontName == frame.m_CallbackObject.font ) then
	  frame.m_Windows[TICK]:Show(true)
	else
	  frame.m_Windows[TICK]:Show(false)
	end

  end

  self.m_CallbackFunction(ChatSettings.Fonts[fontIndex].fontName)
end

function warExtended:CreateContextMenuFont(windowName, callbackObject, callbackFunction)
  local size = #ChatSettings.Fonts

  EA_Window_ContextMenu.CreateContextMenu(windowName, EA_Window_ContextMenu.CONTEXT_MENU_1)

  for idx=1, size do
	local frame = GetFrame(windowName..idx)

	if not frame then
	  frame = FONT_ENTRY_FRAME:Create(windowName, idx, callbackObject, callbackFunction)
	end

	local _, y = frame.m_Windows[LABEL]:GetDimensions()

	EA_Window_ContextMenu.AddUserDefinedMenuItem(frame:GetName(), EA_Window_ContextMenu.CONTEXT_MENU_1)
	if ( ChatSettings.Fonts[idx].fontName == callbackObject.font ) then
	  frame.m_Windows[TICK]:Show(true)
	else
	  frame.m_Windows[TICK]:Show(false)
	end
  end

  EA_Window_ContextMenu.Finalize(EA_Window_ContextMenu.CONTEXT_MENU_1)
end

