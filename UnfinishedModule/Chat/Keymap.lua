local warExtended = warExtended
local warExtendedChat = warExtendedChat

local keymap = {
-- General
['$level'] = function()
  local str = warExtended:GetPlayerLevelString()
  return str
end,

['$mastery'] = function()
  local m1,m2,m3 = warExtended:GetPlayerMasteryLevels()
  local str = warExtended:GetCareerRoleIconString().." "..m1.."/"..m2.."/"..m3
  return str
end,

-- Links
['$guild'] = function()
return warExtended.GetHyperlink(guild, nil)
end,
['$warband'] = function()
return warExtended.GetHyperlink(warband, playerName)
end,
['$discord'] = function()
return warExtended.GetHyperlink(discord, nil)
end,
['$join'] = function()
return warExtended.GetHyperlink(join, playerName)
end,
['$invite'] = function()
return warExtended.GetHyperlink(invite, playerName)
end,
['$tell'] = function()
return warExtended.GetHyperlink(tell, playerName)
end,
['$inspect'] = function()
end,


-- Patterns
['!!(%a+)'] = function(text)
  local color = DefaultColor.MAGENTA
  local link = tostring(CreateHyperLink( L"INVITE:"..towstring(text), L"[Invite:"..towstring(text)..L"]", {color.r, color.g, color.b}, {} ))
  return link
end,


-- Class
['$ib'] = function ()
  local str = warExtended:GetCareerIconShorthandleString("Ironbreaker")
  return str
end,
['$bo'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Black Orc")
  return str
end,
['$wh'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Witch Hunter")
  return str
end,
['$eng'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Engineer")
  return str
end,
['$sq'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Squig Herder")
  return str
end,
['$chp'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Choppa")
  return str
end,
['$sla'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Slayer")
  return str
end,
['$sha'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Shaman")
  return str
end,
['$rp'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Runepriest")
  return str
end,
['$kotbs'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Knight of the Blazing Sun")
  return str
end,
['$sm'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Swordmaster")
  return str
end,
['$cho'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Choppa")
  return str
end,
['$bg'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Blackguard")
  return str
end,
['$wl'] = function()
  local str = warExtended:GetCareerIconShorthandleString("White Lion")
  return str
end,
['$mrd'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Marauder")
  return str
end,
['$we'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Witch Elf")
  return str
end,
['$bw'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Bright Wizard")
  return str
end,
['$mag'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Magus")
  return str
end,
['$src'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Sorcerer")
  return str
end,
['$sw'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Shadow Warrior")
  return str
end,
['$wp'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Warrior Priest")
  return str
end,
['$dok'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Disciple of Khaine")
  return str
end,
['$am'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Archmage")
  return str
end,
['$zel'] = function()
  local str = warExtended:GetCareerIconShorthandleString("Zealot")
  return str
end,



-- Roles
['$tank'] = function()
  local str = warExtended:GetCareerRoleIconString("Ironbreaker")
  return str
end,
['$dps'] = function()
  local str = warExtended:GetCareerRoleIconString("Squig Herder")
  return str
end,
['$heal'] = function()
  local str = warExtended:GetCareerRoleIconString("Zealot")
  return str
end,

['$tanks'] = function()
  local str = warExtended:GetCareerRoleIconString("Ironbreaker", true)
  return str
end,

['$heals'] = function()
  local str = warExtended:GetCareerRoleIconString("Zealot", true)
  return str
end,

-- Target
["$ft"] = function()
  local friendlyName = warExtended:GetTargetName("friendly")
  return friendlyName
end,
["$et"] = function()
  local enemyName = warExtended:GetTargetName("enemy")
  return enemyName
end,
["$mt"] = function()
  local mouseoverName = warExtended:GetTargetName("mouseover")
  return mouseoverName
end,

["$fhp"] = function()
  local friendlyHp = warExtended:GetTargetHealth("friendly")
  return friendlyHp
end,
["$ehp"] = function()
  local enemyHp = warExtended:GetTargetHealth("enemy")
  return enemyHp
end,
["$mhp"] = function()
  local mouseoverHp = warExtended:GetTargetHealth("enemy")
  return mouseoverHp
end,

["$fcr"] = function()
  local friendlyCareer = warExtended:GetTargetCareer("friendly")
  if friendlyCareer ~= 0 then
    friendlyCareer = warExtended:GetCareerIconShorthandleString(friendlyCareer)
  end
  return friendlyCareer
end,
["$ecr"] = function()
  local enemyCareer = warExtended:GetTargetCareer("enemy")
  if enemyCareer ~= 0 then
    enemyCareer = warExtended:GetCareerIconShorthandleString(enemyCareer)
  end
  return enemyCareer
end,
["$mcr"] = function()
  local mouseoverCareer = warExtended:GetTargetCareer("mouseover")
  if mouseoverCareer ~= 0 then
    mouseoverCareer = warExtended:GetCareerIconShorthandleString(mouseoverCareer)
  end
  return mouseoverCareer
end,

["$flvl"] = function()
  local friendlyLevel = warExtended:GetTargetLevel("friendly")
  return friendlyLevel
end,
["$elvl"] = function()
  local enemyLevel = warExtended:GetTargetLevel("enemy")
  return enemyLevel
end,
["$mlvl"] = function()
  local mouseoverLevel = warExtended:GetTargetLevel("mouseover")
  return mouseoverLevel
end
}


warExtendedChat:RegisterKeymap(keymap)