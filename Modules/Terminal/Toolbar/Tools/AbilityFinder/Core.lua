local MAX_ABILITY_ID   = 30000
local TOOL_NAME        = L"Ability Finder"
local TOOL_DESCRIPTION = L"Allows you to quickly look for an ability and display it's ID & description."
local TOOL_ICON        = 05134
local WINDOW_NAME      = "TerminalAbilityFinder"
local GetFrame = GetFrame

local GetAbilityName   = GetAbilityName
TerminalAbilityFinder  = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, { abilityCache = {} })

function TerminalAbilityFinder.OnShown()
  local cache = TerminalAbilityFinder:GetSettings().abilityCache
  
  for i = 1, MAX_ABILITY_ID do
	local abilityName = GetAbilityName(i)
	if abilityName ~= L"" then
        cache[#cache+1] = abilityName
	end
  end

    GetFrame(WINDOW_NAME.."AbilitySearch"):SetArticle(cache)
  TerminalAbilityFinder.UpdateDisplay()
end

function TerminalAbilityFinder.OnHidden()
    TerminalAbilityFinder:GetSettings().abilityCache       = {}
end


