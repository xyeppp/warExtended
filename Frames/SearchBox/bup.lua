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


function SearchEditBox:GetFilters()
  return self.m_Filters
end

function SearchEditBox:AddCallback(callbackFunction)
  self.m_Callback = callbackFunction
end

function SearchEditBox:GetArticle()
  return self.m_Article
end

function SearchEditBox:SetArticle(newArticle)
  self.m_Article = newArticle
end

function SearchEditBox:OnTextChanged(text)
  local article = self.m_Article
  
  if text == L"" or text:len()<1 then
	self.m_Results = {}
	self.m_Seen = {}
	self.m_Callback(article)
	return
  end
  
  for id=1,#article do
	local obj = article[id]
	if self:Matches(id, obj, text) then
	  self.m_Results[self.m_Id] = true
	else
	  self.m_Results[self.m_Id] = false
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
  local failed
  for word in words do
	if word == self.OR then
	  if failed then
		failed = false
	  else
		break
	  end
	
	else
	  local negate, rest = word:match(L'^([!~]=*)(.*)$')
	  if negate or word == self.NOT_MATCH then
		word = rest and rest ~= L'' and rest or words() or L''
		negate = -1
	  else
		negate = 1
	  end
	  
	  local operator, rest = word:match(L'^(=*[<>]=*)(.*)$')
	  if operator then
		word = rest ~= L'' and rest or words()
	  end
	  
	  local result = self:Filter(tag, operator, word) and 1 or -1
	  if result * negate ~= 1 then
		failed = true
	  end
	end
  end
  
  return not failed
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

function SearchEditBox:AddToSeen(id, state)
  self.m_Results[id] = true
  self.m_Seen[id] = true
end

function SearchEditBox:RemoveFromSeen(id)
  self.m_Results[id] = false
  self.m_Seen[id] = false
end

--TODO: add negate passing early and results to match function

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



