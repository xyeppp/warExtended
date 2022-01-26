local chatTextSubstitutions = {}
local URLfilters = {}
local tostring=tostring
local towstring=towstring
local pairs=pairs
local warExtended = warExtended

local keymapManager = {
  registeredMap = {}
  
}

--Register your keymap with the following table format and object:RegisterKeymap
--
--local keymapTable = {
--  [text] = function,
--  [text2] = function,
--}
--
--[[ if isMatch then
--        if isURL then
--          p(SubstituteText("google"))
--        end
--       -- local isWString = type(SubstituteText) == "wstring" or type(SubstituteText()) == "wstring"
--       -- if isWString and not isPattern then
--       --   SubstituteText = tostring(SubstituteText())
--      --  end
--       -- p(isWString)
--       -- p(SubstituteText)
--       -- text:gsub(wordBoundary, SubstituteText)
--      end
--
--
--      local isWString = type(SubstituteText) == "wstring" or type(SubstituteText()) == "wstring"
--       if isWString and not isPattern then
--         SubstituteText = tostring(SubstituteText())
--        end
--
--      text = text:gsub(wordBoundary, SubstituteText)
--
--      if isFunction then --and not isPattern then
--        --local functionCallback = SubstituteText()
--        --SubstituteText = tostring(functionCallback)
--      end
--
--      if isWString then
--        --SubstituteText=tostring(SubstituteText)
--      end
--
--     --text = text:gsub(wordBoundary, SubstituteText)]]


--Everything else will get handled automatically for you.

local function substituteChatText(text)

  for _, registeredModules in pairs(chatTextSubstitutions) do
    for textFunction,substituteText in pairs(registeredModules) do
      local isPattern = string.match(textFunction, "%(%%")
      local wordBoundary = '%f[%w%p]%'..textFunction..'%f[%A]'
      local isTextMatch = text:match(wordBoundary)

      if isPattern then
        local isPatternMatch = text:match(textFunction)
        if isPatternMatch then
          text = text:gsub(textFunction, substituteText)
        end
      elseif isTextMatch then
        text = text:gsub(wordBoundary, substituteText)
      end

    end
  end

  text = towstring(text)
  return text
end


function ChatMacro(chatText,chatChannel)
  if not chatChannel then chatChannel = "/s" end

  chatText  =  substituteChatText(chatText)
  chatChannel = towstring(chatChannel)

  SendChatText(chatText, chatChannel)
end

oldSendChatText = SendChatText
SendChatText = function(text, channel)
  text = substituteChatText(tostring(text))
  oldSendChatText(text, channel)
end


local abuttons = {
  add = function(self, buttonNumber, text)
     self.active[buttonNumber] = text
  end,
  
  getActive = function(self)
    return self.active
  end,
  
  clear = function(self)
    if next(self.active) == 0 then
      return
    end
  end,
  
  active = {}
}
switchedMacros = {}

local function testFFFF(macroData)
  if not switchedMacros[macroData.m_ActionId] then
    return
  end
  
  SetMacroData(switchedMacros[macroData.m_ActionId].name, switchedMacros[macroData.m_ActionId].text, switchedMacros[macroData.m_ActionId].iconNum, macroData.m_ActionId)
  EA_Window_Macro.UpdateDetails (macroData.m_ActionId)
  switchedMacros[macroData.m_ActionId] = nil
end


local function testFFF(macroData)
  if macroData.m_ActionType == 4 then
    local macros = GetMacrosData()
    local macro = macros[macroData.m_ActionId]
    if warExtended:IsKeymapText(tostring(macro.text)) then
      p('is keymap')
      switchedMacros[macroData.m_ActionId] = macro
      SetMacroData (macro.name, substituteChatText(tostring(macro.text)), macro.iconNum, macroData.m_ActionId)
      EA_Window_Macro.UpdateDetails (macroData.m_ActionId)
    end
  end
end

function testMacro()
    warExtended:Hook(ActionButton.OnLButtonDown,testFFF, true)
    warExtended:Hook(ActionButton.OnLButtonUp,testFFFF, true)
end


function warExtended:RegisterKeymap(keymapTable)
  if not chatTextSubstitutions[self.moduleName] then
    chatTextSubstitutions[self.moduleName] = {}
  end
  
  chatTextSubstitutions[self.moduleName] = keymapTable
end

function warExtended:GetModuleKeymap(moduleName)
  moduleName = moduleName or self.moduleName
  return chatTextSubstitutions[moduleName]
end

function warExtended:UnregisterKeymap()
  chatTextSubstitutions[self.moduleName]=nil
end

function warExtended:IsKeymapText(text)
  for _, registeredModules in pairs(chatTextSubstitutions) do
    for textFunction,substituteText in pairs(registeredModules) do
      local isPattern = string.match(textFunction, "%(%%")
      local wordBoundary = '%f[%w%p]%'..textFunction..'%f[%A]'
      local isTextMatch = text:match(wordBoundary)
      
      if (isPattern and text:match(textFunction)) or isTextMatch then
        return true
      end
    
    end
  end
end
