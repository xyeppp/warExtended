local Healer = warExtendedInteraction

if not Healer.Settings then
    Healer.Settings = {}
end
if not Healer.Settings.autoHealInteract then
    Healer.Settings.autoHealInteract = false;
end

local function onInteractShowHealer(penaltyCount, costToRemove)
  if Healer.Settings.isEnabled then
	local cost = MoneyFrame.FormatMoneyString(costToRemove * penaltyCount)
	Healer:Print(L"Automatically healed "..penaltyCount.. L" penalties for a total cost of "..cost..L".")
	
	EA_Window_InteractionHealer.HealAllPenalties()
  end
end

--TODO: Initialize OnInitializeHealer

function Healer.OnInitializeHealer()
  Healer:Hook(EA_Window_InteractionHealer.Show, onInteractShowHealer, true)
end