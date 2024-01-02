local warExtended = warExtended
local pairs = pairs
local StringSplit = StringSplit
local unpack = unpack
local slashCommands = {}

local slash = warExtendedSet:New()
--TODO: change slash into warExt module global
--TODO:make this into set like keymap and save into modules
--All arguments get handled via warExt Slash Handler with an argument split on # character

--slashCommands = {
--  ["command"] = foo
--    {
--      ["func"] = bar,
--      ["desc"] = "this is foobar"
--    }
--}

function warExtended:GetSelfSlash()
	return slashCommands[self.moduleName]
end

function warExtended:PrintSelfSlash()
	self:Print("Available slash commands:")
	for cmd, cmdData in pairs(slashCommands[self.moduleName]) do
		self:Print("/"..cmd.. " - " .. cmdData.desc)
	end
end

function warExtended:RegisterSlash(commands, selfSlash)
	if LibSlash.IsSlashCmdRegistered(selfSlash) then
		error("This self slash command is already registered.")
		return
	end

	slashCommands[self.moduleName] = commands

	for cmd, data in pairs(commands) do
		LibSlash.RegisterSlashCmd(cmd, function(...)
			warExtended.SlashHandler(data.func, ...)
		end)
	end

	LibSlash.RegisterSlashCmd(selfSlash, function()
		self:PrintSelfSlash()
	end)

	warExtended._Settings.AddChildEntry(towstring(self.moduleName), L"Slash Commmands", "warExtendedSettings_SlashTemplate")
end

function warExtended.SlashHandler(cmdfunc, ...)
	local argSplit = StringSplit((...), "#")
	cmdfunc(unpack(argSplit))
end