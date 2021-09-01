warExtendedItemStacking = warExtended.Register("warExtended:Item Stacking" )

local ItemStacking = warExtendedItemStacking
local textBox = "ItemStackingWindowTextInput"

local function testfunction(inviteName)
local color = DefaultColor.MAGENTA
local link = CreateHyperLink( towstring("INVITE:"..inviteName), towstring("[Invite:"..(inviteName).."]"), {color.r, color.g, color.b}, {} )
return tostring(link)
end

local function IconReplace(iconNumber)
   local iconString  = "<icon"..iconNumber..">"
   return iconString
end


local slashCommands = {
  -- ["$das"] = function (...) return testfunction(...) end,
   ["$test"] = warExtended:GetCareerIcon("ironbreaker"),
   ["$tester"] = warExtended:GetCareerIconString("blackorc"),
   ["%tester"] = warExtended:GetRoleIconString("dps"),
   ["#tester"] = warExtended:GetRoleIcon("tank"),
   ["$ft"] = function() return TargetInfo:UnitName("selffriendlytarget") end,
   ["!!(%a+)"] = function (...) return testfunction(...) end,
   ["$ico(%d+)"] = function (...) return IconReplace(... ) end,
--["$et"] = TargetInfo:UnitName("selfhostiletarget"):match(L"([^^]+)^?[^^]*") ,
   ["$mt"] = function () return tostring(TargetInfo:UnitName("mouseovertarget")) end,
--["$ehp"] = (L"HP: "..towstring(TargetInfo:UnitHealth("selfhostiletarget")..L"%%")),
--["$fhp"] = ("HP: "..(TargetInfo:UnitHealth("selffriendlytarget").."%%")),
--["$mhp"] = function() return towstring(L"HP: "..towstring(TargetInfo:UnitHealth("mouseovertarget")..L"%%")) end ,
--["$fcr"] = TargetInfo:UnitCareer("selfriendlytarget"),
--["$ecr"] = function() return towstring(L"CR: "..towstring(QuickNameActionsRessurected.ClassSearcher(TargetInfo:UnitCareer("selfhostiletarget")))) end,
--["$mcr"] = function() return towstring(L"CR: "..towstring(QuickNameActionsRessurected.ClassSearcher(TargetInfo:UnitCareer("mouseovertarget")))) end,
--["$elvl"] = "LVL:"..(TargetInfo:UnitLevel("selfhostiletarget")),
   ["$flvl"] = function () return tostring(TargetInfo:UnitLevel("selffriendlytarget")) end,
["$mlvl"] = function() return TargetInfo:UnitLevel("mouseovertarget") end,

}



function ItemStacking:TestFunction()
   ItemStacking:RegisterKeymap(slashCommands)
end



ItemStackingWindow.MAX_NON_STACKABLE_ITEMS = 1000

if not ItemStacking.history then
   ItemStacking.history={}
end

function ItemStacking.GetHistory()
   TextEditBoxSetHistory(textBox, ItemStacking.history )
end

function ItemStacking.SetHistory()
   DebugWindow.history = TextEditBoxGetHistory(textBox)
end

--function ItemStacking.AddToHistory()
  -- local text = TextEditBoxGetText(textBox)
   --ItemStacking.history[#ItemStacking.history+1]=text
--end

ItemStacking:Hook(ItemStackingWindow.Initialize, ItemStacking.GetHistory)
ItemStacking:Hook(ItemStackingWindow.Shutdown, ItemStacking.SetHistory)
--ItemStacking:Hook(ItemStackingWindow.OnKeyEnter, ItemStacking.AddToHistory)
--ItemStacking:Hook(ItemStackingWindow.OkayButton, ItemStacking.AddToHistory)
