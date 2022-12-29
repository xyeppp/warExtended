local warExtended = warExtended
local GameData = GameData
local GetGameTime = GetGameTime
local GetAbilityData = GetAbilityData
local Enemy = Enemy
local LastId = 0
local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert
local tsort = table.sort
local strchar = string.char
local strbyte = string.byte
local mmin = math.min
local mmax = math.max
local mfloor = math.floor
local strupper = string.upper
local mhuge = math.huge
local sformat = string.format
local wsformat = wstring.format
local tostring = tostring
local towstring = towstring
local tonumber = tonumber
local stringformat = string.format
local math = math
local GetTodaysDate = GetTodaysDate
local GetComputerTime = GetComputerTime
local lastID = 0
local type = type

function warExtended:CompareString(stringToCompare, stringToCheck)
	local stringBoundary = "%f[%w%p]%" .. stringToCompare .. "%f[%A]"
	local isMatch = stringToCheck:match(stringBoundary)
	return isMatch
end

function warExtended:GetMousePosition()
	local x, y = SystemData.MousePosition.x, SystemData.MousePosition.y
	return x, y
end

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

function warExtended:GetGameTime()
	local gameTime = GetGameTime()
	return gameTime
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
	if value == nil then
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

function warExtended:GetNewId()
	lastID = lastID + 1
	return lastID
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
  
  --[[for k, v in pairs (tbl)
  do
	if (type (v) == "table")
	then
	  tbl[k] = warExtended:Clone (v)
	end
  end]]
  
  warExtended:each (tbl, function (t, k, v)
	
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

function warExtended:ExtendTable(t1, t2)
	for key, val in pairs(t2) do
		if type(val) == "table" then
			if not t1[key] or type(t1[key]) ~= "table" then
				t1[key] = {}
			end

			warExtended:ExtendTable(t1[key], val)
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
			res[k] = warExtended:Clone(v)
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
				res[k] = warExtended:Clone2(v)
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

function warExtended:each(t, callback)
	if not t then
		return
	end

	for k, v in pairs(t) do
		callback(t, k, v)
		v = t[k] -- callback could set t[k] to nil, so we must get value again

		if type(v) == "table" then
			warExtended:each(v, callback, t)
		end
	end
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

function warExtended:GetTimeFromSeconds (t)
  
  if (not t) then return 0, 0, 0 end
  
  t = mfloor (t + 0.5)
  
  local d = mfloor (t / 86400.0)
  t = t - (d * 86400)
  local h = mfloor (t / 3600.0)
  t = t - (h * 3600)
  local m = mfloor (t / 60.0)
  t = t - (m * 60)
  local s = mfloor (t + 0.5)
  
  return d, h, m, s
end


function warExtended:GetCurrentDateInSeconds ()
  local d = GetTodaysDate ()
  return (d.todaysDay + (d.todaysMonth + d.todaysYear * 12) * 31) * 86400
end


function warExtended:GetCurrentDateInSecondsWithTime ()
  return self:GetCurrentDateInSeconds () + GetComputerTime ()
end


function warExtended:GetCurrentDateTime ()
  
  local t = GetComputerTime ()
  local d = GetTodaysDate ()
  local _d, h, m, s = self:GetTimeFromSeconds (t)
  local ts = t + (d.todaysDay + (d.todaysMonth + d.todaysYear * 12) * 31) * 86400
  
  return
  {
	year = d.todaysYear,
	month = d.todaysMonth,
	day = d.todaysDay,
	hours = h,
	minutes = m,
	seconds = s,
	totalSeconds = ts
  }
end


function warExtended:DateTimeToString (dt)
  
  local res = wsformat (L"%02d.%02d.%04d %02d:%02d:%02d",
		  dt.day,
		  dt.month,
		  dt.year,
		  dt.hours,
		  dt.minutes,
		  dt.seconds
  )
  
  return res
end

--[[local Ratio = Value / MaxValue
--Ratio = math.floor(ratio * 100 + 0.5) -- Round to nearest whole number.

local function percentage(count,goal)
  local percents = ((count - 1) * 100) / (goal - 1)
  return percents
end



]]
