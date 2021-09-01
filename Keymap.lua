local chatTextSubstitutions = {}
local URLfilters = {}
local tostring=tostring
local towstring=towstring
local pairs=pairs
local warExtended = warExtended
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

  return towstring(text)
end


function ChatMacro(chatText,chatChannel)
  if not chatChannel then chatChannel = "/s" end

  chatText  =  substituteChatText(chatText)
  chatChannel = towstring(chatChannel)

  SendChatText(chatText, chatChannel)
end



function warExtended:RegisterKeymap(keymapTable)
  if not chatTextSubstitutions[self.moduleName] then
    chatTextSubstitutions[self.moduleName] = {}
  end


  chatTextSubstitutions[self.moduleName] = keymapTable
end

function warExtended:UnregisterKeymap()
  chatTextSubstitutions[self.moduleName]=nil
end
