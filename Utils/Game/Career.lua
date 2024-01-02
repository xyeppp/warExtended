local warExtended      = warExtended

local TANK_ROLE = 1
local DPS_ROLE = 2
local HEALER_ROLE = 3

local TANK_ROLE_ICON = 22724
local DPS_ROLE_ICON = 22657
local HEALER_ROLE_ICON = 22706

local DWARF_RACE = 1
local ORC_RACE = 2
local GOBLIN_RACE = 3
local HE_RACE = 4
local DE_RACE = 5
local EMPIRE_RACE = 6
local CHAOS_RACE = 7

local TANK_ROLE_STRING = L"Tank"
local TANK_MULTIPLE_STRING = L"Tanks"

local DPS_ROLE_STRING = L"DPS"
local HEALER_ROLE_STRING = L"Heal"
local HEALER_MULTIPLE_ROLE_STRING = L"Healers"

local roles            = {
	[TANK_ROLE] = {
		icon = TANK_ROLE_ICON,
		text = TANK_ROLE_STRING,
		multiple = TANK_MULTIPLE_STRING
	},
	[DPS_ROLE] = {
		icon = DPS_ROLE_ICON,
		text = DPS_ROLE_STRING,
	},
	[HEALER_ROLE] = {
		icon = HEALER_ROLE_ICON,
		text = HEALER_ROLE_STRING,
		multiple = HEALER_MULTIPLE_ROLE_STRING,
	}
}

local races = {
  [DWARF_RACE] =  {
	name = L"Dwarf",
	icon = 23004,
  },
  [ORC_RACE] =  {
	name = L"Orc",
	icon = 23008,
  },
  [GOBLIN_RACE] =  {
	name = L"Goblin",
	icon = 23008,
  },
  [HE_RACE] =  {
	name = L"High Elf",
	icon = 23010,
  },
  [DE_RACE] =  {
	name = L"Dark Elf",
	icon = 23002,
  },
  [EMPIRE_RACE] =  {
	name = L"Empire",
	icon = 23006,
  },
  [CHAOS_RACE] =  {
	name = L"Chaos",
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




local careers          = {
  [1] = {
	name = L"Ironbreaker",
	line = 20,
	short = L"IB",
	icon = 20189,
	role = 1,
	race = 1,
  },
  [2] = {
	name = L"Slayer",
	line = 21,
	icon = 20188,
	short = L"SLA",
	role = 2,
	race = 1,
  },
  [3] = {
	name = L"Runepriest",
	line = 22,
	icon = 20193,
	short = L"RP",
	role = 3,
	race = 1,
  },
  [4] = {
	name = L"Engineer",
	line = 4,
	icon = 20187,
	short = L"ENG",
	role = 2,
	race = 1,
  },
  [5] = {
	name = L"Black Orc",
	id = 24,
	icon = 20182,
	short = L"BO",
	role = 1,
	race = 2,
  },
  [6] = {
	name = L"Choppa",
	id = 25,
	icon = 20184,
	short = L"CHP",
	role = 2,
	race = 2,
  },
  [7] = {
	name = L"Shaman",
	id = 26,
	icon = 20195,
	short = L"SHA",
	role = 3,
	race = 3,
  },
  [8] = {
	name = L"Squig Herder",
	id = 27,
	icon = 20197,
	short = L"SH",
	role = 2,
	race = 3,
  },
  [9] = {
	name = L"Witch Hunter",
	id = 60,
	icon = 20202,
	short = L"WH",
	role = 2,
	race = 6,
  },
  [10] = {
	name = L"Knight of the Blazing Sun",
	id = 61,
	icon = 20190,
	short = L"KOTBS",
	role = 1,
	race = 6,
  },
  [11] = {
	name = L"Bright Wizard",
	id = 62,
	icon = 20183,
	short = L"BW",
	role = 2,
	race = 6,
  },
  [12] = {
	name = L"Warrior Priest",
	id = 63,
	icon = 20199,
	short = L"WP",
	role = 3,
	race = 6,
  },
  [13] = {
	name = L"Chosen",
	id = 64,
	icon = 20185,
	short = L"CH",
	role = 1,
	race = 7,
  },
  [14] = {
	name = L"Marauder",
	id = 65,
	icon = 20192,
	short = L"MRD",
	role = 2,
	race = 7,
  },
  [15] = {
	name = L"Zealot",
	id = 66,
	icon = 20203,
	short = L"ZEL",
	role = 3,
	race = 7,
  },
  [16] = {
	name = L"Magus",
	id = 67,
	icon = 20191,
	short = L"MAG",
	role = 2,
	race = 7,
  },
  [17] = {
	name = L"Swordmaster",
	id = 100,
	icon = 20198,
	short = L"SM",
	role = 1,
	race = 4,
  },
  [18] = {
	name = L"Shadow Warrior",
	id = 101,
	icon = 20194,
	short = L"SW",
	role = 2,
	race = 4,
  },
  [19] = {
	name = L"White Lion",
	id = 102,
	icon = 20200,
	short = L"WL",
	role = 2,
	race = 4,
  },
  [20] = {
	name = L"Archmage",
	id = 103,
	icon = 20180,
	short = L"AM",
	role = 3,
	race = 4,
  },
  [21] = {
	name = L"Blackguard",
	id = 104,
	icon = 20181,
	short = L"BG",
	role = 1,
	race = 5,
  },
  [22] = {
	name = L"Witch Elf",
	id = 105,
	icon = 20201,
	short = L"WE",
	role = 2,
	race = 5,
  },
  [23] = {
	name = L"Disciple of Khaine",
	id = 106,
	icon = 20186,
	short = L"DOK",
	role = 3,
	race = 5,
  },
  [24] = {
	name = L"Sorcerer",
	id = 107,
	icon = 20196,
	short = L"SRC",
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

function warExtended:GetRoleString(career, multiple)
	return roles[self:GetCareerRole(career)]
end

function warExtended:GetCareerRoleIconString(career, multiple)
  local careerRole = roles[warExtended:GetCareerRole(career)]

  if multiple then
	local roleIconString = warExtended:GetIconString(careerRole.icon) .. L" " .. careerRole.multiple
	return self:toString(roleIconString)
  end

  local roleIconString = warExtended:GetIconString(careerRole.icon) .. L" " .. careerRole.text
  return self:toString(roleIconString)
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
  local icon       = self:GetIconString(self:GetCareerIcon(career))
  return icon
end

function warExtended:GetCareerShorthandle(career)
  local careerData = getCareerData(career)
  return careerData.short
end

function warExtended:GetCareerIconShorthandleString(career)
  local careerIcon       = self:GetCareerIconString(career)
  local shorthandle      = self:GetCareerShorthandle(career) or career
  local careerIconString = careerIcon .. L" " .. shorthandle
  return self:toString(careerIconString)
end

