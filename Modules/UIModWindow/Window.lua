local warExtended = warExtended
local UiMod = warExtendedUiMod
local WINDOW_NAME = "UiModWindow"

local LABEL = 1

local LIST_BOX = ListBox:Subclass(WINDOW_NAME.."ModsList")
local SEARCH_BOX=SearchEditBox:Subclass(WINDOW_NAME.."Search")

function warExtendedUiMod.OnInitialize()
	SEARCH_BOX = SEARCH_BOX:Create(WINDOW_NAME.."Search")
	LIST_BOX = LIST_BOX:CreateFrameForExistingWindow(WINDOW_NAME.."ModsList")
	SEARCH_BOX:CreateFrame()
end

local searchFilters = {
	name = {
		canSearch = function(self, operator, search)
			if not operator then
				return search
			end
		end,

		match = function(self, mod, _, search)
			local modName = mod.wideStrName
			return SEARCH_BOX:Find(search, modName)
		end
	},

	enabled = {
		tags = {L'e', L'enabled'},
		onlyTags = true,

		canSearch = function(self, operator, search)
			return not operator and true
		end,

		match = function(self, mod, _, search)
			local purchased = mod.isEnabled
			return search == purchased
		end
	},
}

function SEARCH_BOX:CreateFrame()
	self.m_Windows[LABEL]:SetText(L"Search:")
	self:AddCallback(LIST_BOX.OnTextChangedSearch)
	self:AddFilters(searchFilters)

	LIST_BOX:SetSelfTable(UiModWindowModsList)
end

function LIST_BOX.OnTextChangedSearch(results)
	modList = {}

	for _,id in ipairs(results) do
		if UiModWindow.ShouldShowType( UiModWindow.modsListData[id] ) and UiModWindow.ShouldShowCategory( UiModWindow.modsListData[id] )
		then
			modList[#modList+1] = id
		end
	end

	LIST_BOX:SetDisplayOrder(modList, UiModWindow.CompareMods)
end

warExtended:Hook(UiModWindow.OnShown, function()
	SEARCH_BOX:SetArticle(UiModWindow.modsListData)
end, true)

warExtended:Hook(UiModWindow.OnClickModListSortButton, function ()
	SEARCH_BOX:OnTextChanged(SEARCH_BOX:GetText())
end ,true)