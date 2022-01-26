-- LinkedList from Enemy addon

local pairs = pairs
local g = {}

warExtendedLinkedList = {}
warExtendedLinkedList.__index = warExtendedLinkedList


function warExtendedLinkedList.New (copySource)
  local obj = {}
  setmetatable (obj, warExtendedLinkedList)
  
  obj:Clear ()
  
  if (copySource)
  then
	local item = copySource.first
	while (item)
	do
	  obj:Add (item.key, item.data)
	  item = item.next
	end
  end
  
  return obj
end


function warExtendedLinkedList:Clear (disposeCallback)
  
  if (disposeCallback)
  then
	local item = self.first
	while (item)
	do
	  disposeCallback (item.data)
	  item = item.next
	end
  end
  
  self.first = nil
  self.last = nil
  self.keys = {}
end


function warExtendedLinkedList:Add (key, data)
  
  if (not data)
  then
	data = key
	key = nil
  end
  
  return self:InsertAfter (nil, key, data)
end

function warExtendedLinkedList:InsertAfter (obj, key, data)
  
  if (not data)
  then
	data = key
	key = nil
  end
  
  if (key)
  then
	local old_obj = self.keys[key]
	if (old_obj)
	then
	  old_obj.data = data
	  return old_obj
	end
  end
  
  local new_obj =
  {
	key = key,
	data = data,
	_prev = nil,
	_next = nil
  }
  
  if (not obj and self.last)
  then
	obj = self.last
  end
  
  if (obj)
  then
	new_obj.next = obj.next
	obj.next = new_obj
	
	new_obj.prev = obj
	
	if (obj == self.last)
	then
	  self.last = new_obj
	end
  else
	self.last = new_obj
	self.first = new_obj
  end
  
  if (key)
  then
	self.keys[key] = new_obj
  end
  
  return new_obj
end


function warExtendedLinkedList:InsertBefore (obj, key, data)
  
  if (not data)
  then
	data = key
	key = nil
  end
  
  if (key)
  then
	local old_obj = self.keys[key]
	if (old_obj)
	then
	  old_obj.data = data
	  return old_obj
	end
  end
  
  local new_obj =
  {
	key = key,
	data = data,
	_prev = nil,
	_next = nil
  }
  
  if (not obj and self.first)
  then
	obj = self.first
  end
  
  if (obj)
  then
	new_obj.prev = obj.prev
	obj.prev = new_obj
	
	new_obj.next = obj
	
	if (obj == self.first)
	then
	  self.first = new_obj
	end
  else
	self.last = new_obj
	self.first = new_obj
  end
  
  if (key)
  then
	self.keys[key] = new_obj
  end
  
  return new_obj
end

function warExtendedLinkedList:Get (key)
  return self.keys[key]
end

function warExtendedLinkedList:Remove (obj)
  
  if (type (obj) ~= "table")
  then
	obj = self.keys[obj]
  end
  
  if (obj == nil or obj.isRemoved) then return end
  
  local p = obj.prev
  local n = obj.next
  
  if (p) then p.next = n end
  if (n) then n.prev = p end
  
  if (obj == self.first)
  then
	self.first = n
  end
  
  if (obj == self.last)
  then
	self.last = p
  end
  
  if (obj.key)
  then
	self.keys[obj.key] = nil
  end
  
  obj.isRemoved = true
end


function warExtendedLinkedList:Count ()
  
  local count = 0
  
  for k, v in pairs (self.keys)
  do
	count = count + 1
  end
  
  return count
end


function warExtendedLinkedList:DebugPrint ()
  
  local item = self.first
  
  d ("================================================")
  
  while (item)
  do
	d (item.data)
	item = item.next
	
	if (item)
	then
	  d ("------------------------------------------------")
	end
  end
  
  d ("================================================")
end




function warExtendedLinkedList:DebugPrintKeys ()
  
  local item = self.first
  
  d ("================================================")
  
  while (item)
  do
	d (tostring (item.key or "nil"))
	item = item.next
  end
  
  d ("================================================")
end


function warExtendedLinkedList:DebugPrintCount ()
  
  local item = self.first
  local k = 0
  
  while (item)
  do
	item = item.next
	k = k + 1
  end
  
  d (k)
end


