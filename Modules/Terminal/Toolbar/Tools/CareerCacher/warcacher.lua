--[[
WarCache - Data collation, caching and export.
Warhammer Online: Age of Reckoning.

Copyright (C) 2009  Gareth "NerfedWar" Jones
nerfed.war@gmail.com www.nerfedwar.net
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

-- ==========================
-- ===== Public members =====
-- ==========================

WarCache = {
	PROGNAME	= L"WarCache",
	VERSION		= L"1.3",
	AUTHOR		= L"NerfedWar",

	TemporaryObjectList = {},

	Storage		= {
		abilities = {},
		items = {},
		morales = {}
	}
}

WarCacheUI = {}
WarCacheUI.Window = "WarCacheUI"

-- ===========================
-- ===== Private members =====
-- ===========================

local Languages = {
	"English",
	"French",
	"German",
	"Italian",
	"Spanish",
	"Korean",
	"Simple_Chinese",
	"Traditional_Chinese",
	"Japanese",
	"Russian"
}

-- ===========================
-- ===== Private methods =====
-- ===========================

-- Chat panel output
local function printToChat(s)
    local str = L"WarCache: "..towstring(s)
    TextLogAddEntry("Chat", SystemData.ChatLogFilters.SAY, str)
end

-- ============================
-- ===== Internal methods =====
-- ============================

-- called once the game loading or a reloadui command being performed.
function WarCache.Initialize()

	-- Register the slash commands
	LibSlash.RegisterSlashCmd("warcache", WarCache.Slash)

	-- Create the window and then hide it.
	CreateWindow(WarCacheUI.Window, true)
	WindowSetShowing(WarCacheUI.Window,false)

	-- Apply text to the labels so they are not blank.
	LabelSetText(WarCacheUI.Window.."TitleBarText", L"WarCache v"..towstring(WarCache.VERSION))

	printToChat("Initialised.")
	printToChat("Type /warcache for usage.")

end

-- slash command handler
function WarCache.Slash(input)
	if input=="reset" then
		WarCache.Reset()
		return
	end
	if input=="export" then
		WarCache.Export()
		return
	end
	if input=="collect" then
		WarCache.Collect()
		return
	end
	printToChat("To collect career data: /warcache collect.")
	printToChat("To export the cache: /warcache export.")
	printToChat("To reset the cache: /warcache reset.")
end

-- close the window
function WarCache.CloseWindow(flags, mouseX, mouseY)
	WindowSetShowing(WarCacheUI.Window,false)
end


-- dump an object (courtesy of ObjectInspector Addon)
function WarCache.DisplayObject(obj, objName, targetDepth)
	-- Inititalise the object list
	WarCache.TemporaryObjectList = {}
	local currentDepth = 0
	local contents = TextEditBoxGetText(WarCacheUI.Window.."ObjectEditBox")
	-- Call the recursive algorithm to traverse through the object
	local objDetails = WarCache.GetObjectDetails(obj, objName, targetDepth, currentDepth)
	-- Clear out the Object List between uses to free up memory
	WarCache.TemporaryObjectList = {}
	TextEditBoxSetText(WarCacheUI.Window.."ObjectEditBox",towstring(objDetails))
end

-- get details of an object (courtesy of ObjectInspector Addon)
function WarCache.GetObjectDetails(obj, objName, targetDepth, previousDepth)
	-- A recursive algorithm to traverse the object
	local contents = ""
	local currentDepth = previousDepth + 1
	-- Check the current depth against the targetDepth to see if we should continue traversing
	-- and if the object is a table and then begin the traversal of the table
	if type(obj) == "table" and (targetDepth == 0 or targetDepth >= currentDepth) then
		-- Check to see if we have already traversed this object and act accordingly
		if WarCache.TemporaryObjectList[tostring(obj)] then
			return "Endless Loop detected on object ["..tostring(objName).."]\n"
		else
			WarCache.TemporaryObjectList[tostring(obj)] = true
		end
		-- Retrieve the contents of the table via a recursive call.
		for k, a in pairs(obj) do
			contents = contents..WarCache.GetObjectDetails(a, tostring(objName).."."..tostring(k), targetDepth, currentDepth)
		end
	else
		-- No more traversal required, add the value of the object to the name of the object
		contents = tostring(objName).." = "
		if type(obj) == "wstring" then
			contents = contents.."\""..tostring(obj).."\"\n"
		else
			contents = contents..tostring(obj).."\n"
		end
	end
	-- Return the obj value back to the parent call
	return contents
end

-- takes ability data and returns the cast time as a string
function WarCache.GetAbilityCastTimeText (abilityData)
    if (abilityData.numTacticSlots > 0)
    then
        return GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_PASSIVE_CAST)
    end

    local castTime = GetAbilityCastTime (abilityData.id)

    if (castTime > 0)
    then
        local _, castTimeFraction = math.modf (castTime)
        local params = nil

        if (castTimeFraction ~= 0)
        then
            params = { wstring.format( L"%.1f", castTime) }
        else
            params = { wstring.format( L"%d", castTime) }
        end

        return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_CAST_TIME, params))
    end

    return (GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_INSTANT_CAST))
