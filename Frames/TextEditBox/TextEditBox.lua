local warExtended = warExtended
local TextEditBox = TextEditBox

function TextEditBox:SetTextCache(data)
  if self.m_Cache == nil then
	self.m_Cache = {}
  end

  self.m_Cache[self:GetName()] = WideStringFromData(data)
  self:SetText(data)
end

function TextEditBox:GetTextCache()
  if self.m_Cache == nil then
	return
  end

  return self.m_Cache[self:GetName()]
end

function TextEditBox:OnTextChanged(data)
  if self:GetTextCache() ~= nil and data ~= self:GetTextCache() then
	self:SetText(self:GetTextCache())
  end
end

function TextEditBox:SetFont(font)
  TextEditBoxSetFont(self:GetName(), font)
end

function TextEditBox:GetAllowEditing()
    return TextEditBoxGetAllowEditing(self:GetName())
end

function TextEditBox:InsertText(data)
    TextEditBoxInsertText(self:GetName(), WideStringFromData (data))
end

function TextEditBox:SetHistory(history)
    TextEditBoxSetHistory(self:GetName(), history)
end

function TextEditBox:GetText()
    return TextEditBoxGetText(self:GetName())
end

function TextEditBox:SelectAll()
    TextEditBoxSelectAll(self:GetName())
end


--[[function TextEditBoxGetAllowEditing()   end
function TextEditBoxGetFont()   end
function TextEditBoxGetHistory()   end
function TextEditBoxGetMaxChars()   end

function TextEditBoxGetTextColor()   end
function TextEditBoxInsertText()   end

function TextEditBoxSetAllowEditing()   end
function TextEditBoxSetFont()   end
function TextEditBoxSetHandleKeyDown()   end
function TextEditBoxSetMaxChars()   end
function TextEditBoxSetText()   end
function TextEditBoxSetTextColor()   end]]
