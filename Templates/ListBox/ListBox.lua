local warExtended = warExtended
local tsort       = table.sort
local pairs       = pairs
local mmod        = math.fmod
local type        = type

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
 
	function ListBox:SetDisplayOrder(tbl, orderFunction)
	  local displayOrder = {}
	
	  for index, state in pairs(tbl)
	  do
		if state then
		  displayOrder[#displayOrder + 1] = index
		end
	  end
	  
	  if ListBox:IsDisplayOrder(displayOrder, self:GetDisplayOrder()) then
		return
	  end
	  
	  self.m_displayOrder = displayOrder
	
	  if orderFunction then
		tsort(displayOrder, orderFunction)
	  end
	  
	  ListBoxSetDisplayOrder(self:GetName(), displayOrder)
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
			frame           = ButtonFrame:CreateFrameForExistingWindow(self:GetName() .. "Row" .. row)
			frame.m_Id      = row
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
	  
	  for row = 1, #self.m_selfTable.PopulatorIndices do
	  for rowFrame, _ in pairs(self.m_rowFrames) do
		  local frame  = GetFrame(self:GetName() .. "Row" .. row .. rowFrame)
		  frame:m_Callback(self:GetDataIndex(row))
		end
	  end
	end