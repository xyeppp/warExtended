local tsort      = table.sort
local tins       = table.insert
local pairs      = pairs
local mmod       = math.fmod

local SortButton = ButtonFrame:Subclass()
local UP_ARROW   = 1
local DOWN_ARROW = 2

function SortButton:Create(parentName, id, buttonData, listBoxFrame)
  local sortButton = self:CreateFrameForExistingWindow(parentName .. "SortButton" .. id)

  if sortButton then
	sortButton.m_listBox = listBoxFrame
	sortButton.m_sortFunc = buttonData.sortFunc

	sortButton.m_Arrows  = {
	  [UP_ARROW] = DynamicImage:CreateFrameForExistingWindow(sortButton:GetName() .. "UpArrow"),
	  [DOWN_ARROW] = DynamicImage:CreateFrameForExistingWindow(sortButton:GetName() .. "DownArrow")
	}

	sortButton:SetDisabled(sortButton.m_sortFunc == nil)
	sortButton:SetId(id)
	sortButton:SetText(buttonData.text)
	sortButton:ClearArrows()

	sortButton.OnLButtonUp = function(self, flags, x, y)
		if self:IsDisabled() then
			return
		end

	  local listBox = GetFrame(self.m_listBox)
	  local oldSort = GetFrame(parentName .. "SortButton" .. listBox.m_sortColumnId)
	  oldSort:ClearArrows()

	  if self:GetId() == listBox.m_sortColumnId then
		listBox.m_reverseDisplayOrder = not listBox.m_reverseDisplayOrder
	  else
		listBox.m_reverseDisplayOrder = false
	  end

	  listBox.m_sortColumnId = self:GetId()

	  self:SetArrows()

	  listBox:SetDisplayOrder(listBox.m_listDataTable, self:GetSortFunc())
	end

	return sortButton
  end
end

function SortButton:SetArrows()
  local listBox = GetFrame(self.m_listBox)
  self.m_Arrows[UP_ARROW]:Show(listBox.m_reverseDisplayOrder)
  self.m_Arrows[DOWN_ARROW]:Show(not listBox.m_reverseDisplayOrder)
end

function SortButton:ClearArrows()
  self.m_Arrows[UP_ARROW]:Show(false)
  self.m_Arrows[DOWN_ARROW]:Show(false)
end

function SortButton:GetSortFunc()
  return self.m_sortFunc
end

ListBox = Frame:Subclass()

function ListBox:GetSelfTable()
  return self.m_selfTable
end

function ListBox:SetSelfTable(dataTable)
  if not self.m_selfTable then
	self.m_selfTable = {}
  end

  self.m_selfTable = dataTable
end

function ListBox:SetDataTableList(dataTable)
  ListBoxSetDataTable(self:GetName(), dataTable)
end

function ListBox:SetVisibleRowCount(rowCount)
  ListBoxSetVisibleRowCount(self:GetName(), rowCount)
end

function ListBox:GetPopulatorIndices()
  return self.m_selfTable.PopulatorIndices
end

function ListBox:GetDataTable()
  return self.m_selfTable.Table
end

function ListBox:GetDataIndex(row)
  local dataIndex = ListBoxGetDataIndex(self:GetName(), row)
  return dataIndex
end

function ListBox:GetDisplayOrder()
  return self.m_displayOrder
end

function ListBox:IsDisplayOrder(a, b)
  return a == b
end

function ListBox:SetSortButtons(sortButtons, parentName, defaultSortId)
  self.m_sortColumnId        = defaultSortId or 1
  self.m_reverseDisplayOrder = true;

  self.m_sortButtons         = {}

  for id, buttonData in pairs(sortButtons) do
	self.m_sortButtons[id] = SortButton:Create(parentName, id, buttonData, self:GetName())
  end

  self.m_sortButtons[self.m_sortColumnId]:SetArrows()
  self.m_sortButtons[self.m_sortColumnId]:OnLButtonUp()
end

--function ListBox:

function ListBox:GetSortFunc(sortId)
  return self.m_sortButtons[sortId].m_sortFunc
end

