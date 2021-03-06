local warExtended = warExtended

local careerNameToLine = {
  ["Ironbreaker"] = 1,
  ["Slayer"] = 2,
  ["Runepriest"] = 3,
  ["Engineer"] = 4,
  ["Black Orc"] = 5,
  ["Choppa"] = 6,
  ["Shaman"] = 7,
  ["Squig Herder"] = 8,
  ["Witch Hunter"] = 9,
  ["Knight of the Blazing Sun"] = 10,
  ["Bright Wizard"] = 11,
  ["Warrior Priest"] = 12,
  ["Chosen"] = 13,
  ["Marauder"] = 14,
  ["Zealot"] = 15,
  ["Magus"] = 16,
  ["Swordmaster"] = 17,
  ["Shadow Warrior"] = 18,
  ["White Lion"] = 19,
  ["Archmage"] = 20,
  ["Blackguard"] = 21,
  ["Witch Elf"] = 22,
  ["Disciple of Khaine"] = 23,
  ["Sorcerer"] = 24
}

local roles = {
  [1] = {
    icon = 22724,
    text = "Tank",
    multiple = "Tanks"
  },
  [2] = {
    icon = 22657,
    text = "DPS",
  },
  [3] = {
    icon = 22706,
    text = "Heal",
    multiple = "Healers",
  }
}

 local careers = {
  [1] =  {
    name = "Ironbreaker",
    line = 20,
    short = "IB",
    icon = 20189,
    role = 1
},
  [2] = {
    name = "Slayer",
    line = 21,
    icon = 20188,
    short = "SLA",
    role = 2
  },
  [3] = {
    name = "Runepriest",
    line = 22,
    icon = 20193,
    short = "RP",
    role = 3,
  },
  [4] = {
    name = "Engineer",
    line = 4,
    icon = 20187,
    short = "ENG",
    role = 2
  },
  [5] =  {
    name = "Black Orc",
    id = 24,
    icon = 20182,
    short = "BO",
    role = 1
},
  [6] = {
    name = "Choppa",
    id = 25,
    icon = 20184,
    short = "CHP",
    role = 2
  },
  [7]= {
    name = "Shaman",
    id = 26,
    icon = 20195,
    short = "SHA",
    role = 3
  },
  [8] = {
    name = "Squig Herder",
    id = 27,
    icon = 20197,
    short = "SH",
    role = 2
  },
  [9] =  {
    name = "Witch Hunter",
    id = 60,
    icon = 20202 ,
    short = "WH",
    role = 2
  },
  [10] = {
    name = "Knight of the Blazing Sun",
    id = 61,
    icon = 20190,
    short = "KOTBS",
    role = 1
  },
  [11] = {
    name = "Bright Wizard",
    id = 62,
    icon = 20183,
    short = "BW",
    role = 2
  },
  [12] = {
    name = "Warrior Priest",
    id = 63,
    icon= 20199,
    short = "WP",
    role = 3
  },
  [13] = {
    name = "Chosen",
    id = 64,
    icon = 20185,
    short = "CH",
    role = 1
  },
  [14] = {
    name = "Marauder",
    id = 65,
    icon = 20192,
    short = "MRD",
    role = 2
  },
  [15] = {
    name = "Zealot",
    id = 66,
    icon = 20203,
    short = "ZEL",
    role = 3
  },
  [16] = {
    name = "Magus",
    id = 67,
    icon = 20191,
    short  = "MAG",
    role = 2
  },
  [17] = {
    name = "Swordmaster",
    id = 100,
    icon = 20198,
    short = "SM",
    role = 1
  },
  [18] = {
    name = "Shadow Warrior",
    id = 101,
    icon = 20194,
    short = "SW",
    role = 2
  },
  [19] = {
    name = "White Lion",
    id = 102,
    icon = 20200,
    short = "WL",
    role = 2
  },
  [20] = {
    name = "Archmage",
    id  = 103,
    icon = 20180,
    short = "AM",
    role = 3
  },
  [21] = {
    name = "Blackguard",
    id= 104,
    icon = 20181,
    short = "BG",
    role = 1
  },
  [22] = {
    name = "Witch Elf",
    id = 105,
    icon = 20201,
    short = "WE",
    role = 2
  },
  [23] = {
    name = "Disciple of Khaine",
    id = 106,
    icon = 20186,
    short = "DOK",
    role = 3
  },
  [24] = {
    name = "Sorcerer",
    id = 107,
    icon = 20196,
    short = "SRC",
    role = 2
  },
 }

local function getCareerData(career)
  local careerData = careers[career] or careers[careerNameToLine[career]] or careers[warExtended:GetPlayerCareerLine()]
  return careerData
end

function warExtended:GetCareerLine(career)
  return careerNameToLine[career]
end

function warExtended:GetCareerId(career)
  local careerData = getCareerData(career)
  return careerData.id
end

function warExtended:GetCareerRole(career)
  local careerData = getCareerData(career)
  return careerData.role
end

function warExtended:GetCareerSpecializationPath(career, path)
  local specs = {
    [1] = 3*career-2,
    [2] = 3*career-1,
    [3] = 3*career,
  }
  
  return specs[path]
end

function warExtended:GetCareerRoleIconString(career, multiple)
  local careerRole = roles[warExtended:GetCareerRole(career)]
  
  if multiple then
    local roleIconString = warExtended:GetIconString(careerRole.icon).." "..careerRole.multiple
    return roleIconString
  end
  
  local roleIconString = warExtended:GetIconString(careerRole.icon).." "..careerRole.text
  return roleIconString
end

function warExtended:GetCareerRoleIcon(career)
    local careerRole = roles[warExtended:GetCareerRole(career)]
    return careerRole.icon
end

function warExtended:GetCareerIcon(career)
  local careerData = getCareerData(career)
  return careerData.icon
end

function warExtended:GetCareerIconString(career)
  local careerData = getCareerData(career)
  local icon = warExtended:GetIconString(careerData.icon)
  return icon
end

function warExtended:GetCareerShorthandle(career)
  local careerData = getCareerData(career)
  return careerData.short
end

function warExtended:GetCareerIconShorthandleString(career)
 local careerIcon = warExtended:GetCareerIconString(career)
 local shorthandle = warExtended:GetCareerShorthandle(career)
 local careerIconString = careerIcon.." "..shorthandle
 return careerIconString
end

