local warExtended = warExtended
local ipairs = ipairs

local roleIcons = {
  ["tank"] = {
    ["icon"] = "<icon22724>",
    ["text"] = "Tank",
    ["plural"] = "Tanks"
  },
  ["dps"] = {
    ["icon"] = "<icon22657>",
    ["text"] = "DPS",
  },
  ["heal"] = {
    ["icon"] = "<icon22706>",
    ["text"] = "Heal",
    ["plural"] = "Healers",
  }
}

 local careerInfo = {
  ["ironbreaker"] =  {
    ["id"] = 1 ,
    ["shorthandle"] = "IB",
    ["icon"] = "<icon20189>",
    ["role"] = "tank"
},
  ["blackorc"] =  {
    ["id"] = 5,
    ["icon"] = "<icon20182>",
    ["shorthandle"] = "BO",
    ["role"] = "tank"
},
  ["kotbs"] = {
    ["id"] = 10,
    ["icon"] = "<icon20190>",
    ["shorthandle"] = "KOTBS",
    ["role"] = "tank"
  },
  ["swordmaster"] = {
    ["id"] = 17,
    ["icon"] = "<icon20198>",
    ["shorthandle"] = "SM",
    ["role"] = "tank"
  },
  ["chosen"] = {
    ["id"] = 13,
    ["icon"] = "<icon20185>",
    ["shorthandle"] = "CH",
    ["role"] = "tank"
  },
  ["blackguard"] = {
    ["id"] = 21,
    ["icon"] = "<icon20181>",
    ["shorthandle"] = "BG",
    ["role"] = "tank"
  },
  ["witchhunter"] =  {
    ["id"] = 9,
    ["icon"] = "<icon20202>" ,
    ["shorthandle"] = "WH",
    ["role"] = "dps"
  },
  ["engineer"] = {
    ["id"] = 4,
    ["icon"] = "<icon20187>",
    ["shorthandle"] = "ENG",
    ["role"] = "dps"
  },
  ["squigherder"] = {
    ["id"] = 8,
    ["icon"] = "<icon20197>",
    ["shorthandle"] = "SH",
    ["role"] = "dps"
  },
  ["choppa"] = {
    ["id"] = 6,
    ["icon"] = "<icon20184>",
    ["shorthandle"] = "CHP",
    ["role"] = "dps"
  },
  ["slayer"] = {
    ["id"] = 2,
    ["icon"] = "<icon20188>",
    ["shorthandle"] = "SLA",
    ["role"] = "dps"
  } ,
  ["whitelion"] = {
    ["id"] = 19,
    ["icon"] = "<icon20200>",
    ["shorthandle"] = "WL",
    ["role"] = "dps"
  },
  ["marauder"] = {
    ["id"] = 14,
    ["icon"] = "<icon20192>",
    ["shorthandle"] = "MRD",
    ["role"] = "dps"
  },
  ["witchelf"] = {
    ["id"] = 22,
    ["icon"] = "<icon20201>",
    ["shorthandle"] = "WE",
    ["role"] = "dps"
  },
  ["brightwizard"] = {
    ["id"] = 11,
    ["icon"] = "<icon20183>",
    ["shorthandle"] = "BW",
    ["role"] = "dps"
  },
  ["magus"] = {
    ["id"] = 16,
    ["icon"] = "<icon20191>",
    ["shorthandle"] = "MAG",
    ["role"] = "dps"
},
  ["sorcerer"] = {
    ["id"] = 24,
    ["icon"] = "<icon20196>",
    ["shorthandle"] = "SRC",
    ["role"] = "dps"
  },
  ["shadowwarrior"] = {
    ["id"] = 18,
    ["icon"] = "<icon20194>",
    ["shorthandle"] = "SW",
    ["role"] = "dps"
  },
  ["shaman"] = {
    ["id"] = 7,
    ["icon"] = "<icon20195>",
    ["shorthandle"] = "SHA",
    ["role"] = "heal"
  },
  ["runepriest"] = {
    ["id"] = 3,
    ["icon"] = "<icon20193>",
    ["shorthandle"] = "RP",
    ["role"] = "heal"
  },
  ["warriorpriest"] = {
    ["id"] = 12,
    ["icon"] = "<icon20199>",
    ["shorthandle"] = "WP",
    ["role"] = "heal"
  },
  ["discipleofkhaine"] = {
    ["id"] = 23,
    ["icon"] = "<icon20186>",
    ["shorthandle"] = "DOK",
    ["role"] = "heal"
  },
  ["archmage"] = {
    ["id"] = 20,
    ["icon"] = "<icon20180>",
    ["shorthandle"] = "AM",
    ["role"] = "heal"
  },
  ["zealot"] = {
    ["id"] = 15,
    ["icon"] = "<icon20203>",
    ["shorthandle"] = "ZEL",
    ["role"] = "heal"
  },
}


