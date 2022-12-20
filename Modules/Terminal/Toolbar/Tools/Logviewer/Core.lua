local warExtended = warExtended
local TOOL_NAME = L"Log Viewer"
local TOOL_DESCRIPTION = L"Access your saved logs & save objects into new ones."
local TOOL_ICON = 23066
local WINDOW_NAME = "TerminalLogViewer"


	--local GetAbilityName = GetAbilityName
	TerminalLogViewer = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, {savedLogs = {}}, {savedLogs= {}})
	
	--[[function TerminalAbilityFinder.OnShown()
	  local cache = TerminalAbilityFinder:GetSettings().abilityCache
	  
	  for i=1,MAX_ABILITY_ID do
		local abilityName = GetAbilityName(i)
		if abilityName ~= L"" then
		  cache[i] = abilityName
		end
	  end
	  
	  TerminalAbilityFinder.UpdateDisplay()
	end
	
	function TerminalAbilityFinder.OnHidden()
	  local cache = TerminalAbilityFinder:GetSettings().abilityCache
	  cache = {}
	end]]
 

---
function logdump(name, ...)
  local testing = false;
  if name == nil or (...) == nil then testing = true;
  else testing = false
  end
  if testing then pp("Usage: logdump(\"logname\", arguments)")
  else
	dump                    = true;
	DevPad_Settings.Logdump = name
	TextLogCreate(tostring(name), 50000)
	TextLogAddEntry(DevPad_Settings.Logdump, 1, (text))
	TextLogDestroy(name)
	TextLogSetIncrementalSaving(name, true, StringToWString("logs/" .. name .. ".log"))
	p(...)
	dump = false;
	pp("\"" .. name .. "\" saved to logs/" .. name .. ".log")
  end
end

--[[function warExtendedTerminal.DumpToLog(name, ...)
  if name == nil or (...) == nil then
	warExtendedTerminal.ConsoleLog("Usage: logdump(\"logname\", args)")
	return
  end
  
  TextLogCreate(name, 99999999999)
  
  local entry = warExtendedTerminal:toWString(objToString(...))
  
  TextLogSetIncrementalSaving(name, true, warExtended:toWString("logs/" .. name .. ".log"))
  TextLogAddEntry(name, 0, entry)
  TextLogSetIncrementalSaving(name, false, warExtended:toWString("logs/" .. name .. ".log"))
  TextLogDestroy(name)
  
  warExtendedTerminal.ConsoleLog("\"" .. name .. "\" saved to logs/" .. name .. ".log")
end

function warExtendedTerminal.LogDumpOnInitialize()
  warExtendedTerminal:RegisterToolbarItem(L"Logviewer", L"View your saved object logs & save object to new ones.", "TerminalLogDump", 23066)
  LabelSetText(WINDOW_NAME.."TitleBarLabel", L"Logviewer")
end]]