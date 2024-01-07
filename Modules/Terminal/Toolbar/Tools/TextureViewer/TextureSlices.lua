local warExtended           = warExtended
local TerminalTextureViewer = TerminalTextureViewer

local textures              = { [L""] = false,
								[L"EA_Abilities01_d5"] = { "AbilityIconFrame", "MainTab", "MainTabBackground", "MainTab-Rollover", "MainTab-Selected",
															"MainTab-SymbolActions", "MainTab-SymbolGeneral", "MainTab-SymbolMorale", "MainTab-SymbolTactics", "MoraleIconFrame",
															"NextButton", "NextButton-Depressed", "NextButton-Rollover", "PrevButton", "PrevButton-Depressed", "PrevButton-Rollover",
															"RightTabFrame", "RightTabFrame-Rollover", "RightTabFrame-Selected", "StoneTabletBackground", "Tab-ALL",
															"Tab-Archmage1-Isha", "Tab-Archmage2-Asuryan", "Tab-Archmage3-Vaul", "TabBar", "TabBar-EndCap-Left", "TabBar-EndCap-Right",
															"Tab-BlackOrc1-DaBrawler", "Tab-BlackOrc2-DaBoss", "Tab-BlackOrc3-DaToughest", "TabBottom",
															"Tab-BrightWizard1-Incineration", "Tab-BrightWizard2-Immolation", "Tab-BrightWizard3-Conflagration",
															"Tab-Choppa1-DaSavage", "Tab-Choppa2-DabigHitta", "Tab-Choppa3-DaWrecka",
															"Tab-Chosen1-Dread", "Tab-Chosen2-Corruption", "Tab-Chosen3-Discord",
															"Tab-Core", "Tab-Crafting",
															"Tab-Disciple1-Dark-Rites", "Tab-Disciple2-Torture", "Tab-Disciple3-Sacrifice",
															"Tab-Engineer1-Tinkerer", "Tab-Engineer2-Rifleman", "Tab-Engineer3-Grenadier",
															"Tab-IronBreaker1-Vengeance", "Tab-IronBreaker2-Stone", "Tab-IronBreaker3-Brotherhood",
															"Tab-Magus1-Havoc", "Tab-Magus2-Changing", "Tab-Magus3-Daemonology",
															"Tab-Marauder1-Savagery", "Tab-Marauder2-Brutality", "Tab-Marauder3-Monstrosity",
															"Tab-PassiveAbilities", "Tab-PassiveSkills",
															"Tab-RunePriest1-Grimnir", "Tab-RunePriest2-Grungni", "Tab-RunePriest3-Valaya",
															"Tab-RvR",
															"Tab-ShadowWarrior1-TheScout", "Tab-ShadowWarrior2-Assault", "Tab-ShadowWarrior3-TheSkirmisher",
															"Tab-Shaman1-DaGreen", "Tab-Shaman2-Gork", "Tab-Shaman3-Mork",
															"Tab-Slayer1-Giantslayer", "Tab-Slayer2-Trollslayer", "Tab-Slayer3-Skavenslayer",
															"Tab-Sorceress1-Agony", "Tab-Sorceress2-Calamity", "Tab-Sorceress3-Destruction",
															"Tab-SquigHerder1-Stabbin", "Tab-SquigHerder2-BigShootin", "Tab-SquigHerder3-QuickShootin",
															"Tab-Swordmaster1-Khaine", "Tab-Swordmaster2-Vaul", "Tab-Swordmaster3-Hoeth",
															"Tab-Tome", "TabTopper",
															"Tab-WarriorPriest1-Salvation", "Tab-WarriorPriest2-Grace", "Tab-WarriorPriest3-Wrath",
															"Tab-WhiteLion1-TheHunter", "Tab-WhiteLion2-TheAxeman", "Tab-WhiteLion3-TheGuardian",
															"Tab-WitchElf1-Carnage", "Tab-WitchElf2-Suffering", "Tab-WitchElf3-Treachery",
															"Tab-WitchHunter1-Confession", "Tab-WitchHunter2-Inquisition", "Tab-WitchHunter3-Judgement",
															"Tab-Zealot1-Alchemy", "Tab-Zealot2-Witchcraft", "Tab-Zealot3-DarkRites",
															"Tab-Knight1-Conquest", "Tab-Knight2-Vigilance", "Tab-Knight3-Glory",
															"Tab-BlackGuard1-Malice", "Tab-BlackGuard2-Loathing", "Tab-BlackGuard3-Anguish",
								},
								[L"EA_ActionBarAnim_Casting"] = false,
								[L"EA_ActionBarAnim_Recharged"] = false,
								[L"EA_ActionBarCap_EM"] = { "left-cap", "right-cap" },
								[L"EA_ActionBarCap_OR"] = { "left-cap", "right-cap" },
								[L"EA_ActionBarCap_DW"] = { "left-cap", "right-cap" },
								[L"EA_ActionBarCap_CH"] = { "left-cap", "right-cap" },
								[L"EA_ActionBarCap_HE"] = { "left-cap", "right-cap" },
								[L"EA_ActionBarCap_DE"] = { "left-cap", "right-cap" },
								[L"EA_Backpack01_d5"] = { "BackpackBackground", "BackpackItemTab",
														   "BackpackItemTab-Rollover", "BackpackItemTab-Selected",
														   "Bag1-Closed", "Bag1-Open", "Bag2-Closed",
														   "Bag2-Open", "Bag3-Closed", "Bag3-Open",
														   "Bag4-Closed", "Bag4-Open", "Bag5-Closed",
														   "Bag5-Open", "CraftItemTab", "CraftItemTab-Rollover",
														   "CraftItemTab-Selected", "CurrencyItemTab", "CurrencyItemTab-Rollover",
														   "CurrencyItemTab-Selected", "LootSortButton", "LootSortButton-Depressed",
														   "LootSortButton-Rollover", "MarketingRewardsBtn", "MarketingRewardsBtn-Rollover",
														   "Quest-Background-Chain", "QuestItemTab", "QuestItemTab-Rollover", "QuestItemTab-Selected",
  
								},
								[L"EA_Career_AM_32b"] = { "ArchmageBlueHighlight", "ArchmageDefault", "ArchmageGoldHighlight" },
								[L"EA_Career_BO_32b"] = { "BlackOrc-Best", "BlackOrc-Betta", "BlackOrc-Good" },
								[L"EA_Career_BW_32b"] = { "BrightWizard-FireFrame1", "BrightWizard-FireFrame2", "BrightWizard-FireFrame3",
														   "BrightWizard-FireFrame4", "BrightWizard-FireFrame5", "BrightWizard-FireFrame6", "BrightWizard-FireFrame7",
														   "BrightWizard-FireFrame8", "BrightWizard-GlowingEyes", "BrightWizard-Skull" },
								[L"EA_Career_Di_32b"] = { "Disciple", "DiscipleFill" },
								[L"EA_Career_Ch_32b"] = { "ChosenEye1", "ChosenEye2", "ChosenEye3", "ChosenFrame" },
								[L"EA_Career_WP_32b"] = { "WarriorPriestBackground", "WarriorPriestFill" },
								[L"EA_Career_WH_32b"] = { "WitchHunter-GlowingEyes", "WitchHunter-Skull", "WitchHunter-SpikeA",
														   "WitchHunter-SpikeB", "WitchHunter-SpikeC", "WitchHunter-SpikeD",
														   "WitchHunter-SpikeE" },
								[L"EA_Career_WE_32b"] = { "WitchElfSpikeA", "WitchElfSpikeB", "WitchElfSpikeC", "WitchElfSpikeD",
														   "WitchElfSpikeE" },
								[L"EA_Career_Sq_32b"] = { "PetState-Aggressive", "PetState-Button-Aggressive", "PetState-Button-Aggressive-ROLLOVER",
														   "PetState-Button-Defensive", "PetState-Button-Defensive-ROLLOVER", "PetState-Button-Passive",
														   "PetState-Button-Passive-ROLLOVER", "PetState-Defensive", "PetStateFrame", "PetState-Passive", "ReleaseIcon" },
								[L"EA_Career_Ma_32b"] = { "PetState-Aggressive", "PetState-Button-Aggressive", "PetState-Button-Aggressive-ROLLOVER",  "PetState-Button-Defensive",
														  "PetState-Button-Defensive-ROLLOVER", "PetState-Button-Passive",
															"PetState-Button-Passive-ROLLOVER", "PetState-Defensive", "PetStateFrame", "PetState-Passive", "ReleaseIcon" },
								[L"EA_Career_WL_32b"] = { "PetState-Aggressive", "PetState-Button-Aggressive", "PetState-Button-Aggressive-ROLLOVER",
														   "PetState-Button-Defensive", "PetState-Button-Defensive-ROLLOVER", "PetState-Button-Passive",
														   "PetState-Button-Passive-ROLLOVER", "PetState-Defensive", "PetStateFrame", "PetState-Passive", "ReleaseIcon" },
								[L"EA_Career_En_32b"] = { "PetState-Aggressive", "PetState-Button-Aggressive", "PetState-Button-Aggressive-ROLLOVER",
														   "PetState-Button-Defensive", "PetState-Button-Defensive-ROLLOVER", "PetState-Button-Passive",
														   "PetState-Button-Passive-ROLLOVER", "PetState-Defensive", "PetStateFrame", "PetState-Passive", "ReleaseIcon" },

								[L"EA_Career_So_32b"] = { "SorcererFrame", "Sorcerer-Orb1", "Sorcerer-Orb2",
														   "Sorcerer-Orb3", "Sorcerer-Orb4", "Sorcerer-Orb5" },
								[L"EA_Career_SM_32b"] = { "SwordmasterBest", "SwordmasterBetta", "SwordmasterGood" },
								[L"EA_Career_Sh_32b"] = { "ShamanJaws", "ShamanRedHead", "ShamanYellowHead" },
								[L"EA_Career_IB_32b"] = { "IronbreakerGlowingEyes", "IronbreakerNormal" },
								[L"EA_Career_BG_32b"] = { "BlackGuardGlowingEyes", "BlackGuardNormal" },
								[L"EA_Career_SL_32b"] = { "Slayer-Frame01", "Slayer-Frame02", "Slayer-Frame03", "Slayer-Frame04",
														   "Slayer-Frame05", "Slayer-Frame06", "Slayer-GreenGlow", "Slayer-Medallion", "Slayer-Medallion-Angry", "Slayer-needle", "Slayer-Ring",
														   "Slayer-YellowGlow" },
								[L"EA_Career_BZ_32b"] = { "Choppa-GlowFrame01", "Choppa-GlowFrame02", "Choppa-GlowFrame03", "Choppa-GlowFrame04",
														   "Choppa-GlowFrame05", "Choppa-GlowFrame06", "Choppa-GreenGlow", "Choppa-HeadDefault",
														   "Choppa-HeadGlow", "Choppa-needle", "Choppa-Ring", "Choppa-YellowGlow" },
								[L"EA_Apothecary01_d5"] = { "BottleTop", "Bottle", "Container-Background",
															 "Determinant-Icon-Frame", "Disabled-Icon-Slot", "Filled-Container-Background",
															 "Green-Orb", "Icon-Frame", "Magenta-Orb", "Main-Background",
															 "Orange-Orb", "Red-Orb", "Stability-Meter", "Stability-Meter-Arrow",
															 "White-Orb", "Purple-Filled-Container-Background" },
								[L"EA_Talisman01_d5"] = { "Gold-Icon-Frame", "orb-blue", "orb-green", "orb-grey", "orb-orange", "orb-red",
														   "Power-Meter", "Power-Meter-Background", "Silver-Icon-Frame" },
								[L"EA_Cultivating01_d5"] = { "Black-Slot", "Dirt", "Dirt-Mini", "Dirt-Mini-SLOT",
															  "Dirt-Slot", "GreenCross", "GreenCross-Mini",
															  "GreenCross-Mini-SLOT", "GreenCross-Slot", "Home-Button",
															  "Home-Button-Depressed", "Home-Button-Rollover", "IconFrame-1", "IconFrame-2",
															  "IconFrame-Mini", "IdiotBox-Background", "PlantStage-1", "PlantStage-2", "PlantStage-3", "PlantStageIcon-1",
															  "PlantStageIcon-2", "PlantStageIcon-3", "Plot", "PlotDivider-Horizontal",
															  "PlotDivider-Vertical", "Plot-Rollover", "PlotView-Background", "RoundFrame", "ShroomPlotView-Background",
															  "ShroomStage-1", "ShroomStage-2", "ShroomStage-3",
															  "ShroomStageIcon-1", "ShroomStageIcon-2", "ShroomStageIcon-3",
															  "SmallRoundFrame", "Square-1", "Square-2", "Square-3",
															  "Square-4", "WaterDrop", "WaterDrop-Mini", "WaterDrop-Mini-SLOT", "WaterDrop-Slot", },
								[L"EA_Death01_d5"] = {"MainWindow", "RespawnButton-Depressed", "RespawnButton-Rollover"},
								[L"EA_Guild_BannerBGOrder"] = {"order-background"},
								[L"EA_Guild_BannerBGDestruction"] = {"destruction-background"},
								[L"EA_Guild"] = {"adminbutton-base","adminbutton-rollover","adminbutton-select", "admintab-bottom-span",
												 "admintab-bottom-span-end" , "admintab-center","admintab-leftend" , "admintab-rightend",
												 "admintab-top-span","admintab-top-span-end","boot" ,"bottomtab-back-center" , "bottomtab-back-center-roll",
												 "bottomtab-back-leftend","bottomtab-back-leftend-roll","bottomtab-back-rightend" ,"bottomtab-back-rightend-roll" ,
"bottomtab-front-center" ,"bottomtab-front-leftend" , "bottomtab-front-rightend" , "color-picker" ,"colorswatch" , "colorswatch-background","colorswatch-select-denied" ,
"colorswatch-select-primary","colorswatch-select-secondary" ,"editbutton-base" ,"editbutton-roll" ,"editbutton-select" ,"guildeditbutton-base", "guildeditbutton-roll","guildeditbutton-select",
								  "guildxp-bar","guildxp-bar-empty","guildxp-bar-frame-center" ,"guildxp-bar-frame-leftend","guildxp-bar-frame-rightend",
"guildxp-symbol" ,"lock","roster-status-green" ,					 "roster-status-yellow" ,"smallarrow-left-base",		 "smallarrow-left-roll" ,
"smallarrow-left-select" ,		  "smallarrow-right-base" ,"smallarrow-right-roll",		 "smallarrow-right-select" ,		 "tactic-highlight"},
[L"EA_Help01_32b"] = {"Icon-Bug","Icon-FAQ","Icon-Feedback","Icon-Appeal","Icon-Manual"}
}

-- EA_INTERACTION_WINDOW IS NEXT

function pairsByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i    = 0      -- iterator variable
  local iter = function()
	-- iterator function
	i = i + 1
	if a[i] == nil then return nil
	else return a[i], t[a[i]]
	end
  end
  return iter
end

function TerminalTextureViewer.GetTextureNames()
  local textureNames = {}
  
  for name, line in pairsByKeys(textures) do
	textureNames[#textureNames + 1] = name
  end
  
  --[[for k, v in pairs(textures) do
	textureNames[#textureNames + 1] = k
  end]]
  
  return textureNames
end

function TerminalTextureViewer.GetTextureSlices(textureName)
  local slices        = { "" }
  local textureSlices = textures[textureName]
  
  if textureSlices then
	p(textureSlices)
	for slice = 1, #textureSlices do
	  slices[#slices + 1] = textureSlices[slice]
	end
	
	return slices
  end
end