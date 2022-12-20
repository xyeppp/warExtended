--[[function DebugWindow.help()
hw = warExtendedTerminal.HighlightWindow
  local help = { [[

 ______________________________________
 \_____________________________________/

                           warTerminal v1.2
  _____________________________________
/______________________________________\

Available commands:

p() - Prints to the terminal.

f - Prints a list of all basic game functions.
ff - Prints a list of all currently registered functions.
e - Prints a list of all game events.

r - Reloads UI

clog - Toggles the Combat Log on or off.

logdump("name", objects) - Dumps the contents of specified objects to a .log file.

abfind("name", desc) - Prints a list of matching abilities with their description if specified.
areainfo - Displays information about the current area.

scjoin - Rejoin a SC/City after a crash or when the scenario-pop window disapeared.
scgroup - Displays Scenario Group window.

fontlist - Prints a list of all in-game available fonts.
changefont("font1", "font2") - Changes the name & title font respectively.

guildid - Displays the ID of your Guild.
keepid - Prints a list of keep IDs.

hw"windowName" - Highlights where a specified window is being drawn even if not currently visible.
(Not compatible with NoUselessMods-HelpTips)
mesh(size) - Creates an on-screen grid for easy layout arrangement/measurements.
(16/256 - intervals of 16)

ror - List of RoR server commands

Event Spy
s - Start on-the-fly event spying.
(UPDATE_PROCESSED, RVR_REWARD_POOLS_UPDATED and PLAYER_POSITION_UPDATED are not added by default)
ss - Stop on-the-fly event spying.
spylist - Prints a list of events being spied upon currently.
spyadd"text" - Looks for partial matches and adds an event to Event Spy.
spyrem"text" - Looks for partial matches and removes an event from Event Spy.

Captain Hook
hook(func) - Hooks a function and spies on it's parameters.
unhook(func) - Unhooks a function from spying.

  }

end

function DebugWindow.ror()
  local ror = { [[

AVAILABLE ROR SERVER COMMANDS
===================================
GROUPCHALLENGE: Challenge another group to a scenario
===================================
   }
  for k, v in pairs(ror) do
	pp(v)
  end
end

function DebugWindow.KeepList()
  local keeplist = { [[

Dok Karaz - ID: 1
   }
  for k, v in pairs(keeplist) do
	pp(v)
  end
end

function DebugWindow.FontList()
  local fontlist = { [[
"font_chat_window_game_rating_text"
 }
  
  for k, v in pairs(fontlist) do
	pp(v)
  end
end]]

