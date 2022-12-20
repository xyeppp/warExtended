local warExtended = warExtended

local rorCommands = {
  
  ["ranked"] = {
	description = "Ranked commands",
	subgroup = {
	  leaderboard = {
		description = "List top players",
		args = { "seasonId", "ratingType", "page" }
	  },
	  leaderboardcareer = {
		description = "List top players by career",
		args = { "seasonId", "ratingType", "page", "career" }
	  },
	  leaderboardplayer = {
		description = "Find a player on leaderboard",
		args = { "seasonId", "ratingType", "playerName" }
	  },
	  playerstatsseason = {
		description = "Get your stats for the specified season",
		args = { "seasonId" },
	  },
	  playerstats = {
		description = "Get your stats for the current season"
	  },
	  listseason = {
		description = "List seasons"
	  },
	  getplayerstatus = {
		description = "Get seasons and player stats"
	  },
	  queuesolo = {
		description = "Queue for ranked solo"
	  },
	  queuegroup = {
		description = "Queue for ranked group"
	  }
	},
  },
  ["readycheck"] = {
	description = "Ready check commands",
	subgroup = {
	  start = {
		description = "Start ready check"
	  },
	  abort = {
		description = "Abort ready check",
	  },
	  answer = {
		description = "Answer ready check",
		args = { "answer" }
	  }
	},
  },
  ["respec"] = {
	description = "Crafting respecialization commands",
	subgroup = {
	  gathering = {
		description = "Respec gathering skill"
	  },
	  crafting = {
		description = "Respec crafting skill"
	  }
	},
  },
  ["spec"] = {
	description = "Career respecialization commands",
	subgroup = {
	  list = {
		description = "List specs"
	  },
	  delete = {
		description = "Delete a spec",
		args = { "entry" }
	  },
	  save = {
		description = "Save a spec",
		args = { "entry" } },
	  load = {
		description = "Load a spec",
		args = { "entry" }
	  },
	  loadhotbar = {
		description = "Load hotbar from a spec",
		args = { "entry" }
	  }
	}
  },
  ["castsequence"] = {
	description = "Cast sequence commands",
	subgroup = {
	  add = {
		description = "Add cast sequence",
		args = { "slotId", "resetTypes", "resetTimeSeconds", "abilities" }
	  },
	  delete = {
		description = "Delete cast sequence",
		args = { "slotId" }
	  },
	  clearall = {
		description = "Clear all cast sequences"
	  },
	  list = {
		description = "List all cast sequences on channel 9"
	  },
	  get = {
		description = "Get cast sequence info on channel 9",
		args = { "slotId" }
	  }
	},
  },
  ["changename"] = {
	description = "Requests a name change, one per account per month"
  },
  ["gmlist"] = {
	description = "Lists available GMs"
  },
  ["rules"] = {
	description = "Sends a condensed list of in-game rules"
  },
  ["assist"] = {
	description = "Switches to friendly target's target"
  },
  ["unlock"] = {
	description = "Used to fix stuck-in-combat problems preventing you from joining a scenario"
  },
  ["tellblock"] = {
	description = "Allows you to block whispers from non-staff players who are outside of your guild"
  },
  ["getstats"] = {
	description = "shows your own linear stat bonuses"
  },
  ["standard"] = {
	description = "assigns standard bearer titel to the player"
  },
  ["ror"] = {
	description = "help files for rorr specific features"
  },
  ["language"] = {
	description = "change the language of data."
  },
  ["tokfix"] = {
	description = "checks if player have all to ks and fixes if needed"
  },
  ["rvrstatus"] = {
	description = "displays current status of rv r"
  },
  ["surrender"] = {
	description = "starts surrender vote in scenario"
  },
  ["yes: vot"] = {
	description = "vote yes durring scenario surrender vote"
  },
  ["no: vote"] = {
	description = "vote no durring scenario surrender vote"
  },
  ["sorenable"] = {
	description = "enables so r addon"
  },
  ["sordisabe"] = {
	description = "disables so r addon"
  },
  ["mmrenable"] = {
	description = "enables mmr addon"
  },
  ["guildinvolve"] = {
	description = "allows you to involve your guild with rv r campaign"
  },
  ["guildchangename"] = {
	description = "change guild name, costs 1000 gold"
  },
  ["claimkeep"] = {
	description = "allows you to claim keep for your guild in rv r campaign"
  },
  ["apprentice"] = {
	description = "allows you to claim keep for your guild in rv r campaign"
  },
  ["lockouts"] = {
	description = "displays lockouts of player and his party"
  },
  ["bagbonus"] = {
	description = "displays accumulated bonuses for rvr bags"
  },
  ["alert"] = {
	description = "sends an alert to the player specified using channel 9(string player name string message). used for addons."
  },
  ["rankedscstatus"] = {
	description = "shows player count of the ranked solo scenario queue"
  },
  ["uiscstatus"] = {
	description = "shows player count of the ranked solo scenario queue for the ui"
  },
  ["uiserver"] = {
	description = "sends user interface server settings"
  },
  ["groupscoreboardreset"] = {
	description = "reset group scoreboard"
  },
  ["groupchallenge"] = {
	description = "challenge another group to a scenario"
  },
}

function warExtended.GetRoRCommands()
  return rorCommands
end