local warExtended = warExtended
warExtended.Modules={}

--To create slash commands for modules use the following table format:
--slashCommands = {
--  ["command"] = a
--    {
--      ["function"] = b,
--      ["description"] = c
--    }
--}
--
--To create options for modules use the following table format:
--options = {
--  ["combobox"] ={ ["label"] = L"label", ["options"] = {L"comboBoxText", L"comboBoxText2"}, ["size"] = small/medium/large/regular, ["onSelect"] = function }
--  ["editbox"] = { ["label"] = L"label", ["size"] = {["type"] = singleLine/multiLine, ["x"] = x, ["y"] = y}, ["onEnter"] = function, ["onTextChanged"]= function}
-- ["tickbox"] = { ["label"] = L"label", ["function"] = function }
--}
--
--Dependency is "warExtended Core", you must name your module "warExtended moduleName" and register with warExtended.RegisterModule("moduleName", slashCommands, moduleOptions)
--All commands will show on running /warext, or individually per module running /warextmoduleName

local function addToSet(set, key)
  set[key] = true
end

local function removeFromSet(set, key)
  set[key] = nil
end

local function setContains(set, key)
  return set[key] ~= nil
end

local function getModuleHyperlink(module)
  local HyperlinkData = L"WAREXT:"..towstring(module)
  local HyperlinkText = L"[warExt] "
  local HyperlinkColor = DefaultColor.GREEN
   return CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
end

local function getModuleVersion(module)
    local Addons = ModulesGetData()
    local moduleName = "warExtended "..module
    for _, AddonData in ipairs(Addons) do
        if AddonData.name == moduleName then
                return towstring(AddonData.version)
        end
    end
end

local function getModuleSlashCommands(module)
    local ModuleHyperlink = warExtended.Modules[module]["hyperlink"]

    for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
       local CommandDescription = warExtended.Modules[module]["cmd"][Command]["description"]
        EA_ChatWindow.Print(ModuleHyperlink..L"/"..towstring(Command)..L" - "..CommandDescription)
    end

 end

local function registerModuleSelfSlash(module)

  local selfSlash = "warext"..module
  local selfSlashFunction = function () return getModuleSlashCommands(module) end

  LibSlash.RegisterSlashCmd(selfSlash, selfSlashFunction)
end


local function registerModuleSlashCommands(module)

    for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
      local CommandFunction = warExtended.Modules[module]["cmd"][Command]["function"]
       LibSlash.RegisterSlashCmd(Command, CommandFunction)
    end

end

function warExtended.RegisterModule(module, slashCommands)

  if not warExtended.Modules[module] then
    local commands = { ["cmd"] = slashCommands }
    warExtended.Modules[module] = commands
    warExtended.Modules[module]["hyperlink"] = getModuleHyperlink(module)
    warExtended.Modules[module]["version"] = getModuleVersion(module)
  end

  registerModuleSlashCommands(module)
  registerModuleSelfSlash(module)

end

function warExtended.UnregisterModule(moduleName)
  warExtended.Modules[moduleName] = nil
end

function warExtended.IsModuleEnabled(module)
  return setContains(warExtended.Modules, module)
end
