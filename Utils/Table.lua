local warExtended = warExtended
local warExtended = warExtended
local pairs = pairs
local mfloor = math.floor
local type = type

function warExtended:ExtendTable(t1, t2)
  for key, val in pairs(t2) do
	if type(val) == "table" then
	  if not t1[key] or type(t1[key]) ~= "table" then
		t1[key] = {}
	  end

	  self:ExtendTable(t1[key], val)
	end

	if t1[key] == nil then
	  t1[key] = val
	end
  end
end

function warExtended:UpdateTable(t1, t2)
	for key, val in pairs(t2) do
		if type(val) == "table" then
			if not t1[key] or type(t1[key]) ~= "table" then
				t1[key] = {}
			end

			self:ExtendTable(t1[key], val)
		end

		if t1[key] == nil then
				t1[key] = val
		end
	end
end

function warExtended:CombineTable(t1, t2)
  local res = {}
  for _,v in pairs(t1) do
	res[#res+1] = v
  end

  for _,v in pairs(t2) do
	res[#res+1] = v
  end

  return res
end

function warExtended:Clone(t)
  if not t then
	return nil
  end
  if type(t) ~= "table" then
	return t
  end

  local res = {}

  for k, v in pairs(t) do
	if type(v) == "table" then
	  res[k] = self:Clone(v)
	elseif type(v) ~= "function" then
	  res[k] = v
	end
  end

  return res
end

function warExtended:Clone2(t)
  local res = {}

  if t then
	for k, v in pairs(t) do
	  if
	  (type(k) == "string" and k:sub(1, 1) == "_")
			  or (type(k) == "wstring" and k:sub(1, 1) == L"_")
			  or type(v) == "function"
	  then
		continue
	  end

	  if type(v) == "table" then
		res[k] = self:Clone2(v)
	  else
		res[k] = v
	  end
	end
  end

  return res
end

function warExtended:tableReverse(t)
  local max = #t
  local max_k = mfloor(max / 2)

  for k = 1, max_k do
	local tmp = t[k]
	local k2 = max - k + 1
	t[k] = t[k2]
	t[k2] = tmp
  end
end

function warExtended:Each(t, callback)
  if not t then
	return
  end

  for k, v in pairs(t) do
	callback(t, k, v)
	v = t[k] -- callback could set t[k] to nil, so we must get value again

	if type(v) == "table" then
	  self:Each(v, callback, t)
	end
  end
end