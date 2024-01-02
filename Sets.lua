local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert
local tstring = tostring
local setmetatable = setmetatable
local getmetatable = getmetatable
local warExtended = warExtended

warExtendedSet = {}
warExtendedSet.mt = {__index = warExtendedSet}

function warExtendedSet:New(values)
  local instance = {}
  local isSet if getmetatable(values) == warExtendedSet.mt then isSet = true end

  if warExtended:IsType(values, "table") then
    if not isSet and #values > 0 then
      for _,v in ipairs(values) do
        instance[v] = true
      end
    else
      for k in pairs(values) do
        instance[k] = true
      end
    end
  elseif values ~= nil then
    instance = {[values] = true}
  end

  return setmetatable(instance, warExtendedSet.mt)
end

function warExtendedSet:Wrap(existingSet)
  return setmetatable(existingSet, warExtendedSet.mt)
end

function warExtendedSet:Add(e, v)
  if e ~= nil then self[e] = v or true end
  return self
end

function warExtendedSet:Remove(e)
  if e ~= nil then self[e] = nil end
  return self
end

function warExtendedSet:Anelement()
  for e in pairs(self) do
    return e
  end
end

function warExtendedSet:Has(e)
  if self[e] == nil then
    return false
  else
    return true
  end
end

function warExtendedSet:Get(e)
  if self[e] ~= nil then
    return self[e]
  end
end

-- Union
warExtendedSet.mt.__add = function (a, b)
  local res, a, b = warExtendedSet:New(), warExtendedSet:New(a), warExtendedSet:New(b)
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

-- Subtraction
warExtendedSet.mt.__sub = function (a, b)
  local res, a, b = warExtendedSet:New(), warExtendedSet:New(a), warExtendedSet:New(b)
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = nil end
  return res
end

-- Intersection
warExtendedSet.mt.__mul = function (a, b)
  local res, a, b = warExtendedSet:New(), warExtendedSet:New(a), warExtendedSet:New(b)
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

-- String representation
warExtendedSet.mt.__tostring = function (set)
  local s = "{"
  local sep = ""
  for k in pairs(set) do
    s = s .. sep .. tstring(k)
    sep = ", "
  end
  return s .. "}"
end

function warExtendedSet:Len()
  local num = 0
  for _ in pairs(self) do
    num = num + 1
  end
  return num
end

function warExtendedSet:ToList()
  local res = {}
  for k in pairs(self) do
    tinsert(res, k)
  end
  return res
end