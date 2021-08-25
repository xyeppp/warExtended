local warExtended = warExtended
local ipairs = ipairs

local roleIcons = {
  ["tank"] = {
    ["icon"] = L"<icon22724>",
    ["text"] = L"Tank"
  },
  ["dps"] = {
    ["icon"] = L"<icon22657>",
    ["text"] = L"DPS",
  },
  ["heal"] = {
    ["icon"] = L"<icon22706>",
    ["text"] = L"Heal"
  }
}

 careerInfo = {
  ["ironbreaker"] =  {
    ["id"] = 1 ,
    ["shorthandle"] = L"IB",
    ["icon"] = L"<icon20189>",
    ["role"] = "tank"
},
  ["blackorc"] =  {
    ["id"] = 5,
    ["icon"] = L"<icon20182>",
    ["shorthandle"] = L"BO",
    ["role"] = "tank"
},
  ["kotbs"] = {
    ["id"] = 10,
    ["icon"] = L"<icon20190>",
    ["shorthandle"] = L"KOTBS",
    ["role"] = "tank"
  },
  ["swordmaster"] = {
    ["id"] = 17,
    ["icon"] = L"<icon20198>",
    ["shorthandle"] = L"SM",
    ["role"] = "tank"
  },
  ["chosen"] = {
    ["id"] = 13,
    ["icon"] = L"<icon20185>",
    ["shorthandle"] = L"CH",
    ["role"] = "tank"
  },
  ["blackguard"] = {
    ["id"] = 21,
    ["icon"] = L"<icon20181>",
    ["shorthandle"] = L"BG",
    ["role"] = "tank"
  },
  ["witchhunter"] =  {
    ["id"] = 9,
    ["icon"] = L"<icon20202>" ,
    ["shorthandle"] = L"WH",
    ["role"] = "dps"
  },
  ["engineer"] = {
    ["id"] = 4,
    ["icon"] = L"<icon20187>",
    ["shorthandle"] = L"ENG",
    ["role"] = "dps"
  },
  ["squigherder"] = {
    ["id"] = 8,
    ["icon"] = L"<icon20197>",
    ["shorthandle"] = L"SH",
    ["role"] = "dps"
  },
  ["choppa"] = {
    ["id"] = 6,
    ["icon"] = L"<icon20184>",
    ["shorthandle"] = L"CHP",
    ["role"] = "dps"
  },
  ["slayer"] = {
    ["id"] = 2,
    ["icon"] = L"<icon20188>",
    ["shorthandle"] = L"SLA",
    ["role"] = "dps"
  } ,
  ["whitelion"] = {
    ["id"] = 19,
    ["icon"] = L"<icon20200>",
    ["shorthandle"] = L"WL",
    ["role"] = "dps"
  },
  ["marauder"] = {
    ["id"] = 14,
    ["icon"] = L"<20192>",
    ["shorthandle"] = L"MRD",
    ["role"] = "dps"
  },
  ["witchelf"] = {
    ["id"] = 22,
    ["icon"] = L"<icon20201>",
    ["shorthandle"] = L"WE",
    ["role"] = "dps"
  },
  ["brightwizard"] = {
    ["id"] = 11,
    ["icon"] = L"<icon20183>",
    ["shorthandle"] = L"BW",
    ["role"] = "dps"
  },
  ["magus"] = {
    ["id"] = 16,
    ["icon"] = L"<icon20191>",
    ["shorthandle"] = L"MAG",
    ["role"] = "dps"
},
  ["sorcerer"] = {
    ["id"] = 24,
    ["icon"] = L"<icon20196>",
    ["shorthandle"] = L"SRC",
    ["role"] = "dps"
  },
  ["shadowwarrior"] = {
    ["id"] = 18,
    ["icon"] = L"<icon20194>",
    ["shorthandle"] = L"SW",
    ["role"] = "dps"
  },
  ["shaman"] = {
    ["id"] = 7,
    ["icon"] = L"<icon20195>",
    ["shorthandle"] = L"SHA",
    ["role"] = "heal"
  },
  ["runepriest"] = {
    ["id"] = 3,
    ["icon"] = L"<icon20193>",
    ["shorthandle"] = L"RP",
    ["role"] = "heal"
  },
  ["warriorpriest"] = {
    ["id"] = 12,
    ["icon"] = L"<icon20199>",
    ["shorthandle"] = L"WP",
    ["role"] = "heal"
  },
  ["discipleofkhaine"] = {
    ["id"] = 23,
    ["icon"] = L"<icon20186>",
    ["shorthandle"] = L"DOK",
    ["role"] = "heal"
  },
  ["archmage"] = {
    ["id"] = 20,
    ["icon"] = L"<icon20180>",
    ["shorthandle"] = L"AM",
    ["role"] = "heal"
  },
  ["zealot"] = {
    ["id"] = 15,
    ["icon"] = L"<icon20203>",
    ["shorthandle"] = L"ZEL",
    ["role"] = "heal"
  },
}

local function isStringInUtilsTable(stringToCheck)
  local isStringInTable = roleIcons[stringToCheck] or careerInfo[stringToCheck]
  if (not isStringInTable) then
    d("Invalid career string. Check contents of warExtended/Utils.lua for proper usage.")
  end
  return isStringInTable
end

function warExtended:GetTargetNames()
  local FriendlyTargetName     = TargetInfo:UnitName('selffriendlytarget'):match(L"([^^]+)^?[^^]*") or false
  local HostileTargetName      = TargetInfo:UnitName('selfhostiletarget'):match(L"([^^]+)^?[^^]*") or false
  local MouseoverTargetName    = TargetInfo:UnitName('mouseovertarget'):match(L"([^^]+)^?[^^]*") or false
  return HostileTargetName, FriendlyTargetName, MouseoverTargetName
end

function warExtended:GetRoleIconString(role)
  if not isStringInUtilsTable(role) then return end
    role  = roleIcons[role]
    roleIcon = role.icon..L" "..role.text
    return roleIcon
end

function warExtended:GetRoleIcon(role)
  if not isStringInUtilsTable(role) then return end
    role  = roleIcons[role]
    roleIcon = role.icon
    return roleIcon
end

function warExtended:GetCareerIcon(career)
  if not isStringInUtilsTable(career) then return end
  career = careerInfo[career]
  local careerIcon = career.icon
  return careerIcon
end

function warExtended:GetCareerIconString(career)
  if not isStringInUtilsTable(career) then return end
  career = careerInfo[career]
  local careerIconString = career.icon..L" "..career.shorthandle
  return careerIconString
end

function warExtended:TellPlayer(playerName, text)
  if not playerName and not text then return end
  return ChatMacro("/tell "..playerName.." "..text, "/e")
end


function warExtended:IsAddonEnabled(addon)
  local Addons = ModulesGetData()
  for _, Addon in ipairs(Addons) do
    if Addon.name == addon then
      if Addon.isEnabled then
        return true
        else
        return false
      end
    end
  end
end
