local Mirage = warExtendedMirage

local slashCommands = {
  mirage = {
	func = Mirage.ToggleWindow,
	desc = "Toggle Mirage window."
  }
}

function Mirage.RegisterSlashCommand()
  Mirage:RegisterSlash(slashCommands, "warext")
end