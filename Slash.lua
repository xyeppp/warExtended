local warExtended = warExtended
local pairs = pairs
local StringSplit = StringSplit

local slashCommands = {}

--slashCommands = {
--  ["command"] = foo
--    {
--      ["func"] = bar,
--      ["desc"] = "this is foobar"
--    }
--}
--All arguments get handled via warExt Slash Handler with an argument split on # character

function warExtended:PrintSelfSlash(selfSlash)
	local slash = slashCommands[selfSlash]

	local item = slash.first
	while item do
		self:Print(item.key .. " - " .. item.data)
		item = item.next
	end
end

function warExtended:RegisterSlash(commands, selfSlash)
	local slash = slashCommands[selfSlash]
	local randomEventName = warExtended:GetRandomString2(10, 24)

	if slash == nil then
		slash = warExtendedLinkedList.New()
		slashCommands[selfSlash] = slash
	end

	warExtended:AddEventHandler(randomEventName, "RegisterSlash", function()
		for command, data in pairs(commands) do
			LibSlash.RegisterSlashCmd(command, function(...)
				warExtended.SlashHandler(data.func, ...)
			end)
			slash:Add("/" .. command, data.desc)
		end

		if not LibSlash.IsSlashCmdRegistered(selfSlash) then
			LibSlash.RegisterSlashCmd(selfSlash, function()
				warExtended:PrintSelfSlash(selfSlash)
			end)
		end

		warExtended:RemoveEventHandler(randomEventName, "RegisterSlash")
	end)

	-- warExtended:TriggerEvent("CreateSettingsEntry", randomEventName)
end

function warExtended.SlashHandler(cmdfunc, ...)
	local argSplit = StringSplit((...), "#")
	cmdfunc(unpack(argSplit))
end

local function registerAllSlash()
	warExtended:TriggerEvent("RegisterSlash")
	warExtended:RemoveEventHandler("RegisterAllSlash", "CoreInitialized")
end

warExtended:AddEventHandler("RegisterAllSlash", "CoreInitialized", registerAllSlash)
