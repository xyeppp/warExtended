-- taken from Enemy
local tinsert = table.insert
local warExtended = warExtended
local type = type
local tostring = tostring
local tonumber = tonumber
local towstring = towstring


function warExtended:SerializeToString (v)

	if (v == nil or v == "" or v == L"") then return v end

	local res = towstring (v)

	res = res:gsub (L"\\", L"\\\\")
	res = res:gsub (L"\"", L"\\\"")
	res = res:gsub (L"{", L"\\{")
	res = res:gsub (L"}", L"\\}")

	return res
end


function warExtended:SerializeTable (t)

	local str = L""
	local is_first = true

	if (type (t) == "string" or type (t) == "wstring")
	then
		return warExtended:SerializeToString (t)
		
	elseif (type (t) == "function")
	then
		return nil
		
	elseif (type (t) ~= "table")
	then
		return towstring (t)
	end

	for k, v in pairs (t)
	do
		if (v ~= nil and type (v) ~= "function")
		then
			if (not is_first) then str = str..L"," end
			is_first = false
			
			if (type (k) == "number")
			then
				str = str..towstring (k)..L"="
			else
				str = str..L"\""..warExtended:SerializeToString (k)..L"\"="
			end

			if (type (v) == "table")
			then
				str = str..warExtended:SerializeTable (v)
				
			elseif (type (v) == "string")
			then
			  p(str)
			  str = towstring(str)
				str = str..L"\""..warExtended:SerializeToString (v)..L"\""
				
			elseif (type (v) == "wstring")
			then
				str = str..L"L\""..warExtended:SerializeToString (v)..L"\""
			
			elseif (type (v) == "boolean")
			then
				if (v == true)
				then
					str = str..L"true"
				else
					str = str..L"false"
				end
				
			else
				str = str..towstring (v)
			end
		end
	end

	if (type (t) == "table")
	then
		str = L"{"..str..L"}"
	end

	return str
end


function warExtended:DeserializeTable (str, startPos)

	if (str == nil) then return nil end
	str = warExtended:trim (towstring (str))
	
	local t = {}

	local len = str:len ()
	local pos = startPos or 1
	local c
	local term = L""
	local status = 0		-- 0 - none
							-- 1 - key parse started
							-- 2 - key parse ended
							-- 3 - "=" delimeter found
							-- 4 - value parse started
	local escaped = false
	local key = nil
	local string_value = nil
	local wstring_value = false

	while (pos <= len)
	do
		c = str:sub (pos, pos)

		if (c == L"\\" and not escaped)
		then
			escaped = true
			
		elseif (c == L"L" and status == 3)
		then
			wstring_value = true

		elseif (c == L"\"" and not escaped)
		then
			if (status == 0)
			then
				-- start parsing key
				status = 1

			elseif (status == 1)
			then
				-- end parsing key
				status = 2
				key = tostring (term)
				term = L""

			elseif (status == 3)
			then
				-- start parsing string value
				status = 4
				string_value = true

			elseif (status == 4)
			then
				-- end parsing string value
				
				if (wstring_value)
				then
					t[key] = towstring (term)
				else
					t[key] = tostring (term)
				end
				
				term = L""
				status = 0
			end

		elseif
			(
				(c == L"," and status == 4 and not string_value)
				or
				(c == L"," and status == 0)
				or
				(c == L"}" and not escaped)
			)
		then
			if (status == 4)
			then
				-- end parsing value
				if (term == L"true")
				then
					t[key] = true
				elseif (term == L"false")
				then
					t[key] = false
				else
					t[key] = tonumber (term)
				end

				status = 0
				term = L""
			end

			if (c == L"}")
			then
				break
			end

		elseif (c == L"=" and (status == 1 or status == 2))
		then
			-- encountered "=" delimeter symbol
			if (status == 1)
			then
				key = tonumber (term)
				term = L""
			end
			
			status = 3
			wstring_value = false

		elseif (c == L"{" and (status == 0 or status == 3))
		then
			-- start of table value
			local new_t, new_pos = warExtended:DeserializeTable (str, pos + 1)

			if (key)
			then
				t[key] = new_t
			else
				t = new_t
			end

			pos = new_pos

			term = L""
			status = 0

		else

			if (status == 0)
			then
				-- start parsing key
				status = 1

			elseif (status == 3)
			then
				-- start parsing value
				status = 4
				string_value = false
			end

			term = term..c
			escaped = false
		end

		pos = pos + 1
	end

	return t, pos
end
