local warExtended = warExtended
local UiMod = warExtendedUiMod
local WINDOW_NAME = "UiModWindow"

local LABEL = 1
local SETS = 2

local LIST_BOX = ListBox:Subclass("UiModWindowModsList")

local SEARCH_BOX=SearchEditBox:Subclass("UiModWindowSearch")

function warExtendedUiMod.OnInitialize()
	local FRAME = Frame:CreateFrameForExistingWindow(WINDOW_NAME)

	FRAME.OnSetChanged = function(self, setId, setContents)

		for index, modData in ipairs(setContents) do
			ModuleInitialize(modData.name)
			ModuleSetEnabled( modData.name, modData.isEnabled  )
		end

		--TODO: set listbox to setContents
		UiModWindow.MarkAsChanged()
		UiModWindow.UpdateEnableDisableAllButtons()

		--UiMod:Broadcast("reload interface")
	end

	FRAME.OnAddSet = function(...)
		return UiModWindow.modsListData
	end

	SEARCH_BOX = SEARCH_BOX:Create("UiModWindowSearch")
	LIST_BOX = LIST_BOX:CreateFrameForExistingWindow("UiModWindowModsList")
	SEARCH_BOX:CreateFrame()

	local setFrame = warExtendedDefaultSets:Create(WINDOW_NAME.."Sets", UiModWindow.Settings, FRAME, L"Add-On Sets")

	if not setFrame:GetSet(1) then
		setFrame:AddSet(UiModWindow.modsListData)
	end
end

-- This function is used to compare mods for table.sort() on
-- the mod list display order.

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
