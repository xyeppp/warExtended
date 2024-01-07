local warExtended           = warExtended
local WINDOW_NAME           = "TerminalAbilityFinder"
local SEARCH_LABEL          = 1
local SEARCH_LIST_WINDOW    = 2
local SEARCH_EDITBOX        = 3
local SORT_BUTTON_1         = 4
local SORT_BUTTON_2         = 5
local TITLEBAR              = 6

local TerminalAbilityFinder = TerminalAbilityFinder

local WINDOW                = Frame:Subclass(WINDOW_NAME)
local SEARCH_LIST           = ListBox:CreateFrameForExistingWindow(WINDOW_NAME .. "AbilityList")
local SEARCH_BOX            = SearchEditBox:Create(WINDOW_NAME .. "AbilitySearch")

--function SEARCH_BOX:OnTextChanged(...)
--	p(...)
--end

local searchFilters         = {
  isAbility = {
	canSearch = function(self, operator, search)
	  return not operator and search
	end,

	match = function(self, article, operator, search)
	  return SEARCH_BOX:Find(search, article)
	end
  },
}

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  SEARCH_LIST:SetSelfTable(TerminalAbilityFinderAbilityList)

  self.m_Windows = {
	[SEARCH_LIST_WINDOW] = SEARCH_LIST,
	[SEARCH_EDITBOX] = SEARCH_BOX,
	[SORT_BUTTON_1] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "IDSortButton"),
	[SORT_BUTTON_2] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "NameSortButton"),
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel")
  }

  local win      = self.m_Windows

  win[SORT_BUTTON_1]:SetText(L"ID")
  win[SORT_BUTTON_2]:SetText(L"Name")
  win[TITLEBAR]:SetText(L"Ability Finder")

  win[SEARCH_EDITBOX].m_Windows[SEARCH_LABEL]:SetText(L"Search:")
  win[SEARCH_EDITBOX]:AddCallback(SEARCH_LIST.OnTextChangedSearch)
  win[SEARCH_EDITBOX]:AddFilters(searchFilters)
  win[SEARCH_EDITBOX]:AddFilters(searchFilters)


  win[SEARCH_LIST_WINDOW]:SetRowDefinition()
end

local a = {}

function SEARCH_LIST.OnTextChangedSearch(searchResults)
   SEARCH_LIST:SetDisplayOrder(searchResults)
end

function SEARCH_LIST:SetRowDefinition()
  local settings  = TerminalAbilityFinder:GetSettings()

  local labelData = {
	["AbilityID"] = { subclass = Label, callback = function(self, index)
	  self:SetText(index)
	end },
	["AbilityName"] = { subclass = Label, callback = function(self, index)
	  local abilityName = settings.abilityCache[index]
	  self:SetText(abilityName)
	end },
	["AbilityDescription"] = { subclass = Label, callback = function(self, index)
	  local abilityDescription = GetAbilityDescription(index, 40)

	  if abilityDescription == L"" then
		abilityDescription = L"No description."
	  end

	  self:SetText(abilityDescription)
	end },
  }

  self:SetRowPopulation(labelData)
end

function TerminalAbilityFinder.OnPopulateSearch()
  SEARCH_LIST:SetRowData()
  SEARCH_LIST:SetRowTints()
end

function TerminalAbilityFinder.UpdateDisplay()
  if SEARCH_LIST.m_selfTable == nil then
	return
  end

  if SEARCH_BOX:TextAsWideString() == L"" then
	local abilityCache = TerminalAbilityFinder:GetSettings().abilityCache
	SEARCH_LIST:SetDisplayOrder(abilityCache, function(a, b) return a < b end)
  end

end

WINDOW:Create()
