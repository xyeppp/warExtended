local NameActions = warExtendedNameActions

local slashCommands = {
  qmsg = {
	func = function ()
	  getCurrentSavedMessages()
	end,
	desc = "Prints currently set Quick-Messages."
  },
  
  qtell = {
	func = function (text, messageNumber)
	  setQuickMessage(text, messageNumber,nil, "Tell")
	end,
	desc = "Set your quick-tell message: /qtell text#slotNumber"
  },
  
  qchat = {
	func =  function (text, messageNumber, channel)
	  setQuickMessage(text, messageNumber,channel, "Chat")
	end,
	desc = "Set your quick-chat message: /qchat text#slotNumber#channel"
  }
}

function NameActions.RegisterSlashCommands()
  NameActions:RegisterSlash(slashCommands, "warext")
end