end

-- takes ability data and returns the cost as a string
function WarCache.GetAbilityCostText (abilityData)
    if (abilityData.moraleLevel ~= 0)
    then
        local params = { abilityData.moraleLevel }
        return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_MORALE_COST, params))
    elseif (abilityData.numTacticSlots ~= 0)
    then
        local params = { abilityData.numTacticSlots, Tooltips.TacticsTypeStrings[abilityData.tacticType] }
        return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_TACTIC_COST, params))
    else
        local apCost = GetAbilityActionPointCost (abilityData.id)

        if (apCost > 0)
        then
            local params = { apCost }

            if (abilityData.hasAPCostPerSecond)
            then
                return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_AP_COST_PER_SECOND, params))
            else
                return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_ACTION_POINT_COST, params))
            end
        end
    end

    return (GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_NO_COST))
end

-- takes ability data and returns the range as a string
function WarCache.GetAbilityRangeText (abilityData)
    local labelText = GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_NO_RANGE)
    local minRange, maxRange = GetAbilityRanges (abilityData.id)

    local fConstFootToMeter = 0.3048
    local bUseInternationalSystemUnit = SystemData.Territory.KOREA

    if ((minRange > 0) and (maxRange > 0))
    then
        local stringID = StringTables.Default.LABEL_ABILITY_TOOLTIP_MIN_RANGE_TO_MAX_RANGE
        if bUseInternationalSystemUnit
        then
            minRange = string.format( "%d", minRange * fConstFootToMeter + 0.5 )
            maxRange = string.format( "%d", maxRange * fConstFootToMeter + 0.5 )
            stringID = StringTables.Default.LABEL_ABILITY_TOOLTIP_MIN_TO_MAX_RANGE_METERS
        end
        local params = { minRange, maxRange }
        labelText = GetStringFormat (stringID, params)
    elseif (maxRange > 0)
    then
        local stringID = StringTables.Default.LABEL_ABILITY_TOOLTIP_MAX_RANGE
        if bUseInternationalSystemUnit
        then
            maxRange = string.format( "%d", maxRange * fConstFootToMeter + 0.5 )
            stringID = StringTables.Default.LABEL_ABILITY_TOOLTIP_MAX_RANGE_METERS
        end
        local params = { maxRange }
        labelText = GetStringFormat (stringID, params)
    end

    return (labelText)
end

-- takes ability data and returns the level as a string
function WarCache.GetAbilityLevelText (abilityData)
    local upgradeRank = GetAbilityUpgradeRank (abilityData.id)

    if (upgradeRank > 0)
    then
        return (GetStringFormat (StringTables.Default.LABEL_ABILITY_TOOLTIP_ABILITY_RANK, {upgradeRank}))
    end

    return (GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_ABILITY_NO_RANK))
end

-- takes ability data and returns the cooldown as a string
function WarCache.GetAbilityCooldownText( cooldown )
    if ( cooldown > 0 )
    then
        -- For abilities with cooldowns under a min, we care about the first decimal.
        -- For instance some abilities have a 1.5 sec cooldown
        local timeText
        if( cooldown < 60 )
        then
            timeText = TimeUtils.FormatRoundedSeconds( cooldown, 0.1, true, false )
        else
            timeText = TimeUtils.FormatSeconds( cooldown, true )
        end
        return ( GetStringFormat( StringTables.Default.LABEL_ABILITY_TOOLTIP_COOLDOWN, { timeText } ) )
    end

    return (GetString (StringTables.Default.LABEL_ABILITY_TOOLTIP_NO_COOLDOWN))
end

-- ==========================
-- ===== Public methods =====
-- ==========================

-- reset the cache
function WarCache.Reset()
	WarCache.Storage.abilities = {}
	WarCache.Storage.items = {}
	printToChat("Persistant storage reset.")
end

-- export ability data to a window so it can be copied to the WarCache website.
function WarCache.Export()

	-- Show the window
	WindowSetShowing(WarCacheUI.Window,true)

	-- copy contents to ui
	WarCache.DisplayObject(WarCache.Storage, "WarCache", 0)

end