function ListBox:SetDisplayOrder(tbl, orderFunction)
  if not tbl then
	return
  end

	self.m_listDataTable = tbl
	--if not self.m_listDataTable then
--		self.m_listDataTable = tbl

--	end
	self.m_displayOrder  = {}

	for index, state in pairs(tbl)
	do
		if state then
			self.m_displayOrder[#self.m_displayOrder + 1] = state
		end
	end

	-- tbl from search results gets turned into displayorder based on false/true - pointless, should return table with object and display order so there's no need to turn it
--[[  for index, state in pairs(tbl)
  do
	if state then
	  displayOrder[#displayOrder + 1] = index
	end
  end]]

  --if ListBox:IsDisplayOrder(displayOrder, self:GetDisplayOrder()) then
	--return
 -- end

  --self.m_displayOrder = displayOrder

--fix : search returns table of [1] = index whereas listDataTable can be original set in displayorder
  ------WORKS BUT YOU NEED TO FIGURE OUT HOW IT INTERACTS WITH SEARCH

  local sortingOrder  = {}
  if orderFunction or self.m_sortColumnId then
	orderFunction = orderFunction or self:GetSortFunc(self.m_sortColumnId)
	tsort(self.m_listDataTable, orderFunction)

	for index, id in pairs(self.m_listDataTable ) do
	  if self.m_reverseDisplayOrder then
		tins(sortingOrder, 1, id)
	  else
		tins(sortingOrder, id)
	  end
	end

	ListBoxSetDisplayOrder(self:GetName(), sortingOrder)
	return
  end

  ListBoxSetDisplayOrder(self:GetName(), self.m_displayOrder)
end

function ListBox:RowCallback(func, frame, ...)
  local dataIndex = self:GetDataIndex(frame:GetId())
  func(dataIndex, frame, ...)
end

function ListBox:SetRowCallbacks(frameCallbacks)
  for event, callbackFunction in pairs(frameCallbacks) do
	local callback = function(frame, ...) self:RowCallback(callbackFunction, frame, ...) end

	for row = 1, self.m_selfTable.numVisibleRows do
	  local frame = GetFrame(self:GetName() .. "Row" .. row)
	  if not frame then
		frame      = ButtonFrame:CreateFrameForExistingWindow(self:GetName() .. "Row" .. row)
		frame.m_Id = row
	  end

	  frame[event] = callback
	end
  end
end

function ListBox:SetRowTints(colorTable)
  if not self:GetSelfTable() then
	return
  end

  for row = 1, self.m_selfTable.numVisibleRows do
	local targetRowWindow = self:GetName() .. "Row" .. row
	local row_mod         = 0
	local color

	row_mod               = mmod(row, 2)

	if colorTable ~= nil then
	  color = colorTable[row_mod]
	else
	  color = DataUtils.GetAlternatingRowColor(row_mod)
	end

	WindowSetTintColor(targetRowWindow .. "Background", color.r, color.g, color.b)
	WindowSetAlpha(targetRowWindow .. "Background", color.a)
  end
end

function ListBox:SetRowPopulation(rowData)
  if not self.m_rowFrames then
	self.m_rowFrames = {}
  end

  for rowFrame, rowDef in pairs(rowData) do
	self.m_rowFrames[rowFrame] = true
	for visibleRow = 1, self.m_selfTable.numVisibleRows do
	  local frameSubclass = rowDef.subclass
	  local frameCallback = rowDef.callback

	  local frame         = GetFrame(self:GetName() .. "Row" .. visibleRow .. rowFrame)

	  if not frame then
		frame            = frameSubclass:CreateFrameForExistingWindow(self:GetName() .. "Row" .. visibleRow .. rowFrame)
		frame.m_Callback = frameCallback
	  end
	end
  end
end

function ListBox:SetRowData()
  if not self:GetSelfTable() then
	return
  end

	for row = 1, #self:GetPopulatorIndices() do
		for rowFrame, _ in pairs(self.m_rowFrames) do
			local frame = GetFrame(self:GetName() .. "Row" .. row .. rowFrame)
			frame:m_Callback(self:GetDataIndex(row))
		end
	end
end