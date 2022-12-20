local warExtendedTerminal       = warExtendedTerminal
local TextLogAddSingleByteEntry = TextLogAddSingleByteEntry
local TextLogAddEntry           = TextLogAddEntry
local log                       = "UiLog"
local tableConcat               = table.concat

local outputs                   = {
  print = 10,
  input = 9,
  event = 11
}

local function printOutput(outputType, msg)
  if outputType == "event" then
	TextLogAddSingleByteEntry(log, outputs[outputType], msg)
  else
	TextLogAddEntry(log, outputs[outputType], msg)
  end
end

local function printTable(t, indent, tableHistory)
  DUMP_TABLE_TO(t, print, indent, tableHistory)
end

local function print(...)
  for msgIndex, message in ipairs(arg)
  do
	if (message == nil)
	then
	  printOutput("print", L"Please don't pass nil as an argument into the terminal.")
	else
	  local messageType = type(message)
	  if (messageType == "number")
	  then
		printOutput("print", L"" .. message)
	  elseif (messageType == "string")
	  then
		printOutput("print", towstring(message))
	  elseif (messageType == "table")
	  then
		printTable(message)
	  elseif (messageType == "boolean")
	  then
		printOutput("print", towstring(booltostring(message)))
	  else
		printOutput("print", message)
	  end
	end
  end
end

local function mysort(alpha, bravo)
  if type(alpha) ~= type(bravo) then
	return type(alpha) < type(bravo)
  end
  if alpha == bravo then
	return false
  end
  if type(alpha) == "string" or type(alpha) == "wstring" then
	return alpha:lower() < bravo:lower()
  end
  if type(alpha) == "number" then
	return alpha < bravo
  end
  return false
end

local recursions = {}
local function better_toString(data, depth)
  if type(data) == "string" then
	return ("%q"):format(data)
  elseif type(data) == "wstring" then
	return ("L%q"):format(WStringToString(data))
  elseif type(data) ~= "table" then
	return ("%s"):format(tostring(data))
  else
	if recursions[data] then
	  return "{<recursive table>}"
	end
	recursions[data] = true
	if next(data) == nil then
	  return "{}"
	elseif next(data, next(data)) == nil then
	  return "{ [" .. better_toString(next(data), depth) .. "] = " .. better_toString(select(2, next(data)), depth) .. " }"
	else
	  local t    = {}
	  t[#t + 1]  = "{\n"
	  local keys = {}
	  for k in pairs(data) do
		keys[#keys + 1] = k
	  end
	  table.sort(keys, mysort)
	  for _, k in ipairs(keys) do
		local v = data[k]
		for i = 1, depth do
		  t[#t + 1] = "    "
		end
		t[#t + 1] = "["
		t[#t + 1] = better_toString(k, depth + 1)
		t[#t + 1] = "] = "
		t[#t + 1] = better_toString(v, depth + 1)
		t[#t + 1] = ",\n"
	  end
	  
	  for i = 1, depth do
		t[#t + 1] = "    "
	  end
	  t[#t + 1] = "}"
	  return table.concat(t)
	end
  end
end

local function eventTableConcat(list, sep, i, j, ...)
  -- Usual parameters are followed by a list of value converters
  local first_conv_idx, converters, t = 4, { sep, i, j, ... }, {}
  local conv_types                    = {
	['function'] = function(cnv, val) return cnv(val) end,
	table = function(cnv, val) return cnv[val] or val end
  }
  if conv_types[type(sep)] then first_conv_idx, sep, i, j = 1
  elseif conv_types[type(i)] then first_conv_idx, i, j = 2
  elseif conv_types[type(j)] then first_conv_idx, j = 3
  end
  sep, i, j = sep or '', i or 1, j or #list
  for k = i, j do
	local v, idx = list[k], first_conv_idx
	while conv_types[type(converters[idx])] do
	  v   = conv_types[type(converters[idx])](converters[idx], v)
	  idx = idx + 1
	end
	t[k] = tostring(v) -- 'tostring' is always the final converter
  end
  return tableConcat(t, sep, i, j)
end

function warExtendedTerminal.ConsoleLog(text)
  printOutput("print", warExtendedTerminal:toWString(text))
end

function objToString(...)
  local n = select('#', ...)
  local t = {}
  for i = 1, n do
	if i > 1 then
	  t[#t + 1] = ", "
	end
	t[#t + 1] = better_toString((select(i, ...)), 0)
  end
  for k in pairs(recursions) do
	recursions[k] = nil
  end
  t = table.concat(t)
  return t
end

-----------------PRETTY PRINT----------------------------
function p(...)
  local str = objToString(...)
  print(str)
end

function eve(...)
  local n = select('#', ...)
  local t = {}
  for i = 1, n do
	if i > 1 then
	  t[#t + 1] = ", "
	end
	t[#t + 1] = better_toString((select(i, ...)), 0)
  end
  for k in pairs(recursions) do
	recursions[k] = nil
  end
  printOutput("event", eventTableConcat(t))
  
end

  function inp(text)
	printOutput("input", text)
  end

local function getRegisteredFunctions()
  local registeredfunctionlist = {}
  for i, v in pairs(_G) do
	if type(v) == "function" then
	  registeredfunctionlist[i] = v
	end
	table.sort(registeredfunctionlist)
  end
end

function functionlist()
  p(getRegisteredFunctions())
end

