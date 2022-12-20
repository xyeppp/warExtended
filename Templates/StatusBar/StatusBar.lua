local warExtended = warExtended


	function StatusBar:SetCurrentValue(value)
	value = value or 0
	 
	 self.m_currentValue = value
	 StatusBarSetCurrentValue(self:GetName(), value)
	end
	
	function StatusBar:GetCurrentValue()
	  return self.m_currentValue
	end
 
	function StatusBar:SetMaxValue(value)
	  value = value or 0
	  
	  self.m_maxValue = value
	  StatusBarSetMaximumValue(self:GetName(), value)
	end
 
	function StatusBar:GetMaxValue(value)
	  self.m_maxValue = value
	end
 
	function StatusBar:StopInterpolating()
	  StatusBarStopInterpolating(self:GetName())
	end
	
	function StatusBar:SetForegroundTint(color)
	  StatusBarSetForegroundTint(self:GetName(), color.r, color.g, color.b)
	end
	
	function StatusBar:SetBackgroundTint(color)
	  StatusBarSetBackgroundTint(self:GetName(), color.r, color.g, color.b)
	end
