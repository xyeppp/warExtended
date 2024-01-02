ExpandableListBox = ListBox:Subclass()
local RowButton = ButtonFrame:Subclass()
local tsort = table.sort
local tins = table.insert
local ipairs = ipairs

local childEntry = {
	create = function(self, name, parentWindow, id)
		local newChildEntry = setmetatable({}, { __index = self })
		newChildEntry.childEntries = {}
		newChildEntry.id = id + 100
		newChildEntry.expanded = false
		newChildEntry.name = name
		newChildEntry.parentWindow = parentWindow
		newChildEntry.parentEntryId = id
		return newChildEntry
	end,

	createChild = function(self, name, parentWindow)
		self.childEntries[#self.childEntries + 1] = self:create(name, parentWindow, self.id)
	end,
}



local entry = {
	create = function(self, name, parentWindow, id)
		local newEntry = setmetatable({}, { __index = self })
		newEntry.name = name:gsub(L"warExtended ", L"")
		newEntry.addonName = name
		newEntry.expanded = false
		newEntry.parentEntryId = 0
		newEntry.parentWindow = parentWindow or false
		newEntry.childEntries = {}
		newEntry.id = id
		return newEntry
	end,

	createChild = function(self, name, entryWindow)
		self.childEntries[#self.childEntries + 1] = childEntry:create(name, entryWindow, self.id)
	end,
}

function ExpandableListBox:AddEntry(entryName, parentWindow, id)
	local id = #self.m_data+1
	local newEntry = entry:create(entryName, parentWindow, id)

	self.m_nameToId[entryName] = id
	self.m_data[id] = newEntry
end

function ExpandableListBox:AddChildEntry(parentName, entryName, entryWindow)
	--p(self.m_data)
	--p(self.m_nameToId)
	local entry = self.m_data[self.m_nameToId[parentName]]

	entry:createChild(entryName, entryWindow)
end

function ExpandableListBox:GetEntry(entryName)
	local entryId = self.m_nameToId[entryName]
	return self.m_data[entryId]
end


function ExpandableListBox:GetEntryParent(parentId)
	for i = 1, #self.m_rowToEntryMap do
		local optionEntry = self.m_rowToEntryMap[i]
		if optionEntry.id == parentId then
			return optionEntry
		end
	end
end

function RowButton:OnLButtonUp(flags, x, y)
	self:GetParent():DisplayRow(self:GetId())
end

function ExpandableListBox:SetSelfTable(dataTable)
  if not self.m_selfTable then
	self.m_selfTable = {}
	self.m_data = { }    -- data we receive from C
	self.m_listBoxData = {}     -- same data, but organized in such a way that ListBox can display it.
	self.m_orderTable = {}
	self.m_rowToEntryMap = {}
	self.m_numTotalRows = 0                -- this value is used to count how many rows are currently visible in the listbox
	self.m_lastPressedButtonId = 0
	self.m_nameToId = {}

  end

  self.m_selfTable = dataTable
end




function ExpandableListBox:SetEntrySelectedById(id, selected)
	for row = 1, self.m_selfTable.numVisibleRows do
		local idx = self:GetDataIndex(row)
		local data = self.m_rowToEntryMap[idx]
		if data and data.id == self.m_lastPressedButtonId then
			ButtonSetPressedFlag(self:GetName().."Row"..row.."Name", selected ) -- set ne
		end
	end
end

function ExpandableListBox:ResetPressedButton()
	self:SetEntrySelectedById( self.m_lastPressedButtonId, false )
end

function ExpandableListBox:DisplayRow(rowIndex)
	local idx = self:GetDataIndex(rowIndex)
	local entryData = self.m_rowToEntryMap[idx]

	entryData.expanded = not entryData.expanded

	self:ResetPressedButton()
	self.m_lastPressedButtonId = entryData.id

	ButtonSetPressedFlag(self:GetName().."Row"..rowIndex.."Name", true ) -- set

	self:DisplayManualEntry(entryData) -- display text for the just selected entry
	self:PrepareData()
end

function ExpandableListBox:PrepareData()
	-- reset tables and counters that are going to be used later on
	self.m_orderTable = {}
	self.m_selfTable.ListBoxData = {}
	self.m_ListBoxData = {}
	self.m_numTotalRows = 1 -- more of an index than row counter
	self.m_rowToEntryMap = {}

	if not self.m_data then
		return -- quit if we have no data to work on.
	end

	local function AddEntryAsRow(entryIndex, entryData, depth)
		local entryTable = { name = entryData.name, depth = depth }
		tins(self.m_selfTable.ListBoxData, self.m_numTotalRows, entryTable)
		tins(self.m_orderTable, self.m_numTotalRows)
		tins(self.m_rowToEntryMap, self.m_numTotalRows, entryData)

		self.m_numTotalRows = self.m_numTotalRows + 1

		if entryData.expanded then
			-- entry is expanded so add children as rows, recursively
			for childEntryIndex, childEntryData in ipairs(entryData.childEntries) do
				AddEntryAsRow(childEntryIndex, childEntryData, depth + 1)
			end
		end
	end

	for entryIndex, entryData in ipairs(self.m_data) do
		AddEntryAsRow(entryIndex, entryData, 0)
	end

	self:SetDisplayOrder(self.m_orderTable)
	self:SetRowTints()
end

--- Updates the ListBox element - sets button pressed state and anchors subEntries accordingly.
--- Needs to be called OnPopulating the ListBox in order for it to work correctly.
function ExpandableListBox:UpdateOptionsWindowRow()
	for row = 1, self.m_selfTable.numVisibleRows do
		local rowWindow = self:GetName().."Row" .. row

		if not GetFrame(rowWindow) then
			local rowFrame = RowButton:CreateFrameForExistingWindow(rowWindow)
			rowFrame.m_Id = row
		end

		local index = self:GetDataIndex(row)
		local data = self.m_rowToEntryMap[index]

		if data ~= nil then
			if self.m_lastPressedButtonId == data.id then
				ButtonSetPressedFlag(rowWindow .. "Name", true) -- set newly selected entry as pressed
			else
				ButtonSetPressedFlag(rowWindow .. "Name", false)
			end

			local hasChildEntries = #data.childEntries > 0
			WindowSetShowing(rowWindow .. "PlusButton", hasChildEntries and not data.expanded)
			WindowSetShowing(rowWindow .. "MinusButton", hasChildEntries and data.expanded)

			local depth = self.m_selfTable.ListBoxData[index].depth
			WindowClearAnchors(rowWindow .. "Name")
			WindowAddAnchor(rowWindow .. "Name", "left", rowWindow, "left", 30 + (15 * depth), 6)
		end
	end
end

--- Use to set define your own function of what happens when an entry gets pressed.
-- @@param entryData gets passed from the ListBox with your own entries.
function ExpandableListBox:DisplayManualEntry(entryData)
	--[[
	local entryText = EA_Window_HelpGetEntryData( entryData.id )
	LabelSetText( "ManualWindowTopicLabel", entryData.name )        -- display the title for the entry
	LabelSetText( "ManualWindowMainText", entryText.text )-- display the entry's text
	ScrollWindowSetOffset( "ManualWindowMain", 0 )        -- reset the scroll bar.
	ScrollWindowUpdateScrollRect("ManualWindowMain")      -- reset the scroll bar.
 ]]--
end
