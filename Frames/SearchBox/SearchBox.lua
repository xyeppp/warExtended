local warExtended = warExtended
local LABEL = 1
local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local select = select
local wstring=wstring
local wstrfind = wstring.find
local pcall = pcall

	SearchEditBox=TextEditBox:Subclass("warExtendedDefaultSearchBox")
	local LABEL_FRAME = Label:Subclass("warExtendedDefaultSearchBoxLabel")

	function SearchEditBox:Create(windowName, article)
	  local newFrame = self:CreateFrameForExistingWindow(windowName)

	  newFrame.m_Article = article
	  newFrame.m_Results = {}
	  newFrame.m_Seen = {}

	  newFrame.m_Windows = {
		[LABEL] = LABEL_FRAME:CreateFrameForExistingWindow(newFrame:GetName().."Label")
	  }

	  return newFrame
	end

	function LABEL_FRAME:OnMouseOver()
	  p("placeholder")
	  --ADD FILTERS warExtended:CreateTextTooltip()
	end

	function SearchEditBox:AddFilters(searchFilters)
	  if not self.m_Filters then
		self.m_Filters={}
	  end

	  self.m_Filters = searchFilters
	end

	function SearchEditBox:SetArticle(article)
		self.m_articleIndex = {}
		self.m_Article = article
		self.m_Results = {}

		for k,_ in pairs(self.m_Article) do
			self.m_articleIndex[#self.m_articleIndex+1] = k
		end
	end


	function SearchEditBox:GetFilters()
	  return self.m_Filters
	end

	function SearchEditBox:AddCallback(callbackFunction)
	  self.m_Callback = callbackFunction
	end

	function SearchEditBox:GetArticle()
	  return self.m_Article
	end


	function SearchEditBox:OnTextChanged(text)
		self.m_Results = {}

		if text == L"" or text:len()<1 then
			return self.m_Callback(self.m_articleIndex or self.m_Article)
		end

		for id=1,#self.m_Article do
			local obj = self.m_Article[id]
			local matches = self:Matches(id, obj, text)
			if matches == true then
				--tinsert(self.m_Results, self.m_Id)
				self.m_Results[#self.m_Results+1] = self.m_Id
				elseif matches==false then
				--trem(self.m_Results, )
			end
		end

		return self.m_Callback(self.m_Results)
	end



	--[[ CUSTOM SEARCH - 1.0 by JALIBORC ]]--

	function SearchEditBox:Matches(id, object, search)
	  if object then
		self.m_Object = object
		self.m_Id = id

		return self:MatchAll(search or L'')
	  end
	end

	function SearchEditBox:MatchAll(search)
	  for phrase in self:Clean(search):gmatch(L'[^&]+') do
		if not self:MatchAny(phrase) then
		  return
		end
	  end

	  return true
	end


	function SearchEditBox:MatchAny(search)
	  for phrase in search:gmatch(L'[^|]+') do
		if self:Match(phrase) then
		  return true
		end
	  end
	end

	function SearchEditBox:Match(search)
	  local tag, rest = search:match(L'^%s*(%S+):(.*)$')
	  if tag then
		tag = L'^' .. tag
		search = rest
	  end

	  local words = search:gmatch(L'%S+')
	  for word in words do
		local negate, operator = 1

		if word:find(self.NOT_MATCH) or word:find(L'^[!~]=*$') then
		  negate = -1
		  word = words() or L""
		end

		if word:find(L'^=*[<>]=*$') then
		  operator = word
		  word = words()
		end

		local result = self:Filter(tag, operator, word) and 1 or -1

		if result*negate~=1 then
		 return
		end
	  end

	  return true
	end
	--[[ Filtering ]]--

	function SearchEditBox:Filter(tag, operator, search)
	  if not search then
		return true
	  end

	  if tag then
		for _, filter in pairs(self.m_Filters) do
		  for _, value in pairs(filter.tags or {}) do
			if value:find(tag) then
			  return self:UseFilter(filter, operator, search)
			end
		  end
		end
	  else
		for _, filter in pairs(self.m_Filters) do
		  if not filter.onlyTags and self:UseFilter(filter, operator, search) then
			return true
		  end
		end
	  end

	end

	function SearchEditBox:UseFilter(filter, operator, search)
	  local data = {filter:canSearch(operator, search)}
	  if data[1] then
		return filter:match(self.m_Object, operator, unpack(data))
	  end
	end


	--[[ Utilities ]]--

	function SearchEditBox:Find(search, ...)
	  local ret, _ = pcall( wstrfind, search, search)
	  if not ret then return end

		for i = 1, select('#', ...) do
		  local text = select(i, ...)
		  if self:Clean(text):find(search) then
			return true
		  end
		end

	  return false
	end

	function SearchEditBox:Clean(string)

	  string = string:lower()

	  if string == "" then
		string = L""
	  end

	  string = string:gsub(L'[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c) return L'%'..c end)
	  string = warExtended:isEmpty(string, L"")
	  for accent, char in pairs(self.ACCENTS) do
		if string == "" then
		  string = L""
		end
		string:gsub(accent, char)
	  end

	  return string
	end

	function SearchEditBox:Compare(op, a, b)
	  if op then
		if op:find(L'<') then
		  if op:find(L'=') then
			return a <= b
		  end
		  return a < b
		end

		if op:find(L'>')then
		  if op:find(L'=') then
			return a >= b
		  end
		  return a > b
		end
	  end

	  return a == b
	end


	--[[ Localization ]]--

	do
	  local no = {
		enUS = L'Not',
	  }

	  local accents = {
		a = {L'à',L'â',L'ã',L'å'},
		e = {L'è',L'é',L'ê',L'ê',L'ë'},
		i = {L'ì', L'í', L'î', L'ï'},
		o = {L'ó',L'ò',L'ô',L'õ'},
		u = {L'ù', L'ú', L'û', L'ü'},
		c = {L'ç'}, n = {L'ñ'}
	  }


	  SearchEditBox.ACCENTS = {}
	  for char, accents in pairs(accents) do
		for _, accent in ipairs(accents) do
		  SearchEditBox.ACCENTS[accent] = char
		end
	  end

	  SearchEditBox.OR = L"or"
	  SearchEditBox.NOT = no["enUS"]
	  SearchEditBox.NOT_MATCH = L'^' .. SearchEditBox:Clean(SearchEditBox.NOT) .. L'$'
	end

BinarySearch = {}

function BinarySearch.DefaultCompare(a, b)
	if b > a then
		return -1
	elseif b < a then
		return 1
	else
		return 0
	end
end

function BinarySearch:Search(tableToSearch, toFind, comparator)
	if not comparator then
		comparator = BinarySearch.DefaultCompare
	end

	local minIndex = 1
	local maxIndex = #tableToSearch

	while minIndex <= maxIndex do
		local mid = math.floor((maxIndex+minIndex)/2)
		local compareVal = comparator(tableToSearch[mid], toFind)
		if compareVal then
			if compareVal == 0 then
				return mid
			elseif compareVal > 0 then
				minIndex = mid + 1
			else
				maxIndex = mid - 1
			end
		end
	end

	return nil
end

function BinarySearch:FindInsertPoint(tableToSearch, toInsert, comparator)
	if #tableToSearch == 0 then
		return 1
	end

	if not comparator then
		comparator = BinarySearch.DefaultCompare
	end

	local minIndex = 1
	local maxIndex = #tableToSearch
	local mid

	while true do
		mid = math.floor((maxIndex+minIndex)/2)
		local compareVal = comparator(tableToSearch[mid], toInsert)
		if compareVal == 0 then
			return mid
		elseif compareVal > 0 then
			minIndex = mid+1
			if minIndex > maxIndex then
				return mid+1
			end
		else
			maxIndex = mid-1
			if minIndex > maxIndex then
				return mid
			end
		end
	end
end

local default_fcompval = function( value ) return value end
local fcompf = function( a,b ) return a < b end
local fcompr = function( a,b ) return a > b end
function table.binsearch( tbl,value,fcompval,reversed )
	-- Initialise functions
	local fcompval = fcompval or default_fcompval
	local fcomp = reversed and fcompr or fcompf
	--  Initialise numbers
	local iStart,iEnd,iMid = 1,#tbl,0
	-- Binary Search
	while iStart <= iEnd do
		-- calculate middle
		iMid = math.floor( (iStart+iEnd)/2 )
		-- get compare value
		local value2 = fcompval( tbl[iMid] )
		-- get all values that match
		if value == value2 then
			local tfound,num = { iMid,iMid },iMid - 1
			while value == fcompval( tbl[num] ) do -- ERROR: this may cause fail in fcompval if num is out of range and tbl[num] is nil
				tfound[1],num = num,num - 1
			end
			num = iMid + 1
			while value == fcompval( tbl[num] ) do -- ERROR: this may cause fail in fcompval if num is out of range and tbl[num] is nil
				tfound[2],num = num,num + 1
			end
			return tfound
			-- keep searching
		elseif fcomp( value,value2 ) then
			iEnd = iMid - 1
		else
			iStart = iMid + 1
		end
	end
end