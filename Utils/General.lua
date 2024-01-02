local warExtended = warExtended
local mmin = math.min
local mmax = math.max
local tonumber = tonumber
local stringformat = string.format
local math = math
local type = type

--TODO: merge all into Utils.lua

function math.percent(percent, maxvalue)
	if tonumber(percent) and tonumber(maxvalue) then
		return (maxvalue * percent) / 100
	end
	return false
end

function warExtended:IsPlayerWorldObjNum(worldObjNum)
	local isPlayerWorldObjNum = worldObjNum == warExtended:GetPlayerWorldObjNum()
	return isPlayerWorldObjNum
end

function warExtended:IsPlayerPetWorldObjNum(worldObjNum)
	local isPlayerPetWorldObjId = worldObjNum == warExtended:GetPlayerPetWorldObjNum()
	return isPlayerPetWorldObjId
end


---------------- ENEMY FUNCTIONS
function warExtended:UnpackRGB(v)
	return v.r, v.g, v.b
end

function warExtended:Round(n, digits)
	return tonumber(stringformat("%." .. (digits or 0) .. "f", n))
end

function warExtended:IsInteger(str)
	if str == nil or wstring.match(warExtended:toWString(str), L"^%s*([%-]?%d+)%s*") == nil then
		return false
	end
	return true
end

function warExtended:IsFloat(str)
	if str == nil or wstring.match(warExtended:toWString(str), L"^%s*([%-]?[%d%.]+)%s*") == nil then
		return false
	end
	return true
end

function warExtended:isNil(value, nilReturnValue)
	if value == nil or value == L"nil" or value == "nil" then
		return nilReturnValue
	end
	return value
end

function warExtended:isEmpty(value, emptyReturnValue)
	if not value or value:len() < 1 then
		return emptyReturnValue
	end
	return value
end

function warExtended:GetRandomNumber(min, max)
	min = min or 0
	max = max or 255

	return math.random(min, max)
end





function warExtended:ConvertToInteger(str)
	if not warExtended:IsInteger(str) then
		return nil
	end

	str = warExtended:trim(str)
	if str:len() > 10 then
		str = str:sub(1, 10)
	end

	return tonumber(str)
end

function warExtended:toNumber(str)
  if str ~= nil then
	return tonumber(str)
  end

  return nil
end

function warExtended:IsType(val, _type)
  return type(val) == _type
end

function warExtended:FixSettings (tbl)

  for k, v in pairs (tbl)
  do
	if (type (v) == "table")
	then
	  tbl[k] = warExtended:Clone (v)
	end
  end

  warExtended:Each (tbl, function (t, k, v)

	if (
			type (v) == "function"
					or
					(type (k) == "string" and k:sub (1, 1) == "_")
					or
					(type (k) == "wstring" and k:sub (1, 1) == L"_")
					or
					(type (v) == "number" and (v == math.huge or v == -math.huge))
	)
	then
	  t[k] = nil
	end
  end)
end




function warExtended:ConvertToFloat(str)
	if not warExtended:IsFloat(str) then
		return nil
	end

	str = warExtended:trim(str)
	if str:len() > 10 then
		str = str:sub(1, 10)
	end

	return tonumber(str)
end

function warExtended:FormatChannel(channel)
	local channel = warExtended:isNil(channel, "s")
	channel = stringformat("/%s", channel:gsub("/", ""))
	return channel
end

function warExtended:Capitalize(str)
	return str:sub(1, 1):upper() .. str:sub(2, str:len()):lower()
end

function warExtended:ConvertToPercent(str)
	local n = warExtended:ConvertToInteger(str)
	if not n then
		return nil
	end

	return warExtended:clamp(0, 100, n)
end

function warExtended:clamp(min, max, value)
	if value == nil then
		return nil
	end
	return mmax(min, mmin(max, value))
end

function warExtended:trim(str)
	if str == nil then
		return nil
	end

	if type(str) == "string" then
		local res = str:match("^%s*(.-)%s*$")
		if res then
			return res
		end
	elseif type(str) == "wstring" then
		local res = str:match(L"^%s*(.-)%s*$")
		if res then
			return res
		end
	end

	return str
end


--[[local Ratio = Value / MaxValue
--Ratio = math.floor(ratio * 100 + 0.5) -- Round to nearest whole number.

local function percentage(count,goal)
  local percents = ((count - 1) * 100) / (goal - 1)
  return percents
end



]]
