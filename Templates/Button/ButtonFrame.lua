local warExtended = warExtended

	function ButtonFrame:SetStayDownFlag(flag)
	  ButtonSetStayDownFlag(self:GetName(), flag)
	end
 
	function ButtonFrame:IsDisabled()
	  local isDisabled = ButtonGetDisabledFlag(self:GetName())
	  return isDisabled
	end
 
	function ButtonFrame:SetDisabled(flag)
	  ButtonSetDisabledFlag(self:GetName(), flag)
	end