-- append ability data to persistant storage
function WarCache.Collect()
 
	EA_Window_InteractionSpecialtyTraining.advanceData = GameData.Player.GetAdvanceData()
  -- extract the data
  
  for _,data in pairs(EA_Window_InteractionSpecialtyTraining.advanceData) do
	if data.abilityInfo then
	  -- get the abilityId adn remove from the array
	  local abilityId = data.abilityInfo.id -- the actual unique id of the ability
	  if data.abilityInfo.abilityType ~= 5 and data.abilityInfo.tacticType ~= 2 then
		
		-- temporary store for the ability data as we flatten the structure
		local abilityData = data
	 
		-- flatten abilityInfo
		for key,val in pairs(data.abilityInfo) do
		  abilityData.key=val
		end
	 
		--local abilityData = data.abilityInfo -- tooltip function compatible data structure
	 
		--[[local _,maxrange = GetAbilityRanges(abilityId) --since 1.3.6 there's no need for minrange
		abilityData.range = maxrange
		abilityData.apCost = GetAbilityActionPointCost(abilityId)
		abilityData.casttime = GetAbilityCastTime(abilityId)]]
	 
		-- rounding of timers
		--abilityData.reuseTimer = math.floor(data.abilityInfo.reuseTimer) -- remove the useless microseconds
		--abilityData.reuseTimerMax = math.floor(data.abilityInfo.reuseTimerMax)
		--abilityData.cooldown = math.floor(data.abilityInfo.cooldown)
	 
		-- add career
		--abilityData.careername = GameData.Player.career.name
		abilityData = abilityData.abilityInfo
		abilityData.specline = DataUtils.GetAbilitySpecLine(data.abilityInfo)
	 
		local dindex           = 40
	 
		-- tooptip display
		--[[abilityData.tooltip = {}
		abilityData.tooltip.name = GetStringFormat(StringTables.Default.LABEL_ABILITY_TOOLTIP_ABILITY_NAME, {data.abilityInfo.name})
		abilityData.tooltip.description = GetAbilityDesc(data.abilityInfo.id, 40)
		abilityData.tooltip.specline = DataUtils.GetAbilitySpecLine(data.abilityInfo)
		abilityData.tooltip.cost = WarCache.GetAbilityCostText(data.abilityInfo)
		abilityData.tooltip.casttime = WarCache.GetAbilityCastTimeText(data.abilityInfo)
		abilityData.tooltip.type = DataUtils.GetAbilityTypeText(data.abilityInfo)
		abilityData.tooltip.level = WarCache.GetAbilityLevelText(data.abilityInfo)
		abilityData.tooltip.range = WarCache.GetAbilityRangeText(data.abilityInfo)
		local realCooldown = GetAbilityCooldown(data.abilityInfo.id) / 1000
		abilityData.tooltip.cooldown = WarCache.GetAbilityCooldownText(realCooldown)
		local reqs = {}
		reqs[1], reqs[2], reqs[3] = GetAbilityRequirements(data.abilityInfo.id)
		abilityData.tooltip.requirements = reqs]]
	 
	 
		-- remove useless values
		--abilityData.key=nil
		--abilityData.advanceIcon=nil
		--abilityData.advanceID=nil
		--abilityData.advanceName=nil
		--abilityData.advanceValue=nil
		--abilityData.packageId=nil
		--abilityData.requiredActionCounterID=nil
		--abilityData.abilityInfo=nil
	 
		if abilityData.abilityType ~= 2 then
		  WarCache.Storage.abilities[abilityId] = abilityData
		else
		  WarCache.Storage.morales[abilityId] = abilityData
		end
	  end
	  
	end
	
	
	--[[tablertabler={}
	bought=false;
	for k,v in pairs(WarCache.Storage.abilities) do
					if v.timesPurchased >= 0 and v.minimumRenown >= 0 then
				bought=true;
				table.insert(tablertabler, v.tooltip.English.name..v.timesPurchased)
		end
		end
	end
	if bought then
		p(tablertabler)
		bought=false;
	end]]
	
	-- store data in persistant cache
	--WarCache.Storage.abilities[] = abilities
	
	-- gather metadata, like careerstats for additional calculations like statcontribution
	--metaData = {}
	--metaData.Language = {}
	--metaData.Language.id = SystemData.Settings.Language.active
	--metaData.Language.name = Languages[metaData.Language.id]
	
	--metaData.Player = {}
	--metaData.Player.STRENGTH = GetBonus(GameData.BonusTypes.EBONUS_STRENGTH,GameData.Player.Stats[GameData.Stats.STRENGTH].baseValue)
	--metaData.Player.BALLISTIC = GetBonus(GameData.BonusTypes.EBONUS_BALLISTICSKILL,GameData.Player.Stats[GameData.Stats.BALLISTICSKILL].baseValue)
	--metaData.Player.INTELLIGENCE = GetBonus(GameData.BonusTypes.EBONUS_INTELLIGENCE,GameData.Player.Stats[GameData.Stats.INTELLIGENCE].baseValue)
	--metaData.Player.WILLPOWER = GetBonus(GameData.BonusTypes.EBONUS_WILLPOWER,GameData.Player.Stats[GameData.Stats.WILLPOWER].baseValue)
	
	--WarCache.Storage.abilities[string.gsub(tostring(GameData.Player.career.name), " ", "_")].meta = metaData
  
  
  end
  
  local string2 = tostring(GameData.Player.career.name)
  logdump(string2.."realMORALE", WarCache.Storage.morales)
  logdump(string2.."realABILITY", WarCache.Storage.abilities)
  
end

