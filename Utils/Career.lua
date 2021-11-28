local warExtended = warExtended
local ipairs = ipairs

local roleIcons = {
  ["tank"] = {
    ["icon"] = 22724,
    ["text"] = "Tank",
    ["plural"] = "Tanks"
  },
  ["dps"] = {
    ["icon"] = 22657,
    ["text"] = "DPS",
  },
  ["heal"] = {
    ["icon"] = 22706,
    ["text"] = "Heal",
    ["plural"] = "Healers",
  }
}

 local careerInfo = {
  ["ironbreaker"] =  {
    ["id"] = 1 ,
    ["shorthandle"] = "IB",
    ["icon"] = 20189,
    ["role"] = "tank"
},
  ["blackorc"] =  {
    ["id"] = 5,
    ["icon"] = 20182,
    ["shorthandle"] = "BO",
    ["role"] = "tank"
},
  ["kotbs"] = {
    ["id"] = 10,
    ["icon"] = 20190,
    ["shorthandle"] = "KOTBS",
    ["role"] = "tank"
  },
  ["swordmaster"] = {
    ["id"] = 17,
    ["icon"] = 20198,
    ["shorthandle"] = "SM",
    ["role"] = "tank"
  },
  ["chosen"] = {
    ["id"] = 13,
    ["icon"] = 20185,
    ["shorthandle"] = "CH",
    ["role"] = "tank"
  },
  ["blackguard"] = {
    ["id"] = 21,
    ["icon"] = 20181,
    ["shorthandle"] = "BG",
    ["role"] = "tank"
  },
  ["witchhunter"] =  {
    ["id"] = 9,
    ["icon"] = 20202 ,
    ["shorthandle"] = "WH",
    ["role"] = "dps"
  },
  ["engineer"] = {
    ["id"] = 4,
    ["icon"] = 20187,
    ["shorthandle"] = "ENG",
    ["role"] = "dps"
  },
  ["squigherder"] = {
    ["id"] = 8,
    ["icon"] = 20197,
    ["shorthandle"] = "SH",
    ["role"] = "dps"
  },
  ["choppa"] = {
    ["id"] = 6,
    ["icon"] = 20184,
    ["shorthandle"] = "CHP",
    ["role"] = "dps"
  },
  ["slayer"] = {
    ["id"] = 2,
    ["icon"] = 20188,
    ["shorthandle"] = "SLA",
    ["role"] = "dps"
  } ,
  ["whitelion"] = {
    ["id"] = 19,
    ["icon"] = 20200,
    ["shorthandle"] = "WL",
    ["role"] = "dps"
  },
  ["marauder"] = {
    ["id"] = 14,
    ["icon"] = 20192,
    ["shorthandle"] = "MRD",
    ["role"] = "dps"
  },
  ["witchelf"] = {
    ["id"] = 22,
    ["icon"] = 20201,
    ["shorthandle"] = "WE",
    ["role"] = "dps"
  },
  ["brightwizard"] = {
    ["id"] = 11,
    ["icon"] = 20183,
    ["shorthandle"] = "BW",
    ["role"] = "dps"
  },
  ["magus"] = {
    ["id"] = 16,
    ["icon"] = 20191,
    ["shorthandle"] = "MAG",
    ["role"] = "dps"
},
  ["sorcerer"] = {
    ["id"] = 24,
    ["icon"] = 20196,
    ["shorthandle"] = "SRC",
    ["role"] = "dps"
  },
  ["shadowwarrior"] = {
    ["id"] = 18,
    ["icon"] = 20194,
    ["shorthandle"] = "SW",
    ["role"] = "dps"
  },
  ["shaman"] = {
    ["id"] = 7,
    ["icon"] = 20195,
    ["shorthandle"] = "SHA",
    ["role"] = "heal"
  },
  ["runepriest"] = {
    ["id"] = 3,
    ["icon"] = 20193,
    ["shorthandle"] = "RP",
    ["role"] = "heal"
  },
  ["warriorpriest"] = {
    ["id"] = 12,
    ["icon"] = 20199,
    ["shorthandle"] = "WP",
    ["role"] = "heal"
  },
  ["discipleofkhaine"] = {
    ["id"] = 23,
    ["icon"] = 20186,
    ["shorthandle"] = "DOK",
    ["role"] = "heal"
  },
  ["archmage"] = {
    ["id"] = 20,
    ["icon"] = 20180,
    ["shorthandle"] = "AM",
    ["role"] = "heal"
  },
  ["zealot"] = {
    ["id"] = 15,
    ["icon"] = 20203,
    ["shorthandle"] = "ZEL",
    ["role"] = "heal"
  },
}


local function isStringInUtilsTable(stringToCheck)
  local isStringInTable = roleIcons[stringToCheck] or careerInfo[stringToCheck]
  if not isStringInTable then
    d("Invalid career string. Check contents of warExtended/Utils.lua for proper usage.")
  end
  return isStringInTable
end


function warExtended:GetRoleFromCareerID(careerID)

  for _, careerData in pairs(careerInfo) do
    if careerID == careerData.id then
      return careerData.role
    end
  end

end

function warExtended:GetRoleIconString(role, plural)
  if not isStringInUtilsTable(role) then return end
  role  = roleIcons[role]
  local roleIconString = warExtended:GetIcon(role.icon).." "..role.text

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

