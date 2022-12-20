local warExtended=warExtended
local WINDOW_NAME = "TerminalCareerCacher"
local SEARCH_LABEL = 1
local ADVANCE_LIST = 2
local ADVANCE_OUTPUT = 3
local CATEGORY_COMBOBOX = 4
local CATEGORY_COMBOLABEL = 5
local LOG_BUTTON = 6
local SEARCH_BOX = 7
local CIRCLE_ICON =8
local CIRCLE_LABEL = 9
local TITLEBAR = 10
local REFRESH_BUTTON = 11



	local TerminalCareerCacher = TerminalCareerCacher
	local WINDOW = Frame:Subclass(WINDOW_NAME)
	local ADVANCES_FRAME = ListBox:CreateFrameForExistingWindow(WINDOW_NAME.."OutputAdvancesList")
	local SEARCH_FRAME = SearchEditBox:Create(WINDOW_NAME.."OutputAdvancesSearch", TerminalCareerCacher:GetSettings().advanceData)
	local OUTPUT_FRAME = TextEditBox:CreateFrameForExistingWindow(WINDOW_NAME.."OutputText")
	local CIRCLE_FRAME = CircleImage:CreateFrameForExistingWindow(WINDOW_NAME.."OutputCareerIconImage")
	local COMBO_FRAME = ComboBox:CreateFrameForExistingWindow(WINDOW_NAME.."OutputCategorySelect")
	local LOG_BUTTON_FRAME = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME.."OutputSaveToLog")
	local REFRESH_BUTTON_FRAME = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME.."OutputRefresh")
 
	local searchFilters = {
	  name = {
		canSearch = function(self, operator, search)
		  if not operator then
			return search
		  end
		end,
	 
		match = function(self, item, _, search)
		  local advanceName = item.advanceName
		  return SEARCH_FRAME:Find(search, advanceName)
		end
	  },
	
	  value = {
		tags = {L't', L'type'},
		onlyTags=true,
		
		canSearch = function(self, operator, search)
		  return operator and tonumber(search)
		end,
	 
		match = function(self, item, operator, num)
		  local advanceType = item.advanceType
		  p(advanceType, num, "HERE")
		  return SEARCH_FRAME:Compare(operator, advanceType, num)
		end
	  },
	
	  purchased = {
		tags = {L'p', L'purchased'},
		onlyTags = true,
	 
		canSearch = function(self, operator, search)
		  return not operator and tonumber(search)
		end,
	 
		match = function(self, item, _, num)
		  local purchased = item.timesPurchased
		  return SEARCH_FRAME:Compare(L"==", purchased, num)
		end
	  },
	}
	
	function WINDOW:Create()
	  self:CreateFromTemplate(WINDOW_NAME)
	  ADVANCES_FRAME:SetSelfTable(TerminalCareerCacherOutputAdvancesList)
	  
	  if not CIRCLE_FRAME.m_Windows then
		CIRCLE_FRAME.m_Windows = {
		  [CIRCLE_LABEL] = Label:CreateFrameForExistingWindow(CIRCLE_FRAME:GetName().."Label")
		}
	  end
	  
	  if not COMBO_FRAME.m_Windows then
		COMBO_FRAME.m_Windows = {
		  [CATEGORY_COMBOLABEL] = Label:CreateFrameForExistingWindow(COMBO_FRAME:GetName().."Label")
		}
	  end
	  
	  
	  self.m_Windows = {
		[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME.."TitleBarLabel"),
		[CIRCLE_ICON] = CIRCLE_FRAME,
		[ADVANCE_LIST] = ADVANCES_FRAME,
		[ADVANCE_OUTPUT] = OUTPUT_FRAME,
		[CATEGORY_COMBOBOX] = COMBO_FRAME,
		[LOG_BUTTON] = LOG_BUTTON_FRAME,
		[REFRESH_BUTTON] = REFRESH_BUTTON_FRAME,
		[SEARCH_BOX] = SEARCH_FRAME
	  }
	  
	  local win = self.m_Windows
	  
	  win[TITLEBAR]:SetText(L"Career Cacher")
	  
	  local careerName = warExtended:toWString(warExtended:GetCareerName())
	  local texture, _, _ = GetIconData(warExtended:GetCareerIcon())
	  
	  win[CIRCLE_ICON]:SetTexture(texture, 16, 16)
	  win[CIRCLE_ICON].m_Windows[CIRCLE_LABEL]:SetText(careerName)
	  
	  win[CATEGORY_COMBOBOX].m_Windows[CATEGORY_COMBOLABEL]:SetText(L"Category")
	  
	  if win[ADVANCE_OUTPUT]:TextAsWideString()==L"" then
		win[ADVANCE_OUTPUT]:SetTextCache("Hover over an entry to see more information.")
	  end
	  
	  win[LOG_BUTTON]:SetText(L"Save To Log")
	  win[REFRESH_BUTTON]:SetText(L"Refresh")
	  
	  win[ADVANCE_LIST]:SetRowDefinition()
	  
	  win[SEARCH_BOX].m_Windows[SEARCH_LABEL]:SetText(L"Search:")
	  win[SEARCH_BOX]:AddCallback(ADVANCES_FRAME.OnTextChangedSearch)
	  win[SEARCH_BOX]:AddFilters(searchFilters)
	end
	
	function WINDOW:OnRButtonUp()
	  EA_Window_ContextMenu.CreateOpacityOnlyContextMenu(WINDOW_NAME)
	end
	
	function LOG_BUTTON_FRAME:OnLButtonUp()
	  p("saving to log placeholder")
	end
	
	function REFRESH_BUTTON_FRAME:OnLButtonUp()
	  TerminalCareerCacher.UpdateDisplay()
	  p("refresh placeholder")
	end
	
	function COMBO_FRAME:OnSelected()
	  p("placeholder add to frame manager")
	end
	
	function ADVANCES_FRAME.OnTextChangedSearch(searchResults)
	  ADVANCES_FRAME:SetDisplayOrder(searchResults, function(a,b) return a<b  end)
	end
	
	function ADVANCES_FRAME.OnMouseOverAdvance(idx, frame, ...)
	  local advance=TerminalCareerCacher:GetSettings().advanceData[idx]
	  
	  local tooltipAnchor = { Point="bottomright", RelativeTo=WINDOW_NAME, RelativePoint="bottomleft", XOffset=18, YOffset=0 }
	  local extraText=L"Purchase count: "..advance.timesPurchased..L"\nPoint cost: "..advance.pointCost..L"\nRight-click to attempt to purchase."
	  
		if (advance.advanceType == GameData.AdvanceType.ABILITY)
		then
		  Tooltips.CreateAbilityTooltip( advance.abilityInfo, frame:GetName(),
				  tooltipAnchor, extraText)
		  
		elseif (advance.advanceType == GameData.AdvanceType.SPEC)
		then
		  warExtended:CreateTextTooltip(frame:GetName(), {
			[1]={{text = advance.advanceName, color=Tooltips.COLOR_HEADING}},
			[2]={{text=L"Type: Spec ("..advance.advanceType..L")"}},
		  }, extraText, tooltipAnchor)
		  
		elseif (advance.advanceType == GameData.AdvanceType.STAT)
		then
		  warExtended:CreateTextTooltip(frame:GetName(),{
			[1] ={{text = advance.advanceName, color=Tooltips.COLOR_HEADING}},
			[2] ={{text=L"Type: Stat ("..advance.advanceType..L")"}},
			[3] ={{text=L"Value: "..advance.advanceValue}},
		  }
		  , extraText, tooltipAnchor)
		  
		elseif (advance.advanceType == GameData.AdvanceType.BONUS)
		then
		  warExtended:CreateTextTooltip(frame:GetName(),{
			[1] ={{text = advance.advanceName, color=Tooltips.COLOR_HEADING}},
			[2] ={{text=L"Type: Bonus ("..advance.advanceType..L")"}},
			[3] ={{text=L"Value: "..advance.advanceValue}},
		  }
		  , extraText, tooltipAnchor)
		end
	  
	  OUTPUT_FRAME:SetOutputText(advance)
	  end
	  
	  function ADVANCES_FRAME.OnRButtonUpAdvance(idx, _,...)
		local advance = TerminalCareerCacher:GetSettings().advanceData[idx]
		BuyCareerPackage(advance.tier, advance.category, advance.packageId )
	  end
	
	function ADVANCES_FRAME:SetRowDefinition()
	  local rowCallbacks={
		["OnMouseOver"]=ADVANCES_FRAME.OnMouseOverAdvance,
		["OnRButtonUp"]=ADVANCES_FRAME.OnRButtonUpAdvance
	  }
	  
	  
	  local labelData = {
		["Square"] = { subclass=DynamicImage, callback=function(self, index)
		  local advanceData = TerminalCareerCacher:GetSettings().advanceData[index]
		  local icon = advanceData.advanceIcon
		  
		  if icon ~= 0 then
			local texture,x,y = GetIconData(icon)
			self:SetTexture(texture, x, y)
		  end
		end },
		["Details1"] = {subclass=Label, callback=function(self, index)
		  local advanceData = TerminalCareerCacher:GetSettings().advanceData[index]
		  local identifierText = L"CC "..advanceData.category..L", tier "..advanceData.tier..L", ID "..advanceData.packageId
		  self:SetText(identifierText)
		end},
		["Details2"] = {subclass=Label, callback=function(self, index)
		  local advanceData = TerminalCareerCacher:GetSettings().advanceData[index]
		  local purchaseText = L""..advanceData.timesPurchased..L"/"..advanceData.maximumPurchaseCount..L": Min Level "..advanceData.minimumRank..L", Min Renown "..advanceData.minimumRenown
		  self:SetText(purchaseText)
		end},
	  }
	  
	  self:SetRowCallbacks(rowCallbacks)
	  self:SetRowPopulation(labelData)
	end
	
	function OUTPUT_FRAME:SetOutputText(data)
	  local str = objToString(data)
	  self:SetTextCache(str)
	end
	
	  
	  function TerminalCareerCacher.UpdateDisplay()
		local advanceTable = TerminalCareerCacher:GetSettings().advanceData

		ADVANCES_FRAME:SetDisplayOrder(advanceTable)
	  end
	  
	  function TerminalCareerCacher.OnPopulateAdvances()
		ADVANCES_FRAME:SetRowData()
		ADVANCES_FRAME:SetRowTints()
	  end
	  
	  
	  
	  
	  
	  WINDOW:Create()
