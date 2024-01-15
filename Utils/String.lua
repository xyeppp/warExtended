local warExtended = warExtended
local strchar = string.char
local strbyte = string.byte
local strupper = string.upper
local tostring = tostring
local towstring = towstring
local math = math

function warExtended:CompareString(stringToCompare, stringToCheck)
  local stringBoundary = "%f[%w%p]%" .. stringToCompare .. "%f[%A]"
  local isMatch = stringToCheck:match(stringBoundary)
  return isMatch
end

function warExtended:toWString(str)
  if str ~= nil then
	return towstring(str)
  end
  return nil
end

function warExtended:FixString(str)
  if str == nil then
	return nil
  end
  
  local str = str
  local pos = str:find(L"^", 1, true)
  if pos then
	str = str:sub(1, pos - 1)
  end
  
  return str
end

function warExtended:toWStringOrEmpty(str)
  if str ~= nil then
	return towstring(str)
  end
  return L""
end

function warExtended:GetRandomString(len, letters)
  if letters == nil then
	letters = 26
  end
  local ch = strchar(strbyte("a") + math.random(letters) - 1)
  
  return ch:rep(len)
end

function warExtended:GetRandomString2(len, letters)
  if letters == nil then
	letters = 26
  end
  
  local res = ""
  for k = 1, len do
	res = res .. strchar(strbyte("a") + math.random(letters) - 1)
  end
  
  return res
end

function warExtended:toString(str)
  if str ~= nil then
	return tostring(str)
  end
  return nil
end

function warExtended:toStringUpper(str)
  if str ~= nil then
	return strupper(str)
  end
  return nil
end

function warExtended:toStringOrEmpty(str)
  if str ~= nil then
	return tostring(str)
  end
  return ""
end