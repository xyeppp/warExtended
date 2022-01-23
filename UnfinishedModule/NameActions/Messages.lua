local NameActions = warExtendedNameActions

NameActions.SavedMessages = {
  Tell = {
	[1] = {
	  Text = L"Invite please."
	},
	[2] = {
	  Text = L"Test message."
	},
  },
  Chat = {
	[1] = {
	  Text = L"LFM BB/BE",
	  Channel = L"/s"
	},
	[2] = {
	  Text = L"Warband LF more.",
	  Channel = L"/shout"
	}
  }
}

local savedMsg = NameActions.SavedMessages

local messageHandler = {
  getMessage = function(messageDestination, messageSlot)
	return savedMsg[messageDestination][messageSlot]
  end,
  
  addMessage = function(messageDestination, messageSlot, message)
	
	
  end
}