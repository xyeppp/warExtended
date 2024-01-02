
local pairs=pairs
local warExtended = warExtended

local URL_PATTERN = "[a-zA-Z@:%._\+~#=%/]+%.[a-zA-Z0-9@:_\+~#=%/%?&]"

local keymaps = warExtendedSet:New()
local macroKeymaps = warExtendedSet:New()

local function checkTextType(text)
  if not warExtended:IsType(text, "string") then
    text = warExtended:toString(text)
  end
  return text
end

local _SendChatText = SendChatText
SendChatText = function(text, channel)
  text = warExtended:SubKeymapText(text)
  _SendChatText(text, channel)
end

function warExtended:SubKeymapText(text)
  text = checkTextType(text)

  for textSub, textFunction in pairs(keymaps) do
    local wordBoundary = '%f[%w%p]%'..textSub..'%f[%A]'

    if (string.match(textSub, "%(%%") and text:match(textSub)) or text:match(URL_PATTERN) then
      text = text:gsub(textSub, textFunction)
    elseif text:match(wordBoundary) then
      text = text:gsub(wordBoundary, textFunction)
    end
  end

  return self:toWString(text)
end

function warExtended:IsKeymapText(text)
 text = checkTextType(text)

  for textSub, _ in pairs(keymaps) do
      local wordBoundary = '%f[%w%p]%'..textSub..'%f[%A]'

      if (string.match(textSub, "%(%%") and text:match(textSub)) or text:match(wordBoundary) or text:match(URL_PATTERN) then
        return true
      end

  end
end

function warExtended:RegisterKeymap(keymapTable)
  if not self:GetModuleData().keymap then
    self:GetModuleData().keymap = keymapTable
  end

  for text, textFunction in pairs(keymapTable) do
    if keymaps:Has(text) then
      error("Unable to add "..text.." - the keymap is already registered.")
    else
      keymaps:Add(text, textFunction)
    end
  end

  warExtended._Settings.AddChildEntry(self:toWString(self.moduleName), L"Keymap Functions", "warExtendedSettings_KeymapTemplate")
end


function warExtended:UnregisterKeymap()
  local keymap = self:GetSelfKeymap()

  for text,_ in pairs(keymap) do
    keymaps:Remove(text)
  end

  keymap = nil
end

function warExtended:GetSelfKeymap()
  return self:GetModuleData().keymap
end

function warExtended.GetModuleKeymap(moduleName)
  return warExtended.modules[moduleName].keymap
end

warExtended:AddEventHandler("InitializeActionButtonKeymapHook", "CoreInitialized", function()
  local _ActionButtonOnLButtonDown = ActionButton.OnLButtonDown
  local _ActionButtonOnLButtonUp = ActionButton.OnLButtonUp

 ActionButton.OnLButtonDown = function(actionButtonData, flags, x, y)
    if warExtended:IsMacro(actionButtonData.m_ActionType) then
      local macro = warExtended:GetMacroData(actionButtonData.m_ActionId)

      if warExtended:IsKeymapText(macro.text) then
        macroKeymaps:Add(actionButtonData.m_ActionId, macro)
        warExtended:SetMacro(macro.name, warExtended:SubKeymapText(macro.text), macro.iconNum, actionButtonData.m_ActionId)
      end
    end

    _ActionButtonOnLButtonDown(actionButtonData, flags, x, y)
  end

  ActionButton.OnLButtonUp = function(actionButtonData, flags, x, y)
    _ActionButtonOnLButtonUp(actionButtonData, flags, x, y)

    if macroKeymaps:Has(actionButtonData.m_ActionId) then
      local macroData = macroKeymaps:Get(actionButtonData.m_ActionId)
      warExtended:SetMacro(macroData.name, macroData.text, macroData.iconNum, actionButtonData.m_ActionId)
      macroKeymaps:Remove(actionButtonData.m_ActionId)
    end
  end
end)