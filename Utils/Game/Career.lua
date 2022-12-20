local warExtended      = warExtended

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

local roles            = {
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


local races = {
  [1] =  {
	name = "Dwarf",
	icon = 23004,
  },
  [2] =  {
	name = "Orc",
	icon = 23008,
  },
  [3] =  {
	name = "Goblin",
	icon = 23008,
  },
  [4] =  {
	name = "High Elf",
	icon = 23010,
  },
  [5] =  {
	name = "Dark Elf",
	icon = 23002,
  },
  [6] =  {
	name = "Empire",
	icon = 23006,
  },
  [7] =  {
	name = "Chaos",
	icon = 23000,
  },
  
}
--[[Enemy.ScenarioCareerIdToLine =
{
  [20] = GameData.CareerLine.IRON_BREAKER,
  [100] = GameData.CareerLine.SWORDMASTER,
  [64] = GameData.CareerLine.CHOSEN,
  [24] = GameData.CareerLine.BLACK_ORC,
  [60] = GameData.CareerLine.WITCH_HUNTER,
  [102] = GameData.CareerLine.WHITE_LION,
  [65] = GameData.CareerLine.MARAUDER,
  [105] = GameData.CareerLine.WITCH_ELF,
  [62] = GameData.CareerLine.BRIGHT_WIZARD,
  [67] = GameData.CareerLine.MAGUS,
  [107] = GameData.CareerLine.SORCERER,
  [23] = GameData.CareerLine.ENGINEER,
  [101] = GameData.CareerLine.SHADOW_WARRIOR,
  [27] = GameData.CareerLine.SQUIG_HERDER,
  [63] = GameData.CareerLine.WARRIOR_PRIEST,
  [106] = GameData.CareerLine.DISCIPLE,
  [103] = GameData.CareerLine.ARCHMAGE,
  [26] = GameData.CareerLine.SHAMAN,
  [22] = GameData.CareerLine.RUNE_PRIEST,
  [66] = GameData.CareerLine.ZEALOT,
  [104] = GameData.CareerLine.BLACKGUARD,
  [61] = GameData.CareerLine.KNIGHT,
  [25] = GameData.CareerLine.CHOPPA,
  [21] = GameData.CareerLine.SLAYER
}
-
--- send string mastery icon based on points allocated

local CareersWithPet   = {
  [GameData.CareerLine.WHITE_LION] = true,
  [GameData.CareerLine.MAGUS] = true,
  [GameData.CareerLine.ENGINEER] = true,
  [GameData.CareerLine.SQUIG_HERDER] = true
}]]



local careers          = {
  [1] = {
	name = "Ironbreaker",
	line = 20,
	short = "IB",
	icon = 20189,
	role = 1,
	race = 1,
  },
  [2] = {
	name = "Slayer",
	line = 21,
	icon = 20188,
	short = "SLA",
	role = 2,
	race = 1,
  },
  [3] = {
	name = "Runepriest",
	line = 22,
	icon = 20193,
	short = "RP",
	role = 3,
	race = 1,
  },
  [4] = {
	name = "Engineer",
	line = 4,
	icon = 20187,
	short = "ENG",
	role = 2,
	race = 1,
  },
  [5] = {
	name = "Black Orc",
	id = 24,
	icon = 20182,
	short = "BO",
	role = 1,
	race = 2,
  },
  [6] = {
	name = "Choppa",
	id = 25,
	icon = 20184,
	short = "CHP",
	role = 2,
	race = 2,
  },
  [7] = {
	name = "Shaman",
	id = 26,
	icon = 20195,
	short = "SHA",
	role = 3,
	race = 3,
  },
  [8] = {
	name = "Squig Herder",
	id = 27,
	icon = 20197,
	short = "SH",
	role = 2,
	race = 3,
  },
  [9] = {
	name = "Witch Hunter",
	id = 60,
	icon = 20202,
	short = "WH",
	role = 2,
	race = 6,
  },
  [10] = {
	name = "Knight of the Blazing Sun",
	id = 61,
	icon = 20190,
	short = "KOTBS",
	role = 1,
	race = 6,
  },
  [11] = {
	name = "Bright Wizard",
	id = 62,
	icon = 20183,
	short = "BW",
	role = 2,
	race = 6,
  },
  [12] = {
	name = "Warrior Priest",
	id = 63,
	icon = 20199,
	short = "WP",
	role = 3,
	race = 6,
  },
  [13] = {
	name = "Chosen",
	id = 64,
	icon = 20185,
	short = "CH",
	role = 1,
	race = 7,
  },
  [14] = {
	name = "Marauder",
	id = 65,
	icon = 20192,
	short = "MRD",
	role = 2,
	race = 7,
  },
  [15] = {
	name = "Zealot",
	id = 66,
	icon = 20203,
	short = "ZEL",
	role = 3,
	race = 7,
  },
  [16] = {
	name = "Magus",
	id = 67,
	icon = 20191,
	short = "MAG",
	role = 2,
	race = 7,
  },
  [17] = {
	name = "Swordmaster",
	id = 100,
	icon = 20198,
	short = "SM",
	role = 1,
	race = 4,
  },
  [18] = {
	name = "Shadow Warrior",
	id = 101,
	icon = 20194,
	short = "SW",
	role = 2,
	race = 4,
  },
  [19] = {
	name = "White Lion",
	id = 102,
	icon = 20200,
	short = "WL",
	role = 2,
	race = 4,
  },
  [20] = {
	name = "Archmage",
	id = 103,
	icon = 20180,
	short = "AM",
	role = 3,
	race = 4,
  },
  [21] = {
	name = "Blackguard",
	id = 104,
	icon = 20181,
	short = "BG",
	role = 1,
	race = 5,
  },
  [22] = {
	name = "Witch Elf",
	id = 105,
	icon = 20201,
	short = "WE",
	role = 2,
	race = 5,
  },
  [23] = {
	name = "Disciple of Khaine",
	id = 106,
	icon = 20186,
	short = "DOK",
	role = 3,
	race = 5,
  },
  [24] = {
	name = "Sorcerer",
	id = 107,
	icon = 20196,
	short = "SRC",
	role = 2,
	race = 5,
  },
}


local function getCareerData(career)
  local careerData = careers[career] or careers[careerNameToLine[career]] or careers[warExtended:GetPlayerCareerLine()]
  return careerData
end

function warExtended:GetCareerRace(career)
  local careerData = getCareerData(career)
  return careerData.race
end

function warExtended:GetCareerRaceIcon(career)
	local raceData = races[warExtended:GetCareerRace(career)]
  	return raceData.icon
end

function warExtended:GetRaceIcon(race)
  local raceData = races[race]
  return raceData.icon
end

function warExtended:GetCareerName(career)
  local careerData = getCareerData(career)
  return careerData.name
end

function warExtended:GetCareerRaceName(career)
  local raceData = races[warExtended:GetCareerRace(career)]
  return raceData.name
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
	[1] = 3 * career - 2,
	[2] = 3 * career - 1,
	[3] = 3 * career,
  }
  
  return specs[path]