local function getGroupType()
  if (IsWarBandActive()) then
    return 3
  end
  if (GetNumGroupmates() > 0) then
    return 2
  end
  return 1
end

local function isStringInUtilsTable(stringToCheck)
  local isStringInTable = roleIcons[stringToCheck] or careerInfo[stringToCheck]
  if not isStringInTable then
    d("Invalid career string. Check contents of warExtended/Utils.lua for proper usage.")
  end
  return isStringInTable
end


local function getRoleFromCareerID(careerID)
  for _, careerData in pairs(careerInfo) do
    if careerID == careerData.id then
      return careerData.role
    end
  end
end


function warExtended:GetGroupRoleCount(groupData)
  local isLeaderAlone = groupData.Group == nil
  local groupRoleCount = {
    tank = 0,
    dps = 0,
    heal = 0
  }

    if isLeaderAlone then
      local leaderCareer = groupData.leaderCareer
      local leaderRole = getRoleFromCareerID(leaderCareer)
      groupRoleCount[leaderRole] = groupRoleCount[leaderRole] + 1
    else
      for member=1,#groupData.Group do
        local memberCareer=groupData.Group[member].m_careerID
        local careerRole = getRoleFromCareerID(memberCareer)
        groupRoleCount[careerRole] = groupRoleCount[careerRole] + 1
      end
    end

    return groupRoleCount.tank, groupRoleCount.dps, groupRoleCount.heal
  end



function warExtended:GetTargetNames()
  local FriendlyTargetName     = TargetInfo:UnitName('selffriendlytarget'):match(L"([^^]+)^?[^^]*") or false
  local HostileTargetName      = TargetInfo:UnitName('selfhostiletarget'):match(L"([^^]+)^?[^^]*") or false
  local MouseoverTargetName    = TargetInfo:UnitName('mouseovertarget'):match(L"([^^]+)^?[^^]*") or false
  return HostileTargetName, FriendlyTargetName, MouseoverTargetName
end



function warExtended:GetRoleIconString(role, plural)
  if not isStringInUtilsTable(role) then return end
  role  = roleIcons[role]
  local roleIconString = role.icon.." "..role.text

  if plural then
    roleIconString = role.icon.." "..role.plural
  end

  return roleIconString
end

function warExtended:GetRoleIcon(role)
  if not isStringInUtilsTable(role) then return end
    role  = roleIcons[role]
    return role.icon
end

function warExtended:GetCareerIcon(career)
  if not isStringInUtilsTable(career) then return end
  career = careerInfo[career]
  return career.icon
end

function warExtended:GetCareerIconString(career)
  if not isStringInUtilsTable(career) then return end
  career = careerInfo[career]
  local careerIconString = career.icon.." "..career.shorthandle
  return careerIconString
end

function warExtended:TellPlayer(playerName, text)
  if not playerName and not text then return end
  ChatMacro("/tell "..playerName.." "..text, "")
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
