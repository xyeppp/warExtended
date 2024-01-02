local warExtended = warExtended
local select = select

local events = {}

function warExtended:AddEventHandler(key, name, callback)
	if not callback then
		d("Wrong arguments for AddEventHandler: " .. key .. ", " .. name .. ", " .. type(callback))
	end

	warExtended:RemoveEventHandler(key, name)

	local e = events[name]
	if e == nil then
		e = warExtendedLinkedList.New()
		events[name] = e
	end

	e:Add(key, callback)
end

function warExtended:TriggerEvent(name, ...)
	local e = events[name]
	if e == nil then
		return
	end

	local item = e.first
	while item do
		item.data(select(1, ...))
		item = item.next
	end
end

function warExtended:GetEvent(key, name)
	local e = events[name]
	if e == nil then
		return
	end
	local item = e:Get(key)
	return item
end

function warExtended:RemoveEventHandler(key, name, func)
	local e = events[name]
	if e == nil then
		return
	end
	e:Remove(key)

  if func ~= nil then
	func = nil
  end
end