end

function warExtended:GetCareerRoleIconString(career, multiple)
  local careerRole = roles[warExtended:GetCareerRole(career)]
  
  if multiple then
	local roleIconString = warExtended:GetIconString(careerRole.icon) .. " " .. careerRole.multiple
	return roleIconString
  end
  
  local roleIconString = warExtended:GetIconString(careerRole.icon) .. " " .. careerRole.text
  return roleIconString
end

function warExtended:GetCareerRoleIcon(career)
  local careerRole = roles[warExtended:GetCareerRole(career)].icon
  return careerRole.icon
end

function warExtended:GetCareerIcon(career)
  local isNPC = career == 0
  
  if isNPC then
	local NPCicon = 75
	return NPCicon
  end
  
  local careerData = getCareerData(career)
  return careerData.icon
end

function warExtended:GetCareerIconString(career)
  local careerData = getCareerData(career)
  local icon       = warExtended:GetIconString(careerData.icon)
  return icon
end

function warExtended:GetCareerShorthandle(career)
  local careerData = getCareerData(career)
  return careerData.short
end

function warExtended:GetCareerIconShorthandleString(career)
  local careerIcon       = warExtended:GetCareerIconString(career)
  local shorthandle      = warExtended:GetCareerShorthandle(career)
  local careerIconString = careerIcon .. " " .. shorthandle
  return careerIconString
end

