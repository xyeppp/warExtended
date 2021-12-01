local UiMod = warExtendedUiMod

local profile = {
  getContents = function(self)
	return self.contents
  end,

  getName = function(self)
	return self.name
  end,

  create = function(self, name, contents)
	local newProfile = setmetatable ({}, self)
	newProfile.name = name
	newProfile.contents = contents
	return newProfile
  end
}

local function getUiModData()
  local modules = ModulesGetData()
  local modulesState = {}

  for mod=1,#modules do
	local moduleName = modules[mod].name
	local moduleIsEnabled = modules[mod].isEnabled

	table.insert(modulesState, {
	  name = moduleName,
	  moduleIsEnabled = moduleIsEnabled
	})

  end
  return modulesState
end


function UiMod.SaveProfile()
	UiMod.Settings.Profiles[#UiMod.Settings.Profiles+1] = profile:create("testProfile", getUiModData())
end

function UiMod.RemoveProfile()

end

function UiMod.LoadProfile()
  local profile = UiMod.Settings.Profiles[4].contents

  for index, modData in ipairs(profile) do
	ModuleInitialize(modData.name)
	ModuleSetEnabled( modData.name, modData.moduleIsEnabled  )
  end

  UiModWindow.MarkAsChanged()
  UiModWindow.UpdateEnableDisableAllButtons()

  BroadcastEvent( SystemData.Events.RELOAD_INTERFACE )
end