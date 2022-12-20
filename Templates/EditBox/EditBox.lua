local warExtended = warExtended

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
