local warExtended = warExtended

function warExtended:StringToNoCaseIgnoreSpecial(s)
	s = tostring(s)
	s = string.gsub(s,'[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c) return '%'..c end)
	s = string.gsub(s, "%a", function (c)
	  return string.format("[%s%s]", string.lower(c),
			  string.upper(c))
	end)
	s = s:gsub("%s", "(.*)")
	return s
end
