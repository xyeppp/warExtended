local warExtended = warExtended
local pairs=pairs
local ipairs=ipairs
local addonLink = warExtended.getSelfHyperlink

local SlashCommands = {
  ["enh"] = function() return warExtended.PrintHelp() end,
}

function warExtended.PrintHelp()
  EA_ChatWindow.Print(addonLink..L"-----------------")
  EA_ChatWindow.Print(addonLink..L"/Test - to see and set your QNA quick-messages")
end

function warExtended.RegisterSlashCommands()
  for Command, CommandFunction in pairs(SlashCommands) do
    LibSlash.RegisterSlashCmd(Command, CommandFunction)
  end
end
